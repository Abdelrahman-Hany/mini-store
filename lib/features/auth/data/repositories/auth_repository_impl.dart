import 'package:mini_store/core/error/exceptions.dart';
import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mini_store/core/common/entities/user.dart';
import 'package:mini_store/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failures(message: 'User not logged in!'));
      }
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(message: e.message));
    }
  }

  @override
  Future<Either<Failures, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.loginWithEmailPasword(
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(message: e.message));
    }
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
      return right(user);
    } on ServerException catch (e) {
      return left(Failures(message: e.message));
    }
  }

  Future<Either<Failures, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return right(null);
    } on ServerException catch (e) {
      return left(Failures(message: e.message));
    }
  }
}
