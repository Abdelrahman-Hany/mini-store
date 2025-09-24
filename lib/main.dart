import 'package:mini_store/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:mini_store/core/theme/theme.dart';
import 'package:mini_store/dependancy_injection.dart';
import 'package:mini_store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_store/features/auth/presentation/bloc/auth_event.dart';
import 'package:mini_store/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/features/product/presentation/bloc/product_bloc.dart';
import 'package:mini_store/features/product/presentation/pages/product_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<ProductBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context.read<AuthBloc>().add(CheckCurrentUserEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        // we used BlocSelector to catch one state in AppUserCubit which is AppUserLoggedIn state
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, state) {
          if (state) {
            return const ProductPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
