import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/core/usecase/usecase.dart';
import 'package:mini_store/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/common/entities/user.dart';

class UserSignUp implements Usecase<User, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp({required this.authRepository});

  @override
  Future<Either<Failures, User>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;
  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
