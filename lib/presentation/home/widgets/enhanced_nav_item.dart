import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/colors.dart';

class EnhancedNavItem extends StatefulWidget {
  final String? iconPath;
  final IconData? icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int? badgeCount;
  final Color color;

  const EnhancedNavItem({
    super.key,
    this.iconPath,
    this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount,
    this.color = AppColors.white,
  }) : assert(iconPath != null || icon != null, 'Either iconPath or icon must be provided');

  @override
  State<EnhancedNavItem> createState() => _EnhancedNavItemState();
}

class _EnhancedNavItemState extends State<EnhancedNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: widget.isActive
                ? Colors.white.withOpacity(0.2)
                : _isHovered
                    ? Colors.white.withOpacity(0.1)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
            border: widget.isActive
                ? Border.all(color: Colors.white.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Row(
            children: [
              // Icon with badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: widget.icon != null
                        ? Icon(
                            widget.icon,
                            color: widget.color,
                            size: 24.0,
                          )
                        : SvgPicture.asset(
                            widget.iconPath!,
                            colorFilter: ColorFilter.mode(
                              widget.color,
                              BlendMode.srcIn,
                            ),
                          ),
                  ),
                  if (widget.badgeCount != null && widget.badgeCount! > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Center(
                          child: Text(
                            widget.badgeCount! > 99 ? '99+' : '${widget.badgeCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Label
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    color: widget.color,
                    fontSize: 14,
                    fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              // Active indicator
              if (widget.isActive)
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
