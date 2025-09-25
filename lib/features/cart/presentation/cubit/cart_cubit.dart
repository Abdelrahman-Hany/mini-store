import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/entities/product.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  void addToCart(Product product) {
    final updatedCart = List<Product>.from(state.cartItems)..add(product);
    emit(CartUpdated(updatedCart));
  }

  void removeFromCart(Product product) {
    final updatedCart = List<Product>.from(state.cartItems)
      ..removeWhere((item) => item.id == product.id);
    emit(CartUpdated(updatedCart));
  }
}