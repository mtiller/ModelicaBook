import * as express from "express";
import * as url from "url";

import * as debug from "debug";
const log = debug("mbe:url");

export function runUrl(req: express.Request | null, model: string): string {
    return resolve(req, `/model/${model}/run`);
}

export function modelUrl(req: express.Request | null, model: string): string {
    return resolve(req, `/model/${model}`);
}

export function findUrl(req: express.Request | null): string {
    return resolve(req, `/find`);
}

export function rootUrl(req: express.Request | null): string {
    return resolve(req, "/");
}

function baseUrl(req: express.Request | null): url.Url {
    if (process.env["BASE_URL"]) {
        // I shouldn't have to resort to this, but I turned on trusted proxy
        // and I still have trouble figuring out the protocol (see request
        // handling below).
        const base = process.env["BASE_URL"] as string;
        log("Base URL supplied via environment variable: '%s'", base);
        return url.parse(base);
    }
    if (req) {
        const host = req.hostname;
        const proto = req.protocol;

        log("Building URL from request where host was '%s' and proto was '%s'", host, proto);

        const uri = `${proto}://${host}`;
        log("  Resulting URL was %s", uri);
        let u = url.parse(uri);
        return u;
    }
    log(`Assuming a base URL of / (no request to process)`);
    return url.parse("/");
}

function resolve(req: express.Request | null, path: string): string {
    let base = baseUrl(req);
    base.pathname = path;
    base.query = null;
    base.search = undefined;
    let ret = url.format(base);
    return ret;
}
