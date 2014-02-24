$(document).ready(function() {
    /* Make the thumb button open and close the TOC */
    $('#toc-sidebar').sidebar('attach events', '#thumb', 'toggle');

    Handlebars.registerHelper('varinfo', function(model, varname, attr) {
	return new Handlebars.SafeString(model.vars[varname][attr]);
    });

    var source = $("#itemplate").html();
    var it = Handlebars.compile(source);

    var fixfig = function(p, was, id, jobj) {
	var context = {"image": was, "id": id, "model": jobj};
	var newt = it(context);
	$(p).html(newt);
	$(".ui.accordion").accordion();
	$("#sim-button-"+id).click(function () {
	    console.log("Whee! let's simulate it!");
	});
    }

    $(".interactive").each(function(i, elem) {
	var p = $(elem).parent();
	var was = $(p).html();
	var id = "SV2";
	$.ajax({
	    dataType: "json",
	    url: "/_static/json/"+id+".json",
	    success: function(jobj) { return fixfig(p, was, id, jobj); }
	});
    });
});
