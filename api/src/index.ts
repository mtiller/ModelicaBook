import * as express from 'express';
import * as fs from 'fs';
import * as path from 'path';
import { rootUrl, modelUrl, runUrl } from './urls';
import { Siren, Link } from 'siren-types';

const app = express();
app.use(express.json());

interface Details {
    desc: {
        description: string,
    }
}

let models = fs.readdirSync(path.join(".", "models", "json"))
    // Consider only files that end with .json
    .filter((f) => f.endsWith(".json"))
    // Strip the suffix
    .map((f) => f.slice(0, f.length - 5))
    // Ensure that we have an _init.xml file and executable for each one
    .filter((f) => fs.existsSync(path.join(".", "models", `${f}_init.xml`)) && fs.existsSync(path.join(".", "models", `${f}`)));

let details: { [model: string]: Details } = {};

function sendSiren(res: express.Response, s: Siren) {
    let str = JSON.stringify(s);
    res.setHeader("content-type", "application/json");
    res.send(str);
}

app.get("/", (req, res) => {
    let links: Link[] = models.map((model) => {
        return {
            "rel": ["model"],
            "title": details[model].desc.description,
            "href": modelUrl(req, model),
        }
    })
    sendSiren(res, {
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
});

app.post(rootUrl(null), (req, res) => {
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
})

models.forEach((model) => {
    let data = fs.readFileSync(path.join(".", "models", "json", `${model}.json`));
    let obj = JSON.parse(data.toString());
    details[model] = obj;

    app.get(modelUrl(null, model), (req, res) => {
        sendSiren(res, {
            title: obj.desc.description,
            actions: [
                {
                    name: "run",
                    method: "POST",
                    href: runUrl(req, model),
                }
            ]
        });
    });
    app.post(runUrl(null, model), (req, res) => {
        // Parse body
        // Run simulation
        // Collect required results
        sendSiren(res, {
            title: "Result of simulating " + obj.desc.description,
        });
    })
})

app.listen(3000, () => console.log("API Server Running"));