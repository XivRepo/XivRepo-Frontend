<template>
  <div class="layout">
    <header class="site-header">
      <section class="navbar columns">
        <section class="logo column">
          <NuxtLink to="/">
            <XivRepoLogo
              v-if="$colorMode.value === 'light'"
              aria-label="xivrepo"
            />
            <XivRepoLogoWhite v-else aria-label="xivrepo" />
          </NuxtLink>
          <span class="badge yellow">Beta</span>
        </section>
        <section class="menu-icon">
          <button @click="changeTheme">
            <MoonIcon v-if="$colorMode.value === 'light'" />
            <SunIcon v-else />
          </button>
          <button @click="toggleNavBar">
            <HamburgerIcon />
          </button>
        </section>
        <section ref="nav" class="right-group columns">
          <section class="column-grow-5 nav">
            <div class="tabs">
              <NuxtLink to="/resources" class="tab">
                <span>Resources</span>
              </NuxtLink>
              <NuxtLink to="/mods" class="tab">
                <span>Mods</span>
              </NuxtLink>
              <NuxtLink to="/mod/random" class="tab">
                <span>Random</span>
              </NuxtLink>
              <div v-if="this.$auth.user" class="section">
                <NuxtLink to="/dashboard/projects" class="tab">
                  <span>Dashboard</span>
                </NuxtLink>
              </div>
              <div v-if="this.$auth.user" class="section section-end">
                <NuxtLink to="/mod/create" class="tab button">
                  <span>New Mod</span>
                </NuxtLink>
              </div>
            </div>
          </section>
          <section class="column-grow">
            <template v-if="this.$auth.user">
              <section class="user-controls">
                <div
                  v-click-outside="hideDropdown"
                  class="dropdown"
                  :class="{ open: isDropdownOpen }"
                >
                  <button class="control" @click="toggleDropdown">
                    <div class="avatar">
                      <span>{{ this.$auth.user.name }}</span>
                      <img :src="this.$auth.user.avatar_url" class="icon" />
                    </div>
                    <div class="notifications">
                      <NotificationIcon />
                      <span v-if="notificationCount > 0" class="counter">{{
                        notificationCount
                      }}</span>
                    </div>
                    <DropdownIcon class="dropdown-icon" />
                  </button>
                  <div class="content">
                    <ul v-if="isDropdownOpen" @click="hideDropdown">
                      <li>
                        <NuxtLink :to="userUrl">
                          <UserIcon />
                          <span>Profile</span>
                        </NuxtLink>
                      </li>
                      <li>
                        <NuxtLink to="/dashboard/notifications">
                          <NotificationIcon />
                          <span>Notifications</span>
                        </NuxtLink>
                      </li>
                      <li>
                        <NuxtLink to="/dashboard/settings">
                          <SettingIcon />
                          <span>Settings</span>
                        </NuxtLink>
                      </li>
                      <li>
                        <button @click="changeTheme">
                          <MoonIcon v-if="$colorMode.value === 'light'" />
                          <SunIcon v-else />
                          <span v-if="$colorMode.value === 'light'">
                            Dark Mode</span
                          >
                          <span v-else>Light Mode</span>
                        </button>
                      </li>
                      <hr />
                      <li>
                        <button @click="logout">
                          <LogOutIcon />
                          <span>Log Out</span>
                        </button>
                      </li>
                    </ul>
                  </div>
                </div>
              </section>
            </template>
            <template v-else>
              <section class="auth-prompt">
                <a class="desktop-header-mode-switch" @click="changeTheme">
                  <MoonIcon v-if="$colorMode.value === 'light'" />
                  <SunIcon v-else />
                </a>
                <a :href="authUrl" class="log-in-button"
                  ><DiscordIcon aria-hidden="true" />Sign In with Discord</a
                >
              </section>
            </template>
          </section>
        </section>
      </section>
    </header>
    <main>
      <CookieConsent />
      <notifications group="main" position="bottom right" />
      <!--<notifications
        group="ads"
        position="bottom right"
        :duration="-1"
        :ignore-duplicates="true"
      />-->
      <Nuxt />
    </main>
  </div>
</template>

<script>
import axios from 'axios'

import ClickOutside from 'vue-click-outside'

import XivRepoLogo from '~/assets/images/long_logo_light.svg?inline'
import XivRepoLogoWhite from '~/assets/images/long_logo_light.svg?inline'

import HamburgerIcon from '~/assets/images/utils/hamburger.svg?inline'

import NotificationIcon from '~/assets/images/sidebar/notifications.svg?inline'
import SettingIcon from '~/assets/images/sidebar/settings.svg?inline'

import DropdownIcon from '~/assets/images/utils/dropdown.svg?inline'
import MoonIcon from '~/assets/images/utils/moon.svg?inline'
import SunIcon from '~/assets/images/utils/sun.svg?inline'

import UserIcon from '~/assets/images/utils/user.svg?inline'
import LogOutIcon from '~/assets/images/utils/log-out.svg?inline'
import DiscordIcon from '~/assets/images/utils/discord.svg?inline'

import CookieConsent from '~/components/ads/CookieConsent'

export default {
  components: {
    XivRepoLogo,
    XivRepoLogoWhite,
    DropdownIcon,
    MoonIcon,
    SunIcon,
    UserIcon,
    LogOutIcon,
    DiscordIcon,
    NotificationIcon,
    SettingIcon,
    HamburgerIcon,
    CookieConsent,
  },
  directives: {
    ClickOutside,
  },
  data() {
    return {
      isDropdownOpen: false,
      notificationCount: 0,
      notificationTimer: '',
    }
  },
  computed: {
    authUrl() {
      return `${process.env.apiUrl}/api/v1/auth/init?url=${process.env.baseUrl}${this.$route.fullPath}`
    },
    userUrl() {
      return `/user/${this.$auth.user.id}`
    },
    userTeamsUrl() {
      return `${this.userUrl}/teams`
    },
  },
  watch: {
    $route() {
      this.$refs.nav.className = 'right-group'
      document.body.style.overflow = 'auto'
    },
  },
  created() {
    this.checkNotifications()
    this.notificationTimer = setInterval(this.checkNotifications, 300000)
  },
  methods: {
    async checkNotifications() {
      if (this.$auth && this.$auth.user && this.$auth.user.id) {
        const notifications = (
          await axios.get(
            `${process.env.apiUrl}/api/v1/user/${this.$auth.user.id}/notifications`,
            this.$auth.headers
          )
        ).data

        this.notificationCount = notifications.length
      }
    },
    cancelNotificationCheck() {
      clearInterval(this.notificationTimer)
    },
    toggleNavBar() {
      window.scrollTo(0, 0)
      const currentlyActive = this.$refs.nav.className === 'right-group active'
      this.$refs.nav.className = `right-group${
        currentlyActive ? '' : ' active'
      }`
      document.body.scrollTop = 0
      document.body.style.overflow =
        document.body.style.overflow !== 'hidden' ? 'hidden' : 'auto'
    },
    toggleDropdown() {
      this.isDropdownOpen = !this.isDropdownOpen
    },
    hideDropdown() {
      this.isDropdownOpen = false
    },
    async logout() {
      this.$cookies.set('auth-token-reset', true)
      // If users logs out on dashboard, redirect on the home page
      if (this.$route.path.startsWith('/dashboard')) {
        await this.$router.push('/')
      } else {
        await this.$router.go(null)
      }
      this.$notify({
        group: 'main',
        title: 'Logged Out',
        text: 'You have logged out successfully!',
        type: 'success',
      })
    },
    changeTheme() {
      this.$colorMode.preference =
        this.$colorMode.value === 'dark' ? 'light' : 'dark'
    },
    destroyed() {
      this.cancelNotificationCheck()
    },
  },
}
</script>

<style lang="scss">
.layout {
  background-color: var(--color-bg);
  display: block;

  .site-header {
    height: var(--size-navbar-height);
    background-color: var(--color-raised-bg);
    max-width: 100vw;
    .navbar {
      margin: 0 var(--spacing-card-lg);
      align-items: center;
      height: 100%;
      section.logo {
        align-items: center;
        display: flex;
        justify-content: space-between;
        padding: 1rem 0;
        margin-left: 1rem;
        color: var(--color-text-dark);
        svg {
          height: 4rem;
          width: auto;
        }
        .badge {
          margin-left: 0.25rem;
        }
        button {
          background: none;
          border: none;
          margin: 0 0 0 0.5rem;
          padding: 0;
          svg {
            height: 1.5rem;
            width: 1.5rem;
          }
        }
      }

      section.menu-icon {
        display: flex;
        margin-left: auto;
        align-items: center;
        margin-right: 1rem;
      }

      .desktop-header-mode-switch {
        margin-right: 1rem;
        cursor: pointer;
      }

      section.right-group {
        display: flex;
        flex-grow: 5;

        flex-direction: column-reverse;

        overflow-y: auto;
        position: fixed;
        width: 100vw;
        top: var(--size-navbar-height);
        height: calc(100vh - var(--size-navbar-height));
        right: -100vw;
        background-color: var(--color-raised-bg);
        transition: right 150ms;
        z-index: 100;

        &.active {
          right: 0;
        }

        section.nav {
          .tabs {
            flex-direction: column;

            .section {
              border-top: 3px solid var(--color-brand-disabled);
              margin-top: 0.75rem;
              padding-top: 0.75rem;

              @media screen and (min-width: 1024px) {
                &.section-end {
                  justify-self: flex-end;
                  margin-left: auto;
                  border-left: none;

                  .tab.button {
                    padding: 6px 20px;
                    background-color: var(--color-brand);

                    span {
                      border-bottom: none;
                      color: var(--color-brand-inverted);
                    }

                    &:hover,
                    &.nuxt-link-exact-active {
                      background-color: var(--color-brand-active);

                      span {
                        border-bottom: none;
                      }
                    }
                  }
                }
              }
            }
            .tab {
              font-size: var(--font-size-md);

              span {
                margin: 0 auto;
              }
            }
          }
        }
        section.user-controls {
          align-items: center;
          display: flex;
          justify-content: space-between;
          position: relative;
          top: 50%;
          transform: translateY(-50%);
          min-width: 12rem;

          width: 13rem;
          margin: 0 auto;

          .dropdown {
            position: relative;
            display: inline-block;
            flex-grow: 1;
            &:hover .control {
              border-radius: var(--size-rounded-control);
              background: var(--color-button-bg);
            }
            &.open {
              .control {
                background: var(--color-button-bg);
                border-radius: var(--size-rounded-control)
                  var(--size-rounded-control) 0 0;
                .dropdown-icon {
                  transform: rotate(180deg);
                }

                .notifications {
                  padding: 1rem;
                  position: relative;
                  span.counter {
                    position: absolute;
                    bottom: 0.5rem;
                    right: 0.5rem;
                    background: var(--color-brand);
                    width: 1.3rem;
                    height: 1.3rem;
                    color: var(--color-brand-inverted);
                    border-radius: 50%;
                    font-size: 0.8rem;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                  }
                }
              }
              .content {
                display: unset;
              }
            }
            .control {
              border-radius: var(--size-rounded-control);
              align-items: center;
              display: flex;
              padding: 0.3rem 0.75rem;
              position: relative;
              z-index: 11;
              width: 100%;
              .avatar {
                align-items: center;
                display: flex;
                flex-grow: 1;
                .icon {
                  border-radius: 50%;
                  height: 3rem;
                  width: 3rem;
                  margin-left: 0.5rem;
                  margin-right: 0.25rem;
                }
                span {
                  display: block;
                  overflow: hidden;
                  text-overflow: ellipsis;
                  white-space: nowrap;
                  color: var(--color-text-dark);
                  font-weight: var(--font-weight-medium);
                }
              }
              .dropdown-icon {
                color: var(--color-text-dark);
                transition: 150ms ease transform;
              }

              .notifications {
                padding: 1rem;
                position: relative;
                span.counter {
                  position: absolute;
                  bottom: 0.5rem;
                  right: 0.5rem;
                  background: var(--color-brand);
                  width: 1.3rem;
                  height: 1.3rem;
                  color: var(--color-brand-inverted);
                  border-radius: 50%;
                  font-size: 0.8rem;
                  display: flex;
                  justify-content: center;
                  align-items: center;
                }
              }
            }
            .content {
              margin: 0 0 0 0;
              min-width: 10rem;
              width: 100%;
              position: fixed;
              display: none;
            }
            button {
              background-color: transparent;
              color: var(--color-text-dark);
              margin: 0;
              padding: 0;
              font-weight: var(--font-weight-medium);
            }
            ul {
              background-color: var(--color-button-bg);
              border-radius: 0 0 var(--size-rounded-control)
                var(--size-rounded-control);
              box-shadow: var(--shadow-dropdown);
              display: flex;
              flex-direction: column;
              margin: 0;
              list-style: none;
              padding: 0.5rem 0;
              z-index: 1;
              hr {
                background-color: var(--color-divider-dark);
                border: none;
                color: var(--color-divider-dark);
                height: 2px;
                margin: 0.5rem 0;
              }
              li {
                margin: 0;
                &:hover,
                &:focus,
                &:active {
                  background-color: var(--color-button-bg-active);
                  color: var(--color-text-dark);
                }
                a,
                button {
                  align-items: center;
                  display: flex;
                  padding: 0.75rem 1.5rem;
                  color: var(--color-text-dark);
                  svg {
                    color: inherit;
                    height: 1rem;
                    width: 1rem;
                  }
                  span {
                    margin-left: 0.5rem;
                  }
                }
              }
            }
          }
        }

        section.auth-prompt {
          display: flex;
          align-items: center;
          height: 100%;

          .log-in-button {
            margin: 0 auto;

            text-align: center;
            border-radius: var(--size-rounded-control);
            background-color: var(--color-brand);
            white-space: nowrap;
            outline: none;
            color: var(--color-brand-inverted);
            display: block;
            padding: 0.5rem 0.75rem;
            svg {
              vertical-align: middle;
              margin-right: 0.5rem;
            }
            &:hover,
            &:focus {
              background-color: var(--color-brand-2);
            }
          }
        }
      }
      @media screen and (min-width: 1024px) {
        max-width: 1280px;
        margin-left: auto;
        margin-right: auto;

        section.menu-icon {
          display: none;
        }

        section.mobile-header-mode-switch {
          display: none;
        }

        section.right-group {
          flex-direction: unset;
          overflow-y: unset;
          position: unset;
          width: unset;
          top: unset;
          height: unset;
          right: unset;
          background-color: unset;
          transition: unset;
          z-index: unset;

          section.nav {
            .tabs {
              flex-direction: unset;
              position: relative;
              top: 50%;
              transform: translateY(-50%);

              .section {
                margin-top: unset;
                padding-top: unset;
                border-top: unset;

                border-left: 3px solid var(--color-brand-disabled);
                margin-left: 0.75rem;
                padding-left: 0.75rem;
              }
            }
          }

          section.user-controls {
            width: unset;
            margin: unset;
          }

          section.auth-prompt {
            margin: 0;
          }
        }
      }
      @media only screen and (max-width: 1024px) {
        .desktop-header-mode-switch {
          display: none;
        }
      }
    }
  }

  main {
    grid-area: main;
  }
}

@media (min-width: 1024px) {
  .layout {
    main {
      .alpha-alert {
        margin: 1rem;

        .wrapper {
          padding: 1rem 2rem 1rem 1rem;
        }
      }
    }
  }
}

@media (max-width: 998px) {
  .layout .site-header .navbar section.logo svg {
    height: 10vw;
  }
}
</style>
