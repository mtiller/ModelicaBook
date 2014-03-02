$(document).ready(function() {
    /* Make the thumb button open and close the TOC */
    $('#toc-sidebar').sidebar('attach events', '#thumb', 'toggle');

    Handlebars.registerHelper('varinfo', function(model, varname, attr) {
	return new Handlebars.SafeString(model.vars[varname][attr]);
    });

    var source = $("#itemplate").html();
    var it = Handlebars.compile(source);
    var worker = null;

    var runsim = function(jobj, id) {
	console.log("Whee! let's simulate "+id+"!");
	if (worker!=null) worker.terminate();
	worker = new Worker("/_static/js/"+id+".js");
	worker.addEventListener("error", function(event) {
	    console.log("Error from worker:");
	    console.log(event);
	});

	worker.addEventListener("message", function(event) {
	    var data = event.data;
	    console.log("Simulation status: "+data.status);
	    var x = $.csv.toArrays(event.data.csv,
				   {onParseValue: $.csv.hooks.castToScalar})
	    var show = ["x", "der(x)"];
	    console.log("x = ");
	    console.log(x);
	    console.log(event);
	    //$("#placeholder").plot(data, options)
	    var where = "#dyn-plot-"+id;
	    var old = "#plot-wrapper-"+id;
	    $(old).hide();
	    $(where).width("640px");
	    $(where).height("480px");
	    console.log("Attempting to plot data to "+where);
	    var data = []
	    for(var i=0;i<show.length;i++) {
		var vn = show[i];
		for(var j=1;j<x[0].length;j++) {
		    var sn = x[0][j];
		    if (sn===vn) {
			data.push({"label": sn,
				   "data": x.slice(1).map(function(r) {
				       return [r[0], r[j]];
				   })})
		    }
		}
	    }
	    console.log("Data = ");
	    console.log(data);
	    $(where).plot(data);
	});
	console.log("Starting simulation");
	var stopTime = parseFloat(jobj.experiment.stopTime);
	var step = stopTime/100;
	worker.postMessage({"basename": "FO",
			    "stopTime": String(stopTime),
			    "tolerance": "1e-03",
			    "stepSize": String(step)})
    };
    
    var fixfig = function(p, was, id, jobj) {
	var context = {"image": was, "id": id, "model": jobj};
	var newt = it(context);
	$(p).html(newt);
	$(".ui.accordion").accordion();
	$("#sim-button-"+id).click(function () {
	    runsim(jobj, id);
	});
    }

    $(".interactive").each(function(i, elem) {
	var p = $(elem).parent();
	var src = $(elem).attr("src");
	var was = $(p).html();
	var id = src.split("/").pop().split(".")[0];
	$.ajax({
	    dataType: "json",
	    url: "/_static/json/"+id+".json",
	    success: function(jobj) { return fixfig(p, was, id, jobj); }
	});
    });
});
