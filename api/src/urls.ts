import * as express from "express";
import * as url from "url";

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
    if (req) {
        let host = req.headers["host"];
        let u = url.parse(req.url);
        u.host = Array.isArray(host) ? host[0] : host;
        u.protocol = req.protocol;
        return u;
    }
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
