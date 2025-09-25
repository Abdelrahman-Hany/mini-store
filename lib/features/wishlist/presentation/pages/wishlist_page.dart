import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/widgets/loader.dart';
import 'package:mini_store/core/theme/app_pallete.dart';
import 'package:mini_store/features/product/presentation/bloc/product_bloc.dart';
import 'package:mini_store/features/wishlist/presentation/cubit/wishlist_cubit.dart';

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
                return const Center(
                  child: Text('Your wishlist is empty!'),
                );
              }

              return ListView.builder(
                itemCount: wishlistedProducts.length,
                itemBuilder: (context, index) {
                  final product = wishlistedProducts[index];
                  return Card(
                    color: AppPallete.borderColor,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      leading:
                          Image.network(product.image, width: 50, height: 50),
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
                        icon: const Icon(Icons.favorite,
                            color: AppPallete.gradient2),
                        onPressed: () {
                          context
                              .read<WishlistCubit>()
                              .toggleWishlist(product);
                        },
                      ),
                    ),
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