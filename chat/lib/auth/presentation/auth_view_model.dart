import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../domain/auth_use_case.dart';
import '../../entity/users.dart';

class AuthViewModel with ChangeNotifier {

  final FirebaseAuth firebaseAuth;

  final AuthUseCase useCase;

  bool isLoading = false;
  String? errorMessage;
  Users? user;

  AuthViewModel(this.useCase, {FirebaseAuth? firebaseAuth})
      : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      user = await useCase.signInWithGoogle();
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithApple() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      user = await useCase.signInWithApple();
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  // 인증 상태 스트림 노출
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await useCase.signOut();
    notifyListeners();
  }
}
