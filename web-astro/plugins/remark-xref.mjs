// remark-modelica-xref — Sphinx :ref: / auto-numbering parity for MDX.
//
// Closes the heaviest feature-parity gap (310 `:ref:` uses). Provides:
//
//   • Explicit labels: `## Heading {/* #label */}` records an anchor id = label,
//     so the RST `.. _label:` targets carry over. (An MDX comment expression is
//     used rather than `{#label}` because bare `{...}` is a JS expression in MDX.)
//     The id is set on the rendered heading.
//   • Section numbering: headings get 1, 1.1, 1.1.1 … (available for :numref:-style
//     refs and ToC).
//   • Figure numbering: each <SimFigure> is assigned "Figure N", keyed by its id,
//     and "Figure N. " is prepended to its caption.
//   • Reference resolution: a link with empty text and a `#label` target — the
//     shape produced by the gettext migration and by authored `[](#label)` —
//     is filled with the target's TITLE (Sphinx :ref: default) or "Figure N"
//     when the target is a figure. Links that already have text are left alone.
//
// Cross-DOCUMENT references (targets in other chapters) can't resolve inside a
// single-file build; they're left as the label text and reported, pending the
// book-wide label index (a trivial extension: persist `labels` across pages).

import { visit } from 'unist-util-visit';
import GithubSlugger from 'github-slugger';

function plainText(node) {
  if (!node) return '';
  if (node.value) return node.value;
  if (node.children) return node.children.map(plainText).join('');
  return '';
}

// Pull an explicit id from a `{/* #label */}` MDX comment expression in the
// heading, remove that node, and return the id (or null).
function extractExplicitId(heading) {
  for (let i = 0; i < heading.children.length; i++) {
    const ch = heading.children[i];
    if ((ch.type === 'mdxTextExpression' || ch.type === 'mdxFlowExpression') && ch.value) {
      const m = ch.value.match(/#([A-Za-z0-9_-]+)/);
      if (m) {
        heading.children.splice(i, 1);
        // tidy a trailing whitespace-only text node left behind
        const prev = heading.children[i - 1];
        if (prev && prev.type === 'text') prev.value = prev.value.replace(/\s+$/, '');
        return m[1];
      }
    }
  }
  return null;
}

function getAttr(el, name) {
  const a = (el.attributes || []).find((x) => x.type === 'mdxJsxAttribute' && x.name === name);
  return a ? a.value : undefined;
}
function setAttr(el, name, value) {
  el.attributes = el.attributes || [];
  const a = el.attributes.find((x) => x.type === 'mdxJsxAttribute' && x.name === name);
  if (a) a.value = value;
  else el.attributes.push({ type: 'mdxJsxAttribute', name, value });
}

export default function remarkModelicaXref() {
  return (tree, file) => {
    const slugger = new GithubSlugger();
    const labels = new Map(); // id -> resolved display text
    const counters = [0, 0, 0, 0, 0, 0];
    let figNo = 0;

    // Pass 1 — assign ids/numbers and record the label table.
    visit(tree, (node) => {
      if (node.type === 'heading') {
        const explicit = extractExplicitId(node);
        const text = plainText(node).trim();
        const depth = node.depth;
        counters[depth - 1] += 1;
        for (let i = depth; i < counters.length; i++) counters[i] = 0;
        const number = counters.slice(0, depth).filter(Boolean).join('.');
        const id = explicit || slugger.slug(text);
        node.data = node.data || {};
        node.data.hProperties = { ...(node.data.hProperties || {}), id };
        // :ref: resolves to the title; record it (number available too).
        labels.set(id, text);
        labels.set(`__num__${id}`, number);
      }
      if (node.type === 'mdxJsxFlowElement' && node.name === 'SimFigure') {
        figNo += 1;
        const id = getAttr(node, 'id');
        const caption = getAttr(node, 'caption') || '';
        if (id) labels.set(id, `Figure ${figNo}`);
        setAttr(node, 'caption', `Figure ${figNo}. ${caption}`);
      }
    });

    // Pass 2 — resolve empty-text intra-page references.
    let unresolved = 0;
    visit(tree, 'link', (node) => {
      if (!node.url || !node.url.startsWith('#')) return;
      const id = node.url.slice(1);
      const hasText = (node.children || []).some((c) => plainText(c).trim().length > 0);
      if (hasText) return; // explicit link text — leave it
      const resolved = labels.get(id);
      if (resolved) {
        node.children = [{ type: 'text', value: resolved }];
      } else {
        node.children = [{ type: 'text', value: id }];
        unresolved += 1;
      }
    });

    if (unresolved && file) {
      file.message(`remark-xref: ${unresolved} cross-reference(s) unresolved on this page (likely cross-document — needs the book-wide label index).`);
    }
  };
}
