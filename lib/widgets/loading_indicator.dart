import 'package:flutter/material.dart';
import 'package:studyhive/utils/constants.dart';

/// Loading indicator with the app's primary color
class LoadingIndicator extends StatelessWidget {
  /// Size of the indicator
  final double size;

  /// Width of the indicator
  final double width;

  /// Color of the indicator
  final Color? color;

  /// Creates a LoadingIndicator
  const LoadingIndicator({
    super.key,
    this.size = 36,
    this.width = 3.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: width,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppConstants.primaryColor,
        ),
      ),
    );
  }
} 