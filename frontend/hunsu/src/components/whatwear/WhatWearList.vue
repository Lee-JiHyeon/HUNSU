<template>
  <!-- WHATWEAR 메인 페이지 -->
  <!--v-for 사용을 위한 최상위 div-->
  <v-card flat>
    <v-card
      v-for="(whatwear, idx) in whatwearList"
      :key="idx"
      @click="goToWhatwearDetail(whatwear)"
      flat
    >
      <div>
        <!--프로필사진-->
        <div class="d-flex ml-4 pt-4">
          <v-img
            :src="whatwear.profileImage"
            @click="goToWhatwearDetail(whatwear)"
            max-width="30px"
            height="30px"
            style="border-radius: 15px"
            class="mt-2"
          />

          <!--유저닉네임-->
          <v-card-subtitle class="mt-3 ml-2 font-weight-bold" id="nickname">
            {{ whatwear.nickname }}
          </v-card-subtitle>
        </div>

        <div class="d-flex align-center mt-3 mb-5">
          <!--뭘입을까 글제목-->
          <v-card-subtitle
            class="ml-5 text-subtitle-1 font-weight-bold"
            id="title"
          >
            {{ whatwear.title }}
          </v-card-subtitle>
          <!--투표기능뱃지-->
          <v-badge
            v-if="whatwear.voteActivated"
            color="red accent-2"
            content="투표"
            inline
            class="ml-1"
          >
          </v-badge>
        </div>
        <v-divider></v-divider>
        <!-- <div class="mb-2"></div> -->
      </div>
    </v-card>

    <v-card flat class="mt-4">
      <div class="text-center">
        <v-pagination
          v-model="page"
          :length="parseInt((getWhatwearListCount - 1) / 10) + 1"
          :total-visible="6"
          @click.native="pageWhatwear()"
        ></v-pagination>
      </div>
    </v-card>
  </v-card>
</template>

<script>
import { mapActions, mapMutations, mapGetters } from "vuex";
import { EventBus } from "@/services/eventBus";

export default {
  name: "WhatWearList",
  data() {
    return {
      page: 1,
      whatwearList: [],
    };
  },
  computed: {
    ...mapGetters(["getWhatwearListInfo", "getWhatwearListCount"]),
  },
  async created() {
    EventBus.$on("WhatwearWriteSuccess", (whatwear) => {
      this.goToWhatwearDetail(whatwear);
      this.pageWhatwear();
    });
  },
  async mounted() {
    await this.pageWhatwear();
  },
  methods: {
    ...mapActions([
      "getWhatwearListInfoApi",
      "getWhatwearInfoApi",
      "getProfileImage",
      "getImageList",
      "getWhatwearProfile",
    ]),
    ...mapMutations(["setWhatwearInfoImages"]),
    async goToWhatwearDetail(whatwear) {
      // 뭘입을까 상세정보 가져오기
      await this.getWhatwearInfoApi({
        wearIdx: whatwear.wear_idx,
        voteCheck: whatwear.voteActivated,
      });

      // 이미지 업로드 및 세팅
      const images = await this.getImageList({
        prefix: "whatwear/" + whatwear.wear_idx,
      });
      this.setWhatwearInfoImages(images);

      // 작성자 프로필사진 가져오기
      await this.getProfileImage({ uid: whatwear.uid, target: "target" });
      window.scrollTo({ top: "0", behavior: "smooth" });
      this.$router.push({ name: "WhatWearDetail" });
    },

    async pageWhatwear() {
      await this.getWhatwearListInfoApi(this.page);
      this.whatwearList = this.getWhatwearListInfo;
      this.getImages();
    },
    getImages() {
      this.whatwearList.forEach(async (info) => {
        const profile = await this.getWhatwearProfile(info.uid);
        this.$set(info, "profileImage", profile);
      });
    },
  },
};
</script>

<style>
#nickname {
  padding: 0 0 0 0;
}

#title {
  padding: 0 0 0 0;
}
</style>