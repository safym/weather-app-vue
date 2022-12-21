<template>
  <div v-bind:class="'app-wrapper ' + timeOfDay">
    <CurrentDate />
    <MainWeatherWrapper />
  </div>
</template>

<script>
import CurrentDate from './components/CurrentDate.vue'
import MainWeatherWrapper from './components/MainWeatherWrapper.vue'

export default {
  name: 'App',
  components: {
    CurrentDate,
    MainWeatherWrapper,
  },
  computed: {
    timeOfDay: function () {
      let date = new Date();
      let hours = date.getHours();

      let nigntHours = [21, 22, 23, 0, 1, 2, 3, 4, 5];
      let morningHours = [6, 7, 8, 9, 10];
      let dayHours = [11, 12, 13, 14, 15, 16];

      if (nigntHours.includes(hours)) {
        return "night";
      } else if (morningHours.includes(hours)) {
        return "morning";
      } else if (dayHours.includes(hours)) {
        return "day";
      } else {
        return "evening";
      }
    }
  },
}
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Mukta&display=swap');

:root {
  --index: calc(1vw + 1vh);
  --transition: transform .3s cubic-bezier(.075, .5, 0, 1);
}

* {
  box-sizing: border-box;
  margin: 0;
  transition: var(--transition);
  font-family: 'Mukta';
  color: white;
}

.app-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
}

/* backrounds */

.morning {
  background: -webkit-linear-gradient(60deg, #fec3a6bf, #ff938bbb), url("https://images.unsplash.com/photo-1603376277241-70b32265cf10?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1167&q=80");
  background: linear-gradient(60deg, #fec3a6bf, #ff938bbb), url("https://images.unsplash.com/photo-1603376277241-70b32265cf10?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1167&q=80");
}

.day {
  background: -webkit-linear-gradient(60deg, #92d0f2c6, #6f99d5b7), url("https://images.unsplash.com/photo-1597200381847-30ec200eeb9a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80");
  background: linear-gradient(60deg, #92d0f2c6, #6f99d5b7), url("https://images.unsplash.com/photo-1597200381847-30ec200eeb9a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80");
}

.evening {
  background: -webkit-linear-gradient(60deg, #e6629db3, #a049a6b3), url("https://images.unsplash.com/photo-1508020963102-c6c723be5764?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80");
  background: linear-gradient(60deg, #e6629db3, #a049a6b3), url("https://images.unsplash.com/photo-1508020963102-c6c723be5764?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80");
}

.night {
  background: -webkit-linear-gradient(60deg, #6b49a6c8, #123258c5), url("https://images.unsplash.com/photo-1475274047050-1d0c0975c63e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80");
  background: linear-gradient(60deg, #6b49a6c8, #123258c5), url("https://images.unsplash.com/photo-1475274047050-1d0c0975c63e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1172&q=80");
}

.day,
.morning,
.evening,
.night {
  background-repeat: no-repeat;
  background-size: cover;
}

/* whole card styles */
.card {
  border-radius: 35px;
  -webkit-backdrop-filter: blur(15px);
  backdrop-filter: blur(15px);
  background-color: rgba(255, 255, 255, 0.1);
  box-shadow: 0 0 40px rgba(30, 23, 99, 0.2);
  padding: calc(1.5 * var(--index));
}

@media screen and (min-width: 1200px) {
  .card {
    padding: 25px;
  }
}
</style>
