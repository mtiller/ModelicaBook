import * as express from 'express';
import { Siren } from 'siren-types';
import * as temp from 'temp';
import * as cp from 'child_process';
import * as fs from 'fs';

temp.track();

export function sendSiren(res: express.Response, s: Siren) {
    // TODO: necessary?
    let str = JSON.stringify(s);
    res.setHeader("content-type", "application/json");
    res.send(str);
}

export function tempDir(affix?: temp.AffixOptions): Promise<string> {
    return new Promise((resolve, reject) => {
        temp.mkdir(affix, (err, path) => {
            if (err) reject(err);
            else resolve(path);
        })
    });
}

export function cleanup() {
    temp.cleanupSync();
}

export function exec(command: string, args: string[], options?: cp.ExecFileOptions): Promise<string> {
    return new Promise((resolve, reject) => {
        cp.execFile(command, args, options || {}, (err, stdout) => {
            if (err) reject(err);
            else resolve(stdout.toString());
        });
    })
}

export function sleep(n: number): Promise<void> {
    return new Promise((resolve, reject) => {
        setTimeout(() => resolve(undefined), n);
    })
}

export function copyFile(source: string, target: string): Promise<void> {
    return new Promise((resolve, reject) => {
        const rd = fs.createReadStream(source, { encoding: "binary" });
        rd.on("error", function (err) {
            reject(err);
        });
        const wr = fs.createWriteStream(target, { encoding: "binary" });
        wr.on("error", function (err) {
            reject(err);
        });
        wr.on("close", function () {
            resolve(undefined);
        });
        rd.pipe(wr);
    })
}