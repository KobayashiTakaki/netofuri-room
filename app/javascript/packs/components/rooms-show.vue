<template>
  <div class="rooms-show" v-if="loaded">
    <span v-if="errorMessage.length !== 0">
      {{ errorMessage }}
    </span>
    <div class="page-header mt-3">
      <h4><span class="video-title">{{ video.title }}</span>の部屋</h4>
    </div>
    <div class="viewing-info mt-3">
      <div class="progress mt-2" style="height: 3px;">
        <div class="progress-bar bg-danger" role="progressbar"
          :style="{ width: seekBarPercent }"
          :aria-valuenow="playTime"
          aria-valuemin="0"
          :aria-valuemax="endTime"
        >
        </div>
      </div>
      <span v-if="video.type == 'show'">
        シーズン{{ video.season }}, 第{{ video.episode }}話
      </span><br />
      <span class="time">{{ playTimeDisplay }}</span>
      <span class="px-1">/</span>
      <span class="time">{{ endTimeDisplay }}</span><br />
      <button class="btn btn-primary"
        @click="openVideo"
      >
        動画を開く
      </button>
      <div class="viewing-users mt-3">
        観てる人: <span class="user-count pr-1">{{ users.length }}</span>人
      </div>
    </div>
    <comments-area
      :playTimeSec="playTime"
      :videoId="video.id">
    </comments-area>
  </div>
</template>

<script>
  import axios from 'axios'
  import CommentsArea from './comments-area'
  axios.defaults.headers.common = {
    Accept: 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  }
  export default {
    data() {
      return {
        loaded: false,
        roomId: null,
        viewing: null,
        video: null,
        users: [],
        playTime: 0,
        endTime: 0,
        errorMessage: '',
        intervalIds: []
      }
    },
    components: {
      CommentsArea
    },
    methods: {
      playTimeSec() {
        return Math.round((new Date() - new Date(this.viewing.start_time))/1000)
      },
      setEndTime() {
        this.endTime = Math.round((new Date(this.viewing.end_time) - new Date(this.viewing.start_time))/1000)
      },
      updateTime() {
        this.playTime = this.playTimeSec()
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
      getRoom() {
        this.loaded = false
        const paths = location.pathname.split('/')
        const room_id = paths[paths.length-1]

        axios
          .get('../rooms/' + room_id)
          .then(response => {
            this.roomId = response.data.id
            this.viewing = response.data.viewing
            this.video = response.data.video
            this.users = response.data.users
            this.errorMessage = ''
            this.setEndTime()
            this.updateTime()
            this.loaded = true
          })
          .catch(error => (
            this.errorMessage = '情報が取得できませんでした、、、'
          ))
          .finally()
      },
      updateRoom() {
        if(new Date(this.viewing.end_time) < new Date()) {
          this.playTime = this.endTime
          this.getRoom()
        }
      },
      openVideo() {
        const baseUrl = 'https://www.netflix.com/watch'
        const videoId = this.video.netflix_id
        const params = '?t=' + this.playTime
        window.open(baseUrl + '/' + videoId + params)
      }
    },
    computed: {
      seekBarPercent() {
        return '' + this.playTime/this.endTime*100 + '%'
      },
      playTimeDisplay() {
        return this.secToTime(this.playTime)
      },
      endTimeDisplay() {
        return this.secToTime(this.endTime)
      }
    },
    mounted() {
      this.getRoom()
      this.intervalIds.push(setInterval(this.updateTime, 1000))
      this.intervalIds.push(setInterval(this.updateRoom, 1000))
    },
    beforeDestroy() {
      this.intervalIds.forEach((id) => {
        clearInterval(id)
      })
    }
  }
</script>
