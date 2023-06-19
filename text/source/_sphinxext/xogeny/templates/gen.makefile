EXES := {%- for res in results %} {{res}} {% endfor %}
all: results_files js_files json_files

results_files: allres {%- for res in results %} {{res}}_res.mat {% endfor %}

allres:
	omc allres.mos

js_files: {%- for res in results %} js/{{res}}.js js/{{res}}.js.gz {% endfor %}
json_files: {%- for res in results %} json/{{res}}.json json/{{res}}.json.gz {% endfor %}
exes = {%- for res in results %} {{res}} {% endfor %}

{% for res in results %}
json/{{res}}.json: {{res}}_init.xml ../tojson.py
	-mkdir json
	../tojson.py {{res}}_init.xml json/{{res}}.json

json/{{res}}.json.gz: json/{{res}}.json
	(cd json; gzip -fk {{res}}.json)
{% endfor %}

exes.tar.gz: {%- for res in results %} {{res}} {{res}}_init.xml json/{{res}}.json {% endfor %}
	tar zcf exes.tar.gz {%- for res in results %} {{res}} {{res}}_init.xml json/{{res}}.json {% endfor %} json/*-case.json 

tidy:
	-rm -f *.o *.c *.h *.libs *.log *.makefile *.fmutmp _FMU.* *_prof.*
	-rm -f *.fmu

clean: tidy 
	{% for res in results -%}
	-rm -f {{res}} {{res}}_info.json {{res}}_init.xml {{res}}_res.mat
	{% endfor %}
