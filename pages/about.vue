<template>
  <div class="main">
    <div class="container">
      <h1>About</h1>
      <p>
        Founded in 2020, XIVMods was created to provide modders with an open and
        intuitive platform to publish their mods on.
      </p>

      <p>
        Our primary goal is to be as open as possible, with all our code being
        <a target="_blank" href="https://github.com/xivrepo">open source</a>,
        while giving back to the modding community as much as possible.
      </p>

      <p>
        While we still are in beta, we hope we can be a major modding platform
        for all modders.
      </p>
      <h2>How does XIVMods work?</h2>
      <p>
        XIVMods is not just a website: it is made of several different
        components that all come together to make a fast and flexible modding
        platform.
      </p>

      <p>
        On the technical level, XIVMods is made up of two main components: the
        <a target="_blank" href="https://github.com/XivRepo/XivRepo-ApiServer"
          >Rust-based backend</a
        >, and the
        <a target="_blank" href="https://github.com/XivRepo/XivRepo-Frontend"
          >Vue-based frontend</a
        >.
      </p>

      <p>
        Additionally, some other custom-created resources exist, including but
        not limited to:
        <a target="_blank" href="https://github.com/xivrepo/minotaur"
          >Minotaur</a
        >, a Gradle plugin for easily publishing mods to XIVMods, and
        <a target="_blank" href="https://github.com/xivrepo/minos">Minos</a>, an
        authentication provider. All of XIVMods's code can be found on
        <a target="_blank" href="https://github.com/xivrepo">our GitHub page</a
        >.
      </p>
      <h2>Backend Documentation</h2>
      <p>
        Documentation for the XIVMods API (Labrinth) can be found on the GitHub
        repository's wiki
        <a
          target="_blank"
          href="https://github.com/xivrepo/labrinth/wiki/API-Documentation"
          >here</a
        >.
      </p>
    </div>
    <m-footer class="footer" centered />
  </div>
</template>

<script>
import MFooter from '~/components/layout/MFooter'

export default {
  components: {
    MFooter,
  },
  auth: false,
  head: {
    title: 'About - XIVMods',
    meta: [
      {
        hid: 'description',
        name: 'description',
        content:
          'View information about XIVMods, an open source modding platform here! XIVMods currently supports Minecraft, including the forge and fabric mod loaders.',
      },
      {
        hid: 'apple-mobile-web-app-title',
        name: 'apple-mobile-web-app-title',
        content: 'About',
      },
      {
        hid: 'og:title',
        name: 'og:title',
        content: 'About',
      },
      {
        hid: 'og:url',
        name: 'og:url',
        content: `${process.env.baseUrl}/about`,
      },
    ],
  },
}
</script>

<style lang="scss" scoped>
.main {
  margin: var(--spacing-card-sm) auto;
  max-width: 800px;
}

.container {
  @extend %card;
  padding: var(--spacing-card-sm) var(--spacing-card-lg);
}

a {
  text-decoration: underline;
}
</style>
