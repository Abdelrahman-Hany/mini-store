import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final AppUserCubit _appUserCubit;
  CartCubit({required AppUserCubit appUserCubit})
      : _appUserCubit = appUserCubit,
        super(CartInitial());

  String? _getCurrentUserId() {
    final state = _appUserCubit.state;
    if (state is AppUserLoggedIn) {
      return state.user.id;
    }
    return null;
  }

  Future<void> loadUserCart() async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final cartKey = 'cart_$userId';
    final cartJsonStringList = prefs.getStringList(cartKey) ?? [];

    final cartProducts = cartJsonStringList
        .map((jsonString) => Product.fromJson(jsonString))
        .toList();

    emit(CartUpdated(cartProducts));
  }

  Future<void> _saveCart(List<Product> products) async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final cartKey = 'cart_$userId';
    final cartJsonStringList =
        products.map((product) => product.toJson()).toList();
    await prefs.setStringList(cartKey, cartJsonStringList);
  }

  void addToCart(Product product) {
    final updatedCart = List<Product>.from(state.cartItems)..add(product);
    emit(CartUpdated(updatedCart));
    _saveCart(updatedCart);
  }

  void removeFromCart(Product product) {
    final updatedCart = List<Product>.from(state.cartItems)
      ..removeWhere((item) => item.id == product.id);
    emit(CartUpdated(updatedCart));
    _saveCart(updatedCart);
  }

  void clearCart() {
    emit(CartInitial());
  }
}