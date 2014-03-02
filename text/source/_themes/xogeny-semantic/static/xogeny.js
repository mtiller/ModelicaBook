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
	worker = new Worker("http://cdn.book.xogeny.com/"+id+".js");
	//worker = new Worker("/_static/js/"+id+".js");
	worker.addEventListener("error", function(event) {
	    console.log("Error from worker:");
	    console.log(event);
	});
	worker.addEventListener("message", function(event) {
	    var data = event.data;
	    console.log("Simulation status: "+data.status);
	    var x = $.csv.toArrays(event.data.csv,
				   {onParseValue: $.csv.hooks.castToScalar})
	    console.log("x = ");
	    console.log(x);
	    console.log(event);
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
	    url: "http://cdn.book.xogeny.com/json/"+id+".json",
	    //url: "/_static/json/"+id+".json",
	    success: function(jobj) { return fixfig(p, was, id, jobj); }
	});
    });
});
