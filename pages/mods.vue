<template>
  <div class="page-container">
    <div class="page-contents">
      <div class="content">
        <section class="search-nav">
          <div class="iconified-input column-grow-2">
            <label class="hidden" for="search">Search Mods</label>
            <input
              id="search"
              v-model="query"
              type="search"
              name="search"
              placeholder="Search..."
              autocomplete="off"
              @input="onSearchChange(1)"
            />
            <SearchIcon />
          </div>
          <div class="sort-paginate">
            <div class="labeled-control">
              <h3>Sort By</h3>
              <Multiselect
                v-model="sortType"
                class="sort-types"
                placeholder="Select one"
                track-by="display"
                label="display"
                :options="sortTypes"
                :searchable="false"
                :close-on-select="true"
                :show-labels="false"
                :allow-empty="false"
                @input="onSearchChange(1)"
              >
                <template slot="singleLabel" slot-scope="{ option }">{{
                  option.display
                }}</template>
              </Multiselect>
            </div>
            <div class="labeled-control per-page">
              <h3>Per Page</h3>
              <Multiselect
                v-model="maxResults"
                class="max-results"
                placeholder="Select one"
                :options="[5, 10, 15, 20, 50, 100]"
                :searchable="false"
                :close-on-select="true"
                :show-labels="false"
                :allow-empty="false"
                @input="onSearchChange(currentPage)"
              >
              </Multiselect>
            </div>
            <div class="labeled-control mobile-filters-button">
              <h3>Filters</h3>
              <button @click="toggleFiltersMenu">Open</button>
            </div>
          </div>
          <pagination
            :current-page="currentPage"
            :pages="pages"
            @switch-page="onSearchChange"
          ></pagination>
        </section>
        <div class="results column-grow-4">
          <div v-if="results === null" class="no-results">
            <p>Loading...</p>
          </div>
          <div v-else>
            <SearchResult
              v-for="(result, index) in results"
              :id="result.slug ? result.slug : result.mod_id.split('-')[1]"
              :key="result.mod_id"
              :author="result.author"
              :name="result.title"
              :description="result.description"
              :latest-version="result.latest_version"
              :created-at="result.date_created"
              :updated-at="result.date_modified"
              :downloads="result.downloads.toString()"
              :icon-url="result.icon_url"
              :author-url="result.author_url"
              :page-url="result.page_url"
              :categories="result.categories"
              :is-ad="index === -1"
              :is-xivrepo="true"
            />
            <div v-if="results.length === 0" class="no-results">
              <p>No results found for your query!</p>
            </div>
          </div>
        </div>
        <section v-if="pages.length > 1" class="search-bottom">
          <div class="per-page labeled-control">
            <h3>Per Page</h3>
            <Multiselect
              v-model="maxResults"
              class="max-results"
              placeholder="Select one"
              :options="[5, 10, 15, 20, 50, 100]"
              :searchable="false"
              :close-on-select="true"
              :show-labels="false"
              :allow-empty="false"
              @input="onSearchChange(currentPage)"
            >
            </Multiselect>
          </div>
          <pagination
            :current-page="currentPage"
            :pages="pages"
            @switch-page="onSearchChangeToTop"
          ></pagination>
        </section>
        <m-footer class="footer" hide-big centered />
      </div>
      <section ref="filters" class="filters">
        <div class="filters-wrapper">
          <section class="filter-group">
            <div class="filter-clear-button">
              <h3>Categories</h3>
              <div class="columns">
                <button class="filter-button-done" @click="toggleFiltersMenu">
                  Close
                </button>
                <button class="iconified-button" @click="clearFilters">
                  <ExitIcon />
                  Clear filters
                </button>
              </div>
            </div>
            <SearchFilter
              :active-filters="facets"
              display-name="Face Mod"
              facet-name="categories:face_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Body Mod"
              facet-name="categories:body_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Hair Mod"
              facet-name="categories:hair_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Skin Mod"
              facet-name="categories:skin_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Gear Mod"
              facet-name="categories:gear_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Mount Mod"
              facet-name="categories:mount_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Minion Mod"
              facet-name="categories:minion_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Furniture Mod"
              facet-name="categories:furniture_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Racial Scale Mod"
              facet-name="categories:racial_scale_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Anamnesis Pose"
              facet-name="categories:anamnesis_pose"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Concept Matrix Pose"
              facet-name="categories:cmt_pose"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Reshade Preset"
              facet-name="categories:reshade"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Other Mod"
              facet-name="categories:other_mod"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <h3>Races</h3>
            <SearchFilter
              :active-filters="facets"
              display-name="Hyur"
              facet-name="categories:hyur"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Elezen"
              facet-name="categories:elezen"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Miqote"
              facet-name="categories:miqote"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Lalafell"
              facet-name="categories:lalafell"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Au Ra"
              facet-name="categories:au_ra"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Roegadyn"
              facet-name="categories:roegadyn"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Hrothgar"
              facet-name="categories:hrothgar"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Viera"
              facet-name="categories:viera"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <h3>Character Genders</h3>
            <SearchFilter
              :active-filters="facets"
              display-name="Male"
              facet-name="categories:male"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Female"
              facet-name="categories:female"
              @toggle="toggleFacet"
            >
            </SearchFilter>
            <SearchFilter
              :active-filters="facets"
              display-name="Unisex"
              facet-name="categories:unisex"
              @toggle="toggleFacet"
            >
            </SearchFilter>
          </section>
          <!-- <section v-if="!$auth.user.show_nsfw"> -->
          <section v-if="true">
            <h3>Adult Content</h3>
            <VueToggles
              checked-text="Shown"
              unchecked-text="Hidden"
              :value="show_nsfw"
              @click="show_nsfw = !show_nsfw"
            />
          </section>
        </div>
        <m-footer class="footer" hide-small />
      </section>
    </div>
  </div>
</template>

<script>
import axios from 'axios'
import Multiselect from 'vue-multiselect'
import VueToggles from 'vue-toggles'

import SearchResult from '~/components/ui/ProjectCard'
import Pagination from '~/components/ui/Pagination'
import SearchFilter from '~/components/ui/search/SearchFilter'

import MFooter from '~/components/layout/MFooter'

import SearchIcon from '~/assets/images/utils/search.svg?inline'
import ExitIcon from '~/assets/images/utils/exit.svg?inline'

export default {
  auth: false,
  components: {
    MFooter,
    SearchResult,
    Pagination,
    Multiselect,
    SearchFilter,
    SearchIcon,
    ExitIcon,
    VueToggles,
  },
  async fetch() {
    if (this.$route.query.q) this.query = this.$route.query.q
    if (this.$route.query.f) {
      const facets = this.$route.query.f.split(',')

      for (const facet of facets) await this.toggleFacet(facet, false)
    }
    if (this.$route.query.v)
      this.selectedGenders = this.$route.query.v.split(',')
    if (this.$route.query.e) this.selectedRaces = this.$route.query.e.split(',')
    if (this.$route.query.s) {
      this.sortType.name = this.$route.query.s

      switch (this.sortType.name) {
        case 'relevance':
          this.sortType.display = 'Relevance'
          break
        case 'downloads':
          this.sortType.display = 'Downloads'
          break
        case 'newest':
          this.sortType.display = 'Recently created'
          break
        case 'updated':
          this.sortType.display = 'Recently updated'
          break
        case 'follows':
          this.sortType.display = 'Follow count'
          break
      }
    }
    if (this.$route.query.m) {
      this.maxResults = this.$route.query.m
    }
    if (this.$route.query.o)
      this.currentPage = Math.ceil(this.$route.query.o / this.maxResults) + 1

    await Promise.all([
      this.fillInitialVersions(),
      this.fillInitialLicenses(),
      this.onSearchChange(this.currentPage),
    ])
  },
  data() {
    return {
      query: '',

      displayLicense: '',
      selectedLicense: '',
      licenses: [],

      showVersions: [],
      selectedGenders: [],
      versions: [],

      selectedRaces: [],

      facets: [],
      results: null,
      pages: [],
      currentPage: 1,
      show_nsfw: false,

      sortTypes: [
        { display: 'Relevance', name: 'relevance' },
        { display: 'Download count', name: 'downloads' },
        { display: 'Follow count', name: 'follows' },
        { display: 'Recently created', name: 'newest' },
        { display: 'Recently updated', name: 'updated' },
      ],
      sortType: { display: 'Relevance', name: 'relevance' },

      maxResults: 20,
      firstRun: true,
    }
  },
  methods: {
    async fillInitialVersions(x) {
      try {
        let url = `${process.env.apiUrl}/api/v1/tag/game_version?type=release`

        if (x !== null) {
          if (!this.showVersions.length > 0 && !this.firstRun) {
            this.showVersions.push('snapshots')

            url = `${process.env.apiUrl}/api/v1/tag/game_version`
          } else {
            this.showVersions = []
          }
        }

        const res = await axios.get(url)

        this.versions = res.data
        this.firstRun = false
      } catch (err) {
        // eslint-disable-next-line no-console
        console.error(err)
      }
    },
    async fillInitialLicenses() {
      const licences = (
        await axios.get(`${process.env.apiUrl}/api/v1/tag/license`)
      ).data
      licences.sort((x, y) => {
        // Custom case for custom, so it goes to the bottom of the list.
        if (x.short === 'custom') return 1
        if (y.short === 'custom') return -1
        if (x.name < y.name) return -1
        if (x.name > y.name) return 1
        return 0
      })
      this.licenses = licences
    },
    async toggleLicense(license) {
      if (this.selectedLicense) {
        const index = this.facets.indexOf(this.selectedLicense)

        this.facets.splice(index, 1)
      }

      if (license) {
        this.selectedLicense = `license:${license.short}`
        this.facets.push(this.selectedLicense)
      }

      await this.onSearchChange(1)
    },
    async clearFilters() {
      for (const facet of [...this.facets]) await this.toggleFacet(facet, true)

      this.displayLicense = null
      this.selectedLicense = null
      this.selectedGenders = []
      this.selectedRaces = []
      await this.onSearchChange(1)
    },
    async toggleFacet(elementName, sendRequest) {
      const index = this.facets.indexOf(elementName)
      if (index !== -1) {
        this.facets.splice(index, 1)
      } else {
        this.facets.push(elementName)
      }

      if (!sendRequest) await this.onSearchChange(1)
    },
    async toggleEnv(environment, sendRequest) {
      const index = this.selectedRaces.indexOf(environment)
      if (index !== -1) {
        this.selectedRaces.splice(index, 1)
      } else {
        this.selectedRaces.push(environment)
      }

      if (!sendRequest) await this.onSearchChange(1)
    },
    async onSearchChangeToTop(newPageNumber) {
      if (process.client) window.scrollTo({ top: 0, behavior: 'smooth' })

      await this.onSearchChange(newPageNumber)
    },
    async onSearchChange(newPageNumber) {
      if (this.query === null) return

      try {
        const params = [
          `limit=${this.maxResults}`,
          `index=${this.sortType.name}`,
        ]

        if (this.query.length > 0) {
          params.push(`query=${this.query.replace(/ /g, '+')}`)
        }

        if (
          this.facets.length > 0 ||
          this.selectedGenders.length > 0 ||
          this.selectedRaces.length > 0
        ) {
          let formattedFacets = []
          for (const facet of this.facets) {
            formattedFacets.push([facet])
          }

          if (this.selectedGenders.length > 0) {
            const versionFacets = []
            for (const facet of this.selectedGenders) {
              versionFacets.push('versions:' + facet)
            }
            formattedFacets.push(versionFacets)
          }

          if (this.selectedRaces.length > 0) {
            let environmentFacets = []

            const includesClient = this.selectedRaces.includes('client')
            const includesServer = this.selectedRaces.includes('server')
            if (includesClient && includesServer) {
              environmentFacets = [
                ['client_side:required'],
                ['server_side:required'],
              ]
            } else {
              if (includesClient) {
                environmentFacets = [
                  ['client_side:optional', 'client_side:required'],
                  ['server_side:optional', 'server_side:unsupported'],
                ]
              }
              if (includesServer) {
                environmentFacets = [
                  ['client_side:optional', 'client_side:unsupported'],
                  ['server_side:optional', 'server_side:required'],
                ]
              }
            }

            formattedFacets = [...formattedFacets, ...environmentFacets]
          }

          params.push(`facets=${JSON.stringify(formattedFacets)}`)
        }

        const offset = (newPageNumber - 1) * this.maxResults
        if (newPageNumber !== 1) {
          params.push(`offset=${offset}`)
        }

        let url = `${process.env.apiUrl}/api/v1/mod`

        if (params.length > 0) {
          for (let i = 0; i < params.length; i++) {
            url += i === 0 ? `?${params[i]}` : `&${params[i]}`
          }
        }

        const res = await axios.get(url)
        this.results = res.data.hits

        const pageAmount = Math.ceil(res.data.total_hits / res.data.limit)

        this.currentPage = newPageNumber
        if (pageAmount > 4) {
          if (this.currentPage + 1 >= pageAmount) {
            this.pages = [
              1,
              pageAmount - 3,
              pageAmount - 2,
              pageAmount - 1,
              pageAmount,
            ]
          } else if (this.currentPage > 4) {
            this.pages = [
              1,
              this.currentPage - 1,
              this.currentPage,
              this.currentPage + 1,
              pageAmount,
            ]
          } else {
            this.pages = [1, 2, 3, 4, pageAmount]
          }
        } else {
          this.pages = Array.from({ length: pageAmount }, (_, i) => i + 1)
        }

        if (process.client) {
          url = `mods?q=${encodeURIComponent(this.query)}`

          if (offset > 0) url += `&o=${offset}`
          if (this.facets.length > 0)
            url += `&f=${encodeURIComponent(this.facets)}`
          if (this.selectedGenders.length > 0)
            url += `&v=${encodeURIComponent(this.selectedGenders)}`
          if (this.selectedRaces.length > 0)
            url += `&e=${encodeURIComponent(this.selectedRaces)}`
          if (this.sortType.name !== 'relevance')
            url += `&s=${encodeURIComponent(this.sortType.name)}`
          if (this.maxResults > 20)
            url += `&m=${encodeURIComponent(this.maxResults)}`

          window.history.replaceState(new Date(), 'Mods', url)
        }
      } catch (err) {
        // eslint-disable-next-line no-console
        console.error(err)
      }
    },
    toggleFiltersMenu() {
      const currentlyActive = this.$refs.filters.className === 'filters active'
      this.$refs.filters.className = `filters${
        currentlyActive ? '' : ' active'
      }`
      document.body.style.overflow =
        document.body.style.overflow !== 'hidden' ? 'hidden' : 'auto'
    },
  },
  head: {
    title: 'Mods - XIVMods',
    meta: [
      {
        hid: 'apple-mobile-web-app-title',
        name: 'apple-mobile-web-app-title',
        content: 'Mods',
      },
      {
        hid: 'og:title',
        name: 'og:title',
        content: 'Mods',
      },
      {
        hid: 'og:url',
        name: 'og:url',
        content: `this.$siteUrl/mods`,
      },
    ],
  },
}
</script>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
<style lang="scss">
.search-nav {
  align-items: center;
  display: flex;
  justify-content: space-between;
  flex-flow: column;
  background: var(--color-raised-bg);
  border-radius: var(--size-rounded-card);
  padding: 0.25rem 1rem 0.25rem 1rem;
  margin-bottom: var(--spacing-card-md);
  input {
    border: none;
    background: transparent;
    min-width: 200px;
  }
  .iconified-input {
    width: auto;
    margin-right: auto;
  }
  .sort-paginate {
    margin-left: 0.5rem;
    margin-right: 0.5rem;
    display: flex;
    width: auto;
    .per-page {
      margin-left: 0.5rem;
      display: none;
    }
  }
  @media screen and (min-width: 1050px) {
    flex-flow: row;
    .sort-paginate {
      width: auto;
    }
  }
  @media screen and (min-width: 450px) {
    .sort-paginate {
      .per-page {
        display: unset;
      }
    }
  }
}

.search-bottom {
  align-items: center;
  display: flex;
  justify-content: flex-end;
  background: var(--color-raised-bg);
  border-radius: var(--size-rounded-card);
  padding: 0 1rem;
  select {
    width: 100px;
    margin-right: 20px;
  }
  .per-page {
    display: none;
  }
  @media screen and (min-width: 550px) {
    padding: 0.25rem 1rem 0.25rem 1rem;
    .per-page {
      display: unset;
    }
  }
}

.labeled-control {
  h3 {
    @extend %small-label;
    margin-left: 0.25rem;
  }
}

.mobile-filters-button {
  display: inline-block;
  margin-left: 0.5rem;
  button {
    margin-top: 0;
    height: 2.5rem;
    padding-left: 1rem;
    padding-right: 1rem;
  }

  // Hide button on larger screens where it's not needed
  @media screen and (min-width: 1250px) {
    display: none;
  }
}

.filters {
  overflow-y: auto;
  position: fixed;
  width: 100vw;
  right: -100vw;
  max-height: 100vh;
  min-width: 15%;
  top: var(--size-navbar-height);
  height: calc(100vh - var(--size-navbar-height));
  transition: right 150ms;
  background-color: var(--color-raised-bg);
  flex-shrink: 0; // Stop shrinking when page contents change
  .filters-wrapper {
    padding: 0.25rem 0.75rem 0.75rem 0.75rem;
    margin-bottom: var(--spacing-card-md);
  }
  h3 {
    @extend %small-label;
    margin-top: 1.25em;
  }
  &.active {
    right: 0;
  }
  // Larger screens that don't need to collapse
  @media screen and (min-width: 1250px) {
    top: 0;
    right: auto;
    position: unset;
    height: unset;
    max-height: unset;
    transition: none;
    margin-left: var(--spacing-card-lg);
    overflow-y: unset;
    padding-right: 1rem;
    width: 18vw;
    background-color: transparent;
    .filters-wrapper {
      background-color: var(--color-raised-bg);
      border-radius: var(--size-rounded-card);
    }
  }
  @media screen and (min-width: 1250px) {
    width: 300px;
  }
}

.filter-group {
  button {
    cursor: pointer;
  }

  .filter-clear-button {
    display: flex;
    justify-content: space-between;
  }

  // Large screens that don't collapse
  @media screen and (min-width: 1250px) {
    .filter-button-done {
      display: none;
    }
  }
}

.sort-types {
  min-width: 200px;
  border: none;
  border-radius: var(--size-rounded-control);

  .multiselect__tags {
    padding: 10px 50px 0 8px;
    border: none;
  }
}

.no-results {
  text-align: center;
  padding: 20px 0;
  font-size: 1.25rem;
  color: var(--color-text);
  margin-bottom: var(--spacing-card-md);
  background: var(--color-raised-bg);
  border-radius: var(--size-rounded-card);
}

.max-results {
  max-width: 80px;
}
</style>
