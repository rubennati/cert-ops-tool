<script setup lang="ts">
/**
 * Site footer.
 *
 * Replaces VitePress' built-in footer (which is hidden on every page that has
 * a sidebar — i.e. on all of the documentation). Three groups, because they
 * answer three different questions: what this is, whether it can be trusted,
 * and who is responsible for it.
 *
 * "Report a problem with this page" builds a GitHub issue that already knows
 * which page it came from, so a reader who spots an error does not have to
 * describe where they were.
 */
import { computed } from 'vue'
import { useData } from 'vitepress'
import { useSidebar } from 'vitepress/theme'

const REPO = 'https://github.com/rubennati/cert-ops-tool'
const SITE = 'https://cert-ops.rubennati.at'

const { page } = useData()
const { hasSidebar } = useSidebar()

const issueUrl = computed(() => {
  const title = page.value.title || 'Documentation'
  const path = page.value.relativePath
    .replace(/(^|\/)index\.md$/, '$1')
    .replace(/\.md$/, '.html')
  const url = `${SITE}/${path}`
  return (
    `${REPO}/issues/new?` +
    new URLSearchParams({
      title: `Documentation: ${title}`,
      body: `**Page:** ${title}\n**URL:** ${url}\n\n**What is wrong or unclear:**\n\n`,
    }).toString()
  )
})

// Build-time year — the site is rebuilt on every push, so it stays current.
const year = new Date().getUTCFullYear()
</script>

<template>
  <footer class="SiteFooter" :class="{ 'has-sidebar': hasSidebar }">
    <div class="container">
      <div class="cols">
        <nav aria-labelledby="foot-project">
          <h2 id="foot-project">Project</h2>
          <ul>
            <li><a :href="REPO" target="_blank" rel="noreferrer">Technical repository<span class="ext" aria-hidden="true">↗</span></a></li>
            <li><a :href="`${REPO}/blob/main/CONTRIBUTING.md`" target="_blank" rel="noreferrer">Contribute<span class="ext" aria-hidden="true">↗</span></a></li>
            <li><a href="/changelog.html">Changelog</a></li>
            <li><a :href="issueUrl" target="_blank" rel="noreferrer">Report a problem with this page<span class="ext" aria-hidden="true">↗</span></a></li>
          </ul>
        </nav>

        <nav aria-labelledby="foot-trust">
          <h2 id="foot-trust">Trust</h2>
          <ul>
            <li><a :href="`${REPO}/blob/main/SECURITY.md`" target="_blank" rel="noreferrer">Security policy<span class="ext" aria-hidden="true">↗</span></a></li>
            <li><a :href="`${REPO}/security/advisories/new`" target="_blank" rel="noreferrer">Report a vulnerability<span class="ext" aria-hidden="true">↗</span></a></li>
            <li><a :href="`${REPO}/blob/main/CODE_OF_CONDUCT.md`" target="_blank" rel="noreferrer">Code of conduct<span class="ext" aria-hidden="true">↗</span></a></li>
          </ul>
        </nav>

        <nav aria-labelledby="foot-legal">
          <h2 id="foot-legal">Legal</h2>
          <ul>
            <li><a href="/legal.html">Legal notice</a></li>
            <li><a href="/privacy.html">Privacy</a></li>
            <li><a :href="`${REPO}/blob/main/LICENSE`" target="_blank" rel="noreferrer">PolyForm Noncommercial (code)<span class="ext" aria-hidden="true">↗</span></a></li>
          </ul>
        </nav>
      </div>

      <p class="fine">
        <span>© {{ year }} Cert Ops</span>
        <span class="sep" aria-hidden="true">·</span>
        <span>Code <a :href="`${REPO}/blob/main/LICENSE`" target="_blank" rel="noreferrer">PolyForm Noncommercial 1.0.0</a></span>
        <span class="sep" aria-hidden="true">·</span>
        <span>Site content <a href="/legal.html">licence not yet decided</a></span>
      </p>
    </div>
  </footer>
</template>

<style scoped>
.SiteFooter {
  position: relative;
  z-index: var(--vp-z-index-footer);
  border-top: 1px solid var(--vp-c-gutter);
  padding: 32px 24px;
  background-color: var(--vp-c-bg);
}

@media (min-width: 768px) {
  .SiteFooter {
    padding: 40px 32px;
  }
}

/* The sidebar is fixed and full-height, so a full-width footer would end up
   underneath it. Mirror VPContent's own offsets instead. */
@media (min-width: 960px) {
  .SiteFooter.has-sidebar {
    padding-left: calc(var(--vp-sidebar-width) + 32px);
  }
}

@media (min-width: 1440px) {
  .SiteFooter.has-sidebar {
    padding-left: calc((100vw - var(--vp-layout-max-width)) / 2 + var(--vp-sidebar-width) + 32px);
    padding-right: calc((100vw - var(--vp-layout-max-width)) / 2 + 32px);
  }
}

.container {
  margin: 0 auto;
  max-width: var(--vp-layout-max-width);
}

.cols {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(12rem, 1fr));
  gap: 24px 32px;
}

.SiteFooter h2 {
  margin: 0 0 8px;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.06em;
  text-transform: uppercase;
  color: var(--vp-c-text-3);
}

.SiteFooter ul {
  list-style: none;
  margin: 0;
  padding: 0;
  display: grid;
  gap: 6px;
}

.SiteFooter li {
  margin: 0;
  font-size: 14px;
  line-height: 20px;
}

.SiteFooter a {
  color: var(--vp-c-text-2);
  text-decoration: none;
  transition: color 0.25s;
}

.SiteFooter a:hover {
  color: var(--vp-c-text-1);
  text-decoration: underline;
  text-underline-offset: 2px;
}

.ext {
  margin-left: 2px;
  font-size: 0.85em;
}

/* Flex with wrapping separators, so a narrow screen breaks between the parts
   instead of stranding a link's external marker on its own line. */
.fine {
  display: flex;
  flex-wrap: wrap;
  gap: 6px 10px;
  margin-top: 28px;
  font-size: 12px;
  line-height: 1.6;
  color: var(--vp-c-text-3);
}

.fine a {
  color: inherit;
  text-decoration: underline;
  text-underline-offset: 2px;
}

/* Below this width the parts wrap anyway, which leaves a separator stranded at
   the end of a line looking like a typo. */
@media (max-width: 480px) {
  .fine {
    flex-direction: column;
    gap: 6px;
  }

  .sep {
    display: none;
  }
}
</style>
