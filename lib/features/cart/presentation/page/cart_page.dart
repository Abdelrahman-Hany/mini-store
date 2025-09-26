import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:mini_store/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:mini_store/features/cart/presentation/widgets/cart_summary.dart';
import 'package:mini_store/features/cart/presentation/widgets/empty_cart.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.cartItems.isEmpty) {
          return const EmptyCartView();
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: state.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = state.cartItems[index];
                  return CartItemCard(
                    cartItem: cartItem,
                    onIncrement: () =>
                        context.read<CartCubit>().incrementQuantity(cartItem),
                    onDecrement: () =>
                        context.read<CartCubit>().decrementQuantity(cartItem),
                    onRemove: () =>
                        context.read<CartCubit>().removeFromCart(cartItem),
                  );
                },
              ),
            ),
            CartSummary(totalPrice: context.read<CartCubit>().totalPrice),
          ],
        );
      },
    );
  }
}