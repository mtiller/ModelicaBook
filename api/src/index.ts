import * as express from 'express';
import { rootUrl, modelUrl, runUrl } from './urls';
import { getModels, getDetails } from './details';
import { rootGet, rootPost } from './root';
import { modelGet, modelPost } from './models';

const app = express();
app.use(express.json());

let models = getModels();
let detailsMap = getDetails(models);

app.get(rootUrl(null), rootGet(models, detailsMap));
app.post(rootUrl(null), rootPost);

models.forEach((model) => {
    let details = detailsMap[model];
    app.get(modelUrl(null, model), modelGet(details, model));
    app.post(runUrl(null, model), modelPost(details, model));
})

app.listen(3000, () => console.log("API Server Running"));