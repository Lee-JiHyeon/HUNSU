<template>
<!-- 라이브 검색 버튼 -->
<div class="d-inline-block">
  <!-- 검색어 입력 -->
  <v-text-field label="검색" class="d-inline-block pl-3" width="100"></v-text-field>
  <!-- 검색어 입력 후 클릭하는 버튼 -->
  <v-btn icon class="d-inline-block">
    <v-icon>mdi-magnify</v-icon>
  </v-btn>
  
</div>
</template>

<script>
export default {
  name: "LiveSearchBtn"
}
</script>

<style>

</style>