<script setup lang="ts">
/**
 * Wraps the default layout so the site footer renders on every page.
 *
 * VitePress' own footer (themeConfig.footer) is deliberately not configured:
 * it is hidden on any page that has a sidebar, which is all of the docs.
 */
import DefaultTheme from 'vitepress/theme'
import SiteFooter from './SiteFooter.vue'

const { Layout } = DefaultTheme
</script>

<template>
  <Layout>
    <template #layout-bottom>
      <SiteFooter />
    </template>
  </Layout>
</template>
