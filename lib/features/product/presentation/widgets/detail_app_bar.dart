import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:mini_store/core/theme/app_pallete.dart';
import 'package:mini_store/core/utils/show_snackbar.dart';
import 'package:mini_store/features/wishlist/presentation/cubit/wishlist_cubit.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Product product;
  const DetailAppBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppPallete.backgroundColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Details',
        style: TextStyle(
          color: AppPallete.backgroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        BlocBuilder<WishlistCubit, WishlistState>(
          builder: (context, state) {
            final isWishlisted =
                context.read<WishlistCubit>().isInWishlist(product);
            return IconButton(
              icon: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted
                    ? AppPallete.gradient2
                    : AppPallete.backgroundColor,
                size: 28,
              ),
              onPressed: () {
                context.read<WishlistCubit>().toggleWishlist(product);
                showSnackbar(context,
                    isWishlisted ? 'Removed from wishlist' : 'Added to wishlist');
              },
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}