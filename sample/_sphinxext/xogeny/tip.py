from docutils import nodes
from sphinx.locale import _
from sphinx.util.compat import Directive
from sphinx.util.compat import make_admonition

#<div class="span1 pull-right right padded">
#  <a class="btn" href="/foo">Try It</a>
#</div>

class tip_node(nodes.Admonition, nodes.Element):
	pass

def visit_tip_node(self, node):
	self.visit_admonition(node)

def depart_tip_node(self, node):
	self.depart_admonition(node)

def process_tips(app, doctree):
	for node in doctree.traverse(tip_node):
		node['classes'] += app.config.tip_classes

class TipDirective(Directive):
	has_content = True

	def run(self):
		env = self.state.document.settings.env

		targetid = "tip-%d" % (env.new_serialno('tip'))
		targetnode = nodes.target('', '', ids=[targetid])

		ad = make_admonition(tip_node, self.name, [_('Tip')],
				     self.options, self.content,
				     self.lineno, self.content_offset,
				     self.block_text, self.state,
				     self.state_machine)

		return [targetnode] + ad

def setup(app):
	app.add_config_value('tip_classes', ['bootstrap-tip'], False)

	app.add_node(tip_node,
		     html=(visit_tip_node, depart_tip_node),
		     latex=(visit_tip_node, depart_tip_node),
		     text=(visit_tip_node, depart_tip_node))

	app.add_directive('tip', TipDirective)

	app.connect('doctree-read', process_tips)
