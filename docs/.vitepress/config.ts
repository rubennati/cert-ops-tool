import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Cert Ops Tool',
  description: 'TLS certificate issuance with acme.sh and DNS-01. PEM and PFX output for upload onto NAS, routers, firewalls, mail servers.',
  lang: 'en-US',

  // Custom domain: https://cert-ops.rubennati.at/ (CNAME in docs/public/)

  sitemap: {
    hostname: 'https://cert-ops.rubennati.at/',
  },

  // Add role="main" to the content wrapper so screen readers can jump
  // straight to the main content (Lighthouse a11y: "main landmark").
  transformHtml(html) {
    return html.replace(
      /<div class="VPContent/g,
      '<div role="main" class="VPContent',
    )
  },

  // Inject a canonical link tag on every page.
  transformPageData(pageData) {
    const path = pageData.relativePath
      .replace(/\.md$/, '.html')
      .replace(/(^|\/)index\.html$/, '$1')
    pageData.frontmatter.head ??= []
    pageData.frontmatter.head.push([
      'link',
      { rel: 'canonical', href: `https://cert-ops.rubennati.at/${path}` },
    ])
  },

  themeConfig: {
    // Wordmark instead of the plain site title. siteTitle is rendered with
    // v-html, so the two-tone mark needs no component of its own; it is styled
    // in theme/style.css.
    siteTitle:
      '<span class="brand"><span class="brand-cert">Cert</span> <span class="brand-ops">Ops</span></span>',

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

    // No `footer` here on purpose: VitePress hides its built-in footer on every
    // page that has a sidebar. theme/SiteFooter.vue replaces it.

    editLink: {
      pattern: 'https://github.com/rubennati/cert-ops-tool/edit/main/docs/:path',
      text: 'Edit this page on GitHub',
    },

    search: {
      provider: 'local',
    },
  },
})
