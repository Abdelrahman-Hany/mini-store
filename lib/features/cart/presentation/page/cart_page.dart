import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/theme/app_pallete.dart';
import 'package:mini_store/features/cart/presentation/cubit/cart_cubit.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.cartItems.isEmpty) {
          return const Center(
            child: Text('Your cart is empty!'),
          );
        }
        return ListView.builder(
          itemCount: state.cartItems.length,
          itemBuilder: (context, index) {
            final product = state.cartItems[index];
            return Card(
              color: AppPallete.borderColor,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: Image.network(product.image, width: 50, height: 50),
                title: Text(
                  product.title,
                  style: const TextStyle(color: AppPallete.whiteColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(color: AppPallete.gradient2),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_shopping_cart,
                      color: AppPallete.errorColor),
                  onPressed: () {
                    context.read<CartCubit>().removeFromCart(product);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}