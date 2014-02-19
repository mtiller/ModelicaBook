$(document).ready(function() {
    /* Make the thumb button open and close the TOC */
    $('#toc-sidebar').sidebar('attach events', '#thumb', 'toggle');

    var frames = [["s1", "s2"], ["b1", "b2", "b3"], ["g1"]];
    var showtime = 3000;

    var showFrame = function(n, cb) {
	console.log("Showing frame "+n);
	for(var i=0;i<frames[n].length;i++) {
	    $("#"+frames[n][i]).transition({
		animiation: "fade in",
		complete: cb
	    });
	}
    };

    var hideFrame = function(n, cb) {
	console.log("Hiding frame "+n);
	for(var i=0;i<frames[n].length;i++) {
	    $("#"+frames[n][i]).transition({
		animation: "fade out",
	        complete: cb
	    });
	}
    };

    var transFrame = function(n1, n2) {
	hideFrame(n1, function() { showFrame(n2) });
    };

    var animateLogos = function() {
	showFrame(0);
	setTimeout(function () { transFrame(0, 1); }, showtime);
	setTimeout(function () { transFrame(1, 2); }, 2*showtime);
	setTimeout(function () { hideFrame(2, animateLogos); }, 3*showtime);
    };

    animateLogos();

    /* Start animation of sponsors */
    $(".logo").transition({
	animation: "fade"
	//complete: animateLogos
    });
});
