<template>
  <div class="main-wrapper">

    <WeatherNowCard v-if="resultWeather" 
      v-bind:resultWeather="this.resultWeather"
      v-bind:city="this.city" 
      v-bind:currentHours="this.currentHours" />
      
    <WeatherForecastCard v-if="resultWeather" v-bind:resultWeather="this.resultWeather" />

    <LoadingWrapper v-if="gettingLocation" />
    <ErrorWrapper v-if="errorStr" />

  </div>
</template>

<script>
import WeatherNowCard from './WeatherNowCard.vue';
import WeatherForecastCard from './WeatherForecastCard.vue';
import LoadingWrapper from './LoadingWrapper.vue'
import ErrorWrapper from './ErrorWrapper.vue'

export default {
  name: 'MainWeatherWrapper',
  components: {
    WeatherNowCard,
    WeatherForecastCard,
    LoadingWrapper,
    ErrorWrapper,
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
  methods: {
    async getLocation() {

      return new Promise((resolve, reject) => {

        if (!("geolocation" in navigator)) {
          reject(new Error('Geolocation is not available.'));
        }

        navigator.geolocation.getCurrentPosition(pos => {
          resolve(pos);
        }, err => {
          console.log(err)
          reject(err);
        });

      });
    },
    async getData() {
      let date = new Date();
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
        .then((result) => {this.resultWeather = result; console.log(result)})
        .then(this.loadedWeather = true);
    },
  },
  created() {
    this.getData()
  }
}
</script>

<style scoped>
.main-wrapper {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: space-around;

  position: relative;
}
</style>
