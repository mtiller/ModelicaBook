all: results_files js_files

results_files: {%- for res in results %} {{res}}_res.mat {% endfor %}

js_files: {%- for res in results %} {{res}}.js {% endfor %}

{% for res in results %}
{{res}}_res.mat: {{results[res]["path"]}}
	omc {{res}}.mos
{% endfor %}

{% for res in results %}
{{res}}.js:  {{results[res]["path"]}}
	omc {{res}}-js.mos
{% endfor %}

tidy:
	-rm *.o *.c *.xml *.h *.libs *.log *.makefile
	{% for res in results -%}
	-rm {{res}}
	{% endfor %}
