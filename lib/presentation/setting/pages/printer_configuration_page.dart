import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/manage_printer_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/sync_data_page.dart';
import 'package:flutter_posresto_app/presentation/setting/widgets/bar_printer_page.dart';
import 'package:flutter_posresto_app/presentation/setting/widgets/checker_printer_page.dart';
import 'package:flutter_posresto_app/presentation/setting/widgets/kitchen_printer_page.dart';
import 'package:flutter_posresto_app/presentation/setting/widgets/receipt_printer_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../../home/widgets/floating_header.dart';

class PrinterConfigurationPage extends StatefulWidget {
  final VoidCallback? onToggleSidebar;
  const PrinterConfigurationPage({super.key, this.onToggleSidebar});

  @override
  State<PrinterConfigurationPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<PrinterConfigurationPage> {
  int currentIndex = 0;
  String? role;

  void indexValue(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setRole();
  }

  void setRole() {
    AuthLocalDataSource().getAuthData().then((value) {
      setState(() {
        role = value.user!.role;
      });
    });
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
              title: 'Printer Configuration',
              onToggleSidebar: widget.onToggleSidebar ?? () {}, // Use widget.onToggleSidebar
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
              _buildTabItem(0, 'Receipt', 'Bill & Receipt'),
              const SizedBox(width: 12),
              _buildTabItem(2, 'Kitchen', 'Food Orders'),
              const SizedBox(width: 12),
              _buildTabItem(3, 'Bar', 'Drink Orders'),
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
                'Configuration',
                style: GoogleFonts.quicksand(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildMenuItem(0, 'Receipt Printer', 'To Print bill and receipt'),
              const SizedBox(height: 12),
              _buildMenuItem(2, 'Kitchen Printer', 'To print food to kitchen'),
              const SizedBox(height: 12),
              _buildMenuItem(3, 'Bar Printer', 'To print drink to bar'),
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
        ReceiptPrinterPage(),
        const SizedBox.shrink(), // Placeholder for index 1
        KitchenPrinterPage(),
        BarPrinterPage(),
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

  Widget _buildMenuItem(int index, String title, String subtitle) {
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
            Icon(
              index == 0 ? Icons.receipt_long : (index == 2 ? Icons.kitchen : Icons.local_bar),
              color: isActive ? Colors.white : AppColors.primary,
              size: 24,
            ),
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
