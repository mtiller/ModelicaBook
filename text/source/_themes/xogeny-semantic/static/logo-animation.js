$(document).ready(function() {
    // These are the sponsors
    var groups = ["CyDesign", "Wolfram", "Modelon", "Maplesoft", "DS",
		  "Ricardo", "ITI", "GlobalCrown", "Siemens",
		  "ST", "OSMC", "dofware", "BauschGall", "TUHH", "Schlegel"];

    // This is the order we will show them in (for this page load)
    var order = _.shuffle(groups);

    // This is the current one being shown
    var current = 0;

    // This terminates animation if someone clicks on a thumbnail
    var stopAnimation = false;

    // This "shows" the sponsor identified by the given id
    var showSponsor = function(id) {
	$(".sentry").hide();
	$(".thumbnail").removeClass("thumbshadow");
	$("#sentry-"+id).show();
	$("#thumbnail-"+id).addClass("thumbshadow");
    };

    // This shows the current sponsor (and then sets the next sponsor to be current)
    var showCurrent = function() {
	if (stopAnimation) return;
	showSponsor(order[current]);
	current = (current + 1) % order.length;
	setTimeout(showCurrent, 5000);
    }

    // This sets an on-click callback on various thumbnails
    for(var i=0;i<groups.length;i++) {
	(function() {
	    var j = i;
	    $("#thumbnail-"+groups[j]).click(function () {
		stopAnimation = true;
		showSponsor(groups[j]);
	    });
	})();
    }

    $(".sentry").hide();
    showCurrent();
});
