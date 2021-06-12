<template>
  <div class="page-container">
    <div class="page-contents">
      <div class="content">
        <img src="~assets/images/loading.gif" alt="Now Loading" />
        <h1>Now Loading...</h1>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  name: 'Random',
  auth: false,
  async beforeMount() {
    await this.redirect()
  },
  methods: {
    async redirect() {
      const mod = (
        await axios.get(
          `${process.env.apiUrl}/api/v1/random_mod`,
          this.$auth.headers
        )
      ).data

      this.$router.replace('/mod/' + mod.slug)
    },
  },
}
</script>

<style lang="scss" scoped>
.page-container .page-contents .content {
  min-height: 80vh;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  background: var(--color-raised-bg);
  border-radius: var(--size-rounded-card);
}
</style>
