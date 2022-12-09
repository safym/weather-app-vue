<template>
  <div class="app-header">
    <h1>Welcome</h1>
  </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  }
}
</script>

<style scoped>
h1 {
 font-size: calc(3 * var(--index));
}
</style>
