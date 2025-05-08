import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studyhive/utils/constants.dart';

/// Dialog to display errors
class ErrorDialog extends StatelessWidget {
  /// The error title
  final String title;

  /// The error message
  final String message;

  /// Creates an ErrorDialog
  const ErrorDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          color: AppConstants.errorColor,
        ),
      ),
      content: Text(
        message,
        style: GoogleFonts.poppins(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppConstants.primaryColor,
          ),
          child: Text(
            'OK',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
} 