import * as fs from "fs";
import * as path from "path";

export interface CaseData {
    mods: {};
    vars: Array<{
        style: string;
        scale: number;
        name: string;
        legend: string;
    }>;
    ncols: number;
    title: string;
    legloc: "upper right" | "upper left" | "lower right" | "lower left";
    res: string;
    ncp: number;
    stopTime: number;
    tol: number;
    ylabel: string;
    ymin: number | null;
    type: string;
    ymax: number | null;
}

export interface Details {
    categories: {
        discrete: string[];
        continuous: string[];
        parameter: string[];
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
        };
    };
    casedata: CaseData;
}

export type DetailsMap = { [model: string]: Details };

function getModels() {
    return (
        fs
            .readdirSync(path.join(".", "models", "json"))
            // Consider only files that end with .json
            .filter(f => f.endsWith("-case.json"))
            // Strip the suffix
            .map(f => f.slice(0, f.length - 10))
    );
    // Ensure that we have an _init.xml file and executable for each one
    //.filter((f) => fs.existsSync(path.join(".", "models", `${f}_init.xml`)) && fs.existsSync(path.join(".", "models", `${f}`)));
}

export function getDetails(): DetailsMap {
    let models = getModels();
    let details: DetailsMap = {};

    models.forEach(model => {
        try {
            let cfile = path.join(".", "models", "json", `${model}-case.json`);
            if (fs.existsSync(cfile)) {
                let cdata = fs.readFileSync(cfile).toString();
                if (cdata !== "") {
                    let cobj = JSON.parse(cdata) as CaseData;
                    let res = cobj.res;
                    let dfile = path.join(".", "models", "json", `${res}.json`);
                    let ddata = fs.readFileSync(dfile);
                    let dobj = JSON.parse(ddata.toString()) as Details;
                    dobj.casedata = cobj;
                    dobj.categories.discrete = dobj.categories.discrete || [];
                    dobj.categories.parameter = dobj.categories.parameter || [];
                    dobj.categories.continuous = dobj.categories.continuous || [];
                    details[model] = dobj;
                }
            } else {
                console.warn("No case data for " + model);
            }
        } catch (e) {
            console.warn("Error parsing case data for " + model + ": ", e);
        }
    });

    return details;
}
