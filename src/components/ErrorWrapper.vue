<template>
  <div class="error card">
    Sorry, but the following error occurred: {{ errorStr }}
  </div>
</template>

<script>
export default {
  name: 'ErrorWrapper',
}
</script>

<style scoped>
.error {
  font-size: calc(1.5 * var(--index));
}
@media screen and (min-width: 1200px) {
  .error {
    font-size: 35px;
  }
}
</style>