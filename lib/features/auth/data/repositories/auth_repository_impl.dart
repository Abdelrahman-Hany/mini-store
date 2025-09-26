import 'package:mini_store/core/constants/constants.dart';
import 'package:mini_store/core/error/exceptions.dart';
import 'package:mini_store/core/error/failures.dart';
import 'package:mini_store/core/network/connection_checker.dart';
import 'package:mini_store/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mini_store/core/common/entities/user.dart';
import 'package:mini_store/features/auth/data/models/user_model.dart';
import 'package:mini_store/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl({required this.connectionChecker, required this.remoteDataSource});

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failures(message: 'User not logged in!'));
        }

        return right(
          UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            name: '',
          ),
        );
      }
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
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPasword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failures, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures(message: Constants.noConnectionErrorMessage));
      }
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failures(message: e.message));
    }
  }
  
  @override
  Future<Either<Failures, void>> logout() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failures(message: Constants.noConnectionErrorMessage));
      }
      await remoteDataSource.logout();
      return right(null);
    } on ServerException catch (e) {
      return left(Failures(message: e.message));
    }
  }
}