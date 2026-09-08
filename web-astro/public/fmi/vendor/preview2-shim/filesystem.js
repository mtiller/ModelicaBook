import { inputStreamCreate, outputStreamCreate } from "./io.js";
import { environment } from "./environment.js";
import { _setCwd, _getCwd } from "./config.js";
export { _setCwd } from "./config.js";
export function _setFileData(fileData) {
    _fileData = fileData;
    _rootPreopen[0] = descriptorCreate(fileData);
    const cwd = environment.initialCwd();
    _setCwd(cwd || "/");
}
export function _getFileData() {
    return JSON.stringify(_fileData);
}
let _fileData = { dir: {} };
const timeZero = {
    seconds: 0n,
    nanoseconds: 0,
};
/** Coerce the given object to a safe integer */
function coerceToSafeIntegerNumber(obj) {
    let n;
    if (typeof obj === "number") {
        n = obj;
    }
    else if (typeof obj == "bigint") {
        n = Number(obj);
    }
    else {
        throw new TypeError(`unexpected non-numeric type: ${obj}`);
    }
    if (n > Number.MAX_SAFE_INTEGER) {
        throw new TypeError(`excessively large number: ${n}`);
    }
    return n;
}
function getChildEntry(parentEntry, subpath, openFlags) {
    if (subpath === "." && _rootPreopen && descriptorGetEntry(_rootPreopen[0]) === parentEntry) {
        subpath = _getCwd();
        if (subpath.startsWith("/") && subpath !== "/") {
            subpath = subpath.slice(1);
        }
    }
    let entry = parentEntry;
    let segmentIdx;
    do {
        if (!entry?.dir) {
            throw "not-directory";
        }
        segmentIdx = subpath.indexOf("/");
        const segment = segmentIdx === -1 ? subpath : subpath.slice(0, segmentIdx);
        if (segment === "..") {
            throw "no-entry";
        }
        if (segment === "." || segment === "") {
        }
        else if (!entry.dir[segment] && openFlags.create) {
            entry = entry.dir[segment] = openFlags.directory
                ? { dir: {} }
                : { source: new Uint8Array([]) };
        }
        else {
            entry = entry.dir[segment];
        }
        subpath = subpath.slice(segmentIdx + 1);
    } while (segmentIdx !== -1);
    if (!entry) {
        throw "no-entry";
    }
    return entry;
}
function getSource(fileEntry) {
    if (typeof fileEntry.source === "string") {
        fileEntry.source = new TextEncoder().encode(fileEntry.source);
    }
    return fileEntry.source;
}
class DirectoryEntryStream {
    idx = 0;
    entries = [];
    static _create(entries) {
        const stream = new DirectoryEntryStream();
        stream.entries = entries;
        return stream;
    }
    readDirectoryEntry() {
        if (this.idx === this.entries.length) {
            return undefined;
        }
        const [name, entry] = this.entries[this.idx];
        this.idx += 1;
        return {
            name,
            type: entry.dir ? "directory" : "regular-file",
        };
    }
}
const descriptorEntryStreamCreate = DirectoryEntryStream._create;
// @ts-expect-error - Deleting static method
delete DirectoryEntryStream._create;
class Descriptor {
    #stream;
    #entry;
    #mtime = 0;
    _getEntry(descriptor) {
        return descriptor.#entry;
    }
    static _create(entry, isStream) {
        const descriptor = new Descriptor();
        if (isStream) {
            descriptor.#stream = entry;
        }
        else {
            descriptor.#entry = entry;
        }
        return descriptor;
    }
    readViaStream(_offset) {
        const source = getSource(this.#entry);
        let offset = Number(_offset);
        return inputStreamCreate({
            blockingRead(len) {
                if (offset === source.byteLength) {
                    throw { tag: "closed" };
                }
                const bytes = source.slice(offset, offset + Number(len));
                offset += bytes.byteLength;
                return bytes;
            },
        });
    }
    writeViaStream(_offset) {
        const entry = this.#entry;
        let offset = Number(_offset);
        return outputStreamCreate({
            write(buf) {
                const src = entry.source;
                const newSource = new Uint8Array(buf.byteLength + src.byteLength);
                newSource.set(src, 0);
                newSource.set(buf, offset);
                offset += buf.byteLength;
                entry.source = newSource;
            },
        });
    }
    appendViaStream() {
        console.log(`[filesystem] APPEND STREAM`);
        return {};
    }
    advise(offset, length, advice) {
        console.log(`[filesystem] ADVISE`, offset, length, advice);
    }
    syncData() {
        console.log(`[filesystem] SYNC DATA`);
    }
    getFlags() {
        console.log(`[filesystem] FLAGS FOR`);
        return {};
    }
    getType() {
        if (this.#stream) {
            return "fifo";
        }
        if (this.#entry.dir) {
            return "directory";
        }
        if (this.#entry.source) {
            return "regular-file";
        }
        return "unknown";
    }
    setSize(size) {
        console.log(`[filesystem] SET SIZE`, size);
    }
    setTimes(dataAccessTimestamp, dataModificationTimestamp) {
        console.log(`[filesystem] SET TIMES`, dataAccessTimestamp, dataModificationTimestamp);
    }
    read(length, offset) {
        const source = getSource(this.#entry);
        const off = coerceToSafeIntegerNumber(offset);
        const len = coerceToSafeIntegerNumber(length);
        const result = [
            source.slice(off, off + len),
            off + len >= source.byteLength,
        ];
        return result;
    }
    write(buffer, offset) {
        if (offset !== 0n) {
            throw "invalid-seek";
        }
        this.#entry.source = buffer;
        return BigInt(buffer.byteLength);
    }
    readDirectory() {
        if (!this.#entry?.dir) {
            throw "bad-descriptor";
        }
        return descriptorEntryStreamCreate(Object.entries(this.#entry.dir).sort(([a], [b]) => (a > b ? 1 : -1)));
    }
    sync() {
        console.log(`[filesystem] SYNC`);
    }
    createDirectoryAt(path) {
        const entry = getChildEntry(this.#entry, path, {
            create: true,
            directory: true,
        });
        if (entry.source) {
            throw "exist";
        }
    }
    stat() {
        let type = "unknown";
        let size = 0n;
        if (this.#entry.source) {
            type = "regular-file";
            const source = getSource(this.#entry);
            size = BigInt(source.byteLength);
        }
        else if (this.#entry.dir) {
            type = "directory";
        }
        return {
            type,
            linkCount: 0n,
            size,
            dataAccessTimestamp: timeZero,
            dataModificationTimestamp: timeZero,
            statusChangeTimestamp: timeZero,
        };
    }
    statAt(_pathFlags, path) {
        const entry = getChildEntry(this.#entry, path, {
            create: false,
            directory: false,
        });
        let type = "unknown";
        let size = 0n;
        if (entry.source) {
            type = "regular-file";
            const source = getSource(entry);
            size = BigInt(source.byteLength);
        }
        else if (entry.dir) {
            type = "directory";
        }
        return {
            type,
            linkCount: 0n,
            size,
            dataAccessTimestamp: timeZero,
            dataModificationTimestamp: timeZero,
            statusChangeTimestamp: timeZero,
        };
    }
    setTimesAt() {
        console.log(`[filesystem] SET TIMES AT`);
    }
    linkAt() {
        console.log(`[filesystem] LINK AT`);
    }
    openAt(_pathFlags, path, openFlags, _flags) {
        const childEntry = getChildEntry(this.#entry, path, openFlags);
        return descriptorCreate(childEntry);
    }
    readlinkAt(_path) {
        console.log(`[filesystem] READLINK AT`);
        return "";
    }
    removeDirectoryAt() {
        console.log(`[filesystem] REMOVE DIR AT`);
    }
    renameAt() {
        console.log(`[filesystem] RENAME AT`);
    }
    symlinkAt() {
        console.log(`[filesystem] SYMLINK AT`);
    }
    unlinkFileAt() {
        console.log(`[filesystem] UNLINK FILE AT`);
    }
    isSameObject(other) {
        return other === this;
    }
    metadataHash() {
        let upper = 0n;
        upper += BigInt(this.#mtime);
        return { upper, lower: 0n };
    }
    metadataHashAt(_pathFlags, _path) {
        return this.metadataHash();
    }
}
const descriptorGetEntry = Descriptor.prototype._getEntry;
// @ts-expect-error - Deleting prototype method
delete Descriptor.prototype._getEntry;
const descriptorCreate = Descriptor._create;
// @ts-expect-error - Deleting static method
delete Descriptor._create;
let _preopens = [[descriptorCreate(_fileData), "/"]];
let _rootPreopen = _preopens[0];
export const preopens = {
    getDirectories() {
        return _preopens;
    },
};
/**
 * Replace all preopens with the given set.
 * @param preopensConfig - Map of virtual paths to file data entries
 */
export function _setPreopens(preopensConfig) {
    _preopens = [];
    for (const [virtualPath, fileData] of Object.entries(preopensConfig)) {
        _addPreopen(virtualPath, fileData);
    }
}
/**
 * Add a single preopen mapping.
 * @param virtualPath - The virtual path visible to the guest
 * @param fileData - The file data object representing the directory
 */
export function _addPreopen(virtualPath, fileData) {
    const descriptor = descriptorCreate(fileData);
    _preopens.push([descriptor, virtualPath]);
    if (virtualPath === "/") {
        _rootPreopen = [descriptor, virtualPath];
    }
}
/**
 * Clear all preopens, giving the guest no filesystem access.
 *
 * This functionality exists mostly to maintain backwards compatibility. Prefer setting preopens
 * via `WASIShim` rather than making top level changes to preopens using these functions.
 */
export function _clearPreopens() {
    _preopens = [];
    _rootPreopen = null;
}
/**
 * Get current preopens configuration.
 * @returns Array of [descriptor, virtualPath] pairs
 */
export function _getPreopens() {
    return [..._preopens];
}
/**
 * Create a preopen descriptor for a host path.
 * This is used internally to create isolated preopen instances.
 * @param  hostPreopen - The host filesystem path
 * @returns A preopen descriptor
 */
export function _createPreopenDescriptor(hostPreopen) {
    _fileData.dir = {
        [hostPreopen]: {},
    };
    return descriptorCreate(_fileData);
}
export const types = {
    Descriptor,
    DirectoryEntryStream,
    filesystemErrorCode: (err) => {
        let message;
        if ("payload" in err) {
            message = err.payload;
        }
        else if ("message" in err) {
            message = err.message;
        }
        return convertFsError(message);
    },
};
function convertFsError(e) {
    switch (e.code) {
        case "EACCES":
            return "access";
        case "EAGAIN":
        case "EWOULDBLOCK":
            return "would-block";
        case "EALREADY":
            return "already";
        case "EBADF":
            return "bad-descriptor";
        case "EBUSY":
            return "busy";
        case "EDEADLK":
            return "deadlock";
        case "EDQUOT":
            return "quota";
        case "EEXIST":
            return "exist";
        case "EFBIG":
            return "file-too-large";
        case "EILSEQ":
            return "illegal-byte-sequence";
        case "EINPROGRESS":
            return "in-progress";
        case "EINTR":
            return "interrupted";
        case "EINVAL":
            return "invalid";
        case "EIO":
            return "io";
        case "EISDIR":
            return "is-directory";
        case "ELOOP":
            return "loop";
        case "EMLINK":
            return "too-many-links";
        case "EMSGSIZE":
            return "message-size";
        case "ENAMETOOLONG":
            return "name-too-long";
        case "ENODEV":
            return "no-device";
        case "ENOENT":
            return "no-entry";
        case "ENOLCK":
            return "no-lock";
        case "ENOMEM":
            return "insufficient-memory";
        case "ENOSPC":
            return "insufficient-space";
        case "ENOTDIR":
        case "ERR_FS_EISDIR":
            return "not-directory";
        case "ENOTEMPTY":
            return "not-empty";
        case "ENOTRECOVERABLE":
            return "not-recoverable";
        case "ENOTSUP":
            return "unsupported";
        case "ENOTTY":
            return "no-tty";
        // windows gives this error for badly structured `//` reads
        // this seems like a slightly better error than unknown given
        // that it's a common footgun
        case -4094:
        case "ENXIO":
            return "no-such-device";
        case "EOVERFLOW":
            return "overflow";
        case "EPERM":
            return "not-permitted";
        case "EPIPE":
            return "pipe";
        case "EROFS":
            return "read-only";
        case "ESPIPE":
            return "invalid-seek";
        case "ETXTBSY":
            return "text-file-busy";
        case "EXDEV":
            return "cross-device";
        case "UNKNOWN":
            switch (e.errno) {
                case -4094:
                    return "no-such-device";
                default:
                    throw e;
            }
        default:
            throw e;
    }
}
