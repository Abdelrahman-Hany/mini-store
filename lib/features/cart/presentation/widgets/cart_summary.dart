import 'package:flutter/material.dart';
import 'package:mini_store/core/common/widgets/gradient_button.dart';
import 'package:mini_store/core/theme/app_pallete.dart';
import 'package:mini_store/core/utils/show_snackbar.dart';

class CartSummary extends StatelessWidget {
  final double totalPrice;
  const CartSummary({super.key, required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0).copyWith(bottom: 24),
      decoration: const BoxDecoration(
        color: AppPallete.borderColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.greyColor),
              ),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppPallete.whiteColor),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child:GradientButton(onPressed: () { showSnackbar(context, 'Checkout feature coming soon!'); }, buttonText: 'Proceed to Checkout',)
          ),
        ],
      ),
    );
  }
}