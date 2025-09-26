import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:mini_store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mini_store/features/auth/presentation/bloc/auth_event.dart';
import 'package:mini_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:mini_store/features/cart/presentation/page/cart_page.dart';
import 'package:mini_store/features/product/presentation/pages/product_page.dart';
import 'package:mini_store/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:mini_store/features/wishlist/presentation/pages/wishlist_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ProductPage(),
    const WishlistPage(),
    const CartPage(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<String> _pageTitles = ['Mini Store', 'My Wishlist', 'My Cart'];

    void _logout() {
    context.read<CartCubit>().clearCart();
    context.read<WishlistCubit>().clearWishlist();

    context.read<AuthBloc>().add(AuthLogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<AppUserCubit, AppUserState>(
          builder: (context, state) {
            if (state is AppUserLoggedIn) {
              if (_currentIndex == 0) {
                return Text('Welcome, ${state.user.name}!');
              }
            }
            return Text(_pageTitles[_currentIndex]);
          },
        ),
        actions: [
          BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, state) {
              return Badge(
                label: Text(state.wishlistProductIds.length.toString()),
                isLabelVisible: state.wishlistProductIds.isNotEmpty,
                child: IconButton(
                  onPressed: () => _onTabTapped(1),
                  icon: Icon(
                    _currentIndex == 1
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                  ),
                ),
              );
            },
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Badge(
                label: Text(state.cartItems.length.toString()),
                isLabelVisible: state.cartItems.isNotEmpty,
                child: IconButton(
                  onPressed: () => _onTabTapped(2),
                  icon: Icon(
                    _currentIndex == 2
                        ? Icons.shopping_cart
                        : Icons.shopping_cart_outlined,
                  ),
                ),
              );
            },
          ),
           IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}