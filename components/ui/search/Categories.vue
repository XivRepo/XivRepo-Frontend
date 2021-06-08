<template>
  <div class="categories">
    <p v-for="item in categories" :key="item">{{ item | categoryLabel }}</p>
  </div>
</template>

<script>
export default {
  name: 'Categories',
  components: {},
  filters: {
    categoryLabel(id) {
      return id.replace(/_/g, ' ').replace(/(\w)(\w*)/g, function (g0, g1, g2) {
        return g1.toUpperCase() + g2.toLowerCase()
      })
    },
  },
  props: {
    categories: {
      type: Array,
      default() {
        return []
      },
    },
  },
}
</script>

<style lang="scss" scoped>
.categories {
  @extend %row;
  flex-wrap: wrap;

  p {
    display: flex;
    align-items: center;
    flex-direction: row;
    background-color: var(--color-category-bg);
    border-radius: var(--size-rounded-max);
    color: var(--color-category-text);
    margin-top: 0.25em;
    margin-bottom: 0.25em;
    margin-right: 0.5em;
    padding: 0.4em 0.7em;
    font-size: var(--font-size-sm);
    height: 1em;
    svg {
      width: 15px;
      margin-right: 5px;
    }
  }
}
</style>
