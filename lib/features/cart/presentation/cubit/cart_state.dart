part of 'cart_cubit.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

@immutable
sealed class CartState {
  final List<CartItem> cartItems;
  const CartState(this.cartItems);
}

final class CartInitial extends CartState {
  CartInitial() : super([]);
}

final class CartUpdated extends CartState {
  const CartUpdated(super.cartItems);
}