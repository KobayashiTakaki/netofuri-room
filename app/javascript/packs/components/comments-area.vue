<template>
  <div class="comment-area mt-3">
    <h4>コメント</h4>
    <form action="#" class="form-inline"
      @submit.prevent
    >
      <div class="form-group" v-if="loggedIn">
        <input type="text" class="form-control form-control-sm mr-1"
          v-model="inputContent"
          :readonly="formDisabled ? true : null"
        >
        <button class="btn btn-primary" type="submit"
          @click="submitComment"
          :disabled="formDisabled ? true : null"
        >送信</button>
        <span class="error-message" v-if="errorMessage.length !== 0">
          {{ errorMessage }}
        </span>
      </div>
      <small v-else>コメントするには<a href="../login">ログイン</a>してください。</small>
    </form>
    <div class="comments mt-2">
      <ul>
        <li class="comment py-1"
          v-for="comment in comments"
          :key="comment.id"
        >
          <span class="comment-at">{{ displayTime(comment) }}</span>
          <span class="comment-content pr-2">{{ comment.content }}</span>
          <span class="username">{{ comment.username }}</span>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
  import axios from 'axios'
  axios.defaults.headers.common = {
    Accept: 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  }
  export default {
    data() {
      return {
        loaded: false,
        comments: [],
        inputContent: '',
        errorMessage: '',
        formDisabled: false,
        intervalIds: []
      }
    },
    props: ['loggedIn', 'playTimeSec', 'videoId'],
    methods: {
      displayTime(comment) {
        return this.secToTime(comment.time)
      },
      secToTime(timeInSeconds) {
        if(timeInSeconds == null) {
          return "--:--:--"
        }
        const pad = function(num, size) { return ('000' + num).slice(size * -1); }
        const time = parseFloat(timeInSeconds).toFixed(3)
        const hours = Math.floor(time / 60 / 60)
        const minutes = Math.floor(time / 60) % 60
        const seconds = Math.floor(time - minutes * 60)
        return pad(hours, 2) + ':' + pad(minutes, 2) + ':' + pad(seconds, 2)
      },
      extractNewComment(comments) {
        const existIds = this.comments.map(
          comment => comment.id
        )
        return comments.filter(
          comment => !existIds.includes(comment.id)
        )
      },
      getComments() {
        this.loaded = false
        let time_from = 0
        if(this.playTimeSec > 1800){
          time_from = this.playTimeSec - 1800
        }
        const path = '../videos/' + this.videoId + '/comments'
        const params = {
          time_to: this.playTimeSec,
          time_from: time_from
        }
        axios
          .get(path, {params: params})
          .then(response => {
            const newComments = this.extractNewComment(response.data)
            newComments.forEach((comment) => {
              this.comments.unshift(comment)
            })
            this.errorMessage = ''
            this.loaded = true
          })
          .catch(error => (
            this.errorMessage = '情報が取得できませんでした、、、'
          ))
          .finally()
      },
      submitComment() {
        if(this.formDisabled) {
          return
        }
        if(this.inputContent == '') {
          return
        }
        this.formDisabled = true
        const path = '../videos/' + this.videoId + '/comments'
        const params = {
          comment: {
            video_id: this.videoId,
            time: this.playTimeSec,
            content: this.inputContent
          }
        }
        axios
          .post(path, params)
          .then(response => {
            this.inputContent= ''
            this.errorMessage = ''
          })
          .catch(error => (
            this.errorMessage = '送信に失敗しました、、、'
          ))
          .finally(this.formDisabled = false)
      }
    },
    mounted() {
      this.getComments()
      this.intervalIds.push(setInterval(this.getComments, 3000))
    },
    beforeDestroy() {
      this.intervalIds.forEach((id) => {
        clearInterval(id)
      })
    }
  }
</script>

<style scoped>
  .comment:not(:last-child) {
    border-bottom: 1px solid rgba(0,0,0,0.04);
  }
</style>
