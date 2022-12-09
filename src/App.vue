<template>
  <div v-bind:class="'app-wrapper ' + timeOfDay">

    <CurrentDate :date="date" v-if="date"/>

    <div class="weather-wrapper" v-cloak>

      <div class="main-wrapper">

        <div class="content-wrapper">

          <div class="block-left">
            <div class="location-block" v-if="city">
              <span class="material-symbols-outlined">
                near_me
              </span>
              <p>{{ city }}</p>
            </div>

            <div class="temperature-block" v-if="resultWeather">

              <div class="temperature-wrapper">
                <span class="main-weather-icon material-symbols-outlined">
                  partly_cloudy_day
                </span>

                <p class="temperature">{{ resultWeather.hourly.temperature_2m[this.currentHours] }}°</p>
              </div>

              <p class="temperature-apparent">Feels like {{ resultWeather.hourly.apparent_temperature[this.currentHours]
              }}°</p>
            </div>


          </div>

          <div className="block-right" v-if="resultWeather">
            <div class="wind-block">
              <span class="material-symbols-outlined">
                air
              </span>
              <p>
                {{ resultWeather.hourly.windspeed_10m[this.currentHours] }}
                {{ resultWeather.hourly_units.windspeed_10m }}
              </p>
            </div>

            <div class="humidity-block">
              <span class="material-symbols-outlined">
                humidity_low
              </span>
              <p>
                {{ resultWeather.hourly.relativehumidity_2m[this.currentHours] }}
                {{ resultWeather.hourly_units.relativehumidity_2m }}
              </p>
            </div>

            <div class="pressure-block">
              <span class="material-symbols-outlined">
                arrow_circle_up
              </span>
              <p>
                {{ resultWeather.hourly.surface_pressure[this.currentHours] }}
                {{ resultWeather.hourly_units.surface_pressure }}
              </p>
            </div>

          </div>
        </div>

        <div class="error" v-if="errorStr">
          Sorry, but the following error
          occurred: {{ errorStr }}
        </div>

        <div class="loading-wrapper" v-if="gettingLocation">
          <p class="loading">Getting your location</p>
        </div>

      </div>

    </div>
  </div>

</template>

<script>
import CurrentDate from './components/CurrentDate.vue'

export default {
  name: 'App',
  components: {
    CurrentDate
  },
  data() {
    return {
      date: null,
      currentHours: null,

      location: null,
      city: null,
      gettingLocation: false,
      errorStr: null,

      loadedWeather: false,
      resultWeather: null,
    }

  },
  computed: {
    timeOfDay: function() {
      let date = new Date();
      let hours = date.getHours();

      let nigntHours = [21, 22, 23, 0, 1, 2, 3, 4, 5];
      let morningHours = [6, 7, 8, 9, 10];
      let dayHours = [11, 12, 13, 14, 15, 16];

      if (nigntHours.includes(hours)) {
        return "night";
      } else if (morningHours.includes(hours)) {
        return  "morning";
      } else if (dayHours.includes(hours)) {
        return  "day";
      } else {
        return "evening";
      }
    }
  },
  methods: {
    async getLocation() {

      return new Promise((resolve, reject) => {

        if (!("geolocation" in navigator)) {
          reject(new Error('Geolocation is not available.'));
        }

        navigator.geolocation.getCurrentPosition(pos => {
          resolve(pos);
        }, err => {
          reject(err);
        });

      });
    },
    async getData() {
      let date = new Date();
      this.date = date;
      this.currentHours = date.getHours()

      this.gettingLocation = true;
      return new Promise((resolve, reject) => {
        let result = this.getLocation();

        if (result) {
          resolve(result)
        } else {
          reject(new Error('Geolocation is not available.'))
        }

      })
        .then(result => {
          this.gettingLocation = false;
          this.loadedWeather = true;
          this.location = result;
          this.getCityByCoords();
          this.getWeatherData()
        },
          error => {
            this.gettingLocation = false;
            this.loadedWeather = true
            this.errorStr = error.message;
          })

    },
    getCityByCoords() {
      fetch(
        `https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${this.location.coords.latitude}&longitude=${this.location.coords.longitude}&localityLanguage=en`
      )
        .then((response) => response.json())
        .then((result) => this.city = result.city);
    },
    getWeatherData() {
      fetch(
        `https://api.open-meteo.com/v1/forecast?latitude=${this.location.coords.latitude}&longitude=${this.location.coords.longitude}&hourly=temperature_2m,relativehumidity_2m,windspeed_10m,surface_pressure,apparent_temperature,weathercode&models=best_match&daily=weathercode&timezone=auto`
      )
        .then((response) => response.json())
        .then((result) => { this.resultWeather = result; })
        .then(this.loadedWeather = true);
    }
  },
  created() {
    this.getData()
  }
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
}

.main-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-around;

  padding: calc(2 * var(--index));
  border-radius: 50px;

  -webkit-backdrop-filter: blur(15px);
  backdrop-filter: blur(15px);

  background-color: rgba(255, 255, 255, 0.1);
  box-shadow: rgba(50, 50, 93, 0.2) 0px 50px 100px -20px, rgba(0, 0, 0, 0.2) 0px 30px 60px -30px;
  box-shadow: 0 0 40px rgba(30, 23, 99, 0.2);
}

.content-wrapper {
  display: flex;
  flex-direction: row;
}

.app-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;

  min-height: 100vh;
  color: white;
}

.block-left,
.block-right {
  display: flex;
  flex-direction: column;
  margin-left: var(--index);
  margin-right: var(--index);
  justify-content: space-between;
}

.block-left {
  align-items: center;
  text-align: center;
}

.block-right {
  align-items: flex-start;
}

.temperature-wrapper {
  margin-top: var(--index);
  margin-bottom: var(--index);
}

.location-block,
.block-right {
  color: rgba(255, 255, 255, 0.6);
}

.temperature-wrapper,
.location-block,
.wind-block,
.pressure-block,
.humidity-block,
.temperature-apparent,
.error,
.loading-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: row;
  font-size: calc(1.5 * var(--index));
}

.main-weather-icon {
  font-size: calc(6 * var(--index));
}

.temperature {
  font-size: calc(3 * var(--index));
}

.material-symbols-outlined {
  margin-right: var(--index);
}

@media screen and (min-width: 1200px) {
  .main-wrapper {
    padding: 45px;
  }

  .temperature-wrapper,
  .location-block,
  .wind-block,
  .pressure-block,
  .humidity-block,
  .temperature-apparent,
  .error,
  .loading-wrapper {
    font-size: 35px;
  }

  .main-weather-icon {
    font-size: 130px;
  }

  .temperature {
    font-size: 70px;
  }
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

/* loading dots */

.loading:after {
  content: ' .';
  animation: dots 1s steps(5, end) infinite;
}

@keyframes dots {

  0%,
  20% {
    color: rgba(0, 0, 0, 0);
    text-shadow:
      .25em 0 0 rgba(0, 0, 0, 0),
      .5em 0 0 rgba(0, 0, 0, 0);
  }

  40% {
    color: white;
    text-shadow:
      .25em 0 0 rgba(0, 0, 0, 0),
      .5em 0 0 rgba(0, 0, 0, 0);
  }

  60% {
    text-shadow:
      .25em 0 0 white,
      .5em 0 0 rgba(0, 0, 0, 0);
  }

  80%,
  100% {
    text-shadow:
      .25em 0 0 white,
      .5em 0 0 white;
  }
}
</style>
