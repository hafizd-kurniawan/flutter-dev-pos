import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';

class ModernRefreshButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String tooltip;

  const ModernRefreshButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    this.tooltip = 'Refresh Data',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : const Icon(Icons.refresh_rounded, size: 20),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary.withOpacity(0.1),
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(8),
      ),
      color: AppColors.primary,
    );
  }
}
