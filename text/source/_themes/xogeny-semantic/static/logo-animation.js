$(document).ready(function() {
    var groups = ["CyDesign", "Wolfram", "Modelon", "Maplesoft", "DS",
		  "Ricardo", "ITI", "GlobalCrown", "Siemens",
		  "ST", "OSMC", "dofware", "BauschGall", "TUHH", "Schlegel"];
    var stopAnimation = false;

    var showSponsor = function(id) {
	$(".sentry").hide();
	$(".thumbnail").removeClass("thumbshadow");
	$("#sentry-"+id).show();
	$("#thumbnail-"+id).addClass("thumbshadow");
    };

    var pickRandom = function() {
	console.log("pickRandom called");
	if (stopAnimation) return;
	console.log("Picking a random sponsor");
	var id = groups[Math.floor(Math.random()*groups.length)];
	console.log("Sponsor: "+id);
	showSponsor(id);
	setTimeout(pickRandom, 5000);
    }

    for(var i=0;i<groups.length;i++) {
	(function() {
	    var j = i;
	    $("#thumbnail-"+groups[j]).click(function () {
		stopAnimation = true;
		console.log("Show "+groups[j]);
		showSponsor(groups[j]);
	    });
	})();
    }

    $(".sentry").hide();
    pickRandom();
});
