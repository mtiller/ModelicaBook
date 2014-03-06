$(document).ready(function() {
    var thumbnails = $(".thumbnail");
    console.log("# of thumbnails: "+thumbnails.length);
    thumbnails.popup({"position": "bottom right"});

    var groups = ["CyDesign", "Wolfram", "Modelon", "Maplesoft", "DS",
		  "Ricardo", "ITI", "GlobalCrown", "Siemens",
		  "ST", "OSMC", "dofware", "BauschGall", "TUHH", "Schlegel"];

    function shuffle(array) {
	var currentIndex = array.length;
	var temporaryValue;
	var randomIndex;

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

    var shownext = function() {
	$(".sentry").hide();
	$(".thumbnail").removeClass("thumbshadow");
	$("#sentry-"+order[next]).show();
	$("#thumbnail-"+order[next]).addClass("thumbshadow");
	console.log("Showing "+order[next]);
	if (next<order.length-1) next = next + 1;
	else next = 0;
    };

    shownext();
    setInterval(shownext, 5000);
});
