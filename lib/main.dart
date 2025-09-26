import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:mini_store/core/common/widgets/main_screen.dart';
import 'package:mini_store/core/theme/theme.dart';
import 'package:mini_store/dependancy_injection.dart';
import 'package:mini_store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_store/features/auth/presentation/bloc/auth_event.dart';
import 'package:mini_store/features/auth/presentation/pages/login_page.dart';
import 'package:mini_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:mini_store/features/product/presentation/bloc/product_bloc.dart';
import 'package:mini_store/features/wishlist/presentation/cubit/wishlist_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider(create: (_) => serviceLocator<ProductBloc>()),
        BlocProvider(create: (_) => serviceLocator<CartCubit>()),
        BlocProvider(create: (_) => serviceLocator<WishlistCubit>()),
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
      title: 'Mini Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: BlocListener<AppUserCubit, AppUserState>(
        listener: (context, state) {
          if (state is AppUserLoggedIn) {
            context.read<CartCubit>().loadUserCart();
            context.read<WishlistCubit>().loadUserWishlist();
          }
        },
        child: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              return const MainScreen();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}