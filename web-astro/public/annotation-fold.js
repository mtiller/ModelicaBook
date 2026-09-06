// MIC-129 — foldable Modelica annotations (progressive enhancement).
//
// Recreates the old site's collapsible annotations: in a highlighted Modelica
// code block, the balanced `(...)` following the `annotation` keyword is folded
// to a "(…)" toggle. Click the toggle to expand; click the expanded body to
// re-collapse. Pure post-render DOM work — JS-off degrades to full code.
//
// Scope: single-line annotations (the common case). Multi-line graphical
// annotations that span several `.ec-line`s are left expanded — a follow-up
// would move this to an Expressive Code plugin operating on the token stream.
(function () {
  function foldLine(line) {
    if (line.dataset.annoDone) return;
    var spans = Array.prototype.slice.call(line.children);
    var ai = -1;
    for (var i = 0; i < spans.length; i++) {
      if (/\bannotation\b/.test(spans[i].textContent)) { ai = i; break; }
    }
    if (ai < 0) return;
    var depth = 0, started = false, start = -1, end = -1;
    for (var j = ai; j < spans.length; j++) {
      var t = spans[j].textContent;
      for (var k = 0; k < t.length; k++) {
        if (t[k] === '(') { if (!started) { started = true; start = j; } depth++; }
        else if (t[k] === ')') { depth--; if (started && depth <= 0) { end = j; break; } }
      }
      if (end >= 0) break;
    }
    if (start < 0 || end < start) return; // not found or spans multiple lines → leave expanded
    line.dataset.annoDone = '1';

    var wrap = document.createElement('span');
    wrap.className = 'anno-fold';
    var toggle = document.createElement('button');
    toggle.type = 'button';
    toggle.className = 'anno-toggle';
    toggle.title = 'Show annotation';
    toggle.textContent = '(…)';

    line.insertBefore(toggle, spans[start]);
    for (var m = start; m <= end; m++) wrap.appendChild(spans[m]);
    line.insertBefore(wrap, toggle.nextSibling);
    wrap.hidden = true;

    toggle.addEventListener('click', function () { wrap.hidden = false; toggle.hidden = true; });
    wrap.addEventListener('click', function () { wrap.hidden = true; toggle.hidden = false; });
  }

  function run() {
    try {
      document.querySelectorAll('pre[data-language="modelica"] .ec-line').forEach(foldLine);
    } catch (e) { /* never break rendering */ }
  }
  document.addEventListener('DOMContentLoaded', run);
  document.addEventListener('astro:page-load', run);
})();
