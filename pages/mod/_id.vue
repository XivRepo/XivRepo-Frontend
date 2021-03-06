<template>
  <div class="page-container">
    <div class="page-contents">
      <div class="content">
        <div class="header">
          <div class="icon">
            <img
              :src="
                mod.icon_url
                  ? mod.icon_url
                  : cdn + '/data/placeholder.svg?inline'
              "
              alt="mod - icon"
            />
          </div>
          <div class="info">
            <h1 class="title">{{ mod.title }}</h1>
            <p class="description">
              {{ mod.description }}
            </p>
            <div class="alt-nav">
              <p>
                <nuxt-link to="/mods"> Mods </nuxt-link>
                >
                <nuxt-link :to="'/mod/' + (mod.slug ? mod.slug : mod.id)">{{
                  mod.title
                }}</nuxt-link>
                <span v-if="linkBar.length > 0"> ></span>
                <nuxt-link
                  v-for="(link, index) in linkBar"
                  :key="index"
                  :to="/mod/ + (mod.slug ? mod.slug : mod.id) + '/' + link[1]"
                  >{{ link[0] }}
                  <span v-if="index !== linkBar.length - 1"> > </span>
                </nuxt-link>
              </p>
            </div>
          </div>
          <div class="buttons">
            <nuxt-link
              v-if="this.$auth.user"
              :to="`/report/create?id=${mod.id}&t=mod`"
              class="iconified-button"
            >
              <ReportIcon />
              Report
            </nuxt-link>
            <button
              v-if="
                this.$auth.user && userFollows && !userFollows.includes(mod.id)
              "
              class="iconified-button"
              @click="followMod"
            >
              <FollowIcon />
              Follow
            </button>
            <button
              v-if="
                this.$auth.user && userFollows && userFollows.includes(mod.id)
              "
              class="iconified-button"
              @click="unfollowMod"
            >
              <FollowIcon fill="currentColor" />
              Unfollow
            </button>
          </div>
        </div>
        <div class="mod-navigation">
          <div class="tabs">
            <nuxt-link
              :to="'/mod/' + (mod.slug ? mod.slug : mod.id)"
              class="tab"
            >
              <span>Description</span>
            </nuxt-link>
            <nuxt-link
              :to="'/mod/' + (mod.slug ? mod.slug : mod.id) + '/versions'"
              class="tab"
            >
              <span>Versions</span>
            </nuxt-link>
            <nuxt-link
              v-if="currentMember"
              :to="'/mod/' + (mod.slug ? mod.slug : mod.id) + '/settings'"
              class="tab"
            >
              <span>Settings</span>
            </nuxt-link>
            <a
              v-if="mod.wiki_url"
              :href="mod.wiki_url"
              target="_blank"
              class="tab"
            >
              <ExternalIcon />
              <span>Wiki</span>
            </a>
            <a
              v-if="mod.issues_url"
              :href="mod.issues_url"
              target="_blank"
              class="tab"
            >
              <ExternalIcon />
              <span>Issues</span>
            </a>
            <a
              v-if="mod.source_url"
              :href="mod.source_url"
              target="_blank"
              class="tab"
            >
              <ExternalIcon />
              <span>Source</span>
            </a>
            <a
              v-if="mod.discord_url"
              :href="mod.discord_url"
              target="_blank"
              class="tab"
            >
              <ExternalIcon />
              <span>Discord</span>
            </a>
            <div class="filler" />
          </div>
        </div>
        <div class="mod-content">
          <NuxtChild
            v-if="finishedLoading"
            :mod="mod"
            :versions="versions"
            :featured-versions="featuredVersions"
            :members="members"
            :current-member="currentMember"
            :link-bar.sync="linkBar"
          />
          <div v-if="!finishedLoading" class="loader">Loading...</div>
        </div>
      </div>
      <section class="mod-info">
        <div class="mod-stats section">
          <div class="stat">
            <DownloadIcon />
            <div class="info">
              <h4>Downloads</h4>
              <p class="value">{{ formatNumber(mod.downloads) }}</p>
            </div>
          </div>
          <div class="stat">
            <CalendarIcon />
            <div class="info">
              <h4>Created</h4>
              <p
                v-tooltip="
                  $dayjs(mod.published).format(
                    '[Created on] YYYY-MM-DD [at] HH:mm A'
                  )
                "
                class="value"
              >
                {{ $dayjs(mod.published).fromNow() }}
              </p>
            </div>
          </div>
          <div class="stat">
            <EditIcon />
            <div class="info">
              <h4>Updated</h4>
              <p
                v-tooltip="
                  $dayjs(mod.updated).format(
                    '[Updated on] YYYY-MM-DD [at] HH:mm A'
                  )
                "
                class="value"
              >
                {{ $dayjs(mod.updated).fromNow() }}
              </p>
            </div>
          </div>
          <div class="stat">
            <InfoIcon />
            <div class="info">
              <h4>Rating</h4>
              <p v-if="mod.is_nsfw" class="value">NSFW</p>
              <p v-else class="value">SFW</p>
            </div>
          </div>
          <div class="stat">
            <CodeIcon />
            <div class="info">
              <h4>Project ID</h4>
              <p class="value">{{ mod.id }}</p>
            </div>
          </div>
        </div>
        <div class="section">
          <h3>Categories</h3>
          <Categories :categories="mod.categories" />
          <h3 style="padding-top: 0.7em">Races</h3>
          <Categories :categories="mod.races" />
          <h3 style="padding-top: 0.7em">Genders</h3>
          <Categories :categories="mod.genders" />
        </div>
        <div v-if="mod.dependencies" class="section">
          <h3>Dependencies</h3>
          <div
            v-for="dependency in mod.dependencies"
            :key="dependency.id"
            class="team-member columns"
          >
            <img :src="dependency.icon_url" alt="profile-picture" />
            <div class="member-info">
              <nuxt-link :to="'/mod/' + dependency.slug">
                <h4>{{ dependency.title }}</h4>
              </nuxt-link>
            </div>
          </div>
        </div>
        <div class="section">
          <h3>Members</h3>
          <div
            v-for="member in members"
            :key="member.user_id"
            class="team-member columns"
          >
            <img :src="member.avatar_url" alt="profile-picture" />
            <div class="member-info">
              <nuxt-link :to="'/user/' + member.user_id">
                <h4>{{ member.name }}</h4>
              </nuxt-link>
              <h3>{{ member.role }}</h3>
            </div>
          </div>
        </div>
        <div v-if="featuredVersions.length > 0" class="section">
          <h3>Featured Versions</h3>
          <div
            v-for="version in featuredVersions"
            :key="version.id"
            class="featured-version"
          >
            <a
              :href="findPrimary(version).filename"
              class="download"
              :download="findPrimary(version).filename"
              @click.prevent="
                downloadFile(
                  findPrimary(version).hashes.sha1,
                  findPrimary(version).url,
                  findPrimary(version).filename
                )
              "
            >
              <DownloadIcon />
            </a>
            <div class="info">
              <div class="top">
                <span
                  v-if="version.version_type === 'release'"
                  class="badge green"
                >
                  Release
                </span>
                <span
                  v-if="version.version_type === 'beta'"
                  class="badge yellow"
                >
                  Beta
                </span>
                <span v-if="version.version_type === 'alpha'" class="badge red">
                  Alpha
                </span>
                <h4 class="title">
                  <nuxt-link
                    :to="
                      '/mod/' +
                      (mod.slug ? mod.slug : mod.id) +
                      '/version/' +
                      version.id
                    "
                  >
                    {{ version.name }}
                  </nuxt-link>
                </h4>
              </div>
              <div class="bottom">
                <span class="version-number limit-text-width">
                  {{ version.version_number }} ·
                </span>
              </div>
            </div>
          </div>
        </div>
        <div
          v-if="mod.donation_urls && mod.donation_urls.length > 0"
          class="section"
        >
          <h3>Donation Links</h3>
          <div
            v-for="(item, index) in mod.donation_urls"
            :key="index"
            class="links"
          >
            <a :href="item.url" class="link">
              <ExternalIcon />
              {{ item.platform }}
            </a>
          </div>
        </div>
        <m-footer class="footer" />
      </section>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import Categories from '~/components/ui/search/Categories'
import MFooter from '~/components/layout/MFooter'

import CalendarIcon from '~/assets/images/utils/calendar.svg?inline'
import DownloadIcon from '~/assets/images/utils/download.svg?inline'
import EditIcon from '~/assets/images/utils/edit.svg?inline'
import CodeIcon from '~/assets/images/sidebar/mod.svg?inline'
import ReportIcon from '~/assets/images/utils/report.svg?inline'
import FollowIcon from '~/assets/images/utils/heart.svg?inline'
import InfoIcon from '~/assets/images/utils/info.svg?inline'

import ExternalIcon from '~/assets/images/utils/external.svg?inline'

export default {
  name: 'ModPage',
  components: {
    MFooter,
    Categories,
    ExternalIcon,
    DownloadIcon,
    CalendarIcon,
    EditIcon,
    CodeIcon,
    ReportIcon,
    FollowIcon,
    InfoIcon,
  },
  props: {
    cdn: {
      type: String,
      default: process.env.cdnUrl,
    },
  },
  async asyncData(data) {
    try {
      const mod = (
        await axios.get(
          `${data.env.apiUrl}/api/v1/mod/${data.params.id}`,
          data.$auth.headers
        )
      ).data

      const [members, versions, featuredVersions, userFollows] = (
        await Promise.all([
          axios.get(`${data.env.apiUrl}/api/v1/team/${mod.team}/members`),
          axios.get(`${data.env.apiUrl}/api/v1/mod/${mod.id}/version`),
          axios.get(
            `${data.env.apiUrl}/api/v1/mod/${mod.id}/version?featured=true`
          ),
          axios.get(
            data.$auth.user
              ? `${data.env.apiUrl}/api/v1/user/${data.$auth.user.id}/follows`
              : `${data.env.apiUrl}`,
            data.$auth.headers
          ),
        ])
      ).map((it) => it.data)

      const users = (
        await axios.get(
          `${data.env.apiUrl}/api/v1/users?ids=${JSON.stringify(
            members.map((it) => it.user_id)
          )}`,
          data.$auth.headers
        )
      ).data

      users.forEach((it) => {
        const index = members.findIndex((x) => x.user_id === it.id)
        members[index].avatar_url = it.avatar_url
        members[index].name = it.username
      })

      const currentMember = data.$auth.user
        ? members.find((x) => x.user_id === data.$auth.user.id)
        : null

      return {
        mod,
        versions,
        featuredVersions,
        members,
        currentMember,
        userFollows: userFollows.name ? null : userFollows,
        linkBar: [],
        finishedLoading: true,
      }
    } catch {
      data.error({
        statusCode: 404,
        message: 'Mod not found',
      })
    }
  },
  data() {
    return {
      finishedLoading: false,
    }
  },
  methods: {
    formatNumber(x) {
      return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    },
    findPrimary(version) {
      let file = version.files.find((x) => x.primary)

      if (!file) {
        file = version.files[0]
      }

      if (!file) {
        file = { url: `/mod/${this.mod.id}/version/${version.id}` }
      }

      return file
    },
    async downloadFile(hash, url, filename) {
      await axios.get(
        `${process.env.apiUrl}/api/v1/version_file/${hash}/download`
      )

      const elem = document.createElement('a')
      elem.download = filename
      elem.href = url
      elem.click()
    },
    async followMod() {
      await axios.post(
        `${process.env.apiUrl}/api/v1/mod/${this.mod.id}/follow`,
        {},
        this.$auth.headers
      )

      this.userFollows.push(this.mod.id)
    },
    async unfollowMod() {
      await axios.delete(
        `${process.env.apiUrl}/api/v1/mod/${this.mod.id}/follow`,
        this.$auth.headers
      )

      this.userFollows.splice(this.userFollows.indexOf(this.mod.id), 1)
    },
  },
  head() {
    return {
      title: this.mod.title + ' - XIVMods',
      meta: [
        {
          hid: 'og:type',
          name: 'og:type',
          content: 'website',
        },
        {
          hid: 'og:title',
          name: 'og:title',
          content: this.mod.title,
        },
        {
          hid: 'apple-mobile-web-app-title',
          name: 'apple-mobile-web-app-title',
          content: this.mod.title,
        },
        {
          hid: 'og:description',
          name: 'og:description',
          content: this.mod.description,
        },
        {
          hid: 'description',
          name: 'description',
          content:
            this.mod.description +
            ' View other minecraft mods on XIVMods today! XIVMods is a new and modern Minecraft modding platform supporting both the Forge and Fabric mod loaders.',
        },
        {
          hid: 'og:url',
          name: 'og:url',
          content: `${process.env.baseUrl}/mod/${this.mod.id}`,
        },
        {
          hid: 'og:image',
          name: 'og:image',
          content: this.mod.icon_url
            ? this.mod.icon_url
            : process.env.cdnUrl + '/data/placeholder.png',
        },
      ],
    }
  },
}
</script>

<style lang="scss" scoped>
.header {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  flex-wrap: wrap;

  @extend %card-spaced-b;
  width: 100%;
  .icon {
    margin: auto 0;
    width: 100%;
    background: black;
    img {
      width: 100%;
      height: 100%;
      max-height: 25rem;
      margin: 0;
      border-radius: var(--size-rounded-icon);
      object-fit: contain;
    }
  }
  .info {
    @extend %column;
    margin: var(--spacing-card-md) 0 var(--spacing-card-md)
      var(--spacing-card-md);
    justify-content: center;
    .title {
      margin: var(--spacing-card-md) var(--spacing-card-md) 0 0;
      color: var(--color-text-dark);
      font-size: var(--font-size-lg);
    }
    .description {
      margin: var(--spacing-card-sm) var(--spacing-card-md) 0 0;
      color: var(--color-text-dark);
    }
    .alt-nav {
      margin: var(--spacing-card-sm) var(--spacing-card-md) 0 0;
      p {
        margin: 0;
      }
    }
  }
  .buttons {
    @extend %row;
    margin: var(--spacing-card-md) var(--spacing-card-md) var(--spacing-card-md)
      0;
    justify-content: center;

    button,
    a {
      margin: 0.2rem 0 0 0.2rem;
    }
  }

  @media screen and (min-width: 1024px) {
    align-items: unset;
    text-align: unset;
    flex-direction: row;

    .buttons {
      flex-direction: column;
      margin-left: auto;
    }
  }
}

.mod-navigation {
  @extend %card-spaced-b;
  padding-bottom: 0.2rem;
}

.mod-info {
  height: auto;

  @media screen and (min-width: 1024px) {
    width: 30rem;
    margin-left: var(--spacing-card-lg);
  }

  .section {
    padding: var(--spacing-card-sm);
    @extend %card-spaced-b;
  }

  h3 {
    @extend %large-label;
  }

  .mod-stats {
    display: flex;
    flex-wrap: wrap;
    margin-top: 0;
    p {
      max-width: 6rem;
      overflow: hidden;
      white-space: nowrap;
      text-overflow: '';
      margin: 3px;
    }
    .stat {
      width: 8.5rem;
      margin: 0.75rem;
      @extend %stat;

      svg {
        padding: 0.25rem;
        border-radius: 50%;
        background-color: var(--color-button-bg);
      }
    }
  }

  .team-member {
    margin-left: 5px;
    margin-bottom: 10px;

    img {
      border-radius: var(--size-rounded-icon);
      height: 50px;
      width: 50px;
    }
    .member-info {
      max-width: 150px;
      overflow: hidden;
      margin: auto 0 auto 0.5rem;
      h4 {
        font-weight: normal;
        margin: 0;
      }
      h3 {
        margin-top: 0.1rem;
        margin-bottom: 0;
      }
    }
  }

  .featured-version {
    @extend %row;
    padding-top: var(--spacing-card-sm);
    padding-bottom: var(--spacing-card-sm);
    .download {
      display: flex;
      align-items: center;
      height: 2.25rem;
      width: 2.25rem;
      border-radius: 2rem;
      background-color: var(--color-button-bg);
      margin-right: var(--spacing-card-sm);
      cursor: pointer;
      svg {
        width: 1.25rem;
        margin: auto;
      }
      flex-shrink: 0;
    }
    .info {
      @extend %column;
      font-size: var(--font-size-xs);
      .top {
        @extend %row;
        .badge {
          font-size: var(--font-size-xs);
          margin-right: var(--spacing-card-sm);
        }
        .title {
          margin: auto 0;
        }
      }
      .bottom {
        margin-top: 0.25rem;
        @extend %row;
        .loader {
          height: 1rem;
        }
      }
    }
  }

  .links {
    padding: 0.5rem 1rem;

    .link {
      display: flex;
      align-items: center;
      padding: 0.25rem 0;

      svg {
        width: 1rem;
        height: 1rem;
        margin-right: 0.3rem;
      }

      &:hover,
      &:focus {
        padding-bottom: calc(0.25rem - 3px);
        border-bottom: 3px solid var(--color-brand-disabled);
        color: var(--color-text-medium);
      }
    }
  }
}

.limit-text-width {
  display: inline-block;
  height: 1em;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

@media screen and (max-width: 550px) {
  .title a {
    display: none;
  }
}

@media screen and (max-width: 800px) {
  .mod-navigation {
    display: block;
    overflow-x: auto;
    overflow-wrap: break-word;
    overflow-y: hidden;
  }
}
/*
@media screen and (max-width: 1400px) {
  .mod-info {
    display: none;
  }
}
*/
</style>
