"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const url = require("url");
function runUrl(req, model) {
    return resolve(req, `/model/${model}/run`);
}
exports.runUrl = runUrl;
function modelUrl(req, model) {
    return resolve(req, `/model/${model}`);
}
exports.modelUrl = modelUrl;
function rootUrl(req) {
    return resolve(req, "/");
}
exports.rootUrl = rootUrl;
function baseUrl(req) {
    if (req) {
        let host = req.headers["host"];
        let u = url.parse(req.url);
        u.host = Array.isArray(host) ? host[0] : host;
        u.protocol = req.protocol;
        return u;
    }
    return url.parse("/");
}
function resolve(req, path) {
    let base = baseUrl(req);
    base.pathname = path;
    base.query = null;
    base.search = undefined;
    let ret = url.format(base);
    return ret;
}
