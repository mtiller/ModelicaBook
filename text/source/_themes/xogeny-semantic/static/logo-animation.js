$(document).ready(function() {
    var groups = ["CyDesign", "Wolfram", "Modelon", "Maplesoft", "DS",
		  "Ricardo", "ITI", "GlobalCrown", "Siemens",
		  "ST", "OSMC", "dofware", "BauschGall", "TUHH", "Schlegel"];

    var showsponsor = function(id) {
	$(".sentry").hide();
	$(".thumbnail").removeClass("thumbshadow");
	$("#sentry-"+id).show();
	$("#thumbnail-"+id).addClass("thumbshadow");
    };

    for(var i=0;i<groups.length;i++) {
	(function() {
	    var j = i;
	    $("#thumbnail-"+groups[j]).click(function () {
		console.log("Show "+groups[j]);
		showsponsor(groups[j]);
	    });
	})();
    }

    $(".sentry").hide();
});
