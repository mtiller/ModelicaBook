all: results_files js_files json_files

results_files: {%- for res in results %} {{res}}_res.mat {% endfor %}

js_files: {%- for res in results %} {{res}}.js {% endfor %}

json_files: {%- for res in results %} {{res}}.json {% endfor %}

{% for res in results %}
{{res}}_res.mat {{res}}_init.xml: {{results[res]["path"]}}
	omc {{res}}.mos

{{res}}.json: {{res}}_init.xml ../tojson.py
	../tojson.py {{res}}_init.xml {{res}}.json

{{res}}.js:  {{results[res]["path"]}}
	omc {{res}}-js.mos
{% endfor %}

tidy:
	-rm *.o *.c *.h *.libs *.log *.makefile
	{% for res in results -%}
	-rm {{res}}
	{% endfor %}
