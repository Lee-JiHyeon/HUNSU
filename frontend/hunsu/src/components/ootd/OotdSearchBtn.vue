<template>
  <!-- OOTD 검색 버튼 -->
  <div class="d-inline-block">
    <!-- 검색어 입력 -->
    <v-text-field
      color="deep-purple accent-1"
      v-model="searchWord"
      label="해시태그 OR 단어 검색"
      class="d-inline-block pl-3"
      width="100"
      @keydown.enter="searchHashtag(searchWord)"
    ></v-text-field>
    <!-- 검색어 입력 후 클릭하는 버튼 -->
    <v-btn icon class="d-inline-block" @click="searchHashtag(searchWord)">
      <v-icon>mdi-magnify</v-icon>
    </v-btn>
  </div>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import { EventBus } from "@/services/eventBus";

export default {
  name: "OotdSearchBtn",
  data() {
    return {
      searchWord: "",
    };
  },
  computed: {
    ...mapGetters(["getOotdList"]),
  },
  methods: {
    ...mapActions([
      "getSearchedListInApi",
      "getOotdListInApi",
      "getOotdInfoInApi",
      "getImageList",
      "getProfileInfoInApi",
      "getProfileImage",
      "getProfiles",
    ]),
    async searchHashtag(searchWord) {
      await this.getSearchedListInApi(searchWord);
      this.getProfiles(this.getOotdList);
      this.getOotdList.forEach((info) => {
        this.getImageList({ prefix: "ootd/" + info.ootdIdx }).then((res) => {
          this.$set(info, "imageUrls", res);
          // info.imageUrls = res;
        });
      });
      EventBus.$emit("searchHashtag", this.getOotdList);
    },
  },
};
</script>

<style>
#searchbar {
  margin-top: 5%;
}
</style>