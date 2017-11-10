# This extension allows me to declaratively specify what simulations
# I would like to see described in the text.  For the moment, it will
# simply make sure that results files (and maybe plots?!?) are generated
# for specific examples (and with specific settings).  But in the future,
# my hope is to use these nodes to indicate where dynamic content
# should be inserted.

from docutils import nodes
from docutils.parsers.rst import Directive
import json

class sim_request(nodes.General, nodes.Element):
    """
    This is the node that will be inserted in our document
    tree when a 'simulate' directive is invoked.
    """
    def __init__(self, model, start_time):
        self.model = model
        self.start_time = start_time
        self.children = []
    def __str__(self):
        return str({"model": self.model,
                    "experiment": {"start_time": self.start_time}})

def visit_sim_request(self, node):
    print "Visiting sim request: "+str(node)
    pass

def depart_sim_request(self, node):
    pass

class SimulateDirective(Directive):
    required_arguments = 0
    optional_arguments = 0
    final_argument_whitespace = True
    option_spec = {"model": str, "start_time": float}
    #option_spec = {}
    has_content = False

    def run(self):
        return [sim_request(**self.options)]

def setup(app):
    app.add_config_value("sim_include_dynamic", False, True)

    # This is the node we'll insert
    app.add_node(sim_request,
                 html=(visit_sim_request, depart_sim_request))

    app.add_directive('simulate', SimulateDirective)
