import 'package:http/http.dart' as http;
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
import 'package:mini_store/features/product/data/datasources/product_remote_data_source.dart';
import 'package:mini_store/features/product/data/repositories/product_repository_impl.dart';
import 'package:mini_store/features/product/domain/repositories/product_repository.dart' show ProductRepository;
import 'package:mini_store/features/product/domain/usecases/get_all_products.dart';
import 'package:mini_store/features/product/presentation/bloc/product_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  _initAuth();
  _initProduct();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(
    () => supabase.client,
  );

  serviceLocator.registerLazySingleton(() => http.Client());

  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
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


void _initProduct() {
  serviceLocator
    ..registerFactory<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(serviceLocator()),
    )
    ..registerFactory<ProductRepository>(
      () => ProductRepositoryImpl(remoteDataSource:serviceLocator()),
    )
    ..registerFactory(
      () => GetAllProducts(productRepository: serviceLocator()),
    )
    ..registerLazySingleton(
      () => ProductBloc(
        getAllProducts: serviceLocator(),
      ),
    );
}