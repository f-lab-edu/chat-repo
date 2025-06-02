import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../entity/users.dart'; // User 엔터티 import

class AuthRepository {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 구글 로그인
  Future<Users> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('구글 로그인 취소됨');

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = fb_auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final fb_auth.UserCredential authResult =
    await _auth.signInWithCredential(credential);

    return await _saveOrFetchUser(authResult.user,
      nickName: googleUser.displayName,
      email: googleUser.email,
      profileImageLink: googleUser.photoUrl,
    );
  }

  // 애플 로그인 (iOS only)
  Future<Users> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = fb_auth.OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    final fb_auth.UserCredential authResult =
    await _auth.signInWithCredential(oauthCredential);

    // Apple은 최초 로그인 시에만 이름/이메일 제공
    return await _saveOrFetchUser(
      authResult.user,
      nickName: appleCredential.givenName ?? 'AppleUser',
      email: appleCredential.email ?? authResult.user?.email,
      profileImageLink: null,
    );
  }

  // Firestore에 유저 정보 저장(최초 로그인 시) 또는 기존 정보 반환
  Future<Users> _saveOrFetchUser(
      fb_auth.User? fbUser, {
        String? nickName,
        String? email,
        String? profileImageLink,
      }) async {
    if (fbUser == null) throw Exception('인증 실패');
    final doc = _firestore.collection('Users').doc(fbUser.uid);
    final snapshot = await doc.get();
    if (!snapshot.exists) {
      final user = Users(
        uid: fbUser.uid,
        nickName: nickName,
        email: email ?? fbUser.email,
        profileImageLink: profileImageLink,
        alramSet: true,
        friendsList: {},
        blockedList: {},
      );
      await doc.set(user.toJson());
      return user;
    } else {
      return Users.fromJson(snapshot.data()!);
    }
  }

  Future<void> signOut() async {
    await fb_auth.FirebaseAuth.instance.signOut();
  }

}
