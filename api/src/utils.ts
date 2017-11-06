import * as express from 'express';
import { Siren } from 'siren-types';

export function sendSiren(res: express.Response, s: Siren) {
    // TODO: necessary?
    let str = JSON.stringify(s);
    res.setHeader("content-type", "application/json");
    res.send(str);
}

