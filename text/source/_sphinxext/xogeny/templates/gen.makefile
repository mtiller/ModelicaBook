all: results_files js_files json_files

results_files: {%- for res in results %} {{res}}_res.mat {% endfor %}

js_files: {%- for res in results %} js/{{res}}.js js/{{res}}.js.gz {% endfor %}

json_files: {%- for res in results %} json/{{res}}.json json/{{res}}.json.gz {% endfor %}

{% for res in results %}
{{res}}_res.mat {{res}}_init.xml: {{results[res]["path"]}}
	omc {{res}}.mos

json/{{res}}.json: {{res}}_init.xml ../tojson.py
	-mkdir json
	../tojson.py {{res}}_init.xml json/{{res}}.json

json/{{res}}.json.gz: json/{{res}}.json
	(cd json; gzip -fk {{res}}.json)

js/{{res}}.js:  {{results[res]["path"]}}
	-mkdir js
	omc {{res}}-js.mos
	-mv {{res}}.node.js js/{{res}}.node.js
	mv {{res}}.js js/{{res}}.js

js/{{res}}.js.gz: js/{{res}}.js
	(cd js; gzip -fk {{res}}.js)

{% endfor %}

tidy:
	-rm *.o *.c *.h *.libs *.log *.makefile
	{% for res in results -%}
	-rm {{res}}
	{% endfor %}
