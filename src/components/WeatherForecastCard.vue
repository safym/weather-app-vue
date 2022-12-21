<template>

  <div class="forecast-wrapper" v-if="resultWeather">

    <!-- three days forecast -->

    <div class="forecast card" v-for="day in this.daysForecast" v-bind:key="day">
      <div class="forecast-date">
        {{ new Date(resultWeather.hourly.time[this.startingHoursDay = this.startingHoursDay + 24]).getDate() }}
        {{ new Date(resultWeather.hourly.time[this.startingHoursNight = this.startingHoursNight+ 24]).toLocaleString("en-us", { month: "short" })}}
      </div>

      <div class="forecast-weather">
        <span class="material-symbols-outlined">
          {{ this.getWeatherIcon(this.resultWeather.hourly.weathercode[this.startingHoursDay]) }}
        </span>

        <div class="forecast-temp">
          <div>{{ resultWeather.hourly.temperature_2m[this.startingHoursDay] }}°</div>
          <div class="forecast-temp-night">{{ resultWeather.hourly.temperature_2m[this.startingHoursNight] }}°</div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
export default {
  name: 'WeatherForecastCard',
  props: ['resultWeather'],
  methods: {
    getWeatherIcon(weatherCode) {
      let weatherCodeIcon = {
        sunny: [0],
        partly_cloudy_day: [1, 2],
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

  },
  created() {
    this.startingHoursDay = 12;
    this.startingHoursNight = 24;
    this.daysForecast = 3;
  }
}
</script>

<style scoped>
.forecast-wrapper {
  display: flex;
  flex-direction: row;

  width: 100%;

  margin-top: calc(1 * var(--index));
  margin-bottom: calc(1 * var(--index));
}

.forecast {
  display: flex;
  flex-direction: column;
  align-items: center;

  width: 100%;

  font-size: calc(1.2 * var(--index));

  margin-left: calc(0.5 * var(--index));
  margin-right: calc(0.5 * var(--index));
}

.forecast-date {
  margin-bottom: calc( 0.5 *var(--index));
}
.forecast-weather {
  display: flex;
  flex-direction: row;
  align-items: center;
}

.material-symbols-outlined {
  margin-right: var(--index);
  font-size: calc(2 * var(--index));
}

.forecast-temp-night {
  opacity: 0.5;
}

@media screen and (min-width: 1200px) {
  .forecast {
    font-size: 30px;
  }
}
</style>
