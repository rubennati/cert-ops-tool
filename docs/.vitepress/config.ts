import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'cert-ops-tool',
  description: 'TLS certificate issuance and renewal for NAS, routers, firewalls, Proxmox, and anything without a reverse proxy.',

  // GitHub Pages: https://rubennati.github.io/cert-ops-tool/
  // To use a custom domain, remove base and add a docs/public/CNAME file.
  base: '/cert-ops-tool/',

  themeConfig: {
    nav: [
      { text: 'Setup', link: '/guide/setup' },
      { text: 'Issuing & Renewal', link: '/guide/issuing' },
      { text: 'Configuration', link: '/reference/configuration' },
      { text: 'Changelog', link: '/changelog' },
    ],

    sidebar: [
      {
        text: 'Getting Started',
        items: [
          { text: 'Setup', link: '/guide/setup' },
          { text: 'Issuing & Renewal', link: '/guide/issuing' },
        ],
      },
      {
        text: 'Reference',
        items: [
          { text: 'Configuration', link: '/reference/configuration' },
          { text: 'Changelog', link: '/changelog' },
        ],
      },
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/rubennati/cert-ops-tool' },
    ],

    footer: {
      message: 'PolyForm Noncommercial 1.0.0',
      copyright: '© Ruben Nati',
    },

    editLink: {
      pattern: 'https://github.com/rubennati/cert-ops-tool/edit/main/docs/:path',
      text: 'Edit this page on GitHub',
    },

    search: {
      provider: 'local',
    },
  },
})
