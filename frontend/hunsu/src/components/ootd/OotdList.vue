<template>
  <!-- OOTD 메인 페이지 -->
  <div>
    <!-- OOTD 하나 클릭하면 디테일페이지 뜨는 섹션 -->
    <!-- <router-view></router-view> -->
    <v-card
      v-for="(ootd, idx) in ootdList"
      :key="idx"
      elevation="24"
      max-width="450"
      class="mx-auto my-5"
    >
      <!-- OOTD 사진 -->
      <ImageView
        :images="ootd.imageUrls"
        @click.native="goToOotdDetail(ootd)"
      />

      <v-list two-line>
        <v-list-item>
          <!-- 작성자 프로필 -->
          <v-list-item-avatar>
            <v-img
              v-if="ootd.profileImage"
              @click="goToProfilePage(ootd)"
              :src="ootd.profileImage"
            ></v-img>
            <v-img
              v-else
              @click="goToProfilePage(ootd)"
              src="@/assets/profilephoto.png"
            ></v-img>
          </v-list-item-avatar>

          <v-list-item-content>
            <v-list-item-title>{{ ootd.ootdContent }}</v-list-item-title>
            <v-list-item-subtitle>
              <!-- 추후 해쉬태그에 검색 링크 걸 예정 -->
              <p
                v-for="(hashtag, i) in ootd.hashtagList"
                :key="i"
                style="display: inline"
              >
                {{ "#" + hashtag }}
              </p>
            </v-list-item-subtitle>
          </v-list-item-content>
          <!-- <v-list-item-content>{{ootd.ootdLike}}개의</v-list-item-content> -->
          <v-list-item-action>
            <!-- 좋아요 버튼 -->
            <div>
              {{ ootd.ootdLike }}
              <v-btn icon>
                <v-icon color="red">mdi-heart</v-icon>
              </v-btn>
            </div>
          </v-list-item-action>
        </v-list-item>
      </v-list>
    </v-card>

    <!--무한스크롤-->
    <!--아래 문구는 데이터 모두 출력한 뒤 보이는 문구, spinner는 데이터
    가져올 때 표시하는 바람개비아이콘으로 default, spiral, circles, bubbles, waveDots 다섯가지 있음-->
    <infinite-loading
      v-if="!click"
      @infinite="infiniteHandler"
      spinner="waveDots"
    >
      <div
        slot="no-more"
        style="color: rgb(102, 102, 102); font-size: 14px; padding: 10px 0px"
      >
        목록의 끝입니다 :)
      </div>
    </infinite-loading>
  </div>
</template>


<script>
import { mapActions, mapGetters, mapMutations } from "vuex";
import ImageView from "@/components/module/ImageView";
import infiniteLoading from "vue-infinite-loading";
import { rscApi } from "@/services/api";
import { EventBus } from "@/services/eventBus";

export default {
  name: "OotdList",
  components: {
    ImageView,
    infiniteLoading,
  },
  props: ["sortNum", "limitNum", "click", "searchedList"],
  data() {
    return {
      cycle: false,
      imageUrls: [],
      ootdList: [],
      sort: this.sortNum,
      limit: this.limitNum,
      noResult: false,
    };
  },
  computed: {
    ...mapGetters(["getOotdList", "getNickname", "getOotdInfo"]),
  },

  mounted() {
    EventBus.$on("searchHashtag", (getOotdList) => {
      this.ootdList = getOotdList;
    });
    if (this.click) {
      this.ootdList = this.searchedList;
    }
  },
  beforeDestroy() {
    if (this.click) {
      this.setSearchedList([]);
    }
  },
  methods: {
    ...mapActions([
      "getOotdInfoInApi",
      "getOotdListInApi",
      "getImageList",
      "getProfileInfoInApi",
      "getProfileImage",
      "getProfiles",
      "getSearchedList",
    ]),
    ...mapMutations([
      "setOotdInfoImages",
      "setTargetProfileImage",
      "setSearchedList",
    ]),
    clickHashTag(ootdList) {
      this.ootdList = ootdList;
    },
    async goToOotdDetail(ootd) {
      // 디테일로 이동
      await this.getOotdInfoInApi({
        ootdIdx: ootd.ootdIdx,
      });
      const res = await this.getImageList({ prefix: "ootd/" + ootd.ootdIdx });
      this.setOotdInfoImages(res);

      await this.getProfileImage({
        uid: ootd.uid,
        target: "target",
      });
      window.scrollTo({ top: "0", behavior: "smooth" });
      this.$router.push({ name: "OotdDetail" });
    },
    async goToProfilePage(ootdInfo) {
      //프로필로 이동
      await this.getProfileInfoInApi(ootdInfo.nickname);
      this.getProfileImage({
        uid: ootdInfo.uid,
        target: "target",
      });
      window.scrollTo({ top: "0", behavior: "smooth" });
      this.$router.push({ name: "MyPage" });
    },
    async infiniteHandler($state) {
      // 무한스크롤 함수
      if (this.click) {
        return;
      }
      const res = await rscApi.get(`ootd/${this.sort}/${this.limit}`);
      setTimeout(() => {
        if (res.data.ootdMainDTOList.length) {
          this.ootdList = res.data.ootdMainDTOList;
          this.loadImages();
          $state.loaded();
          this.limit += 1;
          if (this.ootdList.length === res.data.count) {
            $state.complete();
          }
        } else {
          $state.complete();
        }
      }, 1000);
    },
    loadImages() {
      this.getProfiles(this.ootdList);
      this.ootdList.forEach((info) => {
        this.getImageList({ prefix: "ootd/" + info.ootdIdx }).then((res) => {
          this.$set(info, "imageUrls", res);
        });
      });
    },
  },
};
</script>