import * as express from 'express';
import { sendSiren } from './utils';
import { runUrl } from './urls';
import { Field } from 'siren-types';
import { Details } from './details';

export function modelGet(details: Details, model: string) {
    return (req: express.Request, res: express.Response) => {
        sendSiren(res, {
            title: details.desc.description,
            actions: [
                {
                    name: "run",
                    method: "POST",
                    href: runUrl(req, model),
                    fields: (details.categories.parameter || []).map((param): Field => (
                        {
                            name: param,
                            type: "number",
                            title: details.vars[param].description,
                        }))
                }
            ]
        });
    }
}

export function modelPost(details: Details, model: string) {
    return (req: express.Request, res: express.Response) => {
        // Parse body
        // Run simulation
        // Collect required results
        sendSiren(res, {
            title: "Result of simulating " + details.desc.description,
        });
    }
}