#!/usr/bin/env python

# Import several packages
import yaml
import jinja2
import sys
import os

# Setup Jinja environment
root = os.path.dirname(os.path.abspath(sys.argv[0]))
template_dir = os.path.join(root, "templates")
loader = jinja2.FileSystemLoader(template_dir)
env = jinja2.Environment(loader=loader)

# Read topic file
tf = open("topics.yaml")
tdata = tf.read()
tf.close()
ttree = yaml.load(tdata)

# Read outline
of = open("outline.yaml")
odata = of.read()
of.close()
otree = yaml.load(odata)

# Initialize data
topics = set()
sections = set()

# Loop through topic tree and extract
# topic identifiers and specification
# section numbers
for heading in ttree:
    htopics = ttree[heading]
    for t in htopics:
        sects = htopics[t]
        for s in sects:
            sections.add(s)
        if t in topics:
            print "Topic %s is repeated under heading %s" % \
                (str(t), str(heading))
        else:
            topics.add(t)

def topics_covered(node):
    """
    This function takes a YAML node and walks it until it
    gets to the leaves which it will assume are topic
    identifiers.
    """
    global topics
    ret = set()
    if node==None:
        return set()
    if type(node)==list:
        for t in node:
            if t in topics:
                ret.add(t)
            else:
                print "Unknown topic: %s in node %s" % (str(t), str(node))
        return ret
    if type(node)==dict:
        for key in node:
            for t in topics_covered(node[key]):
                if t in topics:
                    ret.add(t)
                else:
                    print "Unknown topic: %s in node %s" % (str(t), str(node))
        return ret
    print "Cannot extract topics from: "+str(node)
    return set()

# A list of the sections
sectmap = []
# Topics covered by each section
coverage = {} # chapter:sect -> topics

# Traverse the parts of the book
for part in otree:
    chapters = otree[part]
    # Traverse chapters of the book
    for chapter in chapters:
        sects = chapters[chapter]
        if sects==None:
            #print "Chapter %s has no sections" % (chapter,)
            continue
        # Traverse sections of the chapter
        for sect in sects:
            # Record information about topics covered
            # in this section
            try:
                structure = sects[sect]
                covered = topics_covered(structure)
                name = "%s:%s" % (chapter, sect)
                coverage[name] = covered
                sectmap.append(name)
            except:
                print "Error access section '"+str(sect)+"'"

covered = set()
for ts in coverage.values():
    covered.update(ts)

uncovered = topics-covered

template = env.get_template("coverage_report.html")
result = template.render(sects=sectmap, topics=topics, coverage=coverage,
                         covered=covered, uncovered=uncovered)

alpha = list(uncovered)
alpha.sort(lambda x, y: cmp(x, y))

print "Uncovered topics:"
for t in alpha:
    print str(t)

fp = open("coverage_report.html", "w")
fp.write(result)
fp.close()
