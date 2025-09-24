import 'package:mini_store/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:mini_store/core/secrets/app_secrets.dart';
import 'package:mini_store/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mini_store/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mini_store/features/auth/domain/repository/auth_repository.dart';
import 'package:mini_store/features/auth/domain/usecases/current_user.dart';
import 'package:mini_store/features/auth/domain/usecases/user_login.dart';
import 'package:mini_store/features/auth/domain/usecases/user_sign_up.dart';
import 'package:mini_store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void initAuth() {
  //Data source
  serviceLocator..registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator(),
    ),
  )

  //Repository
  ..registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
     remoteDataSource: serviceLocator(),
    ),
  )

  //Usecases
  ..registerFactory(
    () => UserSignUp(
     authRepository: serviceLocator(),
    ),
  )

  ..registerFactory(() => UserLogin(authRepository: serviceLocator()))

  ..registerFactory(() => CurrentUser(authRepository: serviceLocator()))

  //Bloc
  ..registerLazySingleton(
    () => AuthBloc(
      userSignUp:
          serviceLocator(), 

      userLogin: serviceLocator(),

      currentUser: serviceLocator(),

      appUserCubit: serviceLocator(),
    ),
  );
}
