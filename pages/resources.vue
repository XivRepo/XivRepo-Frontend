<template>
  <div class="page-container">
    <div class="page-contents">
      <header>
        <h1>Tools and Resources</h1>
        <p>
          Whether you are new to modding or a seasoned expert, it can't ever
          hurt to have a nice place you can go to for help. Here we've listed
          some of our favorite tools as well as helpful resources for modding.
          If you would like to see more tools or resources add, feel free to
          reach out to our moderation team over on discord.
        </p>
      </header>
      <div class="cards">
        <div v-for="item in tools" :key="item.link" class="card">
          <div class="content">
            <a :href="item.link" target="_blank">
              <img
                :src="require(`assets/images/resources/${item.icon}`)"
                alt=""
              />
              <h3>{{ item.title }}</h3>
            </a>
            <p v-html="item.description" />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Resources',
  components: {},
  data() {
    return {
      tools: [
        {
          title: 'GShade by GPOSERS',
          description:
            'GShade runs on a custom in-house ReShade build which features a network-unlocked Z-Depth Buffer in Final Fantasy XIV, Second Life, Phantasy Star Online 2, Warframe, and a number of other whitelisted games. Further, GShade is the only ReShade build capable of completely ignoring the Final Fantasy XIV UI, including job bars and nameplates, meaning gameplay presets look better on GShade than on anything else. For more information feel free to join their <a style="text-decoration: underline" href="https://discord.gg/gposers" target="_blank">discord</a>.',
          icon: 'gposers.png',
          link: 'https://gposers.com/gshade/',
        },
        {
          title: 'CMTools',
          description:
            'Concept Matrix is a standalone tool that is used to modify certain client side only values and allow them a greater degree of flexibility for making creative and interesting screenshots. In short, this tool allows its users to temporarily change their race, gender, looks, equipment, etc in game without actually making any changes visible to other players. It also allows to use all of the emotes in game, and you can even pose as monsters, other NPCs, etc. With the latest addition, Posing Matrix, you can even tweak existing emotes or create your own poses. As such this tool can be looked at as a valuable resource for both the beginner and advanced screenshot lovers.',
          icon: 'cmtools.png',
          link: 'https://github.com/imchillin/CMTool',
        },
        {
          title: 'Anamnesis',
          description:
            'Anamnesis is a standalone tool that is used to modify certain clientside-only values and allow the user a greater degree of flexibility for making creative and interesting screenshots. In short, this tool allows its users to temporarily change their race, gender, looks, equipment, etc. in game without actually making any changes visible to other players. This tool also allows users to create their own poses.',
          icon: 'anamnesis.png',
          link: 'https://github.com/imchillin/Anamnesis',
        },
        {
          title: 'TexTools',
          description:
            'TexTools is your go to solution for modding your installation of FFXIV. With this tool and our repository of mods, the possibilities are endless! For more information, feel free to join their <a style="text-decoration: underline" href="https://discord.com/invite/ffxivtextools" target="_blank">discord</a>.',
          icon: 'textools.png',
          link: 'https://www.ffxiv-textools.net/',
        },
        {
          title: 'FFXIV Quick Launcher',
          description:
            'XIVLauncher (abbreviated as XL) is a faster launcher for Final Fantasy XIV, with various available addons and enhancements to the game! With tons of community made plugins such as discord rich presense and NoSoliciting for RMT message filtering, this tool is sure to enhance your FFXIV experience. ',
          icon: 'launcher.png',
          link: 'https://github.com/goatcorp/FFXIVQuickLauncher',
        },
      ],
    }
  },
}
</script>

<style lang="scss" scoped>
.page-contents {
  flex-direction: column;
}

.cards {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: space-between;

  .card {
    @extend %card;
    margin-bottom: var(--spacing-card-lg);
    flex-basis: 31%;
    min-width: 31%;

    .content {
      display: flex;
      flex-direction: column;
      box-sizing: border-box;
      padding: var(--spacing-card-md);

      img {
        max-width: 100%;
        max-height: 200px;
      }
    }
  }

  &::after {
    content: '';
    flex-basis: 31%;
    min-width: 31%;
  }
}
</style>
