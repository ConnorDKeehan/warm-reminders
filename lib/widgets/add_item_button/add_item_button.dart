import 'package:flutter/material.dart';
import 'package:warmreminders/styles/app_colors.dart';

class AddItemButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddItemButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.submitButtonColor, // background color
          borderRadius: BorderRadius.circular(12), // rounded rectangle
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: onPressed,
        ));
  }
}
