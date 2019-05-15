import * as express from "express";
import { sendSiren, tempDir, cleanup, exec, copyFile } from "./utils";
import { runUrl } from "./urls";
import { Field, Siren } from "siren-types";
import { Details } from "./details";
import * as fs from "fs";
import * as debug from "debug";
import * as path from "path";
import { blobReader, MatFile, DymolaResultsExtractor } from "@xogeny/mat-parser";

const runDebug = debug("mbe:run");
// runDebug.enabled = true;

export function modelGet(details: Details, model: string) {
    return (req: express.Request, res: express.Response) => {
        const response: Siren = {
            title: details.casedata.title,
            properties: details,
            actions: [
                {
                    name: "run",
                    method: "POST",
                    type: "application/json",
                    href: runUrl(req, model),
                    fields: (details.categories.parameter || []).map(
                        (param): Field => ({
                            name: param,
                            type: "number",
                            title: details.vars[param].description,
                        }),
                    ),
                },
            ],
        };
        sendSiren(res, response, { maxAge: 600 });
    };
}

export function modelPost(details: Details, model2: string, testing: boolean) {
    return async (req: express.Request, res: express.Response) => {
        try {
            // Name various files and directories involve
            let dir = await tempDir(testing ? { dir: path.join(__dirname, "./tmp") } : {});
            let mdir = path.resolve(path.join(".", "models"));
            let ldir = path.join(__dirname, "..", "..", "libs");
            runDebug("Temporary directory = %s", dir);
            runDebug("  Model directory = %s", mdir);
            runDebug("  Libraries directory = %s", ldir);
            runDebug("  Case data = %o", details.casedata);
            let exe = details.casedata.res;
            let sexe = path.join(mdir, exe);
            let sinit = path.join(mdir, `${exe}_init.xml`);
            let dexe = path.join(dir, exe);
            let dinit = path.join(dir, `${exe}_init.xml`);
            let rfile = path.join(dir, `${exe}_res.mat`);

            // Parse body
            runDebug("Parameters given in body: %o", req.body);
            let overrides = Object.keys(req.body || {}).filter(
                name => (details.categories.parameter || []).indexOf(name) >= 0,
            );
            let params: { [param: string]: string } = {};
            let oflags: string[] = [];
            overrides.forEach(name => {
                params[name] = req.body[name];
                oflags.push(`${name}=${req.body[name]}`);
            });
            let oflag = oflags.join(",");
            runDebug("Override flags = %s", oflag);

            // Copy executable to temporary directory
            runDebug("Copying %s to %s", sexe, dexe);
            await copyFile(sexe, dexe);
            runDebug("Changing permissions on %s", dexe);
            fs.chmodSync(dexe, 0o777);
            runDebug("Copying %s to %s", sinit, dinit);
            await copyFile(sinit, dinit);

            // Run exectuable
            let exeFile = path.join(dir, exe);
            runDebug("Executable path: %s", exeFile);
            runDebug("Testing mode: %j", testing);
            let output = testing
                ? await exec("docker", [
                      "run",
                      "-v",
                      `${dir}:/opt/RUN`,
                      "-w",
                      "/opt/RUN",
                      "-i",
                      "mtiller/book-builder",
                      exeFile,
                      `-override=${oflag}`,
                      `-emit_protected`,
                  ])
                : await exec(`${dexe}`, [`-override=${oflag}`, `-emit_protected`], {
                      env: {
                          LD_LIBRARY_PATH: ldir,
                      },
                      cwd: dir,
                  });
            runDebug("Simulation output:");
            runDebug(output);

            if (!output.success) {
                // Collect required results
                sendSiren(res, {
                    title: "Error simulating " + details.desc.description,
                    class: ["error"],
                    properties: {
                        ...output,
                        params: params,
                    },
                });
            } else {
                // Parse simulation results
                let obs = blobReader(rfile);
                let file = new MatFile(obs);
                let handler = new DymolaResultsExtractor((name: string) => true, (name: string) => false);
                await file.parse(handler);

                // Collect required results
                sendSiren(res, {
                    title: "Result of simulating " + details.desc.description,
                    class: ["result"],
                    properties: {
                        ...output,
                        params: params,
                        trajectories: handler.trajectories,
                    },
                });
            }
        } catch (e) {
            console.error("Error running simulation: ", e);
            res.status(500).send(e.message);
        } finally {
            runDebug("Cleanup starting");
            cleanup();
            runDebug("  Cleanup completed");
        }
    };
}
