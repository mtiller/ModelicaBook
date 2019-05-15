import { rootUrl, findUrl } from "./urls";
import * as express from "express";
import { Link, Siren } from "siren-types";
import { DetailsMap } from "./details";
import { modelUrl } from "./urls";
import { sendSiren } from "./utils";

import * as debug from "debug";

const log = debug("mbe:root");

export function rootGet(models: string[], details: DetailsMap) {
    return (req: express.Request, res: express.Response) => {
        log("Get GET requests at API root");
        let links: Link[] = models.map(model => {
            return {
                rel: ["model"],
                title: details[model].casedata.title,
                href: modelUrl(req, model),
            };
        });
        const response: Siren = {
            properties: {
                models: models,
            },
            links: [
                ...links,
                {
                    rel: ["self"],
                    href: rootUrl(req),
                },
                {
                    rel: ["template"],
                    href: modelUrl(req, "{model}"),
                },
            ],
            actions: [
                {
                    name: "find",
                    method: "POST",
                    href: findUrl(req),
                    type: "application/json",
                    fields: [{ name: "model", type: "text" }],
                },
            ],
        };
        sendSiren(res, response, {
            maxAge: 600,
        });
    };
}

export function rootPost(models: string[]) {
    return (req: express.Request, res: express.Response) => {
        log("Received POST request at root for %j", req.body);
        if (req.body.hasOwnProperty("model")) {
            let model = req.body["model"];

            log("  Model of interest: %s", model);
            if (models.indexOf(model) == -1) {
                res.status(400).send("No model named " + model);
            } else {
                const location = modelUrl(req, model);
                log("  Location header set to %s", location);
                res.setHeader("Location", location);
                res.status(201).send("Found model " + model);
            }
        } else {
            log("  No model provided");
            res.status(400).send("Required payload field 'model' not found");
        }
    };
}
