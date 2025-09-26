import 'package:flutter/material.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:mini_store/core/theme/app_pallete.dart';
import 'package:mini_store/core/common/widgets/gradient_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isWishlisted;
  final VoidCallback onAddToCartPressed;
  final VoidCallback onWishlistPressed;

  const ProductCard({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.onAddToCartPressed,
    required this.onWishlistPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: AppPallete.borderColor.withOpacity(0.5),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted
                            ? AppPallete.gradient2
                            : Colors.white,
                      ),
                      onPressed: onWishlistPressed,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Text(
              product.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppPallete.whiteColor,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: AppPallete.gradient2,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${product.rating.rate} (${product.rating.count})',
                  style: const TextStyle(color: AppPallete.greyColor),
                ),
                const Spacer(),
                SizedBox(
                  width: 79,
                  height: 30,
                  child: GradientButton(
                    buttonText: 'Add',
                    onPressed: onAddToCartPressed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
