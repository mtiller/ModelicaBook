import { rootUrl } from './urls';
import * as express from 'express';
import { Link } from 'siren-types';
import { DetailsMap } from './details';
import { modelUrl } from './urls';
import { sendSiren } from './utils';

export function rootGet(models: string[], details: DetailsMap) {
    return (req: express.Request, res: express.Response) => {
        let links: Link[] = models.map((model) => {
            return {
                "rel": ["model"],
                "title": details[model].desc.description,
                "href": modelUrl(req, model),
            }
        })
        sendSiren(res, {
            properties: {
                models: models,
            },
            links: [...links,
            {
                "rel": ["self"],
                href: rootUrl(req),
            },
            {
                "rel": ["template"],
                href: modelUrl(req, "{model}"),
            }],
            actions: [{
                name: "find",
                method: "POST",
                href: rootUrl(req),
                fields: [{ name: "model", type: "text" }],
            }]
        });
    }
}

export function rootPost(models: string[]) {
    return (req: express.Request, res: express.Response) => {
        if (req.body.hasOwnProperty("model")) {
            let model = req.body["model"];
            if (models.indexOf(model) == -1) {
                res.status(400).send("No model named " + model);
            } else {
                res.setHeader("location", modelUrl(req, model));
                res.send("Found model " + model);
            }
        } else {
            res.status(400).send("Required payload field 'model' not found");
        }
    }
}