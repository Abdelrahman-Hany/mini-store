import 'package:flutter/material.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:mini_store/core/theme/app_pallete.dart';

class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      transform: Matrix4.translationValues(0, -30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  product.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.gradient2),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
              const SizedBox(width: 4),
              Text(
                '${product.rating.rate} (${product.rating.count} Reviews)',
                style:
                    const TextStyle(color: AppPallete.greyColor, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            product.description,
            style: const TextStyle(
                fontSize: 15, color: AppPallete.greyColor, height: 1.6),
          ),
        ],
      ),
    );
  }
}