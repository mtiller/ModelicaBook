import type { error as ErrorNamespace, poll as PollNamespace, streams as StreamsNamespace } from "../../types/io.js";
declare const symbolDispose: symbol;
type IInputStream = StreamsNamespace.InputStream;
type IOutputStream = StreamsNamespace.OutputStream;
/**
 * Handler interface for creating custom input streams
 */
export type InputStreamHandler = Partial<IInputStream> & Required<Pick<IInputStream, "blockingRead">> & {
    drop?: () => void;
};
/**
 * Handler interface for creating custom output streams
 */
export type OutputStreamHandler = Partial<IOutputStream> & Required<Pick<IOutputStream, "write">> & {
    drop?: () => void;
};
declare class InputStream implements IInputStream {
    [symbolDispose]: () => void;
    id: number;
    handler: InputStreamHandler;
    static _create(handler: InputStreamHandler): InputStream;
    read(len: bigint): Uint8Array<ArrayBufferLike>;
    blockingRead(len: bigint): Uint8Array<ArrayBufferLike>;
    skip(len: bigint): bigint;
    blockingSkip(len: bigint): bigint;
    subscribe(): PollNamespace.Pollable | Pollable;
}
export declare const inputStreamCreate: typeof InputStream._create;
declare class OutputStream implements IOutputStream {
    [symbolDispose]: () => void;
    id: number;
    open: boolean;
    handler: OutputStreamHandler;
    static _create(handler: OutputStreamHandler): OutputStream;
    checkWrite(): bigint;
    write(buf: Uint8Array): void;
    blockingWriteAndFlush(buf: Uint8Array): void;
    flush(): void;
    blockingFlush(): void;
    writeZeroes(len: bigint): void;
    blockingWriteZeroesAndFlush(len: bigint): void;
    splice(src: InputStream, len: bigint): bigint;
    blockingSplice(_src: InputStream, _len: bigint): bigint;
    subscribe(): PollNamespace.Pollable | Pollable;
}
export declare const outputStreamCreate: typeof OutputStream._create;
export declare const error: typeof ErrorNamespace;
export declare const streams: typeof StreamsNamespace;
declare class Pollable implements PollNamespace.Pollable {
    #private;
    [symbolDispose]: () => void;
    static _create(promise?: Promise<void>): Pollable;
    ready(): boolean;
    block(): Promise<void>;
}
export declare const pollableCreate: typeof Pollable._create;
export declare const poll: typeof PollNamespace;
export {};
