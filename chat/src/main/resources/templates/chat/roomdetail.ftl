<!doctype html>
<html lang="en">
<head>
    <title>Websocket ChatRoom</title>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="/webjars/bootstrap/4.3.1/dist/css/bootstrap.min.css">
    <style>
        [v-cloak] {
            display: none;
        }
    </style>
</head>
<body>
<div class="container" id="app" v-cloak>
    <div class="row">
        <div class="col-md-6">
            <h4>{{roomName}} <span class="badge badge-info badge-pill">{{userCount}}</span><span
                        class="badge badge-info badge-pill">{{likeCount}}</span></h4>
        </div>
        <div class="col-md-6 text-right">
            <a class="btn btn-info btn-sm" @click="leaveRoom">채팅방 나가기</a>
        </div>

    </div>
    <div class="input-group">
        <div class="input-group-prepend">
            <label class="input-group-text">내용</label>
        </div>
        <input type="text" class="form-control" v-model="message" v-on:keypress.enter="sendMessage('TALK')">
        <div class="input-group-append">
            <button class="btn btn-primary" type="button" @click="sendMessage('TALK')">보내기</button>
            <button class="btn btn-primary" type="button" @click="plusLike('LIKE')">좋아요</button>
        </div>
    </div>
    <ul class="list-group">
        <li class="list-group-item" v-for="message in messages" v-if="message.type != 'LIKE'">
            {{message.sender}} - {{message.message}}</a>
        </li>
    </ul>
</div>
<!-- JavaScript -->
<script src="/webjars/vue/2.5.16/dist/vue.min.js"></script>
<script src="/webjars/axios/0.17.1/dist/axios.min.js"></script>
<script src="/webjars/sockjs-client/1.1.2/sockjs.min.js"></script>
<script src="/webjars/stomp-websocket/2.3.3-1/stomp.min.js"></script>
<script>
    // websocket & stomp initialize
    var sock = new SockJS("/ws-stomp");
    var ws = Stomp.over(sock);
    // vue.js
    var vm = new Vue({
        el: '#app',
        data: {
            roomId: '',
            roomName: '',
            message: '',
            messages: [],
            token: '',
            userCount: 0,
            likeCount: 0,
            fixedComment: '',
            nickname: 'koyuchang',
        },
        created() {
            this.roomId = localStorage.getItem('wschat.roomId');
            this.roomName = localStorage.getItem('wschat.roomName');
            var _this = this;
            ws.connect({}, function (frame) {//연결이 성공되면 채팅방을 구독
                ws.subscribe("/sub/chat/room/" + _this.roomId, function (message) {
                    var recv = JSON.parse(message.body);
                    _this.recvMessage(recv);
                    //방입장 닉네임 설정을 위해 닉네임을 헤더에 보내주세요!({"nickname":"koyuchang"})
                }, {"nickname": _this.nickname});
            }, function (error) {
                alert("서버 연결에 실패 하였습니다. 다시 접속해 주십시요.");
                location.href = "/chat/room";
            });

        },
        methods: {
            leaveRoom: function () {
                var _this = this;
                ws.disconnect("/sub/chat/room/" + this.roomId, {"nickname": _this.nickname})
                location.href = "/chat/room"
            },
            plusLike: function (type) {
                ws.send("/pub/chat/like", {"nickname": this.nickname}, JSON.stringify({
                    type: type,
                    roomId: this.roomId,
                    sender: this.nickname
                }))
            },
            sendMessage: function (type) {
                console.log("여기부터")
                ws.send("/pub/chat/message", {"nickname": this.nickname}, JSON.stringify({
                    type: type,
                    roomId: this.roomId,
                    message: this.message
                }));
                this.message = '';
            },
            recvMessage: function (recv) {
                this.fixedComment = recv.fixedComment;
                this.userCount = recv.userCount;
                this.likeCount = recv.likeCount;
                this.messages.unshift({"type": recv.type, "sender": recv.sender, "message": recv.message})
            }
        }
    });
</script>
</body>
</html>