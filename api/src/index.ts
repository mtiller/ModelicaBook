import * as express from 'express';
import { rootUrl, modelUrl, runUrl } from './urls';
import { getModels, getDetails } from './details';
import { rootGet, rootPost } from './root';
import { modelGet, modelPost } from './models';
import * as cors from 'cors';

const app = express();
app.use(express.json());
app.use(cors({}));

let models = getModels();
let detailsMap = getDetails(models);

app.get(rootUrl(null), rootGet(models, detailsMap));
app.post(rootUrl(null), rootPost);

let testing = process.env.hasOwnProperty("TESTING_API");

models.forEach((model) => {
    let details = detailsMap[model];
    app.get(modelUrl(null, model), modelGet(details, model));
    app.post(runUrl(null, model), modelPost(details, model, testing));
})

app.listen(3000, () => console.log("API Server Running"));