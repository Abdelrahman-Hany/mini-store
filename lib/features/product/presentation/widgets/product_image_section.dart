import 'package:flutter/material.dart';
import 'package:mini_store/core/common/entities/product.dart';

class ProductImageSection extends StatelessWidget {
  const ProductImageSection({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Center(
        child: Hero(
          tag: 'product_image_${product.id}',
          child: Image.network(
            product.image,
            fit: BoxFit.contain,
            height: MediaQuery.of(context).size.height * 0.3,
          ),
        ),
      ),
    );
  }
}