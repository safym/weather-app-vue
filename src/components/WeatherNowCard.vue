<template>
  <div class="now-wrapper card">

    <div class="block-left" v-if="resultWeather">
      <div class="location-block" v-if="city">
        <span class="material-symbols-outlined">
          near_me
        </span>
        <p>{{ city }}</p>
      </div>

      <div class="temperature-block">

        <div class="temperature-wrapper">
          <span class="main-weather-icon material-symbols-outlined">
            {{ this.getWeatherIcon(this.resultWeather.hourly.weathercode[currentHours]) }}
          </span>

          <p class="temperature">{{ resultWeather.hourly.temperature_2m[currentHours] }}°</p>
        </div>

        <p class="temperature-apparent">Feels like {{ resultWeather.hourly.apparent_temperature[currentHours]
        }}°</p>
      </div>
    </div>

    <div className="block-right" v-if="resultWeather">
      <div class="wind-block">
        <span class="material-symbols-outlined">
          air
        </span>
        <p>
          {{ resultWeather.hourly.windspeed_10m[currentHours] }}
          {{ resultWeather.hourly_units.windspeed_10m }}
        </p>
      </div>

      <div class="humidity-block">
        <span class="material-symbols-outlined">
          humidity_low
        </span>
        <p>
          {{ resultWeather.hourly.relativehumidity_2m[currentHours] }}
          {{ resultWeather.hourly_units.relativehumidity_2m }}
        </p>
      </div>

      <div class="pressure-block">
        <span class="material-symbols-outlined">
          arrow_circle_up
        </span>
        <p>
          {{ resultWeather.hourly.surface_pressure[currentHours] }}
          {{ resultWeather.hourly_units.surface_pressure }}
        </p>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  name: 'WeatherNowCard',
  props: ['resultWeather', 'city', 'currentHours', 'iconName'],
  methods: {
    // переделать 
    getWeatherIcon(weatherCode) {
      let weatherCodeIcon = {
        sunny: [0],
        partly_cloudy_day: [1, 2],
        clear_night: [0],
        nights_stay: [1, 2],
        cloudy: [3],
        rainy: [45, 48, 51, 53, 55, 56, 57, 61, 63, 65, 66, 67, 80, 81, 82],
        thunderstorm: [95, 96, 99],
        cloudy_snowing: [71, 73, 75, 77, 85, 86],
      }

      let iconName = "";
      for (let prop in weatherCodeIcon) {
        if (weatherCodeIcon[prop].includes(weatherCode)) {
          iconName = prop;
        }
      }
      return iconName;
    }

  }
}
</script>

<style scoped>
.now-wrapper {
  display: flex;
  flex-direction: row;

}

.block-left,
.block-right {
  display: flex;
  flex-direction: column;
  justify-content: space-between;

  margin-left: var(--index);
  margin-right: var(--index);
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

.temperature-apparent {
  opacity: 0.5;
}

.material-symbols-outlined {
  margin-right: var(--index);
}

@media screen and (min-width: 1200px) {

  .temperature-wrapper,
  .location-block,
  .wind-block,
  .pressure-block,
  .humidity-block,
  .temperature-apparent {
    font-size: 30px;
  }

  .main-weather-icon {
    font-size: 130px;
  }

  .temperature {
    font-size: 70px;
  }
}
</style>
