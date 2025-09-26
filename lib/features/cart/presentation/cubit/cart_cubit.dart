import 'dart:convert';
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

  double get totalPrice {
    return state.cartItems.fold(
        0.0, (total, current) => total + (current.product.price * current.quantity));
  }

  Future<void> loadUserCart() async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final cartKey = 'cart_$userId';
    final cartJsonStringList = prefs.getStringList(cartKey) ?? [];

    final cartItems = cartJsonStringList.map((jsonString) {
      final map = json.decode(jsonString);
      return CartItem(
        product: Product.fromMap(map['product']),
        quantity: map['quantity'],
      );
    }).toList();

    emit(CartUpdated(cartItems));
  }

  Future<void> _saveCart(List<CartItem> cartItems) async {
    final userId = _getCurrentUserId();
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final cartKey = 'cart_$userId';
    final cartJsonStringList = cartItems.map((item) {
      return json.encode({
        'product': item.product.toMap(),
        'quantity': item.quantity,
      });
    }).toList();
    await prefs.setStringList(cartKey, cartJsonStringList);
  }

  void addToCart(Product product) {
    final currentState = state.cartItems;
    final existingItemIndex =
        currentState.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      currentState[existingItemIndex].quantity++;
    } else {
      currentState.add(CartItem(product: product));
    }

    emit(CartUpdated(List.from(currentState)));
    _saveCart(currentState);
  }

  void removeFromCart(CartItem cartItem) {
    final updatedCart = List<CartItem>.from(state.cartItems)
      ..removeWhere((item) => item.product.id == cartItem.product.id);
    emit(CartUpdated(updatedCart));
    _saveCart(updatedCart);
  }

  void incrementQuantity(CartItem cartItem) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    final itemIndex = updatedCart.indexWhere((item) => item.product.id == cartItem.product.id);
    if(itemIndex != -1) {
      updatedCart[itemIndex].quantity++;
      emit(CartUpdated(updatedCart));
      _saveCart(updatedCart);
    }
  }

  void decrementQuantity(CartItem cartItem) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    final itemIndex = updatedCart.indexWhere((item) => item.product.id == cartItem.product.id);
    if(itemIndex != -1 && updatedCart[itemIndex].quantity > 1) {
      updatedCart[itemIndex].quantity--;
      emit(CartUpdated(updatedCart));
      _saveCart(updatedCart);
    }
  }

  void clearCart() {
    emit(CartInitial());
  }
}