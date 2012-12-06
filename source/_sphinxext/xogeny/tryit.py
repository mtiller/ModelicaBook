from docutils import nodes
from sphinx.locale import _
from sphinx.util.compat import Directive
from sphinx.util.compat import make_admonition
from docutils.parsers.rst import directives

# Node definition
class tryit_node(nodes.Part, nodes.Element):
    pass

# Visit and depart methods.  The only thing they really do is
# expand the tryit_node into HTML based on the template (which
# is a configuration option) and the name (which comes directly
# from the directive)
def visit_tryit_node(self, node):
    self.body.append(node['template'] % node['name'])

# NoOp
def visit_tryit_node_latex(self, node):
    pass

# NoOp
def depart_tryit_node(self, node):
    pass

# NoOp
def depart_tryit_node_latex(self, node):
    pass

# This attaches the template (which is an application configuration
# value) to the tryit nodes in the doctree
def process_tryits(app, doctree):
    for node in doctree.traverse(tryit_node):
        node['template'] = app.config.tryit_template

# This defines the directive that we use in the markup.  It has
# exactly one (required) option which is the name (which is
# ultimately passed into the app level configuration template
class TryItDirective(Directive):
	has_content = True
        option_spec = {
            'name': directives.unchanged
        }

	def run(self):
		env = self.state.document.settings.env

		targetid = "tryit-%d" % (env.new_serialno('tryit'))
		targetnode = nodes.target('', '', ids=[targetid])
                node = tryit_node()
                node['name'] = self.options.get('name', None)
                assert node['name']!=None

                return [targetnode] + [node]

# Set up the extension
def setup(app):
    app.add_config_value('tryit_template',
                         '''<div><a href="%s">Try It</a></div>''', False)
    app.add_node(tryit_node,
                 html=(visit_tryit_node, depart_tryit_node),
                 latex=(visit_tryit_node_latex, depart_tryit_node_latex))

    app.add_directive('tryit', TryItDirective)

    app.connect('doctree-read', process_tryits)
