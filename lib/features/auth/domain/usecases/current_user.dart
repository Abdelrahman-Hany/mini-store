import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/core/usecase/usecase.dart';
import 'package:mini_store/core/common/entities/user.dart';
import 'package:mini_store/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;
  CurrentUser({required this.authRepository});

  @override
  Future<Either<Failures, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
