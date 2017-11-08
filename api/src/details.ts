import * as fs from 'fs';
import * as path from 'path';

export interface CaseData {
    mods: {},
    vars: Array<{
        style: string,
        scale: number,
        name: string,
        legend: string,
    }>;
    ncols: number,
    title: string,
    legloc: "upper right" | "upper left" | "lower right" | "lower left",
    res: string,
    ncp: number,
    stopTime: number,
    tol: number,
    ylabel: string,
    ymin: number | null,
    type: string,
    ymax: number | null,
};

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
    casedata?: CaseData;
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
        let dfile = path.join(".", "models", "json", `${model}.json`);
        let ddata = fs.readFileSync(dfile);
        let dobj = JSON.parse(ddata.toString()) as Details;
        let cfile = path.join(".", "models", "json", `${model}-case.json`);
        if (fs.existsSync(cfile)) {
            let cdata = fs.readFileSync(cfile);
            let cobj = JSON.parse(cdata.toString()) as CaseData;
            dobj.casedata = cobj;
        }
        details[model] = dobj;
    });

    return details;
}