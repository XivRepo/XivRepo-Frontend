<template>
  <div class="categories">
    <p v-if="categories.includes('face_mod')">Face Mod</p>
    <p v-if="categories.includes('hair_mod')">Hair Mod</p>
    <p v-if="categories.includes('body_mod')">Body Mod</p>
    <p v-if="categories.includes('skin_mod')">Skin Mod</p>
    <p v-if="categories.includes('gear_mod')">Gear Mod</p>
    <p v-if="categories.includes('mount_mod')">Mount Mod</p>
    <p v-if="categories.includes('minion_mod')">Minion Mod</p>
    <p v-if="categories.includes('minion_mod')">Furniture Mod</p>
    <p v-if="categories.includes('racial_scale_mod')">Racial Scale Mod</p>
    <p v-if="categories.includes('anamnesis_pose')">Anamnesis Pose</p>
    <p v-if="categories.includes('cmt_pose')">CMT Pose</p>
    <p v-if="categories.includes('reshade')">Reshade Preset</p>
    <p v-if="categories.includes('other_mod')">Other Mod</p>
  </div>
</template>

<script>
export default {
  name: 'Categories',
  components: {},
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
