$(document).ready(function () {
	/* Make the thumb button open and close the TOC */
	// $('#toc-sidebar').sidebar('attach events', '#thumb', 'toggle');

	// Handlebars.registerHelper('varinfo', function (model, varname, attr) {
	// 	return new Handlebars.SafeString(model.vars[varname][attr]);
	// });

	// var source = $("#itemplate").html();
	// var it = Handlebars.compile(source);
	// var worker = null;

	// var runsim = function (jobj, model_id, casedata, plot_id) {
	// 	console.log("Whee! let's simulate model " + model_id + "!");
	// 	if (worker != null) worker.terminate();
	// 	var jsurl = "/_static/js/" + model_id + ".js";
	// 	console.log("Creating worker for script at " + jsurl);
	// 	worker = new Worker(jsurl);

	// 	/* Setup listeners, before we fire off any messages to the worker */
	// 	worker.addEventListener("error", function (event) {
	// 		console.log("Error from worker:");
	// 		console.log(event);
	// 	});

	// 	worker.addEventListener("message", function (event) {
	// 		console.log("Message from worker: ");
	// 		console.log(event);
	// 		var data = event.data;
	// 		if (data.preloaded) {
	// 			/* If we get here, the worker is telling us that
	// 			   they fetched the _init.xml and _info.xml files.
	// 			   So now we can fire off the actual simulation. */
	// 			console.log("Got preload message");
	// 			console.log("Starting simulation");
	// 			var stopTime = parseFloat(casedata.stopTime);
	// 			var step = stopTime / casedata.ncp;
	// 			var tol = casedata.tol;
	// 			var overrides = {
	// 				"stopTime": String(stopTime),
	// 				"tolerance": String(tol),
	// 				"stepSize": String(step)
	// 			};
	// 			var formobj = $("#form-" + plot_id);
	// 			var params = $(formobj).children("div.paramrow");
	// 			params.each(function (i, elem) {
	// 				var pname = $(elem).children("label.paramname").text();
	// 				var pval = $(elem).children("input.paramvalue").val();
	// 				overrides[pname] = pval;
	// 			});
	// 			var runmsg = {
	// 				"basename": model_id,
	// 				"override": overrides
	// 			};
	// 			console.log("Run command sent to worker:");
	// 			console.log(runmsg);
	// 			worker.postMessage(runmsg);
	// 		}
	// 		console.log("Simulation status: " + data.status);
	// 		var x = $.csv.toArrays(event.data.csv,
	// 			{ onParseValue: $.csv.hooks.castToScalar })
	// 		var where = "#dyn-plot-" + plot_id;
	// 		var old = "#plot-wrapper-" + plot_id;
	// 		$(old).hide();
	// 		$(where).width("640px");
	// 		$(where).height("480px");
	// 		var data = []
	// 		for (var i = 0; i < casedata.vars.length; i++) {
	// 			var vn = casedata.vars[i]["name"];
	// 			for (var j = 1; j < x[0].length; j++) {
	// 				var sn = x[0][j];
	// 				if (sn === vn) {
	// 					data.push({
	// 						"label": casedata.vars[i]["legend"],
	// 						"data": x.slice(1).map(function (r) {
	// 							return [r[0], r[j]];
	// 						})
	// 					})
	// 				}
	// 			}
	// 		}
	// 		$("#plot-title-" + plot_id).text(casedata.title);
	// 		$(where).plot(data);
	// 		$("#sim-button-" + plot_id).text("Simulate");
	// 		$("#sim-button-" + plot_id).removeClass("disabled");
	// 	});

	// 	/* Tell the worker to preload the _init.xml and _info.xml files */
	// 	console.log("Firing message to worker");
	// 	worker.postMessage({ "basename": model_id, "preload": true });
	// };

	// var fixfig = function (p, was, plot_id, casedata, model_id, jobj) {
	// 	var context = {
	// 		"image": was, "plot_id": plot_id, "casedata": casedata,
	// 		"model_id": model_id, "model": jobj
	// 	};
	// 	var newt = it(context);
	// 	$(p).html(newt);
	// 	$(".ui.accordion").accordion();
	// 	$(".ui.modal").modal();
	// 	$("#modal-plot-" + plot_id).modal('attach events',
	// 		"#sim-help-" + plot_id, 'show')
	// 	$("#sim-button-" + plot_id).click(function () {
	// 		$("#sim-button-" + plot_id).text("Simulating...");
	// 		$("#sim-button-" + plot_id).addClass("disabled");
	// 		runsim(jobj, model_id, casedata, plot_id);
	// 	});
	// }

	// $(".interactive").each(function(i, elem) {
	// var p = $(elem).parent();
	// var src = $(elem).attr("src");
	// var was = $(p).html();
	// var plot_id = src.split("/").pop().split(".")[0];

	// var getModelData = function(casedata) {
	//     var model_id = casedata["res"]
	//     $.ajax({
	// 	dataType: "json",
	// 	url: "/_static/json/"+model_id+".json",
	// 	success: function(jobj) { 
	// 	    return fixfig(p, was,
	// 			  plot_id, casedata,
	// 			  model_id, jobj);
	// 	}
	//     });
	// };

	// 	$.ajax({
	// 		dataType: "json",
	// 		url: "/_static/json/" + plot_id + "-case.json",
	// 		success: getModelData
	// 	});
	// });
});
