<template>
  <!-- 회원가입 후 추가정보 입력할 컴포넌트 -->
  <div style="height: 100%">
    <v-toolbar dark color="black">
      <v-toolbar-title class="text-subtitle-1">회원가입</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-toolbar-title class="text-subtitle-1" @click="signUp"
        >완료</v-toolbar-title
      >
    </v-toolbar>
    <!-- 프로필 사진 -->
    <div class="d-flex justify-center ml-1 mt-6">
      <v-avatar width="100px" height="100px">
        <v-img
          v-if="getUploadImageUrls.length !== 0"
          :src="getUploadImageUrls[getUploadImageUrls.length - 1]"
        />
        <!-- <v-img v-else-if="getMyProfileImage" :src="getMyProfileImage" /> -->
        <v-img v-else src="@/assets/profilephoto.png" alt="John" />
      </v-avatar>
    </div>
    <!-- 프로필 이미지 업로드 부분 -->
    <!-- <v-file-input truncate-length="15" hide-input></v-file-input> -->
    <input ref="imageInput" type="file" hidden @change="onChangeImages" />
    <v-btn id="profileInput" x-large icon @click="onClickImageUpload"
      ><v-icon>mdi-camera</v-icon></v-btn
    >

    <!-- <v-avatar>
      <img src="https://cdn.vuetifyjs.com/images/john.jpg" alt="John" />
    </v-avatar>
    <v-row align="center" justify="space-around"> -->
    <!-- 프로필 사진 변경 버튼 -->
    <!-- <v-btn tile color="success"> Edit </v-btn>
    </v-row> -->
    <!-- 닉네임 입력 -->
    <v-text-field
      class="mx-auto mb-7"
      label="닉네임"
      :rules="rules"
      hide-details="auto"
      style="width: 94%"
      v-model="nickname"
      outlined
    ></v-text-field>
    <v-divider></v-divider>
    <h3 class="ml-3 mt-5 mb-4">추가정보(선택)</h3>
    <!-- 키 입력, 사이즈 선택 , 숫자만 입력하게 값검증 필요-->
    <v-text-field
      class="mx-auto"
      label="키(cm)"
      hide-details="auto"
      style="width: 94%"
      v-model="height"
      outlined
    ></v-text-field>
    <v-select
      class="mx-auto mt-5"
      style="width: 94%"
      outlined
      v-model="size"
      :items="items"
      label="사이즈"
    ></v-select>
  </div>
</template>

<script>
import { mapActions, mapGetters, mapMutations } from "vuex";
// import axios from "axios";

export default {
  name: "SignupInfo",

  props: {
    accessToken: {
      type: String,
    },
    refreshToken: {
      type: String,
    },
  },
  data: () => ({
    nickname: "",
    height: "",
    size: "",
    rules: [
      (value) => !!value || "Required.",
      (value) => (value || "").length <= 20 || "Max 20 characters",
      // (value) => {
      // const pattern = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      // return pattern.test(value) || "Invalid e-mail.";
      // },
    ],
    items: ["XXS", "XS", "S", "M", "L", "XL", "XXL"],
  }),
  computed: {
    ...mapGetters([
      "getAccessToken",
      "getUploadImageFiles",
      "getUploadImageUrls",
      "getUid",
    ]),
  },
  methods: {
    ...mapActions(["signUpInApi", "kakaoLogin", "uploadProfile"]),
    ...mapMutations([
      "setAllToken",
      "setUploadImageFiles",
      "setUploadImageUrls",
      "clearUploads",
    ]),
    async signUp() {
      await this.signUpInApi({
        accessToken: this.accessToken,
        height: this.height,
        nickname: this.nickname,
        size: this.size,
      });
      if (this.getUploadImageFiles.length !== 0) {
        await this.uploadProfile();
        this.clearUploads();
      }
      alert("회원가입 감사합니다!!");
      this.$router.push("/");
      // this.kakaoLogin();
    },
    onClickImageUpload() {
      this.$refs.imageInput.click();
    },
    onChangeImages(e) {
      this.setUploadImageFiles(e.target.files);
      this.setUploadImageUrls();
    },
  },
};
</script>

<style>
#profileInput {
  display: flex;
  margin: 0 auto;
}
</style>