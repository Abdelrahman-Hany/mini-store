import 'package:flutter/material.dart';
import 'package:mini_store/core/theme/app_pallete.dart';

class CustomSnackbar extends SnackBar {
  CustomSnackbar({
    super.key,
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) : super(
          content: Row(
            children: [
              Icon(icon, color: AppPallete.whiteColor, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppPallete.whiteColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(10),
          elevation: 6,
          duration: const Duration(seconds: 2),
        );
}