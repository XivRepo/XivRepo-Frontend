<template>
  <div class="page-container">
    <div class="page-contents">
      <header class="columns">
        <h3 class="column-grow-1">Request a tag</h3>
        <button
          title="Create"
          class="brand-button column"
          :disabled="!this.$nuxt.$loading"
          @click="createTagRequest"
        >
          Submit
        </button>
      </header>
      <section class="info">
        <h3>Tag Title</h3>
        <label>
          <span>
            Please enter the name of the tag you would like added to the site.
            This should be a short one or two word indicator describing a mod.
          </span>
          <input
            v-model="tagTitle"
            type="text"
            placeholder="Enter the your requested tag"
          />
        </label>
        <h3>Addition Information</h3>
        <span>
          Please provide any addition information you would like the moderators
          to see when they review your request.
        </span>
        <div class="textarea-wrapper">
          <textarea id="body" v-model="body"></textarea>
        </div>
      </section>
    </div>
  </div>
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      tagTitle: '',
      body: '',
    }
  },
  methods: {
    async createTagRequest() {
      this.$nuxt.$loading.start()

      try {
        const data = {
          tag_tile: this.tagTitle,
          body: this.body,
        }

        await axios.post(
          `${process.env.apiUrl}/api/v1/request_tag`,
          data,
          this.$auth.headers
        )
      } catch (err) {
        this.$notify({
          group: 'main',
          title: 'An Error Occurred',
          text: err.response.data.description,
          type: 'error',
        })
        window.scrollTo({ top: 0, behavior: 'smooth' })
      }
      this.$nuxt.$loading.finish()
    },
  },
}
</script>

<style lang="scss" scoped>
.title {
  * {
    display: inline;
  }
  .button {
    margin-left: 1rem;
  }
}

label {
  display: flex;

  span {
    flex: 2;
    padding-right: var(--spacing-card-lg);
  }

  input,
  .multiselect,
  .input-group {
    flex: 3;
    height: fit-content;
  }
}

.textarea-wrapper {
  display: flex;
  flex-direction: column;
  align-items: stretch;

  textarea {
    flex: 1;
    overflow-y: auto;
    resize: none;
    max-width: 100%;
  }
}

.page-contents {
  display: grid;
  grid-template:
    'header       header      header' auto
    'info         info        info' auto
    / 4fr 1fr 4fr;
  column-gap: var(--spacing-card-md);
  row-gap: var(--spacing-card-md);
}

header {
  @extend %card;

  grid-area: header;
  padding: var(--spacing-card-md) var(--spacing-card-lg);

  h3 {
    margin: auto 0;
    color: var(--color-text-dark);
    font-weight: var(--font-weight-extrabold);
  }

  button {
    margin-left: 0.5rem;
  }
}

section {
  @extend %card;

  padding: var(--spacing-card-md) var(--spacing-card-lg);
}

section.info {
  grid-area: info;
}
</style>
