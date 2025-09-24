import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_store/core/common/widgets/loader.dart';
import 'package:mini_store/core/utils/show_snackbar.dart';
import 'package:mini_store/features/product/presentation/bloc/product_bloc.dart';
import 'package:mini_store/features/product/presentation/widgets/product_card.dart';

class ProductPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const ProductPage());
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchAllProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Store'),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductFailure) {
            showSnackbar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Loader();
          }
          if (state is FetchSuccess) {
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductCard(product: product);
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}