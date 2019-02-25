<template>
  <form action="#" class="mt-3">
    <div class="form-group">
      <label for="video-url">観る動画のURL</label>
      <input type="url" class="form-control" id="source-url" autocomplete="off"
        v-model="sourceUrl" @change="getVideoInfo"
      >
    </div>
    <div class="video-info" v-if="loaded">
      <h4 class="video-title">{{ videoInfo.title }}</h4>
      <div class="form-group mt-2" ref="seekBar"
        @mousedown="onMouseDown"
        @mousemove="onMouseMove"
        @mouseup="onMouseUp"
        @mouseleave="onMouseLeave"
      >
        <label for="start-time">動画の開始時間</label>
        <div class="progress" style="height: 3px;">
          <div class="progress-bar bg-danger" role="progressbar" v-bind:style="{ width: seekBarPercent }" aria-valuenow="700" aria-valuemin="0" aria-valuemax="7661"></div>
        </div>
        <span class="time">{{ startTimeDisplay }}</span>/<span class="time">{{ runTimeDisplay }}</span><br />
      </div>
      <button type="submit" class="btn btn-primary" @click="openVideo">開く</button>
    </div>
    <div class="loading-message" v-if="loading">
      <p>Loading...</p>
    </div>
  </form>
</template>

<script>
  import axios from 'axios'
  export default {
    data() {
      return {
        sourceUrl: '',
        videoInfo: {},
        loading: false,
        loaded: false,
        isSeekBarHold: false,
        pointedSeekBarX: 0,
        startTime: 0,
        errorMessage: ''
      }
    },
    methods: {
      getVideoInfo() {
        this.loaded = false
        this.sourceUrl = this.formatUrl(this.sourceUrl)
        if(this.sourceUrl.match(/[0-9]+$/) == null) {
          return
        }
        const netflix_id = this.sourceUrl.match(/[0-9]+$/)[0]
        this.loading = true
        axios
          .get('../videos/' + netflix_id)
          .then(response => {
            this.videoInfo = response.data
            this.loaded = true
          })
          .catch(error => (
            this.errorMessage = '情報が取得できませんでした、、、'
          ))
          .finally(() => this.loading = false)
      },
      formatUrl(url) {
        // クエリパラメータを削除
        return url.replace(/\?.+/, '')
      },
      onMouseDown(e) {
        this.isSeekBarHold = true
        this.pointedSeedBarX = e.offsetX
        this.startTime = Math.round(e.offsetX/this.seekBarWidth*this.videoInfo.runtime)
        console.log(this.pointedSeedBarX)
        console.log(this.seekBarWidth)
        console.log(this.videoInfo.runtime)
        console.log(Math.round(this.startTime))
      },
      onMouseMove(e) {
        if(!this.isSeekBarHold) {
          return
        }
        this.pointedSeedBarX = e.offsetX
        this.startTime = Math.round(e.offsetX/this.seekBarWidth*this.videoInfo.runtime)
      },
      onMouseUp(e) {
        this.isSeekBarHold = false
      },
      onMouseLeave(e) {
        this.isSeekBarHold = false
      },
      secToTime(timeInSeconds) {
        const pad = function(num, size) { return ('000' + num).slice(size * -1); }
        const time = parseFloat(timeInSeconds).toFixed(3)
        const hours = Math.floor(time / 60 / 60)
        const minutes = Math.floor(time / 60) % 60
        const seconds = Math.floor(time - minutes * 60)
        return pad(hours, 2) + ':' + pad(minutes, 2) + ':' + pad(seconds, 2)
      },
      openVideo() {
        window.open(this.viewingUrl)
      }
    },
    computed: {
      viewingUrl() {
        const base_url = 'https://www.netflix.com/watch'
        if(this.startTime !== 0){
          return base_url + '/' + this.videoInfo.netflix_id + '?t=' + this.startTime
        } else {
          return base_url + '/' + this.videoInfo.netflix_id
        }
      },
      seekBarWidth() {
        return this.$refs.seekBar.clientWidth
      },
      startTimeDisplay() {
        return this.secToTime(this.startTime)
      },
      runTimeDisplay() {
        return this.secToTime(this.videoInfo.runtime)
      },
      seekBarPercent() {
        return '' + this.startTime/this.videoInfo.runtime*100 + '%'
      }
    }
  }
</script>
