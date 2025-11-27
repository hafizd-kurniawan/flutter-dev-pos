// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_posresto_app/core/components/spaces.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/auth/login_page.dart';
import 'package:flutter_posresto_app/presentation/dashboard/pages/simple_dashboard_page.dart';
import 'package:flutter_posresto_app/presentation/sales/pages/sales_page.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/printer_configuration_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/settings_page.dart';
import 'package:flutter_posresto_app/presentation/table/pages/new_table_management_page.dart';
import 'package:flutter_posresto_app/presentation/table/pages/table_page.dart';
import 'package:flutter_posresto_app/presentation/table/pages/table_management_api_page.dart';
import 'package:flutter_posresto_app/presentation/history/pages/history_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import '../bloc/online_checker/online_checker_bloc.dart';
import '../widgets/nav_item.dart';
import '../widgets/enhanced_nav_item.dart';
import '../widgets/collapsed_nav_item.dart';
import '../widgets/nav_user_info_card.dart';
import 'home_page.dart';

class DashboardPage extends StatefulWidget {
  final int? index;
  final TableModel? table;
  const DashboardPage({
    Key? key,
    this.index = 0,
    this.table,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  TableModel? _selectedTable; // Shared table state
  bool _isSidebarExpanded = false; // Sidebar collapse/expand state

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }
  
  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }
  
  void _onTableSelected(TableModel table) {
    // Update selected table and navigate back to home
    setState(() {
      _selectedTable = table;
      _selectedIndex = 0; // Back to home
    });
    print('✅ Table selected in Dashboard: ${table.name}');
  }
  
  List<Widget> _getPages() {
    return [
      HomePage(
        isTable: false,
        table: _selectedTable,
        onNavigateToTables: () => _onItemTapped(1),
        onPaymentSuccess: () {
          // Reset table selection after successful payment
          setState(() {
            _selectedTable = null;
            print('✅ DashboardPage: Table selection reset after payment');
          });
        },
      ),
      TableManagementApiPage(
        onTableSelected: _onTableSelected,
      ),
      const HistoryPage(),
      const SimpleDashboardPage(), // ← CHANGED from ReportPage!
      const PrinterConfigurationPage(),
      const SettingsPage(),
    ];
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index!;
    _selectedTable = widget.table;
    
    StreamSubscription<List<ConnectivityResult>> subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> connectivityResult) {
      // Received changes in available connectivity types!
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        // Mobile network available.
        context
            .read<OnlineCheckerBloc>()
            .add(const OnlineCheckerEvent.check(true));
      } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
        // Wi-fi is available.
        context
            .read<OnlineCheckerBloc>()
            .add(const OnlineCheckerEvent.check(true));
        // Note for Android:
        // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      } else {
        // Neither mobile network nor Wi-fi available.
        context
            .read<OnlineCheckerBloc>()
            .add(const OnlineCheckerEvent.check(false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            // Animated Sidebar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _isSidebarExpanded ? 250 : 80,
              height: context.deviceHeight - 20.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.85),
                  ],
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                children: [
                  // Hamburger Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: InkWell(
                      onTap: _toggleSidebar,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedRotation(
                              turns: _isSidebarExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 300),
                              child: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            if (_isSidebarExpanded) ...[
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  'Menu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // User Info Card (only when expanded)
                  if (_isSidebarExpanded) ...[
                    const NavUserInfoCard(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Divider(
                        color: Colors.white.withOpacity(0.2),
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Navigation Items (conditional rendering)
                  if (_isSidebarExpanded) ...[
                    EnhancedNavItem(
                      iconPath: Assets.icons.homeResto.path,
                      label: 'POS',
                      isActive: _selectedIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),
                    EnhancedNavItem(
                      iconPath: Assets.icons.kelolaProduk.path,
                      label: 'Tables',
                      isActive: _selectedIndex == 1,
                      onTap: () => _onItemTapped(1),
                    ),
                    EnhancedNavItem(
                      iconPath: Assets.icons.dashboard.path,
                      label: 'History',
                      isActive: _selectedIndex == 2,
                      onTap: () => _onItemTapped(2),
                      badgeCount: 0,
                    ),
                    EnhancedNavItem(
                      iconPath: Assets.icons.report.path,
                      label: 'Dashboard',
                      isActive: _selectedIndex == 3,
                      onTap: () => _onItemTapped(3),
                    ),
                    EnhancedNavItem(
                      iconPath: Assets.icons.print.path,
                      label: 'Printer',
                      isActive: _selectedIndex == 4,
                      onTap: () => _onItemTapped(4),
                    ),
                    EnhancedNavItem(
                      iconPath: Assets.icons.setting.path,
                      label: 'Settings',
                      isActive: _selectedIndex == 5,
                      onTap: () => _onItemTapped(5),
                    ),
                  ] else ...[
                    CollapsedNavItem(
                      iconPath: Assets.icons.homeResto.path,
                      isActive: _selectedIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),
                    CollapsedNavItem(
                      iconPath: Assets.icons.kelolaProduk.path,
                      isActive: _selectedIndex == 1,
                      onTap: () => _onItemTapped(1),
                    ),
                    CollapsedNavItem(
                      iconPath: Assets.icons.dashboard.path,
                      isActive: _selectedIndex == 2,
                      onTap: () => _onItemTapped(2),
                      badgeCount: 0,
                    ),
                    CollapsedNavItem(
                      iconPath: Assets.icons.report.path,
                      isActive: _selectedIndex == 3,
                      onTap: () => _onItemTapped(3),
                    ),
                    CollapsedNavItem(
                      iconPath: Assets.icons.print.path,
                      isActive: _selectedIndex == 4,
                      onTap: () => _onItemTapped(4),
                    ),
                    CollapsedNavItem(
                      iconPath: Assets.icons.setting.path,
                      isActive: _selectedIndex == 5,
                      onTap: () => _onItemTapped(5),
                    ),
                  ],
                  
                  const SizedBox(height: 16),
                      
                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Divider(
                          color: Colors.white.withOpacity(0.2),
                          thickness: 1,
                        ),
                      ),
                      
                      //container flag online/offline
                      BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              padding: _isSidebarExpanded
                                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                                  : const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: _isSidebarExpanded
                                  ? Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.red.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.signal_wifi_off,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Offline',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'No connection',
                                                style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Icon(
                                      Icons.signal_wifi_off,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                            ),
                            online: () {
                              context.read<SyncOrderBloc>().add(
                                    const SyncOrderEvent.syncOrder(),
                                  );
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                padding: _isSidebarExpanded
                                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
                                    : const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: Colors.green.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: _isSidebarExpanded
                                    ? Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.green.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.wifi,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Online',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'Connected',
                                                  style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Icon(
                                        Icons.wifi,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                              );
                            },
                          );
                        },
                      ),

                      BlocListener<LogoutBloc, LogoutState>(
                        listener: (context, state) {
                          state.maybeMap(
                            orElse: () {},
                            error: (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message),
                                  backgroundColor: AppColors.red,
                                ),
                              );
                            },
                            success: (value) {
                              AuthLocalDataSource().removeAuthData();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Logout success'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return const LoginPage();
                              }));
                            },
                          );
                        },
                        child: NavItem(
                          iconPath: Assets.icons.logout.path,
                          isActive: false,
                          onTap: () {
                            context
                                .read<LogoutBloc>()
                                .add(const LogoutEvent.logout());
                          },
                        ),
                      ),
                    ],
                  ),
            ),
            Expanded(
              flex: 10,
              child: IndexedStack(
                index: _selectedIndex,
                children: _getPages(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
