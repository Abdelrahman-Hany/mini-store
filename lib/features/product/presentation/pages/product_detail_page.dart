import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/entities/product.dart';
import 'package:mini_store/core/utils/show_snackbar.dart';
import 'package:mini_store/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:mini_store/features/product/presentation/widgets/bottom_action_bar.dart';
import 'package:mini_store/features/product/presentation/widgets/detail_app_bar.dart';
import 'package:mini_store/features/product/presentation/widgets/product_details_section.dart';
import 'package:mini_store/features/product/presentation/widgets/product_image_section.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  static route(Product product) => MaterialPageRoute(
        builder: (context) => ProductDetailPage(product: product),
      );

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int _currentQuantity = 1;

  void _incrementQuantity() => setState(() => _currentQuantity++);
  void _decrementQuantity() =>
      setState(() => _currentQuantity > 1 ? _currentQuantity-- : null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBar(product: widget.product),
      body: Column(
        children: [
          ProductImageSection(product: widget.product),
          SizedBox(height: 30,),
          Expanded(
            child: SingleChildScrollView(
              child: ProductDetailsSection(product: widget.product),
            ),
          ),
          BottomActionBar(
            quantity: _currentQuantity,
            onIncrement: _incrementQuantity,
            onDecrement: _decrementQuantity,
            onAddToCart: () {
              for (int i = 0; i < _currentQuantity; i++) {
                context.read<CartCubit>().addToCart(widget.product);
              }
              showSnackbar(context,
                  '${_currentQuantity}x ${widget.product.title} added to cart!');
            },
          ),
        ],
      ),
    );
  }
}