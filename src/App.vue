<template>
  <WeatherCard msg="Welcome" />

  <div class="App-wrapper" v-cloak>

    <div class="main-wrapper">

      <div class="date" v-if="date">
        {{ date.toLocaleString("en-us", { weekday: "long" }) }}
        {{ date.getDate() }}
        {{ date.toLocaleString("en-us", { month: "long" }) }}
        {{ date.getHours()}}
      </div>

      <div class="content-wrapper">

        <div class="block-left">
          <p class="location-block" v-if="city">
            IconLocation {{city}}
          </p>
          <div class="temperature-block" v-if="resultWeather">
            <p class="weather-icon">IconWeather</p>
            <p class="temperature">{{resultWeather.hourly.temperature_2m[this.currentHours]}}°</p>
            <p>Feels like {{resultWeather.hourly.apparent_temperature[this.currentHours]}}°</p>
          </div>

          
        </div>

        <div className="block-right" v-if="resultWeather">
          <p>
            IconWind {{resultWeather.hourly.windspeed_10m[this.currentHours]}} {{resultWeather.hourly_units.windspeed_10m}}
          </p>
          <p>
            IconDrop {{resultWeather.hourly.relativehumidity_2m[this.currentHours]}} {{resultWeather.hourly_units.relativehumidity_2m}}
          </p>
          <p>
            IconPressure {{resultWeather.hourly.surface_pressure[this.currentHours]}} {{resultWeather.hourly_units.surface_pressure}}
          </p>
        </div>
      </div>
    </div>

    <div v-if="errorStr">
      Sorry, but the following error
      occurred: {{ errorStr }}
    </div>

    <div v-if="gettingLocation">
      <i>Getting your location...</i>
    </div>
  </div>

</template>

<script>
import WeatherCard from './components/WeatherCard.vue'


export default {
  name: 'App',
  components: {
    WeatherCard
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
@import url('https://fonts.googleapis.com/css2?family=Comfortaa:wght@700&display=swap');

:root {
  --index: calc(1vw + 1vh);
  --transition: transform .3s cubic-bezier(.075, .5, 0, 1);
}  

* {
  box-sizing: border-box;
  margin: 0;
  transition: var(--transition);
  font-family: 'Comfortaa';
}

#app {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(1.5 * var(--index));
  color: white;
  /* day */
  background: linear-gradient(60deg, #92d0f2c6, #6f99d5b7), url("https://images.unsplash.com/photo-1597200381847-30ec200eeb9a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1074&q=80");
  background-repeat: no-repeat;
  background-size: cover;
}

#app * {
  margin-bottom: var(--index);
  margin-top: var(--index);
}

</style>
