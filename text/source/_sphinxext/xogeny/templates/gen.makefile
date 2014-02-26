all: results_files js_files json_files

results_files: {%- for res in results %} {{res}}_res.mat {% endfor %}

js_files: {%- for res in results %} {{res}}.js {% endfor %}

json_files: {%- for res in results %} json/{{res}}.json {% endfor %}

json:
	-mkdir json

js:
	-mkdir js

{% for res in results %}
{{res}}_res.mat {{res}}_init.xml: {{results[res]["path"]}}
	omc {{res}}.mos

json/{{res}}.json: json {{res}}_init.xml ../tojson.py
	../tojson.py {{res}}_init.xml json/{{res}}.json

js/{{res}}.js:  js {{results[res]["path"]}}
	omc {{res}}-js.mos
	-mv {{res}}.node.js js/{{res}}.node.js
	mv {{res}}.js js/{{res}}.js
{% endfor %}

tidy:
	-rm *.o *.c *.h *.libs *.log *.makefile
	{% for res in results -%}
	-rm {{res}}
	{% endfor %}
