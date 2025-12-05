import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/manage_printer_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/sync_data_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/notifications_settings_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/about_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../home/widgets/floating_header.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onToggleSidebar;
  const SettingsPage({super.key, this.onToggleSidebar});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int currentIndex = 0;

  void indexValue(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF), // App Background
      body: Stack(
        children: [
          // 1. Main Content
          LayoutBuilder(
            builder: (context, constraints) {
              final isTight = constraints.maxWidth < 800; // Mobile/Tablet breakpoint
              final margin = isTight ? 16.0 : 24.0;
              
              return Padding(
                padding: EdgeInsets.only(top: 100.0, left: margin, right: margin, bottom: 24.0),
                child: isTight
                    ? _buildMobileLayout()
                    : _buildDesktopLayout(),
              );
            },
          ),
          
          // 2. Floating Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FloatingHeader(
              title: 'Settings',
              onToggleSidebar: widget.onToggleSidebar ?? () {},
              isSidebarVisible: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Horizontal Tabs
        SizedBox(
          height: 40, // Reduced height
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildTabItem(0, 'Sync Data', 'Server Sync'),
              const SizedBox(width: 12),
              _buildTabItem(1, 'Notifications', 'Preferences'),
              const SizedBox(width: 12),
              _buildTabItem(2, 'About', 'App Info'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Content Area
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT CONTENT (Menu)
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: GoogleFonts.quicksand(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuItem(0, 'Sync Data', 'Sinkronisasi data dari dan ke server', Assets.icons.kelolaPajak.svg(width: 24, height: 24, color: currentIndex == 0 ? Colors.white : AppColors.primary)),
              const SizedBox(height: 12),
              _buildMenuItem(1, 'Notifications', 'Manage notification preferences', Icon(Icons.notifications, color: currentIndex == 1 ? Colors.white : AppColors.primary)),
              const SizedBox(height: 12),
              _buildMenuItem(2, 'About & Help', 'App info and support', Icon(Icons.info, color: currentIndex == 2 ? Colors.white : AppColors.primary)),
            ],
          ),
        ),
        const SizedBox(width: 24),
        
        // RIGHT CONTENT (Details)
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return IndexedStack(
      index: currentIndex,
      children: [
        SyncDataPage(),
        NotificationsSettingsPage(),
        AboutPage(),
      ],
    );
  }

  Widget _buildTabItem(int index, String title, String subtitle) {
    final bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => indexValue(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Adjusted padding
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(100), // Pill shape
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.grey[300]!,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2), // Lighter shadow
                    blurRadius: 4, // Reduced blur
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.quicksand(
            color: isActive ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
            fontSize: 13, // Slightly smaller font
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(int index, String title, String subtitle, Widget icon) {
    final bool isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => indexValue(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.quicksand(
                      color: isActive ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.quicksand(
                      color: isActive ? Colors.white.withOpacity(0.8) : Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isActive)
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}
