import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";

// Base do GitHub Pages. O sitemap usa origem + base, por isso o subpath
// vai no `base` (e não embutido no `site`) — assim todo build gera sitemap certo.
const pagesBase = process.env.PAGES_BASE ?? "/nutricionista-alexandrapetry/";

export default defineConfig({
  site: "https://studiotche.github.io",
  base: pagesBase,
  output: "static",
  integrations: [sitemap()],
  build: { format: "directory" },
});
