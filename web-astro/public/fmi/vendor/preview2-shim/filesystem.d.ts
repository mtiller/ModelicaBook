import { types as TypesNamespace, preopens as PreopensNamespace } from "../../types/filesystem.js";
import { InputStream as IInputStream, OutputStream as IOutputStream } from "../../types/interfaces/wasi-io-streams.js";
export { _setCwd } from "./config.js";
type Filesize = TypesNamespace.Filesize;
type OpenFlags = TypesNamespace.OpenFlags;
type PathFlags = TypesNamespace.PathFlags;
export interface FileDataEntry {
    dir?: Record<string, FileDataEntry>;
    source?: Uint8Array | string;
}
/**
 * Root file data structure representing a filesystem tree.
 * Each entry is either a directory (has `dir` property) or a file (has `source` property).
 * @example
 * // A simple filesystem with one directory containing one file:
 * const fileData = {
 *   dir: {
 *     'myfile.txt': { source: new Uint8Array([72, 101, 108, 108, 111]) }
 *   }
 * };
 */
export type FileData = FileDataEntry;
export declare function _setFileData(fileData: FileData): void;
export declare function _getFileData(): string;
declare class DirectoryEntryStream implements TypesNamespace.DirectoryEntryStream {
    idx: number;
    entries: [string, FileDataEntry][];
    static _create(entries: [string, FileDataEntry][]): DirectoryEntryStream;
    readDirectoryEntry(): TypesNamespace.DirectoryEntry | undefined;
}
declare class Descriptor implements TypesNamespace.Descriptor {
    #private;
    _getEntry(descriptor: Descriptor): FileDataEntry;
    static _create(entry: FileDataEntry | any, isStream?: boolean): Descriptor;
    readViaStream(_offset: bigint): IInputStream;
    writeViaStream(_offset: bigint): IOutputStream;
    appendViaStream(): IOutputStream;
    advise(offset: Filesize, length: Filesize, advice: TypesNamespace.Advice): void;
    syncData(): void;
    getFlags(): TypesNamespace.DescriptorFlags;
    getType(): "directory" | "regular-file" | "unknown" | "fifo";
    setSize(size: bigint): void;
    setTimes(dataAccessTimestamp: any, dataModificationTimestamp: any): void;
    read(length: bigint, offset: bigint): [Uint8Array<ArrayBufferLike>, boolean];
    write(buffer: Uint8Array, offset: Filesize): bigint;
    readDirectory(): DirectoryEntryStream;
    sync(): void;
    createDirectoryAt(path: string): void;
    stat(): {
        type: "directory" | "regular-file" | "unknown";
        linkCount: bigint;
        size: bigint;
        dataAccessTimestamp: {
            seconds: bigint;
            nanoseconds: number;
        };
        dataModificationTimestamp: {
            seconds: bigint;
            nanoseconds: number;
        };
        statusChangeTimestamp: {
            seconds: bigint;
            nanoseconds: number;
        };
    };
    statAt(_pathFlags: PathFlags, path: string): {
        type: "directory" | "regular-file" | "unknown";
        linkCount: bigint;
        size: bigint;
        dataAccessTimestamp: {
            seconds: bigint;
            nanoseconds: number;
        };
        dataModificationTimestamp: {
            seconds: bigint;
            nanoseconds: number;
        };
        statusChangeTimestamp: {
            seconds: bigint;
            nanoseconds: number;
        };
    };
    setTimesAt(): void;
    linkAt(): void;
    openAt(_pathFlags: PathFlags, path: string, openFlags: OpenFlags, _flags: TypesNamespace.DescriptorFlags): Descriptor;
    readlinkAt(_path: string): string;
    removeDirectoryAt(): void;
    renameAt(): void;
    symlinkAt(): void;
    unlinkFileAt(): void;
    isSameObject(other: TypesNamespace.Descriptor): boolean;
    metadataHash(): {
        upper: bigint;
        lower: bigint;
    };
    metadataHashAt(_pathFlags: any, _path: string): {
        upper: bigint;
        lower: bigint;
    };
}
export declare const preopens: typeof PreopensNamespace;
/**
 * Replace all preopens with the given set.
 * @param preopensConfig - Map of virtual paths to file data entries
 */
export declare function _setPreopens(preopensConfig: Record<string, FileData>): void;
/**
 * Add a single preopen mapping.
 * @param virtualPath - The virtual path visible to the guest
 * @param fileData - The file data object representing the directory
 */
export declare function _addPreopen(virtualPath: string, fileData: FileData): void;
/**
 * Clear all preopens, giving the guest no filesystem access.
 *
 * This functionality exists mostly to maintain backwards compatibility. Prefer setting preopens
 * via `WASIShim` rather than making top level changes to preopens using these functions.
 */
export declare function _clearPreopens(): void;
/**
 * Get current preopens configuration.
 * @returns Array of [descriptor, virtualPath] pairs
 */
export declare function _getPreopens(): [Descriptor, string][];
/**
 * Create a preopen descriptor for a host path.
 * This is used internally to create isolated preopen instances.
 * @param  hostPreopen - The host filesystem path
 * @returns A preopen descriptor
 */
export declare function _createPreopenDescriptor(hostPreopen: string): Descriptor;
export declare const types: typeof TypesNamespace;
