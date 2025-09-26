import 'package:flutter/material.dart';
import 'package:mini_store/core/theme/app_pallete.dart';

class EmptyWishlistView extends StatelessWidget {
  const EmptyWishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 80, color: AppPallete.borderColor),
          SizedBox(height: 20),
          Text(
            'Your Wishlist is Empty',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Tap the heart on any product to save it here.',
              style: TextStyle(fontSize: 16, color: AppPallete.greyColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}