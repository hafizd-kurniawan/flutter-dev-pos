import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationHelper {
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error_outline,
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.blue.shade600,
      icon: Icons.info_outline,
    );
  }

  static void showWarning(BuildContext context, String message) {
    _showSnackBar(
      context,
      message,
      backgroundColor: Colors.orange.shade800,
      icon: Icons.warning_amber_rounded,
    );
  }

  static void _showSnackBar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
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
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
        elevation: 4,
      ),
    );
  }
}
