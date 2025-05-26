import '../data/auth_repository.dart';
import '../../entity/users.dart';

class AuthUseCase {
  final AuthRepository _repository;
  AuthUseCase(this._repository);

  Future<User> signInWithGoogle() => _repository.signInWithGoogle();
  Future<User> signInWithApple() => _repository.signInWithApple();
}
