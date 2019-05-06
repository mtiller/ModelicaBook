import * as express from "express";
import { Siren } from "siren-types";
import * as temp from "temp";
import * as cp from "child_process";
import * as fs from "fs";

import * as debug from "debug";
const utilDebug = debug("mbe:utils");
// utilDebug.enabled = true;

temp.track();

export interface ExecResult {
    success: boolean;
    message?: string;
    stdout: string;
    stderr: string;
}

export interface SirenOptions {
    maxAge?: number;
}

export function sendSiren(res: express.Response, s: Siren, opts?: SirenOptions) {
    const options: SirenOptions = {
        maxAge: opts ? opts.maxAge : undefined,
    };
    // TODO: necessary?
    let str = JSON.stringify(s);
    res.setHeader("content-type", "application/json");

    if (options.maxAge) {
        res.setHeader("cache-control", `public, max-age=${options.maxAge}`);
    }

    res.send(str);
}

export function tempDir(affix?: temp.AffixOptions): Promise<string> {
    return new Promise((resolve, reject) => {
        temp.mkdir(affix, (err, path) => {
            if (err) reject(err);
            else resolve(path);
        });
    });
}

export function cleanup() {
    temp.cleanupSync();
}

export function exec(command: string, args: string[], options?: cp.ExecFileOptions): Promise<ExecResult> {
    return new Promise((resolve, reject) => {
        cp.execFile(command, args, options || {}, (err, stdout, stderr) => {
            utilDebug("Error = %j", err);
            utilDebug("Stdout = %s", stdout);
            utilDebug("Stderr = %s", stderr);
            if (err) {
                let code: any = (err as any).code;
                // If code is a number, then the executed command ran.  So we should see not
                // reject in this case but rather provide details in the resolution of any
                // issues with the simulation.
                if (typeof code === "number") {
                    resolve({
                        success: code === 0,
                        message: err.message,
                        stdout: stdout,
                        stderr: stderr,
                    });
                } else {
                    reject(err);
                }
            } else {
                resolve({
                    success: true,
                    stdout: stdout,
                    stderr: stderr,
                });
            }
        });
    });
}

export function sleep(n: number): Promise<void> {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve(undefined), n);
    });
}

export function copyFile(source: string, target: string): Promise<void> {
    return new Promise((resolve, reject) => {
        const rd = fs.createReadStream(source, { encoding: "binary" });
        rd.on("error", function(err) {
            reject(err);
        });
        const wr = fs.createWriteStream(target, { encoding: "binary" });
        wr.on("error", function(err) {
            reject(err);
        });
        wr.on("close", function() {
            resolve(undefined);
        });
        rd.pipe(wr);
    });
}
