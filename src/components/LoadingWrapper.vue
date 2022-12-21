<template>
  <div class="loading-wrapper card">
    <p class="loading">Getting your location</p>
  </div>
</template>

<script>
export default {
  name: 'LoadingWrapper'
}
</script>

<style scoped>

.loading-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-direction: row;

  font-size: calc(1.5 * var(--index));
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

@media screen and (min-width: 1200px) {
  .loading-wrapper {
    font-size: 35px;
  }
}
</style>