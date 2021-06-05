/* eslint-disable vue/attribute-hyphenation */
<template>
  <div>
    <ConfirmPopup
      ref="delete_popup"
      title="Are you sure you want to delete your account?"
      description="If you proceed, your user and all attached data will be removed from our
        servers. This cannot be reversed, so be careful!"
      proceed-label="Delete Account"
      :confirmation-text="username"
      :has-to-type="true"
      @proceed="deleteAccount"
    />
    <div class="section-header columns">
      <h3 class="column-grow-1">Settings</h3>
      <button class="brand-button column" @click="editProfile">Save</button>
    </div>
    <section>
      <h3>Username</h3>
      <label class="form-label">
        <span>
          The username used on the XIVMods site to identify yourself. This must
          be unique.
        </span>
        <input
          v-model="username"
          type="text"
          placeholder="Enter your username"
        />
      </label>
      <h3>Name</h3>
      <label class="form-label">
        <span>
          Your display name on your XIVMods profile. This does not have to be
          unique, can be set to anything, and is optional.
        </span>
        <input v-model="name" type="text" placeholder="Enter your name" />
      </label>
      <h3>Email</h3>
      <label class="form-label">
        <span>
          The email for your account. This is private information which is not
          displayed in any API routes or your profile. It is also optional.
        </span>
        <input v-model="email" type="email" placeholder="Enter your email" />
      </label>
      <h3>Bio</h3>
      <label class="form-label">
        <span>
          A description of yourself which other users can see on your profile.
        </span>
        <input v-model="bio" type="text" placeholder="Enter your bio" />
      </label>
      <h3>Adult Content</h3>
      <label>
        <span>
          This setting will allow you to view 18+ mods that have been submitted
          to the site. By enabling this option, you agree that you are of legal
          age to view pornographic content in your region.
        </span>
        <div style="margin-left: 1em">
          <client-only>
            <VueToggles
              checked-text="Shown"
              unchecked-text="Hidden"
              :value="show_nsfw"
              @click="show_nsfw = !show_nsfw"
            />
          </client-only>
        </div>
      </label>
    </section>
    <section class="pad-maker">
      <h3>Theme</h3>
      <label class="form-label">
        <span
          >Change the global site theme of XIVMods. You can choose from light
          mode and dark mode. You can switch it using this button or anywhere by
          accessing the theme switcher in the navigation bar dropdown.</span
        >
        <input
          type="button"
          class="button pad-rem"
          value="Change Theme"
          @click="changeTheme"
        />
      </label>
    </section>
    <section class="pad-maker">
      <h3>Delete your account</h3>
      <label>
        <span
          >Clicking on this WILL delete your user. Do not click on this unless
          you want your user deleted. If you delete your user, all attached data
          will be removed from our servers. This cannot be reversed, so be
          careful!</span
        >
        <input
          value="Delete Account"
          type="button"
          class="button"
          @click="showPopup"
        />
      </label>
    </section>
  </div>
</template>

<script>
import axios from 'axios'
import VueToggles from 'vue-toggles'

import ConfirmPopup from '~/components/ui/ConfirmPopup'

export default {
  components: {
    ConfirmPopup,
    VueToggles,
  },
  fetch() {
    this.username = this.$auth.user.username
    this.name = this.$auth.user.name
    this.email = this.$auth.user.email
    this.bio = this.$auth.user.bio
    this.show_nsfw = this.$auth.user.show_nsfw
    this.token = this.$auth.token
  },
  data() {
    return {
      username: '',
      name: '',
      email: '',
      bio: '',
      token: '',
      confirm_delete: false,
      show_nsfw: false,
    }
  },
  methods: {
    changeTheme() {
      this.$colorMode.preference =
        this.$colorMode.value === 'dark' ? 'light' : 'dark'
    },
    gotoRevoke() {
      this.$router.replace('/dashboard/misc/revoke-token')
    },
    async copyToken() {
      await navigator.clipboard.writeText(this.token)
      this.$notify({
        group: 'main',
        title: 'Copied to clipboard.',
        text: 'Copied your XIVMods token to the clipboard.',
        type: 'success',
      })
    },
    async editProfile() {
      this.$nuxt.$loading.start()

      try {
        const data = {
          username: this.username,
          name: this.name,
          email: this.email,
          bio: this.bio,
          show_nsfw: this.show_nsfw,
        }

        await axios.patch(
          `${process.env.apiUrl}/api/v1/user/${this.$auth.user.id}`,
          data,
          this.$auth.headers
        )

        await this.$store.dispatch('auth/fetchUser', {
          token: this.$auth.token,
        })
      } catch (err) {
        this.$notify({
          group: 'main',
          title: 'An Error Occurred',
          text: err.response.data.description,
          type: 'error',
        })
      }

      this.$nuxt.$loading.finish()
    },
    async deleteAccount() {
      this.$nuxt.$loading.start()

      try {
        await axios.delete(
          `${process.env.apiUrl}/api/v1/user/${this.$auth.user.id}`,
          this.$auth.headers
        )
      } catch (err) {
        this.$notify({
          group: 'main',
          title: 'An Error Occurred',
          text: err.response.data.description,
          type: 'error',
        })
      }

      this.$nuxt.$loading.finish()
    },
    showPopup() {
      this.$refs.delete_popup.show()
    },
  },
  head: {
    title: 'Settings - XIVMods',
  },
}
</script>

<style lang="scss" scoped>
.pad-rem {
  margin-top: 0;
}

.pad-maker {
  margin-top: var(--spacing-card-md);
}

.save-btn-div {
  overflow: hidden;
  clear: both;
}

.save-btn {
  float: right;
}

section {
  @extend %card;
  padding: var(--spacing-card-md) var(--spacing-card-lg);
}
</style>
