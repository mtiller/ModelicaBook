import * as fs from 'fs';
import * as path from 'path';

export interface Details {
    categories: {
        discrete?: string[];
        continuous?: string[];
        parameter?: string[];
    };
    desc: {
        modelName: string;
        shortName: string;
        description: string;
    };
    vars: {
        [varname: string]: {
            variability: string;
            valueReference: string;
            description: string;
            units?: string;
            start?: string;
            causality: string;
            name: string;
        }
    };
};

export type DetailsMap = { [model: string]: Details };

export function getModels() {
    return fs.readdirSync(path.join(".", "models", "json"))
        // Consider only files that end with .json
        .filter((f) => f.endsWith(".json"))
        // Strip the suffix
        .map((f) => f.slice(0, f.length - 5))
        // Ensure that we have an _init.xml file and executable for each one
        .filter((f) => fs.existsSync(path.join(".", "models", `${f}_init.xml`)) && fs.existsSync(path.join(".", "models", `${f}`)));
}

export function getDetails(models: string[]): DetailsMap {
    let details: DetailsMap = {};

    models.forEach((model) => {
        let data = fs.readFileSync(path.join(".", "models", "json", `${model}.json`));
        let obj = JSON.parse(data.toString()) as Details;
        details[model] = obj;
    });

    return details;
}