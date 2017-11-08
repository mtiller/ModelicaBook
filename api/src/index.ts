import * as express from 'express';
import { rootUrl, modelUrl, runUrl } from './urls';
import { getDetails } from './details';
import { rootGet, rootPost } from './root';
import { modelGet, modelPost } from './models';
import * as cors from 'cors';
import * as compression from 'compression';

import * as debug from 'debug';
const appDebug = debug("mbe:app");
// appDebug.enabled = true;

const app = express();
app.use(express.json());
app.use(cors({}));
app.use(compression());

let detailsMap = getDetails();
let models = Object.keys(detailsMap);

app.get(rootUrl(null), rootGet(models, detailsMap));
app.post(rootUrl(null), rootPost);

let testing = process.env.hasOwnProperty("TESTING_API");
appDebug("Testing flag: %j", testing);

models.forEach((model) => {
    appDebug("Adding model %s", model);
    let details = detailsMap[model];
    app.get(modelUrl(null, model), modelGet(details, model));
    app.post(runUrl(null, model), modelPost(details, model, testing));
})

app.listen(3000, () => console.log("API Server Running"));