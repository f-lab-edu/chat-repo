import 'package:flutter/material.dart';
import '../domain/auth_use_case.dart';
import '../../entity/users.dart';

class AuthViewModel with ChangeNotifier {
  final AuthUseCase useCase;

  bool isLoading = false;
  String? errorMessage;
  User? user;

  AuthViewModel(this.useCase);

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
}
