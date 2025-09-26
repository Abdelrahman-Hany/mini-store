import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/widgets/loader.dart';
import 'package:mini_store/core/utils/show_snackbar.dart';
import 'package:mini_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:mini_store/features/product/presentation/bloc/product_bloc.dart';
import 'package:mini_store/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:mini_store/features/wishlist/presentation/widgets/empty_wishlist.dart';
import 'package:mini_store/features/wishlist/presentation/widgets/wishlist_item_card.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, productState) {
        if (productState is ProductLoading || productState is ProductInitial) {
          return const Loader();
        }
        if (productState is FetchSuccess) {
          return BlocBuilder<WishlistCubit, WishlistState>(
            builder: (context, wishlistState) {
              final wishlistedProducts = productState.products
                  .where((product) =>
                      wishlistState.wishlistProductIds.contains(product.id))
                  .toList();

              if (wishlistedProducts.isEmpty) {
                return const EmptyWishlistView();
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: wishlistedProducts.length,
                itemBuilder: (context, index) {
                  final product = wishlistedProducts[index];
                  return WishlistItemCard(
                    product: product,
                    onRemoveFromWishlist: () {
                      context.read<WishlistCubit>().toggleWishlist(product);
                      showSnackbar(context, 'Removed from wishlist');
                    },
                    onAddToCart: () {
                      context.read<CartCubit>().addToCart(product);
                      showSnackbar(context, '${product.title} added to cart!');
                    },
                  );
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}