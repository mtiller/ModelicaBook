$(document).ready(function() {
    /* If this is a normal browser, show sidebar */
    $("#toc-sidebar").sidebar('show');
    /* If mobile, hide it and let people open it with a button */

    /* Make the thumb button open and close the TOC */
    $('#toc-sidebar').sidebar('attach events', '#thumb', 'toggle');
});
