import '../data/auth_repository.dart';
import '../../entity/users.dart';

class AuthUseCase {
  final AuthRepository _repository;
  AuthUseCase(this._repository);

  Future<Users> signInWithGoogle() => _repository.signInWithGoogle();
  Future<Users> signInWithApple() => _repository.signInWithApple();

  Future<void> signOut() async => await _repository.signOut();

}
