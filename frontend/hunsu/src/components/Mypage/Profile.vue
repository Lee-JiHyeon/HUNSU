<template>
  <v-container style="width: 375px">
    <v-layout justify-center>
      <v-card>
        <!-- width="800"
      height="100%" -->
        <div class="d-flex">
          <!--상대 프로필이미지-->
          <!--웹 전체화면일때-->
          <v-avatar class="mt-10 ml-10 mb-8 hidden-sm-and-down">
            <v-img
              v-model="getTargetProfileImage"
              v-if="getTargetProfileImage"
              :src="getTargetProfileImage"
            />
            <v-img v-else src="@/assets/profilephoto.png" />
          </v-avatar>
          <!--모바일-->
          <v-avatar
            width="80"
            height="80"
            class="mt-7 ml-7 hidden-sm-and-up"
            style="margin: 80px 60px 0px 20px"
          >
            <v-img
              v-model="getTargetProfileImage"
              v-if="getTargetProfileImage"
              :src="getTargetProfileImage"
            />
            <v-img v-else src="@/assets/profilephoto.png" />
          </v-avatar>
          <!--유저닉네임-->
          <!-- <p class="font-weight-black text-h5 hidden-sm-and-down" style="margin: 60px 20px">닉네임</p>
          <p class="font-weight-black subtitle-1 hidden-sm-and-up" style="margin: 40px 10px">닉네임</p> -->

          <!--팔로우버튼, 팔로우목록 dialog-->
          <div class="mt-9">
            <div class="ml-2">팔로워</div>
            <v-dialog transition="dialog-top-transition" max-width="600">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  text
                  v-bind="attrs"
                  v-on="on"
                  class="mt-1 ml-8 hidden-sm-and-down"
                  >{{ followerListLength }}</v-btn
                >
                <v-btn
                  text
                  v-bind="attrs"
                  v-on="on"
                  class="mt-1 mr-2 hidden-sm-and-up"
                  >{{ followerListLength }}</v-btn
                >
              </template>
              <template v-slot:default="dialog">
                <v-card>
                  <v-toolbar color="dark" dark>팔로워</v-toolbar>
                  <v-list subheader>
                    <v-list-item
                      v-for="follower in profileData.follower_list"
                      :key="follower.id"
                    >
                      <v-list-item-avatar>
                        <v-img
                          :alt="`${follower} avatar`"
                          src="https://cdn.vuetifyjs.com/images/lists/2.jpg"
                        ></v-img>
                      </v-list-item-avatar>

                      <v-list-item-content>
                        <v-list-item-title
                          v-text="follower"
                        ></v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                  <v-card-actions class="justify-end">
                    <v-btn text @click="dialog.value = false">Close</v-btn>
                  </v-card-actions>
                </v-card>
              </template>
            </v-dialog>
          </div>
          <!--팔로잉버튼, 팔로잉목록dialog-->
          <div class="mt-9">
            <div class="ml-2">팔로잉</div>
            <v-dialog transition="dialog-top-transition" max-width="600">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  text
                  v-bind="attrs"
                  v-on="on"
                  class="mt-1 ml-5 hidden-sm-and-down"
                  >{{ followingListLength }}</v-btn
                >
                <v-btn
                  text
                  v-bind="attrs"
                  v-on="on"
                  class="mt-1 hidden-sm-and-up"
                  >{{ followingListLength }}</v-btn
                >
              </template>
              <template v-slot:default="dialog">
                <v-card>
                  <v-toolbar color="dark" dark>팔로잉</v-toolbar>
                  <v-list subheader>
                    <v-list-item
                      v-for="following in profileData.following_list"
                      :key="following.id"
                    >
                      <v-list-item-avatar>
                        <v-img
                          :alt="`${following} avatar`"
                          src="https://cdn.vuetifyjs.com/images/lists/1.jpg"
                        ></v-img>
                      </v-list-item-avatar>

                      <v-list-item-content>
                        <v-list-item-title
                          v-text="following"
                        ></v-list-item-title>
                      </v-list-item-content>
                    </v-list-item>
                  </v-list>
                  <v-card-actions class="justify-end">
                    <v-btn text @click="dialog.value = false">Close</v-btn>
                  </v-card-actions>
                </v-card>
              </template>
            </v-dialog>
          </div>
          <!--설정아이콘-->
          <ProfileSetting v-if="getUserInfo.mypageNickname === getNickname" />
        </div>
        <div>
          <!--유저닉네임-->
          <div class="d-inline-block">
            <p
              class="font-weight-black text-h5 hidden-sm-and-down"
              style="margin: 10px 80px 10px 30px"
            >
              {{ getUserInfo.mypageNickname }}
            </p>
            <p
              class="d-inline-block font-weight-black subtitle-1 hidden-sm-and-up"
              style="margin: 10px 80px 10px 30px"
            >
              {{ getUserInfo.mypageNickname }}
            </p>
          </div>
          <!--팔로우버튼-->
          <div class="d-inline-block">
            <v-btn
              small
              v-model="followName"
              v-if="getUserInfo.mypageNickname !== getNickname"
              @click="followThisUser()"
              style="color: white"
              color="deep-purple accent-1"
              >{{ followName }}</v-btn
            >
          </div>
        </div>
        <!--ootd, 좋아요 탭-->
        <v-tabs
          v-model="tab"
          background-color="white"
          color="red accent-3"
          grow
        >
          <v-tab v-for="item in items" :key="item">
            {{ item }}
          </v-tab>
        </v-tabs>
        <v-tabs-items v-model="tab">
          <v-tab-item v-for="item in items" :key="item">
            <!-- ootd탭 -->
            <v-container
              v-if="item === 'OOTD'"
              class="white"
              style="padding: 0px"
            >
              <v-row no-gutters>
                <v-col
                  v-for="(ootd, idx) in profileData.imageList"
                  :key="idx"
                  cols="4"
                >
                  <v-card outlined tile>
                    <ImageViewForMypage
                      :images="ootd.img"
                      @click.native="goToOotdDetail(ootd.ootdIdx)"
                    />
                  </v-card>
                </v-col>
              </v-row>
            </v-container>

            <!-- 좋아요탭 -->
            <v-container
              v-if="item === '좋아요'"
              class="white"
              style="padding: 0px"
            >
              <v-row no-gutters>
                <v-col
                  v-for="(like, idx) in profileData.imageListForLike"
                  :key="idx"
                  cols="4"
                >
                  <v-card outlined tile>
                    <ImageViewForMypage
                      :images="like.imglike"
                      @click.native="goToOotdDetailForLike(like.ootdIdx)"
                    />
                  </v-card>
                </v-col>
              </v-row>
            </v-container>
          </v-tab-item>
        </v-tabs-items>
      </v-card>
    </v-layout>
  </v-container>
</template>
<script>
import ProfileSetting from "@/components/Mypage/ProfileSetting";
import { mapGetters, mapActions, mapMutations } from "vuex";
import ImageViewForMypage from "@/components/module/ImageViewForMypage";
import { rscApi } from "@/services/api";

export default {
  name: "Profile",
  components: {
    ProfileSetting,
    ImageViewForMypage,
  },
  data() {
    return {
      tab: null,
      items: ["OOTD", "좋아요"],
      profileData: {},
      followName: "", // 팔로우 상태에 따른 버튼내용
    };
  },
  created() {
    this.getProfile(this.getUserInfo);
    if (this.getUserInfo.follow) {
      return (this.followName = "Unfollow");
    } else {
      return (this.followName = "Follow");
    }
  },
  computed: {
    ...mapGetters([
      "getNickname",
      "getUserInfo",
      "getMyProfileImage",
      "getTargetProfileImage",
      "getOotdList",
      "getOotdInfo",
      "getMyProfileInfo",
    ]),
    // v-for에 쓰일 length값들
    ootdListLength() {
      if (this.profileData.ootd_list) {
        return this.profileData.ootd_list.length;
      }
      return "";
    },
    ootdLikeListLength() {
      if (this.profileData.ootd_like_list) {
        return this.profileData.ootd_like_list.length;
      }
      return "";
    },
    followerListLength() {
      if (this.profileData.follower_list) {
        return this.profileData.follower_list.length;
      }
      return "";
    },
    followingListLength() {
      if (this.profileData.following_list) {
        return this.profileData.following_list.length;
      }
      return "";
    },
  },
  methods: {
    ...mapMutations(["setOotdInfoImages", "setTargetProfileImage"]),
    ...mapActions([
      "getOotdInfoInApi",
      "getProfileImage",
      "getOotdListInApi",
      "getImageList",
      "getProfileInfoInApi",
      "getProfiles",
    ]),
    async getProfile(getUserInfo) {
      await this.getProfileInfoInApi(getUserInfo.mypageNickname);
      this.profileData = this.getUserInfo;
      let imageList = [];
      let imageListForLike = [];
      //이미지 받아온 후
      this.profileData.ootd_list.map(async (idx) => {
        let img = await this.getImageList({ prefix: "ootd/" + idx });
        imageList.push({ img, ootdIdx: idx });
      });
      this.profileData.ootd_like_list.map(async (idx) => {
        let imglike = await this.getImageList({ prefix: "ootd/" + idx });
        imageListForLike.push({ imglike, ootdIdx: idx });
      });
      //마지막에 this.$set으로 넣어주면, 리스트가 나중에 들어가도 데이터바인딩 됩니당
      this.$set(this.profileData, "imageList", imageList);
      this.$set(this.profileData, "imageListForLike", imageListForLike);
    },
    followThisUser() {
      const yourNickname = this.getUserInfo.mypageNickname;
      rscApi
        .post(
          `http://i4c102.p.ssafy.io:8080/api/user/follow?nickname=${yourNickname}`
        )
        .then((res) => {
          if (res.data) {
            this.followName = "Unfollow";
          } else {
            this.followName = "Follow";
          }
          this.getProfile(this.getUserInfo);
        })
        .catch((err) => {
          console.error(err);
        });
    },
    async goToOotdDetail(idx) {
      //idx 굳이 보여줄 필요 없을것같아서 params로 변경
      // this.$router.push({ name: "OotdDetail", params: { no: ootd.ootdIdx } });
      let root = this;
      await this.getOotdInfoInApi({
        ootdIdx: idx,
      });
      const images = await root.getImageList({ prefix: "ootd/" + idx });
      root.setOotdInfoImages(images);
      await this.getProfileImage({
        uid: this.getOotdInfo.uid,
        target: "target",
      });
      window.scrollTo({ top: "0", behavior: "smooth" });
      this.$router.push({ name: "OotdDetail" });
    },
    async goToOotdDetailForLike(idx) {
      let root = this;
      await this.getOotdInfoInApi({
        ootdIdx: idx,
      });
      const images = await root.getImageList({ prefix: "ootd/" + idx });
      root.setOotdInfoImages(images);
      await this.getProfileImage({
        uid: this.getOotdInfo.uid,
        target: "target",
      });
      window.scrollTo({ top: "0", behavior: "smooth" });
      this.$router.push({ name: "OotdDetail" });
    },
  },
};
</script>

<style>
</style>