$(document).ready(function() {
    /* If this is a normal browser, show sidebar */
    $("#toc-sidebar").sidebar('show');
    /* If mobile, hide it and let people open it with a button */
    if ($(window).width()<1000) {
	$("#toc-sidebar").sidebar('hide');
    }

    /* Make the thumb button open and close the TOC */
    $('#toc-sidebar').sidebar('attach events', '#thumb', 'toggle');
});
