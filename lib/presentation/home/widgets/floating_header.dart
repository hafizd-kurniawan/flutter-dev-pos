import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingHeader extends StatelessWidget {
  final String title;
  final VoidCallback onToggleSidebar;
  final bool isSidebarVisible;
  final List<Widget>? actions;

  const FloatingHeader({
    Key? key,
    required this.title,
    required this.onToggleSidebar,
    required this.isSidebarVisible,
    this.actions,
    this.useBackIcon = false, // NEW: Flag for Back Button
  }) : super(key: key);

  final bool useBackIcon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Determine layout mode based on available width
          // < 600px usually means Mobile or Sidebar Open on Tablet
          final isTightSpace = constraints.maxWidth < 600;
          final margin = isTightSpace ? 8.0 : 24.0;

          return Container(
            margin: EdgeInsets.all(margin),
            padding: EdgeInsets.symmetric(horizontal: isTightSpace ? 8.0 : 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: isTightSpace
                ? _buildSafeRowLayout() // Mobile/Tight: No Overlap
                : _buildCenteredStackLayout(), // Desktop: True Center
          );
        },
      ),
    );
  }

  // Option A (Modified): Safe Row for Mobile/Tight Spaces
  // Prevents Title from overlapping Actions
  Widget _buildSafeRowLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 1. Left: Menu / Back
        _buildLeadingButton(),

        // 2. Center: Title (Expanded to fill available space)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),

        // 3. Right: Actions
        Row(
          mainAxisSize: MainAxisSize.min,
          children: actions ?? [],
        ),
      ],
    );
  }

  // Option A (Original): True Center Stack for Desktop
  Widget _buildCenteredStackLayout() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Left
        Align(
          alignment: Alignment.centerLeft,
          child: _buildLeadingButton(),
        ),

        // 2. Center
        Align(
          alignment: Alignment.center,
          child: Text(
            title,
            style: GoogleFonts.quicksand(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // 3. Right
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: actions ?? [],
          ),
        ),
      ],
    );
  }

  Widget _buildLeadingButton() {
    return InkWell(
      onTap: onToggleSidebar,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSidebarVisible ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          useBackIcon ? Icons.arrow_back_rounded : Icons.menu_rounded,
          color: AppColors.primary,
          size: 24.0,
        ),
      ),
    );
  }
}
