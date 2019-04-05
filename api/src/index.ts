import * as express from "express";
import { rootUrl, modelUrl, runUrl, findUrl } from "./urls";
import { getDetails } from "./details";
import { rootGet, rootPost } from "./root";
import { modelGet, modelPost } from "./models";
import * as cors from "cors";
import * as compression from "compression";

import * as debug from "debug";
const appDebug = debug("mbe:app");
// appDebug.enabled = true;

const app = express();
app.use(express.json());
app.use(
    cors({
        origin: "*",
        exposedHeaders: ["Location"], // Needed because the 'find' action requires us to follow Location
    }),
);
app.use(compression());
app.set("trust proxy", ["loopback", "linklocal", "uniquelocal"]); // specify multiple subnets as an array
app.set("trust proxy", "127.0.0.1"); // For when we run behind an nginx reverse proxy

let detailsMap = getDetails();
let models = Object.keys(detailsMap);

appDebug("Root URL for API: %s", rootUrl(null));
app.get(rootUrl(null), rootGet(models, detailsMap));

appDebug("Find action at %s", findUrl(null));
app.post(findUrl(null), rootPost(models));

let testing = process.env.hasOwnProperty("TESTING_API");
appDebug("Testing flag: %j", testing);

models.forEach(model => {
    appDebug("Adding model %s", model);
    let details = detailsMap[model];
    appDebug("  model details: %s", modelUrl(null, model));
    app.get(modelUrl(null, model), modelGet(details, model));
    appDebug("  run: %s", runUrl(null, model));
    app.post(runUrl(null, model), modelPost(details, model, testing));
});

app.listen(process.env["MBE_API_PORT"] || 3000, () => console.log("API Server Running"));
