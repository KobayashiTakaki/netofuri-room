<template>
  <div class="rooms-show row" v-if="loaded">
    <div class="col-md-6">
      <div class="video-info pl-3 pr-md-0 pr-3">
        <span v-if="errorMessage.length !== 0">
          {{ errorMessage }}
        </span>
        <div class="page-header mt-3">
          <h4><span class="video-title">{{ video.title }}</span>の部屋</h4>
        </div>
        <div class="viewing-info mt-3">
          <span v-if="video.type == 'show'">
            シーズン{{ video.season }}, 第{{ video.episode }}話
          </span><br />
          <div class="progress mt-2" style="height: 3px;">
            <div class="progress-bar bg-danger" role="progressbar"
              :style="{ width: seekBarPercent }"
              :aria-valuenow="playTime"
              aria-valuemin="0"
              :aria-valuemax="endTime"
            >
            </div>
          </div>
          <span class="time">{{ playTimeDisplay }}</span>
          <span class="px-1">/</span>
          <span class="time">{{ endTimeDisplay }}</span><br />
          <div class="open-video-btn mt-2">
            <button class="btn btn-primary"
              @click="openVideo(5)"
            >
              動画を開く
            </button>
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="auto-open-check"
                v-model="autoOpen"
              >
              <label class="form-check-label" for="auto-open-check">
                次の動画を自動的に開く
              </label>
            </div>
          </div>
          <div class="viewing-users mt-2">
            観てる人: <span class="user-count pr-1">{{ users.length }}</span>人
          </div>
        </div>
      </div>
    </div>
    <div class="col-md-6">
      <comments-area
        :loggedIn="loggedIn"
        :playTimeSec="playTime"
        :videoId="video.id">
      </comments-area>
    </div>
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
        videoWindow: null,
        autoOpen: false,
        users: [],
        playTime: 0,
        endTime: 0,
        errorMessage: '',
        intervalIds: []
      }
    },
    props: ['loggedIn'],
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
      setRoomId() {
        const paths = location.pathname.split('/')
        this.roomId = paths[paths.length-1]
      },
      getRoom() {
        const response = axios.get('../rooms/' + this.roomId)
          .catch(error => (
            this.errorMessage = '情報が取得できませんでした、、、'
          ))
        return response
      },
      async loadRoom() {
        this.loaded = false
        const response = await this.getRoom()
        this.viewing = response.data.viewing
        this.video = response.data.video
        this.users = response.data.users
        this.errorMessage = ''
        this.setEndTime()
        this.updateTime()
        this.loaded = true

      },
      async updateUsers() {
        const response = await this.getRoom()
        this.users = response.data.users
      },
      reloadRoom() {
        if(new Date() < new Date(this.viewing.end_time)){
          return
        }
        this.closeVideo()
        this.playTime = this.endTime
        this.join()
        this.loadRoom()
        this.openNextVideo()
      },
      openVideo(offset) {
        const baseUrl = 'https://www.netflix.com/watch'
        const videoId = this.video.netflix_id
        const params = '?t=' + (this.playTime + offset)
        this.videoWindow = window.open(baseUrl + '/' + videoId + params)
      },
      openNextVideo() {
        if(this.autoOpen){
          this.openVideo(5)
        }
      },
      closeVideo() {
        if(this.videoWindow) {
          this.videoWindow.close()
        }
      },
      join() {
        const params = {
          room_id: this.roomId
        }
        axios.post('../join', params)
      },
      leave() {
        axios.delete('../leave')
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
      this.setRoomId()
      this.join()
      this.loadRoom()
      this.intervalIds.push(setInterval(this.updateTime, 1000))
      this.intervalIds.push(setInterval(this.reloadRoom, 1000))
      this.intervalIds.push(setInterval(this.updateUsers, 5000))
    },
    beforeDestroy() {
      this.intervalIds.forEach((id) => {
        clearInterval(id)
      })
      this.leave()
    }
  }
</script>

<style scoped>
  .video-title {
    font-size: 120%;
    font-weight: bold;
  }

  .user-count {
    font-size: 120%;
    font-weight: bold;
  }

  .time {
    font-weight: bold;
  }
</style>
