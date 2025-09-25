import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/widgets/loader.dart';
import 'package:mini_store/core/utils/show_snackbar.dart';
import 'package:mini_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:mini_store/features/product/presentation/bloc/product_bloc.dart';
import 'package:mini_store/features/product/presentation/widgets/product_card.dart';
import 'package:mini_store/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    // Fetch products if they haven't been fetched yet
    if (context.read<ProductBloc>().state is! FetchSuccess) {
      context.read<ProductBloc>().add(FetchAllProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    // This widget no longer has a Scaffold or AppBar
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductFailure) {
          showSnackbar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ProductLoading || state is ProductInitial) {
          return const Loader();
        }
        if (state is FetchSuccess) {
          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.58,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, wishlistState) {
                  final isWishlisted =
                      wishlistState.wishlistProductIds.contains(product.id);
                  return ProductCard(
                    product: product,
                    isWishlisted: isWishlisted,
                    onAddToCartPressed: () {
                      context.read<CartCubit>().addToCart(product);
                      showSnackbar(context, '${product.title} added to cart!');
                    },
                    onWishlistPressed: () {
                      context.read<WishlistCubit>().toggleWishlist(product);
                      showSnackbar(
                        context,
                        isWishlisted
                            ? 'Removed from wishlist'
                            : 'Added to wishlist',
                      );
                    },
                  );
                },
              );
            },
          );
        }
        return const Center(child: Text("No products found!"));
      },
    );
  }
}