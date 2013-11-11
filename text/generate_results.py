#!/usr/bin/env python

import os
import re
import sys

def findModel(*frags):
    rfrags = map(lambda x: re.compile(x), frags)
    res = []
    root = os.path.join(path, "ModelicaByExample")
    for ent in os.walk(root):
        for f in ent[2]:
            if f=="package.mo":
                continue
            match = True
            full = os.path.join(ent[0], f)
            rel = full[(len(root)+1):]
            modname = rel[:-3].replace("/",".")
            for rfrag in rfrags:
                if len(rfrag.findall(modname))==0:
                    match = False
            if match:
                res.append((full, rel, modname))
    if len(res)==1:
        return res[0]
    else:
        print "Unable to find a unique match for "+str(frags)+" matches include:"
        for r in res:
            print str(r)
        sys.exit(1)

def add_model(*frags, **kwargs):
    mod = findModel(*frags)
    data = kwargs.copy()
    data["name"] = mod[2]
    models.append(data)

models = []
path = os.path.abspath("..");
results = default=os.path.abspath("./results")

# This is the list of things I need to simulate

## Simple Examples
add_model("SimpleExample", "FirstOrder$", stopTime=10);
add_model("SimpleExample", "FirstOrderInitial", stopTime=10);
add_model("SimpleExample", "FirstOrderSteady", stopTime=10);

## Cooling Example
add_model("NewtonCoolingWithDefaults", stopTime=10)

## RLC
add_model("RLC1", stopTime=10)

## RotationalSMD
add_model("SecondOrderSystemInitParams", stopTime=1)
add_model("SecondOrderSystemInitParams", stopTime=1, mods={"phi1": 1.0})

def genSimScript():
    preamble = """
    loadModel(ModelicaServices);
    loadModel(Modelica);
    setModelicaPath(getModelicaPath()+":"+"%s");
    loadModel(ModelicaByExample);
    """ % (path,)

    cmd = preamble

    for model in models:
        dotname = model["name"]
        stop_time = model["stopTime"]
        dashname = dotname.replace(".", "_")

        if stop_time==None:
            cmd = cmd+"""
    simulate(ModelicaByExample.%s, tolerance=1e-3, numberOfIntervals=500, fileNamePrefix="%s");
    """ % (dotname,dashname)
        else:
            cmd = cmd+"""
    simulate(ModelicaByExample.%s, stopTime=%s, tolerance=1e-3, numberOfIntervals=500, fileNamePrefix="%s");
    """ % (dotname, stop_time, dashname)

    print cmd

genSimScript()
