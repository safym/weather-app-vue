<template>
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
              {{ this.iconName }}
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
</template>

<script>
export default {
  name: 'WeatherBlock',
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
      iconName: "",

      weatherCodeIcon: {
        sunny: [0],
        partly_cloudy_day: [1, 2],
        clear_night: [0],
        nights_stay: [1, 2],
        cloudy: [3],
        rainy: [45, 48, 51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82],
        thunderstorm: [95, 96, 99],
        cloudy_snowing: [ 71, 73, 75, 77, 85, 86],
      },
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
          this.getWeatherIcon()
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
        .then((result) => this.resultWeather = result)
        .then((result) => this.getWeatherIcon(result.hourly.weathercode[this.currentHours]))
        .then(this.loadedWeather = true);
    },
    getWeatherIcon(weatherCode) {
      let iconName = "";
      for (let prop in this.weatherCodeIcon) {
        if (this.weatherCodeIcon[prop].includes(weatherCode)) {
          iconName = prop;
        }
      }
      this.iconName = iconName;
    }

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
