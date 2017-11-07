import * as express from 'express';
import { sendSiren, tempDir, cleanup, exec, copyFile } from './utils';
import { runUrl } from './urls';
import { Field } from 'siren-types';
import { Details } from './details';
import * as fs from 'fs';
import * as debug from 'debug';
import * as path from 'path';
import { blobReader, MatFile, DymolaResultsExtractor } from '@xogeny/mat-parser';

const runDebug = debug("mbe:run");
// runDebug.enabled = true;

export function modelGet(details: Details, model: string) {
    return (req: express.Request, res: express.Response) => {
        sendSiren(res, {
            title: details.desc.description,
            properties: details,
            actions: [
                {
                    name: "run",
                    method: "POST",
                    href: runUrl(req, model),
                    fields: (details.categories.parameter || []).map((param): Field => (
                        {
                            name: param,
                            type: "number",
                            title: details.vars[param].description,
                        }))
                }
            ]
        });
    }
}

export function modelPost(details: Details, model: string, testing: boolean) {
    return async (req: express.Request, res: express.Response) => {
        try {
            // Name various files and directories involve
            let dir = await tempDir(testing ? { dir: path.join(__dirname, "./tmp") } : {});
            let mdir = path.join(".", "models");
            let ldir = path.join(__dirname, "..", "..", "libs");
            runDebug("Temporary directory = %s", dir);
            runDebug("  Model directory = %s", mdir);
            runDebug("  Libraries directory = %s", ldir);
            let sexe = path.join(mdir, model);
            let sinit = path.join(mdir, `${model}_init.xml`);
            let dexe = path.join(dir, model);
            let dinit = path.join(dir, `${model}_init.xml`);
            let rfile = path.join(dir, `${model}_res.mat`);

            // Parse body
            runDebug("Parameters given in body: %o", req.body);
            let overrides = Object.keys(req.body || {}).filter((name) => (details.categories.parameter || []).indexOf(name) >= 0);
            let oflag = overrides.map((name) => `${name}=${req.body[name]}`).join(",");
            runDebug("Override flags = %s", oflag);

            // Copy executable to temporary directory
            runDebug("Copying %s to %s", sexe, dexe);
            await copyFile(sexe, dexe);
            runDebug("Changing permissions on %s", dexe);
            fs.chmodSync(dexe, 0o777);
            runDebug("Copying %s to %s", sinit, dinit);
            await copyFile(sinit, dinit);

            // Run exectuable
            // docker run -v `pwd`:/opt/RUN -w /opt/RUN -i -t mtiller/book-builder ./FO
            if (testing) {
                let output = await exec("docker", ["run", "-v", `${dir}:/opt/RUN`, "-w", "/opt/RUN", "-i", "mtiller/book-builder", `/opt/RUN/${model}`, `-override=${oflag}`]);
                runDebug("Simulation output:");
                runDebug(output);
            } else {
                let output = await exec(`${model}`, [], {
                    env: {
                        "LD_LIBRARY_PATH": ldir,
                    },
                    cwd: dir,
                });
                runDebug("Simulation output:");
                runDebug(output);
            }
            // Parse simulation results
            let obs = blobReader(rfile);
            let file = new MatFile(obs);
            let handler = new DymolaResultsExtractor((name: string) => true, (name: string) => false);
            await file.parse(handler);

            // Collect required results
            sendSiren(res, {
                title: "Result of simulating " + details.desc.description,
                properties: {
                    trajectories: handler.trajectories,
                }
            });
        } catch (e) {
            console.error("Error running simulation: ", e);
            res.status(500).send(e.message);
        } finally {
            runDebug("Cleanup starting");
            cleanup();
            runDebug("  Cleanup completed");
        }
    }
}