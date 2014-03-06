$(document).ready(function() {
    /*
    var frames = [["s1", "s2"], ["b1", "b2", "b3"], ["g1"]];
    var showtime = 6000;

    var showFrame = function(n, cb) {
	console.log("Showing frame "+n);
	for(var i=0;i<frames[n].length;i++) {
	    $("#"+frames[n][i]).transition({
		animation: "fade in"
	    });
	    $("#"+frames[n][i]+"i").addClass("svis");
	}
	if (cb) { setTimeout(cb, 300); }
    };

    var hideFrame = function(n, cb) {
	console.log("Hiding frame "+n);
	for(var i=0;i<frames[n].length;i++) {
	    $("#"+frames[n][i]).transition({
		animation: "fade out",
	    });
	    $("#"+frames[n][i]+"i").removeClass("svis");
	}
	if (cb) { setTimeout(cb, 300); }
    };

    var transFrame = function(n1, n2) {
	hideFrame(n1, function() { showFrame(n2) });
    };

    var animateLogos = function() {
	console.log("show frame "+0);
	showFrame(0);
	for(var i=0;i<frames.length-1;i++) {
	    (function() {
		var j = i;
		console.log("transframe "+j+" -> "+(j+1));
		setTimeout(function () { transFrame(j, j+1); }, (j+1)*showtime);
	    })();
	}
	console.log("hide frame "+(frames.length-1));
	setTimeout(function () { hideFrame(frames.length-1, animateLogos); },
		   frames.length*showtime);
    };

    if (true) {
	// Start animation of sponsors
	$(".logo").transition({
	    animation: "fade"
	});
	setTimeout(animateLogos, 300);
    }
    */

    var thumbnails = $(".thumbnail");
    console.log(thumbnails.length+" found");
    thumbnails.popup();

    var groups = ["CyDesign", "Wolfram", "Modelon", "Maplesoft", "DS",
		  "Ricardo", "ITI", "GlobalCrown", "Siemens",
		  "ST", "OSMC", "dofware", "BauschGall", "TUHH", "Schlegel"];

    function shuffle(array) {
	var currentIndex = array.length
	, temporaryValue
	, randomIndex
	;

	// While there remain elements to shuffle...
	while (0 !== currentIndex) {

	    // Pick a remaining element...
	    randomIndex = Math.floor(Math.random() * currentIndex);
	    currentIndex -= 1;

	    // And swap it with the current element.
	    temporaryValue = array[currentIndex];
	    array[currentIndex] = array[randomIndex];
	    array[randomIndex] = temporaryValue;
	}

	return array;
    }
    var order = shuffle(groups);
    var next = 0;
    console.log("Order: ");
    console.log(order);

    var shownext = function() {
	$(".sentry").hide();
	$("#sentry-"+order[next]).show();
	console.log("Showing "+order[next]);
	if (next<order.length-1) next = next + 1;
	else next = 0;
    };

    shownext();
    setInterval(shownext, 1000);
});
