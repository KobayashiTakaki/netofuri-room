<template>
  <div class="col-lg-8">
    <h4>{{ video.title }}</h4>
    <div class="video-episode" v-if="video.type == 'show'">
      シーズン{{ video.season }}, 第{{ video.episode }}話
    </div>
    <div class="mt-2">
      <form accept-charset="UTF-8" method="post" :action="postPath">
        <input type="hidden" name="authenticity_token" :value="authenticationToken">
        <div class="form-group">
          <label for="scene_title">タイトル</label>
          <input type="text" class="form-control" name="scene[title]" id="scene_title"
            v-model="title"
          >
        </div>

        <div class="form-group">
          <label for="scene_start_time">開始時間</label>
          <input type="text" class="form-control" name="scene[start_time]" id="scene_start_time"
            v-model="startTime"
          >
          {{ startTimeDisplay }}
        </div>

        <div class="form-group">
          <label for="scene_end_time">終了時間</label>
          <input type="text" class="form-control" name="scene[end_time]" id="scene_end_time"
            v-model="endTime"
          >
          {{ endTimeDisplay }}
        </div>

        <button class="btn btn-primary" type="submit">送信</button>
      </form>
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        title: '',
        startTime: 0,
        endTime: 0
      }
    },
    props: ['authenticationToken', 'postPath', 'video'],
    methods: {
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
      }
    },
    computed: {
      startTimeDisplay() {
        return this.secToTime(this.startTime)
      },
      endTimeDisplay() {
        return this.secToTime(this.endTime)
      }
    }
  }
</script>
