import 'package:flutter/material.dart';
import 'package:machine_test/core/theme/app_color.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double width;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.width = double.maxFinite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : null,
          borderRadius: BorderRadius.circular(10),
          gradient: isLoading
              ? null
              : const LinearGradient(
                  colors: [AppColor.primaryBlue, AppColor.primaryRed],
                ),
        ),
        child: isLoading
            ? const CircularProgressIndicator()
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
