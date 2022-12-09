<template>
    <div class="date">
      {{ date.toLocaleString("en-us", { weekday: "long" }) }}
      {{ date.getDate() }}
      {{ date.toLocaleString("en-us", { month: "long" }) }}
    </div>
</template>

<script>
export default {
  name: 'HelloWorld',
  props: {
    date: Date
  }
}
</script>

<style scoped>
.date {
  font-size: calc(2 * var(--index));
  margin-bottom: var(--index);
}
</style>
