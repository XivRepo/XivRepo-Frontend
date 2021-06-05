import Vue from 'vue'
import FileUpload from 'vue-upload-component/dist/vue-upload-component.part.js'

if (process.BROWSER_BUILD) {
  Vue.use(FileUpload)
}
