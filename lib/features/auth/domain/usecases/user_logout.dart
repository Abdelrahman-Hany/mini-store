import 'package:fpdart/fpdart.dart';
import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/core/usecase/usecase.dart';
import 'package:mini_store/features/auth/domain/repository/auth_repository.dart';

class UserLogout implements Usecase<void, NoParams> {
  final AuthRepository authRepository;

  UserLogout({required this.authRepository});

  @override
  Future<Either<Failures, void>> call(NoParams params) async {
    return await authRepository.logout();
  }
}