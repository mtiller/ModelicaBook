#!/usr/bin/env python
import sys
import xml.etree.ElementTree as ET
import json

if len(sys.argv) != 3:
    print "Usage: "+sys.argv[0]+" xmlfile jsonfile"

tree = ET.parse(sys.argv[1])
root = tree.getroot()
j = {"desc": {},
     "experiment": {},
     "vars": {},
     "categories": {},
     "tree": {}}

desc = root.iter("fmiModelDescription").next()

for k in desc.attrib:
    j["desc"][k] = desc.attrib[k]
fqn = desc.attrib["modelName"]
j["desc"]["shortName"] = fqn.split(".")[-1]

exp = root.iter("DefaultExperiment").next()

for k in ["startTime", "stopTime", "tolerance"]:
    j["experiment"][k] = exp.attrib[k]

vars = root.iter("ModelVariables").next().iter("ScalarVariable")


def add2tree(name, parts, cur):
    if len(parts) == 1:
        cur[parts[0]] = name
        return
    if not parts[0] in cur:
        cur[parts[0]] = {}
    add2tree(name, parts[1:], cur[parts[0]])


def treename(name):
    if name.startswith("der("):
        vname = treename(name[4:-1])
        s = vname.split(".")
        s[-1] = "der("+s[-1]+")"
        return ".".join(s)
    return name


for v in vars:
    t = v[0]
    jv = {}
    vari = v.attrib["variability"]
    if not vari in j["categories"]:
        j["categories"][vari] = []
    for k in ["name", "valueReference", "variability", "causality",
              "alias", "description"]:
        jv[k] = v.attrib.get(k, "")

    jv["units"] = t.attrib.get("unit", "-")
    jv["start"] = t.attrib.get("start", "0")
    for a in ["min", "max"]:
        if a in t.attrib:
            jv[a] = t.attrib[a]

    if (vari != "parameter"):
        j["categories"][vari].append(jv["name"])
    else:
        if v.attrib.get("isValueChangeable", "false") == "true":
            j["categories"][vari].append(jv["name"])

    j["vars"][jv["name"]] = jv
    add2tree(jv["name"], treename(jv["name"]).split("."), j["tree"])

with open(sys.argv[2], "w+") as ofp:
    json.dump(j, ofp, indent=2)
