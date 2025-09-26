import 'package:flutter/material.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:mini_store/core/common/widgets/gradient_button.dart';
import 'package:mini_store/core/theme/app_pallete.dart';
import 'package:mini_store/features/product/presentation/pages/product_detail_page.dart';

class WishlistItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromWishlist;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromWishlist,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(ProductDetailPage.route(product)); 
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: AppPallete.borderColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8),
                child: Image.network(product.image, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppPallete.whiteColor),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(color: AppPallete.gradient2),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onRemoveFromWishlist,
                    icon: const Icon(Icons.delete_outline,
                        color: AppPallete.errorColor),
                  ),
                  SizedBox(
                    width: 79,
                    height: 30,
                    child: GradientButton(
                      onPressed: onAddToCart,
                      buttonText: 'Add',
                    ),
                  ),  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}