import { _setCwd as fsSetCwd } from "./config.js";
let _env = [];
let _args = [];
let _cwd = "/";
export function _setEnv(envObj) {
    _env = Object.entries(envObj);
}
export function _setArgs(args) {
    _args = args;
}
export function _setCwd(cwd) {
    fsSetCwd((_cwd = cwd));
}
export const environment = {
    getEnvironment() {
        return _env;
    },
    getArguments() {
        return _args;
    },
    initialCwd() {
        return _cwd;
    },
};
