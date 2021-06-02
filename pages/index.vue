<template>
  <div>
    <div class="main-hero columns">
      <div class="left">
        <div class="logo">
          <img
            class="char"
            src="~/assets/images/logo_small.png"
            style="max-height: 20vh; width: 100%; display: inline"
            alt="logo"
          />
        </div>
        <h1>Welcome to XIVMods</h1>
        <h2 class="typewriter">
          {{ currentText }}<span aria-hidden="true"></span> Mods
        </h2>
      </div>
    </div>
    <div class="default-hero">
      <div class="left mod-grid">
        <h2 class="centered">New Mods</h2>
        <div v-if="newest_mods.hits !== null">
          <ModCardGrid
            v-for="(result, index) in newest_mods.hits"
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
        </div>
        <a
          class="button brand-button button-big margin-center"
          href="/mods?s=newest"
          >View More New Mods</a
        >
      </div>
      <div class="right mod-grid">
        <h2 class="centered">Popular Mods</h2>
        <div v-if="popular_mods.hits !== null">
          <ModCardGrid
            v-for="(result, index) in popular_mods.hits"
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
        </div>
        <a
          class="button brand-button button-big margin-center"
          href="/mods?s=follows"
          >View More Popular Mods</a
        >
      </div>
    </div>
    <m-footer class="footer" centered />
  </div>
</template>

<script>
import axios from 'axios'
import MFooter from '~/components/layout/MFooter'
import ModCardGrid from '~/components/ui/ModCardGrid'

export default {
  components: {
    MFooter,
    ModCardGrid,
  },
  auth: false,
  async asyncData(data) {
    const newest = await axios.get(
      `${data.env.apiUrl}/api/v1/mod?limit=6&index=newest`,
      data.$auth.headers
    )

    const popular = await axios.get(
      `${data.env.apiUrl}/api/v1/mod?limit=6&index=follows`,
      data.$auth.headers
    )

    return {
      newest_mods: newest.data,
      popular_mods: popular.data,
    }
  },
  data() {
    return {
      currentText: 'Face',
      texts: [
        'Face',
        'Body',
        'Hair',
        'Skin',
        'Gear',
        'Mount',
        'Minion',
        'Furniture',
        'More',
      ],
      newest_mods: [],
      popular_mods: [],
    }
  },
  beforeMount() {
    document.documentElement.setAttribute('data-theme', 'light')

    this.startNext(0)
  },
  methods: {
    startNext(i) {
      const startIndex = i % this.texts.length

      this.typeWriter(this.texts[startIndex], 0, () => {
        this.startNext(startIndex + 1)
      })
    },
    typeWriter(text, i, callback) {
      if (!text || i >= text.length) {
        setTimeout(callback, 1000 + Math.random() * 500)
        return
      }

      this.currentText = text.substring(0, i + 1)
      setTimeout(
        () => this.typeWriter(text, i + 1, callback),
        150 + Math.random() * 50
      )
    },
  },
}
</script>

<style lang="scss" scoped>
.left,
.right {
  width: 50%;
  min-width: 920px;
}

.main-hero {
  height: 80vh;
  min-height: 400px;
  background-image: url(~/assets/images/banner-sample.png);
  background-position: center;
  background-size: cover;
  display: flex;
  align-items: flex-end;

  .left {
    padding: 10px 40px;
    width: 100%;
    height: 40%;
    min-height: 400px;
    background: rgba(var(--color-bg-decimal), 0.7);
    backdrop-filter: blur(8px);
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;

    .logo {
      display: inline-block;
      max-width: 25vh;
      width: 100%;
    }

    .typewriter {
      display: inline-block;
      color: var(--color-brand);
      font-size: 2.5rem;

      span {
        border-right: 0.15em solid var(--color-brand);
        animation: caret 1s steps(1) infinite;

        @keyframes caret {
          50% {
            border-color: transparent;
          }
        }
      }
    }

    h1 {
      margin: 0;
      font-size: 4em;
    }
  }
  .right {
    padding-left: 20%;

    .char {
      height: 400px;
    }
  }
}

.hero {
  margin-left: 15%;
  width: 30%;
  z-index: 1;
  h3 {
    font-size: 18px;
    font-weight: bolder;
    color: var(--color-brand);
  }
  h1 {
    font-size: 46px;
    font-weight: 520;
  }
  p {
    line-height: 25px;
    letter-spacing: 0.2px;
    color: var(--color-text);

    span {
      color: var(--color-brand);
      font-weight: bold;
    }
  }
}

.hero-image {
  padding-left: 10%;
  padding-top: 75px;
  padding-right: 10%;

  img,
  video {
    height: 300px;
  }
}

.slanted-hero {
  background: var(--color-raised-bg);
  height: 500px;
  position: relative;
  z-index: 1;

  &:before,
  &:after {
    background: inherit;
    content: '';
    display: block;
    height: 50%;
    left: 0;
    position: absolute;
    right: 0;
    z-index: -1;
    -webkit-backface-visibility: hidden;
    backface-visibility: hidden;
  }

  &:before {
    top: 0;
    transform: skewY(5deg);
    transform-origin: 100% 0;
  }

  &:after {
    bottom: 0;
    transform: skewY(-5deg);
    transform-origin: 100%;
  }
}

.default-hero {
  padding: 2em;
  margin-top: 0;
  display: flex;
  flex-wrap: wrap;
  justify-content: center;

  h2 {
    text-align: center;
  }
}

.mod-grid {
  margin: var(--spacing-card-lg) 0;
  > div {
    display: flex;
    margin: 0 auto;
    flex-wrap: wrap;
    justify-content: center;
  }
}

.workflow {
  padding-top: 75px;
  padding-left: 10%;
  div {
    margin: 0 20px;
    text-align: center;
    width: 100px;
    h3 {
      margin: 0;
    }
    svg {
      color: #fff;
      border-radius: 50%;
      margin-top: 10px;
      padding: 25px;
    }
  }
  img {
    color: var(--color-text);
    align-self: flex-start;
  }
}

.footer {
  margin-top: 150px;
}

@media screen and (max-width: 980px) {
  .default-hero.mod-grid {
    > div {
      flex-direction: column;
    }
  }

  .left,
  .right {
    min-width: unset;
  }

  .main-hero {
    .left {
      padding: 0;
    }
  }
}

@media screen and (max-width: 500px) {
  .hero {
    margin-top: 0 !important;
  }

  .default-hero {
    padding: 0.25rem;
  }
}

@media screen and (max-width: 1300px) {
  .workflow {
    display: none;
  }

  .left,
  .right {
    padding-left: 0 !important;
    text-align: center;
    width: 100%;
  }

  .hero {
    margin-top: 100px;
    text-align: center;
    margin-left: 0;
    width: 100%;
  }
}

@media screen and (min-width: 1300px) and (max-width: 1500px) {
  .hero {
    margin-left: 10%;
  }
}
</style>
