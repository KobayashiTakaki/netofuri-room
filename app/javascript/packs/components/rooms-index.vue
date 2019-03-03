<template>
  <div class="container-fluid">
    <div class="rooms-index row">
      <div class="col-md-6"
        v-for="room in rooms"
        v-bind:id="tagId(room)"
      >
        <div class="room-card p-2 mt-2">
          <div class="room-info">
            <span class="video-title px-1">{{ room.video.title }}</span>の部屋<br />
            <span v-if="video(room).type == 'show'">
              シーズン{{ video(room).season }}, 第{{ video(room).episode }}話
            </span><br />
            <div class="progress mt-2" style="height: 3px;">
              <div class="progress-bar bg-danger" role="progressbar"
                v-bind:style="{ width: seekBarPercent(room) }"
                :aria-valuenow="playTimeSec(room)"
                aria-valuemin="0"
                :aria-valuemax="endTimeSec(room)"
              >
              </div>
            </div>
            <span class="time">{{ secToTime(playTimes[room.id]) }}</span>
            <span class="px-1">/</span>
            <span class="time">{{ endTimeDisplay(room) }}</span>
            <div class="viewing-users mt-3">
              観てる人: <span class="user-count pr-1">{{ users(room).length }}</span>人
            </div>
          </div>
          <a class="btn btn-secondary btn-sm" role="button"
            v-bind:href="path(room)"
          >
            入る
          </a>
        </div>
      </div>
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
        rooms: [],
        playTimes: {},
        errorMessage: '',
        intervalIds: []
      }
    },
    methods: {
      tagId(room) {
        return "room-" + room.id
      },
      path(room) {
        return "../rooms/" + room.id
      },
      playTimeDisplay(room) {
        const sec = this.playTimeSec(room)
        return this.secToTime(sec)
      },
      endTimeDisplay(room) {
        const sec = this.endTimeSec(room)
        return this.secToTime(sec)
      },
      playTimeSec(room) {
        return Math.round((new Date() - new Date(room.viewing.start_time))/1000)
      },
      endTimeSec(room) {
        return Math.round((new Date(room.viewing.end_time) - new Date(room.viewing.start_time))/1000)
      },
      video(room) {
        return room.video
      },
      users(room) {
        return room.users
      },
      updateTimes() {
        let playTimes = {}
        this.rooms.forEach((room) => {
          playTimes[room.id] = this.playTimeSec(room)
        })
        this.playTimes = playTimes
      },
      seekBarPercent(room) {
        return '' + this.playTimes[room.id]/this.endTimeSec(room)*100 + '%'
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
      getRooms() {
        axios
          .get('../rooms/')
          .then(response => {
            this.rooms = response.data
            this.errorMessage = ''
          })
          .catch(error => (
            this.errorMessage = '情報が取得できませんでした、、、'
          ))
          .finally()
      },
      updateRooms() {
        const length_bef = this.rooms.length
        this.rooms = this.rooms.filter(
          room => new Date(room.viewing.end_time) > new Date()
        )
        if(length_bef !== this.rooms.length){
          this.getRooms()
        }
      }
    },
    mounted() {
      this.getRooms()
      this.updateTimes()
      this.intervalIds.push(setInterval(this.updateTimes, 1000))
      this.intervalIds.push(setInterval(this.updateRooms, 1000))
    },
    beforeDestroy() {
      this.intervalIds.forEach((id) => {
        clearInterval(id)
      })
    }
  }
</script>

<style scoped>
  .room-card {
    border-radius: 5px;
    border: solid 1px rgba(0, 0, 0, 0.3);
  }

  .username {
    font-weight: bold;
  }
  .video-title {
    font-size: 150%;
    font-weight: bold;
  }

  .time {
    font-weight: bold;
  }
</style>
