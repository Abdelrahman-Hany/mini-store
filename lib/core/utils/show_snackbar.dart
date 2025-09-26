import 'package:flutter/material.dart';
import 'package:mini_store/core/common/widgets/custom_snackbar.dart';
import 'package:mini_store/core/theme/app_pallete.dart';

void showSnackbar(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      CustomSnackbar(
        message: message,
        icon: isError ? Icons.error_outline : Icons.check_circle_outline,
        backgroundColor: isError ? AppPallete.errorColor : Colors.green.shade600,
      ),
    );
}