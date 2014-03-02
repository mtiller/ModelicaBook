$(document).ready(function() {
    /* Make the thumb button open and close the TOC */
    $('#toc-sidebar').sidebar('attach events', '#thumb', 'toggle');

    Handlebars.registerHelper('varinfo', function(model, varname, attr) {
	return new Handlebars.SafeString(model.vars[varname][attr]);
    });

    var source = $("#itemplate").html();
    var it = Handlebars.compile(source);
    var worker = null;

    var runsim = function(jobj, model_id, casedata, plot_id) {
	console.log("Whee! let's simulate model "+model_id+"!");
	if (worker!=null) worker.terminate();
	worker = new Worker("/_static/js/"+model_id+".js");
	worker.addEventListener("error", function(event) {
	    console.log("Error from worker:");
	    console.log(event);
	});

	worker.addEventListener("message", function(event) {
	    var data = event.data;
	    console.log("Simulation status: "+data.status);
	    var x = $.csv.toArrays(event.data.csv,
				   {onParseValue: $.csv.hooks.castToScalar})
	    var where = "#dyn-plot-"+plot_id;
	    var old = "#plot-wrapper-"+plot_id;
	    $(old).hide();
	    $(where).width("640px");
	    $(where).height("480px");
	    var data = []
	    for(var i=0;i<casedata.vars.length;i++) {
		var vn = casedata.vars[i]["name"];
		for(var j=1;j<x[0].length;j++) {
		    var sn = x[0][j];
		    if (sn===vn) {
			data.push({"label": casedata.vars[i]["legend"],
				   "data": x.slice(1).map(function(r) {
				       return [r[0], r[j]];
				   })})
		    }
		}
	    }
	    $("#plot-title-"+plot_id).text(casedata.title);
	    $(where).plot(data);
	});
	console.log("Starting simulation");
	var stopTime = parseFloat(casedata.stopTime);
	var step = stopTime/casedata.ncp;
	var tol = casedata.tol;
	worker.postMessage({"basename": model_id,
			    "stopTime": String(stopTime),
			    "tolerance": String(tol),
			    "stepSize": String(step)})
    };
    
    var fixfig = function(p, was, plot_id, casedata, model_id, jobj) {
	var context = {"image": was, "plot_id": plot_id, "casedata": casedata,
		       "model_id": model_id, "model": jobj};
	var newt = it(context);
	$(p).html(newt);
	$(".ui.accordion").accordion();
	$(".ui.modal").modal();
	$("#modal-plot-"+plot_id).modal('attach events',
					"#sim-help-"+plot_id, 'show')
	$("#sim-button-"+plot_id).click(function () {
	    runsim(jobj, model_id, casedata, plot_id);
	});
    }

    $(".interactive").each(function(i, elem) {
	var p = $(elem).parent();
	var src = $(elem).attr("src");
	var was = $(p).html();
	var plot_id = src.split("/").pop().split(".")[0];

	var getModelData = function(casedata) {
	    var model_id = casedata["res"]
	    $.ajax({
		dataType: "json",
		url: "/_static/json/"+model_id+".json",
		success: function(jobj) { 
		    return fixfig(p, was,
				  plot_id, casedata,
				  model_id, jobj);
		}
	    });
	};

	$.ajax({
	    dataType: "json",
	    url: "/_static/json/"+plot_id+"-case.json",
	    success: getModelData
	});
    });
});
