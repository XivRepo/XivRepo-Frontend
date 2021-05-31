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
    <div class="default-hero"></div>
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
  data() {
    return {
      currentText: 'Body',
      texts: ['Body', 'Hair', 'Mount', 'Minion'],
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
  margin-top: 200px;
  height: 700px;
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

@media screen and (max-width: 500px) {
  .hero {
    margin-top: 0 !important;
  }
}

@media screen and (max-width: 1300px) {
  .workflow {
    display: none;
  }

  .right {
    display: none;
  }

  .left {
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
