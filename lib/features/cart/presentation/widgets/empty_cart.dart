import 'package:flutter/material.dart';
import 'package:mini_store/core/theme/app_pallete.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: AppPallete.borderColor),
          SizedBox(height: 20),
          Text(
            'Your Cart is Empty',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Looks like you haven\'t added anything to your cart yet.',
              style: TextStyle(fontSize: 16, color: AppPallete.greyColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}