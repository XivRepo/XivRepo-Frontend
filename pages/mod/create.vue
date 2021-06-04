<template>
  <div class="page-container">
    <div class="page-contents">
      <header class="columns">
        <h3 class="column-grow-1">Create a mod</h3>
        <button
          title="Save draft"
          class="button column"
          :disabled="!this.$nuxt.$loading"
          @click="createDraft"
        >
          Save draft
        </button>
        <button
          title="Create"
          class="brand-button column"
          :disabled="!this.$nuxt.$loading"
          @click="createMod"
        >
          Create
        </button>
      </header>
      <section class="essentials">
        <h3>Name</h3>
        <label>
          <span> Be creative and descriptive with your mod name. </span>
          <input v-model="name" type="text" placeholder="Enter the name" />
        </label>
        <h3>Summary</h3>
        <label>
          <span>
            Give a quick description to your mod. It will appear in the search.
          </span>
          <input
            v-model="description"
            type="text"
            placeholder="Enter the summary"
          />
        </label>
        <h3>Categories</h3>
        <label>
          <span>
            Select up to 12 categories. They will help others find your mod.
          </span>
          <multiselect
            id="categories"
            v-model="categories"
            :options="availableCategories"
            :custom-label="versionLabels"
            :loading="availableCategories.length === 0"
            :multiple="true"
            :searchable="true"
            :show-no-results="false"
            :close-on-select="false"
            :clear-on-select="false"
            :show-labels="true"
            :max="12"
            :limit="8"
            :hide-selected="true"
            placeholder="Choose categories"
          />
        </label>
      </section>
      <section class="mod-icon rows">
        <h3>Icon</h3>
        <div class="columns row-grow-1">
          <div class="column-grow-1 rows">
            <file-input
              accept="image/png,image/jpeg,image/gif,image/webp"
              class="choose-image"
              prompt="Choose image or drag it here"
              @change="showPreviewImage"
            />
            <ul class="row-grow-1">
              <li>Must be a square</li>
              <li>Minimum size is 100x100</li>
              <li>Acceptable formats are PNG, JPEG, GIF and WEBP</li>
            </ul>
            <button
              class="transparent-button"
              @click="
                icon = null
                previewImage = null
              "
            >
              Reset icon
            </button>
          </div>
          <img
            :src="previewImage ? previewImage : cdn + '/data/placeholder.svg'"
            alt="preview-image"
          />
        </div>
      </section>
      <section class="description">
        <h3>
          <label
            for="body"
            title="You can type the of the long form of your description here."
          >
            Body
          </label>
        </h3>
        <span>
          You can type the of the long form of your description here. This
          editor supports markdown. You can find the syntax
          <a
            class=""
            href="https://guides.github.com/features/mastering-markdown/"
            target="_blank"
            rel="noopener noreferrer"
            >here</a
          >. HTML can also be used inside your description, excluding scripts
          and iframes.
        </span>
        <div class="columns">
          <div class="textarea-wrapper">
            <textarea id="body" v-model="body"></textarea>
          </div>
          <div v-compiled-markdown="body" class="markdown-body"></div>
        </div>
      </section>
      <section class="versions">
        <div class="title">
          <h3>Upload Versions</h3>
          <button
            title="Add a version"
            class="button"
            :disabled="currentVersionIndex !== -1"
            @click="createVersion"
          >
            Add a version
          </button>
        </div>
        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Version</th>
              <th>Release Type</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="(version, index) in versions.filter((it) =>
                currentVersionIndex !== -1
                  ? it !== versions[currentVersionIndex]
                  : true
              )"
              :key="version.id"
            >
              <td>
                {{ version.version_title }}
              </td>
              <td>{{ version.version_number }}</td>
              <td>
                <span
                  v-if="version.release_channel === 'release'"
                  class="badge green"
                >
                  Release
                </span>
                <span
                  v-if="version.release_channel === 'beta'"
                  class="badge yellow"
                >
                  Beta
                </span>
                <span
                  v-if="version.release_channel === 'alpha'"
                  class="badge red"
                >
                  Alpha
                </span>
              </td>
              <td>
                <button
                  title="Remove version"
                  @click="versions.splice(index, 1)"
                >
                  Remove
                </button>
                <button
                  title="Edit version"
                  @click="currentVersionIndex = index"
                >
                  Edit
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <hr v-if="currentVersionIndex !== -1" />
        <div v-if="currentVersionIndex !== -1" class="new-version">
          <div class="controls">
            <button
              class="brand-button"
              title="Save version"
              @click="currentVersionIndex = -1"
            >
              Save version
            </button>
            <button title="Discard version" @click="deleteVersion">
              Discard
            </button>
          </div>
          <div class="main">
            <h3>Name</h3>
            <label>
              <span>
                This is what users will see first. Will default to version
                number
              </span>
              <input
                v-model="versions[currentVersionIndex].version_title"
                type="text"
                placeholder="Enter the name"
              />
            </label>
            <h3>Number</h3>
            <label>
              <span>
                That's how your version will appear in mod lists and in URLs
              </span>
              <input
                v-model="versions[currentVersionIndex].version_number"
                type="text"
                placeholder="Enter the number"
              />
            </label>
            <h3>Channel</h3>
            <label>
              <span>
                It is important to notify players and pack makers if the version
                is stable
              </span>
              <multiselect
                v-model="versions[currentVersionIndex].release_channel"
                placeholder="Select one"
                :options="['release', 'beta', 'alpha']"
                :searchable="false"
                :close-on-select="true"
                :show-labels="false"
                :allow-empty="false"
              />
            </label>
            <h3>Files</h3>
            <label>
              <span>
                You should upload a single archive file. However, you are
                allowed to upload multiple
              </span>
              <FileInput
                accept=".zip,.rar,.7z,.7zip,.tar.gz,.ttmp,.ttmp2,.pose,.cmp"
                multiple
                prompt="Choose files or drag them here"
                @change="updateVersionFiles"
              />
            </label>
            <div class="uploader">
              <file-upload
                ref="upload"
                v-model="versions[currentVersionIndex].files"
                post-action=""
                extensions="zip,rar,7z,7zip,tar.gz,ttmp,ttmp2"
                accept="image/png,image/gif,image/jpeg,image/webp"
                :multiple="true"
                :size="1024 * 1024 * 10"
                @input-filter="inputFilter"
                @input-file="inputFile"
              >
                Choose Files
              </file-upload>
            </div>
            <ul class="file-list">
              <li
                v-for="file in versions[currentVersionIndex].files"
                :key="file.id"
              >
                <span>{{ file.name }}</span> -
                <span>{{ file.size | formatSize }}</span> -
                <span v-if="file.error">{{ file.error }}</span>
                <span v-else-if="file.success">success</span>
                <span v-else-if="file.active">active</span>
                <span v-else-if="!!file.error">{{ file.error }}</span>
                <span v-else></span>
              </li>
            </ul>
          </div>
          <div class="changelog">
            <h3>Changelog</h3>
            <span>
              Tell players and modpack makers what's new. It supports the same
              markdown as description, but it is advisable not to be too
              creative with it in changelogs
            </span>
            <div class="textarea-wrapper">
              <textarea
                v-model="versions[currentVersionIndex].changelog"
              ></textarea>
            </div>
          </div>
        </div>
      </section>
      <section class="extra-links">
        <div class="title">
          <h3>External links</h3>
          <i>— this section is optional</i>
        </div>
        <label
          title="A place for users to report bugs, issues, and concerns about your mod."
        >
          <span>Issue tracker</span>
          <input
            v-model="issues_url"
            type="url"
            placeholder="Enter a valid URL"
          />
        </label>
        <label title="A page/repository containing the source code">
          <span>Source code</span>
          <input
            v-model="source_url"
            type="url"
            placeholder="Enter a valid URL"
          />
        </label>
        <label
          title="A page containing information, documentation, and help for the mod."
        >
          <span>Wiki page</span>
          <input
            v-model="wiki_url"
            type="url"
            placeholder="Enter a valid URL"
          />
        </label>
      </section>
      <section class="license">
        <div class="title">
          <h3>License</h3>
          <i>— this section is optional</i>
        </div>
        <label>
          <span>
            It is really important to choose a proper license for your mod. You
            may choose one from our list or provide a URL to your own license.
            URL field will be filled automatically for provided licenses
          </span>
          <div class="input-group">
            <Multiselect
              v-model="license"
              placeholder="Select one"
              track-by="short"
              label="name"
              :searchable="true"
              :options="availableLicenses"
              :close-on-select="true"
              :show-labels="false"
            />
            <input v-model="license_url" type="url" placeholder="License URL" />
          </div>
        </label>
      </section>
      <section class="donations">
        <div class="title">
          <h3>Donation links</h3>
          <i>— this section is optional</i>
          <button
            title="Add a link"
            class="button"
            :disabled="false"
            @click="
              donationPlatforms.push({})
              donationLinks.push('')
            "
          >
            Add a link
          </button>
        </div>
        <div v-for="(item, index) in donationPlatforms" :key="index">
          <label title="The donation link.">
            <span>Donation Link</span>
            <input
              v-model="donationLinks[index]"
              type="url"
              placeholder="Enter a valid URL"
            />
          </label>
          <label title="The donation platform of the link.">
            <span>Donation Platform</span>
            <Multiselect
              v-model="donationPlatforms[index]"
              placeholder="Select one"
              track-by="short"
              label="name"
              :options="availableDonationPlatforms"
              :searchable="false"
              :close-on-select="true"
              :show-labels="false"
            />
          </label>
          <button
            class="button"
            @click="
              donationPlatforms.splice(index, 1)
              donationLinks.splice(index, 1)
            "
          >
            Remove Link
          </button>
          <hr />
        </div>
      </section>
      <m-footer class="footer" centered />
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import Multiselect from 'vue-multiselect'
import FileUpload from 'vue-upload-component'

import FileInput from '~/components/ui/FileInput'
import MFooter from '~/components/layout/MFooter'

export default {
  components: {
    MFooter,
    FileInput,
    Multiselect,
    FileUpload,
  },
  filters: {
    formatSize(size) {
      if (size > 1024 * 1024 * 1024 * 1024) {
        return (size / 1024 / 1024 / 1024 / 1024).toFixed(2) + ' TB'
      } else if (size > 1024 * 1024 * 1024) {
        return (size / 1024 / 1024 / 1024).toFixed(2) + ' GB'
      } else if (size > 1024 * 1024) {
        return (size / 1024 / 1024).toFixed(2) + ' MB'
      } else if (size > 1024) {
        return (size / 1024).toFixed(2) + ' KB'
      }
      return size.toString() + ' B'
    },
  },
  async asyncData(data) {
    const [
      availableCategories,
      availableLoaders,
      availableGameVersions,
      availableLicenses,
      availableDonationPlatforms,
    ] = (
      await Promise.all([
        axios.get(`${data.env.apiUrl}/api/v1/tag/category`),
        axios.get(`${data.env.apiUrl}/api/v1/tag/loader`),
        axios.get(`${data.env.apiUrl}/api/v1/tag/game_version`),
        axios.get(`${data.env.apiUrl}/api/v1/tag/license`),
        axios.get(`${data.env.apiUrl}/api/v1/tag/donation_platform`),
      ])
    ).map((it) => it.data)

    return {
      availableCategories,
      availableLoaders,
      availableGameVersions,
      availableLicenses,
      availableDonationPlatforms,
    }
  },
  data() {
    return {
      previewImage: null,
      compiledBody: '',
      releaseChannels: ['beta', 'alpha', 'release'],
      currentVersionIndex: -1,
      filePost: '',
      filePut: '',

      cdn: process.env.cdnUrl,
      name: '',
      slug: '',
      draft: false,
      description: '',
      body: '',
      versions: [],
      categories: [],
      issues_url: null,
      source_url: null,
      wiki_url: null,
      discord_url: null,
      icon: null,
      license: null,
      license_url: null,

      sideTypes: ['Required', 'Optional', 'Unsupported'],
      clientSideType: 'Required',
      serverSideType: 'Required',

      donationLinks: [],
      donationPlatforms: [],
    }
  },
  watch: {
    license(newValue, oldValue) {
      if (newValue == null) {
        this.license_url = ''
        return
      }

      switch (newValue.short) {
        case 'custom':
          this.license_url = ''
          break
        default:
          this.license_url =
            process.env.cdnUrl + `/data/licenses/${newValue.short}.txt`
      }
    },
  },
  methods: {
    async createDraft() {
      this.draft = true
      await this.createMod()
    },

    async createMod() {
      this.$nuxt.$loading.start()

      for (const version of this.versions) {
        if (!version.version_title) {
          version.version_title = version.version_number
        }
      }

      const formData = new FormData()

      formData.append(
        'data',
        JSON.stringify({
          mod_name: this.name,
          mod_slug: this.slug,
          mod_namespace: this.namespace,
          mod_description: this.description,
          mod_body: this.body,
          initial_versions: this.versions,
          team_members: [
            {
              user_id: this.$auth.user.id,
              name: this.$auth.user.username,
              role: 'Owner',
            },
          ],
          categories: this.categories,
          issues_url: this.issues_url,
          source_url: this.source_url,
          wiki_url: this.wiki_url,
          discord_url: this.discord_url,
          client_side: this.clientSideType.toLowerCase(),
          server_side: this.serverSideType.toLowerCase(),
          license_id: this.license ? this.license.short : 'arr',
          license_url: this.license_url,
          is_draft: this.draft,
          donation_urls: this.donationPlatforms.map((it, index) => {
            return {
              id: it.short,
              platform: it.name,
              url: this.donationLinks[index],
            }
          }),
        })
      )

      if (this.icon) {
        formData.append('icon', new Blob([this.icon]), this.icon.name)
      }

      for (const version of this.versions) {
        for (let i = 0; i < version.raw_files.length; i++) {
          formData.append(
            version.file_parts[i],
            new Blob([version.raw_files[i]]),
            version.raw_files[i].name
          )
        }
      }

      try {
        await axios({
          url: process.env.apiUrl + '/api/v1/mod',
          method: 'POST',
          data: formData,
          headers: {
            'Content-Type': 'multipart/form-data',
            Authorization: this.$auth.token,
          },
        })

        await this.$router.replace('/dashboard/projects')
      } catch (err) {
        let description = err.response.data.description

        if (description.includes('JSON')) {
          description = 'Please fill in missing required fields.'
        }

        this.$notify({
          group: 'main',
          title: 'An Error Occurred',
          text: description,
          type: 'error',
        })

        window.scrollTo({ top: 0, behavior: 'smooth' })
      }

      this.$nuxt.$loading.finish()
    },

    versionLabels(id) {
      if (id) {
        return this.toProperCase(id.replace(/_/g, ' '))
      } else {
        return ''
      }
    },

    toProperCase(str) {
      return str.replace(/\w\S*/g, function (txt) {
        return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
      })
    },

    showPreviewImage(files) {
      const reader = new FileReader()
      this.icon = files[0]
      reader.readAsDataURL(this.icon)

      reader.onload = (event) => {
        this.previewImage = event.target.result
        this.cdn = process.env.cdnUrl
      }
    },

    updateVersionFiles(files) {
      this.versions[this.currentVersionIndex].raw_files = files

      const newFileParts = []
      for (let i = 0; i < files.length; i++) {
        newFileParts.push(files[i].name.concat('-' + i))
      }

      this.versions[this.currentVersionIndex].file_parts = newFileParts
    },

    createVersion() {
      this.versions.push({
        raw_files: [],
        file_parts: [],
        files: [],
        version_number: '1.0.0',
        version_title: 'Initial Release',
        version_body: '',
        dependencies: [],
        game_versions: [],
        release_channel: 'release',
        loaders: [],
        featured: false,
      })

      this.currentVersionIndex = this.versions.length - 1
    },

    deleteVersion() {
      this.versions.splice(this.currentVersionIndex, 1)
      this.currentVersionIndex = -1
    },

    inputFilter(newFile, oldFile, prevent) {
      if (newFile && !oldFile) {
        if (/(\/|^)(Thumbs\.db|desktop\.ini|\..+)$/.test(newFile.name)) {
          return prevent()
        }

        if (/\.(php5?|html?|jsx?)$/i.test(newFile.name)) {
          return prevent()
        }
      }
    },

    inputFile(newFile, oldFile) {
      if (newFile && !oldFile) {
        console.log('add', newFile)
      }
      if (newFile && oldFile) {
        console.log('update', newFile)
      }
      if (!newFile && oldFile) {
        console.log('remove', oldFile)
      }
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
    'advert       advert      advert' auto
    'essentials   essentials  essentials' auto
    'mod-icon     mod-icon    mod-icon' auto
    'game-sides   game-sides  game-sides' auto
    'description  description description' auto
    'files         files        files' auto
    'versions     versions    versions' auto
    'extra-links  extra-links extra-links' auto
    'license      license     license' auto
    'donations    donations   donations' auto
    'footer       footer      footer' auto
    / 4fr 1fr 4fr;

  @media screen and (min-width: 1024px) {
    grid-template:
      'header       header      header' auto
      'advert       advert      advert' auto
      'essentials   essentials  mod-icon' auto
      'game-sides   game-sides  game-sides' auto
      'description  description description' auto
      'files         files        files' auto
      'versions     versions    versions' auto
      'extra-links  license     license' auto
      'donations    donations   .' auto
      'footer       footer      footer' auto
      / 4fr 1fr 4fr;
  }

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

.advert {
  grid-area: advert;
}

section {
  @extend %card;

  padding: var(--spacing-card-md) var(--spacing-card-lg);
}

section.essentials {
  grid-area: essentials;
}

section.mod-icon {
  grid-area: mod-icon;

  img {
    align-self: flex-start;
    max-width: 50%;
    margin-left: var(--spacing-card-lg);
  }
}

section.game-sides {
  grid-area: game-sides;

  .columns {
    flex-wrap: wrap;

    span {
      flex: 2;
    }

    .labeled-control {
      flex: 2;
      margin-left: var(--spacing-card-lg);
    }
  }
}

section.description {
  grid-area: description;

  span a {
    text-decoration: underline;
  }

  & > .columns {
    align-items: stretch;
    min-height: 10rem;
    max-height: 40rem;

    & > * {
      flex: 1;
      max-width: 50%;
    }
  }

  .markdown-body {
    overflow-y: auto;
    padding: 0 var(--spacing-card-sm);
  }
}

section.files {
  grid-area: files;

  .initial-release {
    display: grid;
    grid-template:
      'main changelog' auto
      / 5fr 4fr;
    column-gap: var(--spacing-card-md);
  }
}

section.versions {
  grid-area: versions;

  table {
    border-collapse: collapse;
    margin-bottom: var(--spacing-card-md);
    background: var(--color-raised-bg);
    border-radius: var(--size-rounded-card);
    table-layout: fixed;
    width: 100%;

    * {
      text-align: left;
    }

    tr:not(:last-child),
    tr:first-child {
      th,
      td {
        border-bottom: 1px solid var(--color-divider);
      }
    }

    th,
    td {
      &:first-child {
        text-align: left;
        width: 30%;

        svg {
          color: var(--color-text);

          &:hover,
          &:focus {
            color: var(--color-text-hover);
          }
        }
      }

      &:nth-child(2),
      &:nth-child(3) {
        padding-left: 0;
        width: 12%;
      }
    }

    th {
      color: var(--color-heading);
      font-size: 0.8rem;
      letter-spacing: 0.02rem;
      margin-bottom: 0.5rem;
      margin-top: 1.5rem;
      padding: 0.75rem 1rem;
      text-transform: uppercase;
    }

    td {
      overflow: hidden;
      padding: 0.75rem 1rem;

      img {
        height: 3rem;
        width: 3rem;
      }
    }
  }

  hr {
    background-color: var(--color-divider);
    border: none;
    color: var(--color-divider);
    height: 2px;
    margin: 0.5rem 0;
  }

  .new-version {
    display: grid;
    grid-template:
      'controls controls' auto
      'main changelog' auto
      / 5fr 4fr;
    column-gap: var(--spacing-card-md);

    .controls {
      grid-area: controls;
      display: flex;
      flex-direction: row-reverse;
    }

    .main {
      grid-area: main;
    }

    .changelog {
      grid-area: changelog;
      display: flex;
      flex-direction: column;

      .textarea-wrapper {
        flex: 1;
      }
    }

    .uploader {
      margin-top: 1em;
      label {
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        padding: var(--spacing-card-sm) var(--spacing-card-md);
      }

      span {
        border: 2px dashed var(--color-divider-dark);
        border-radius: var(--size-rounded-control);
        padding: var(--spacing-card-md) var(--spacing-card-lg);
      }
    }
  }
}

section.extra-links {
  grid-area: extra-links;

  label {
    align-items: center;
    margin-top: var(--spacing-card-sm);

    span {
      flex: 1;
    }
  }
}

section.license {
  grid-area: license;

  label {
    margin-top: var(--spacing-card-sm);
  }
}

section.donations {
  grid-area: donations;

  label {
    align-items: center;
    margin-top: var(--spacing-card-sm);

    span {
      flex: 1;
    }
  }
}

.footer {
  grid-area: footer;
}

.choose-image {
  cursor: pointer;
}
</style>
