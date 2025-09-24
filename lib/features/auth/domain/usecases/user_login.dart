import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/core/usecase/usecase.dart';
import 'package:mini_store/core/common/entities/user.dart';
import 'package:mini_store/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements Usecase<User, UserLoginParams> {
  final AuthRepository authRepository;

  UserLogin({required this.authRepository});
  @override
  Future<Either<Failures, User>> call(UserLoginParams params) async{
    return await authRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;
  UserLoginParams({required this.email, required this.password});
}
