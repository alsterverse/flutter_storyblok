import 'package:example/colors.dart';
import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      content: Text(
        message,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.white),
      ),
      behavior: SnackBarBehavior.floating,
      shape: const StadiumBorder(),
      backgroundColor: error ? AppColors.danger : AppColors.primary,
    ));
}
