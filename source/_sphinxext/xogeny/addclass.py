from docutils import nodes

cleared_files = []
def truncate_file(app):
    if app.config.addclass_dump_file!=None:
        dump_file = app.config.addclass_dump_file
        if not dump_file in cleared_files:
            f = open(dump_file, "w")
            f.close()
            cleared_files.append(dump_file)

def add_classes(app, doctree):
    # If we have enabled the dump_file option, first check
    # to see if the dump_file has been truncated already.
    # If not then truncate it first and then append
    # the doctree to the dump file.
    if app.config.addclass_dump_file!=None:
        truncate_file(app)
        f = open(app.config.addclass_dump_file, "a+")
        print >> f, str(doctree)
        f.close()

    # Look through every node in the tree
    for node in doctree.traverse():
        # If it is an element, check to see if any classes should be added
        if isinstance(node, nodes.Element):
            # But, if we find one of the keys we are looking for
            # in the set of existing classes we are looking for
            # merge in the extra classes specified associated
            # with that class
            for key in app.config.addclass_class_map:
                if key in node.attributes['classes']:
                    node.attributes['classes'] += app.config.addclass_class_map[key]

            # Of if this element has an id we are looking for
            # add some classes then too...
            for key in app.config.addclass_id_map:
                if 'ids' in node.attributes and key in node.attributes['ids']:
                    node.attributes['classes'] += app.config.addclass_id_map[key]

            # Check this elements tag name and if it matches one of the
            # tag names we are looking for, add the classes to associate
            # with that tag
            if node.tagname in app.config.addclass_tag_map:
                node.attributes['classes'] += app.config.addclass_tag_map[node.tagname]

def setup(app):
    app.add_config_value('addclass_dump_file', None, False)
    app.add_config_value('addclass_class_map', {}, False)
    app.add_config_value('addclass_id_map', {}, False)
    app.add_config_value('addclass_tag_map', {}, False)

    app.connect('doctree-read', add_classes)
