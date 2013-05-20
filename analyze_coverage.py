#!/usr/bin/env python

import yaml

tf = open("topics.yaml")
tdata = tf.read()
tf.close()

ttree = yaml.load(tdata)
print "Tree: "+str(ttree)

topics = set()
sections = set()

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

print
print "Topics: "+str(topics)
print "Sections: "+str(sections)

