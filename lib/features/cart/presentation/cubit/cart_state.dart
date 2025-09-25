part of 'cart_cubit.dart';

@immutable
sealed class CartState {
  final List<Product> cartItems;
  const CartState(this.cartItems);
}

final class CartInitial extends CartState {
  CartInitial() : super([]);
}

final class CartUpdated extends CartState {
  const CartUpdated(super.cartItems);
}