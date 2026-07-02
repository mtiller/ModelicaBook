// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import remarkModelicaXref from './plugins/remark-xref.mjs';
import bookSidebar from './tools/sidebar.gen.json' with { type: 'json' };

// MIC-84 bake-off: Astro + Starlight rendering of the first-order chapter.
// Contrast with the mystmd slice in ../web: here the interactive figure is a
// first-class Astro island (a component imported in MDX + a bundled <script>) —
// no theme fork, no post-build injection, no sanitizer fight.
export default defineConfig({
  // Math via remark/rehype plugins — an npm install + config, not a theme fork.
  // This is the "extend via plugins" story that replaces mystmd's directive gap.
  markdown: {
    remarkPlugins: [remarkModelicaXref, remarkMath],
    rehypePlugins: [rehypeKatex],
  },
  // Allow importing the .mo sources from the repo root via ?raw, so code blocks
  // stay sourced from the single source of truth (parity with literalinclude).
  vite: { server: { fs: { allow: ['..'] } } },
  integrations: [
    starlight({
      title: 'Modelica by Example',
      description: 'Astro + Starlight vertical slice (MIC-84)',
      customCss: ['katex/dist/katex.min.css', './src/styles/skins.css'],
      sidebar: bookSidebar,
    }),
  ],
});
