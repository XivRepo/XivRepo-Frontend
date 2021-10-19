<template>
  <div>
    <table>
      <thead>
        <tr>
          <th></th>
          <th>Name</th>
          <th>Version</th>
          <th>Files</th>
          <th>Status</th>
          <th>Location</th>
          <th>Downloads</th>
          <th>Date Published</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="version in versions" :key="version.id">
          <td>
            <a
              v-if="version.hosting_location === 'hosted'"
              :href="$parent.findPrimary(version).filename"
              class="download"
              :download="$parent.findPrimary(version).filename"
              @click.prevent="
                $parent.downloadFile(
                  $parent.findPrimary(version).hashes.sha1,
                  $parent.findPrimary(version).url,
                  $parent.findPrimary(version).filename
                )
              "
            >
              <DownloadIcon />
            </a>
            <a
              v-if="version.hosting_location === 'external'"
              :href="version.external_url"
              class="download"
            >
              <DownloadIcon />
            </a>
          </td>
          <td>
            <nuxt-link
              v-if="version.hosting_location === 'hosted'"
              :to="
                '/mod/' +
                (mod.slug ? mod.slug : mod.id) +
                '/version/' +
                version.id
              "
            >
              {{ version.name ? version.name : version.version_number }}
            </nuxt-link>
            <a
              v-if="version.hosting_location === 'external'"
              :href="version.external_url"
            >
              {{ version.name ? version.name : version.version_number }}
            </a>
          </td>
          <td>
            <nuxt-link
              v-if="version.hosting_location === 'hosted'"
              :to="
                '/mod/' +
                (mod.slug ? mod.slug : mod.id) +
                '/version/' +
                version.id
              "
            >
              {{ version.version_number }}
            </nuxt-link>
            <a
              v-if="version.hosting_location === 'external'"
              :href="version.external_url"
            >
              {{ version.version_number }}
            </a>
          </td>
          <td>
            <nuxt-link
              v-if="version.hosting_location === 'hosted'"
              :to="
                '/mod/' +
                (mod.slug ? mod.slug : mod.id) +
                '/version/' +
                version.id
              "
            >
              {{ version.files.length }}
            </nuxt-link>
            <span v-else>Unknown</span>
          </td>
          <td>
            <span v-if="version.version_type === 'release'" class="badge green">
              Release
            </span>
            <span v-if="version.version_type === 'beta'" class="badge yellow">
              Beta
            </span>
            <span v-if="version.version_type === 'alpha'" class="badge red">
              Alpha
            </span>
          </td>
          <td>
            <span
              v-if="version.hosting_location === 'hosted'"
              class="badge green"
            >
              Hosted
            </span>
            <span
              v-if="version.hosting_location === 'external'"
              class="badge yellow"
            >
              External
            </span>
          </td>
          <td>
            <span v-if="version.hosting_location === 'hosted'">
              {{ version.downloads }}
            </span>
            <span v-else>Unknown</span>
          </td>
          <td>{{ $dayjs(version.date_published).format('YYYY-MM-DD') }}</td>
        </tr>
      </tbody>
    </table>
    <div class="new-version">
      <nuxt-link
        v-if="currentMember"
        :to="{ path: 'newversion', query: { location: 'hosted' } }"
        class="button"
        style="margin-right: 1em"
      >
        New Version
      </nuxt-link>
      <nuxt-link
        v-if="currentMember"
        :to="{ path: 'newversion', query: { location: 'external' } }"
        class="button"
      >
        New Externally Hosted Version
      </nuxt-link>
    </div>
  </div>
</template>
<script>
import DownloadIcon from '~/assets/images/utils/download.svg?inline'

export default {
  components: {
    DownloadIcon,
  },
  auth: false,
  props: {
    mod: {
      type: Object,
      default() {
        return {}
      },
    },
    versions: {
      type: Array,
      default() {
        return []
      },
    },
    currentMember: {
      type: Object,
      default() {
        return null
      },
    },
  },
  created() {
    this.$emit('update:link-bar', [['Versions', 'versions']])
  },
}
</script>

<style lang="scss" scoped>
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
      text-align: center;
      width: 5%;

      svg {
        color: var(--color-text);

        &:hover,
        &:focus {
          color: var(--color-text-hover);
        }
      }
    }

    &:nth-child(2),
    &:nth-child(8) {
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

.download {
  cursor: pointer;
}

.new-version {
  width: 100%;
  text-align: right;
  margin-bottom: var(--spacing-card-md);
}

@media screen and (max-width: 400px) {
  th,
  td {
    &:nth-child(7) {
      display: none;
    }
  }
}

@media screen and (max-width: 600px) {
  th,
  td {
    &:nth-child(8) {
      display: none;
    }
  }
}

@media screen and (max-width: 800px) {
  th,
  td {
    &:nth-child(5) {
      display: none;
    }
  }
}

@media screen and (max-width: 1000px) {
  th,
  td {
    &:nth-child(2) {
      display: none;
    }
  }
}
</style>
