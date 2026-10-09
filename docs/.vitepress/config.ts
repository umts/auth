import { defineConfig } from "vitepress";

export default defineConfig({
  base: "./",
  title: "umts-auth",
  description: "Preconfigured styles and views for UMTS rails apps.",
  themeConfig: {
    search: { provider: "local" },
    nav: [],
    sidebar: [
      {
        text: "Setup",
        items: [{ text: "Installation", link: "/installation" }],
      },
      {
        text: "Reference",
        items: [
          { text: "Reference", link: "/reference" },
        ],
      },
    ],
    socialLinks: [{ icon: "github", link: "https://github.com/umts/auth" }],
  },
});
