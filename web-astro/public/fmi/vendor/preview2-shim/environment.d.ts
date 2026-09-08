import type { environment as EnvironmentNamespace } from "../../types/cli.js";
export declare function _setEnv(envObj: Record<string, string>): void;
export declare function _setArgs(args: string[]): void;
export declare function _setCwd(cwd: string): void;
export declare const environment: typeof EnvironmentNamespace;
