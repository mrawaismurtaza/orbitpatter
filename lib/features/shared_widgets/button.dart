import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final String? leadingImage;
  final double? width;
  final double? height;
  const CustomButton({super.key, required this.text, required this.onPressed, this.icon, this.color, this.leadingImage, this.width, this.height});

  @override
  Widget build(BuildContext context) {

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final TextStyle textStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: colorScheme.onPrimary,
      fontSize: 16,
    ) ?? TextStyle(
      color: colorScheme.onPrimary,
      fontSize: 16,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? colorScheme.primary,
        minimumSize: Size(width ?? 100, height ?? 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (leadingImage != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(
                leadingImage!,
                width: 24,
                height: 24,
              ),
            ),
          if (icon != null)
            Icon(icon, size: 24, color: colorScheme.onPrimary),
          const SizedBox(width: 8.0),
          Text(
            text,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}