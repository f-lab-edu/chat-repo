
class User {
  String? uid; // 사용자 고유 식별자 (Firestore 문서 ID)
  String? nickName; // 닉네임
  String? email; // 이메일 주소
  String? profileImageLink; // 프로필 사진 URL
  bool? alramSet; // 알람 설정 여부
  Map<String, bool>? friendsList; // 친구 목록 (예: {'friendUid1': true, ...})
  Map<String, bool>? blockedList; // 차단한 친구 목록 (예: {'blockedUid1': true, ...})

  User({
     this.uid,
     this.nickName,
     this.email,
     this.profileImageLink,
     this.alramSet,
     this.friendsList,
     this.blockedList,
  });

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    nickName = json['nickName'];
    email = json['email'];
    profileImageLink = json['profileImageLink'];
    alramSet = json['alramSet'];
    friendsList = json['friendsList'];
    blockedList = json['blockedList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['nickName'] = nickName;
    data['email'] = email;
    data['profileImageLink'] = profileImageLink;
    data['alramSet'] = alramSet;
    data['friendsList'] = friendsList;
    data['blockedList'] = blockedList;
    return data;
  }
}

