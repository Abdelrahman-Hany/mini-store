import 'package:flutter/material.dart';
import 'package:mini_store/core/common/widgets/gradient_button.dart';
import 'package:mini_store/core/theme/app_pallete.dart';

class BottomActionBar extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  const BottomActionBar({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: AppPallete.backgroundColor,
        border: Border(
          top: BorderSide(color: AppPallete.borderColor, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppPallete.borderColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.remove), onPressed: onDecrement),
                Text('$quantity',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.add), onPressed: onIncrement),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GradientButton(
              buttonText: 'Add to Cart',
              onPressed: onAddToCart,
            )
          ),
        ],
      ),
    );
  }
}