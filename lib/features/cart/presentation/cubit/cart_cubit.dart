import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_state.dart';

const String cartKey = 'cart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial()) {
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJsonStringList = prefs.getStringList(cartKey) ?? [];
    
    final cartProducts = cartJsonStringList
        .map((jsonString) => Product.fromJson(jsonString))
        .toList();
        
    emit(CartUpdated(cartProducts));
  }

  Future<void> _saveCart(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
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
}