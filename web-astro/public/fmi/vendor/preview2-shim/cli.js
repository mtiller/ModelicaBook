import { inputStreamCreate, outputStreamCreate, pollableCreate, } from "./io.js";
export { _setEnv, _setArgs, environment } from "./environment.js";
export { _setCwd } from "./config.js";
const symbolDispose = Symbol.dispose ?? Symbol.for("dispose");
class ComponentExit extends Error {
    exitError = true;
    code;
    constructor(code) {
        super(`Component exited ${code === 0 ? "successfully" : "with error"}`);
        this.code = code;
    }
}
export const exit = {
    exit(status) {
        throw new ComponentExit(status.tag === "err" ? 1 : 0);
    },
    // @ts-expect-error - Available only wasi-cli v0.2.12
    exitWithCode(code) {
        throw new ComponentExit(code);
    },
};
export function _setStdin(handler) {
    stdinStream.handler = handler;
}
export function _setStderr(handler) {
    stderrStream.handler = handler;
}
export function _setStdout(handler) {
    stdoutStream.handler = handler;
}
const stdinStream = inputStreamCreate({
    blockingRead(_len) {
        // TODO
        return new Uint8Array(0);
    },
    subscribe() {
        // TODO
        return pollableCreate();
    },
    [symbolDispose]() {
        // TODO
    },
});
const textDecoder = new TextDecoder();
const stdoutStream = outputStreamCreate({
    write(contents) {
        if (contents.at(-1) == 10) {
            // console.log already appends a new line
            contents = contents.subarray(0, -1);
        }
        console.log(textDecoder.decode(contents));
    },
    blockingFlush() { },
    [symbolDispose]() { },
});
const stderrStream = outputStreamCreate({
    write(contents) {
        if (contents.at(-1) == 10) {
            // console.error already appends a new line
            contents = contents.subarray(0, -1);
        }
        console.error(textDecoder.decode(contents));
    },
    blockingFlush() { },
    [symbolDispose]() { },
});
export const stdin = {
    getStdin() {
        return stdinStream;
    },
};
export const stdout = {
    getStdout() {
        return stdoutStream;
    },
};
export const stderr = {
    getStderr() {
        return stderrStream;
    },
};
class TerminalInput {
}
class TerminalOutput {
}
const terminalStdoutInstance = new TerminalOutput();
const terminalStderrInstance = new TerminalOutput();
const terminalStdinInstance = new TerminalInput();
export const terminalInput = {
    TerminalInput,
};
export const terminalOutput = {
    TerminalOutput,
};
export const terminalStderr = {
    getTerminalStderr() {
        return terminalStderrInstance;
    },
};
export const terminalStdin = {
    getTerminalStdin() {
        return terminalStdinInstance;
    },
};
export const terminalStdout = {
    getTerminalStdout() {
        return terminalStdoutInstance;
    },
};
