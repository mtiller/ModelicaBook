"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const fs = require("fs");
const path = require("path");
const urls_1 = require("./urls");
const app = express();
app.use(express.json());
let models = fs.readdirSync(path.join(".", "models", "json"))
    .filter((f) => f.endsWith(".json"))
    .map((f) => f.slice(0, f.length - 5))
    .filter((f) => fs.existsSync(path.join(".", "models", `${f}_init.xml`)) && fs.existsSync(path.join(".", "models", `${f}`)));
let details = {};
function sendSiren(res, s) {
    let str = JSON.stringify(s);
    res.setHeader("content-type", "application/json");
    res.send(str);
}
app.get("/", (req, res) => {
    let links = models.map((model) => {
        return {
            "rel": ["model"],
            "title": details[model].desc.description,
            "href": urls_1.modelUrl(req, model),
        };
    });
    sendSiren(res, {
        links: [...links,
            {
                "rel": ["self"],
                href: urls_1.rootUrl(req),
            },
            {
                "rel": ["template"],
                href: urls_1.modelUrl(req, "{model}"),
            }],
        actions: [{
                name: "find",
                method: "POST",
                href: urls_1.rootUrl(req),
                fields: [{ name: "model", type: "text" }],
            }]
    });
});
app.post(urls_1.rootUrl(null), (req, res) => {
    if (req.body.hasOwnProperty("model")) {
        let model = req.body["model"];
        if (models.indexOf(model) == -1) {
            res.status(400).send("No model named " + model);
        }
        else {
            res.setHeader("location", urls_1.modelUrl(req, model));
            res.send("Found model " + model);
        }
    }
    else {
        res.status(400).send("Required payload field 'model' not found");
    }
});
models.forEach((model) => {
    let data = fs.readFileSync(path.join(".", "models", "json", `${model}.json`));
    let obj = JSON.parse(data.toString());
    details[model] = obj;
    app.get(urls_1.modelUrl(null, model), (req, res) => {
        sendSiren(res, {
            title: obj.desc.description,
            actions: [
                {
                    name: "run",
                    method: "POST",
                    href: urls_1.runUrl(req, model),
                }
            ]
        });
    });
    app.post(urls_1.runUrl(null, model), (req, res) => {
        // Parse body
        // Run simulation
        // Collect required results
        sendSiren(res, {
            title: "Result of simulating " + obj.desc.description,
        });
    });
});
app.listen(3000, () => console.log("API Server Running"));
