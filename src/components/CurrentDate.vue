<template>
  <div class="dateBlock">
    <span class="material-symbols-outlined">
      calendar_month
    </span>
    <div class="date">
      {{ this.currentDate.toLocaleString("en-us", { weekday: "long" }) }}
      {{ this.currentDate.getDate() }}
      {{ this.currentDate.toLocaleString("en-us", { month: "long" }) }}
    </div>
  </div>
</template>

<script>
export default {
  name: 'CurrentDate',
  data() {
    return {
      currentDate: null,
    }
  },
  methods: {
    setCurrentDate() {
      this.currentDate = new Date();
    }
  },
  created() {
    this.setCurrentDate()
  }
}
</script>

<style scoped>
.dateBlock {
  display: flex;
  flex-direction: row;
  align-items: center;
  justify-content: center;
  margin-bottom: var(--index);
  font-size: calc(1.5 * var(--index));
  opacity: 70%;
}

.date {
  margin-left: var(--index);
}
</style>
