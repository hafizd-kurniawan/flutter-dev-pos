// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:developer';


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
import 'package:flutter_posresto_app/presentation/setting/pages/printer_configuration_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/settings_page.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';
import 'package:flutter_posresto_app/presentation/table/pages/new_table_management_page.dart';
import 'package:flutter_posresto_app/presentation/table/pages/table_page.dart';
import 'package:flutter_posresto_app/presentation/table/pages/table_management_api_page.dart';
import 'package:flutter_posresto_app/presentation/history/pages/history_page.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/settings/settings_bloc.dart'; // NEW IMPORT
import 'package:flutter_posresto_app/presentation/home/bloc/notification/notification_bloc.dart'; // NEW IMPORT
import 'package:flutter_posresto_app/presentation/history/bloc/history/history_bloc.dart'; // NEW IMPORT

import '../../../core/assets/assets.gen.dart';
import '../../auth/bloc/logout/logout_bloc.dart';
import '../widgets/nav_item.dart';
import '../widgets/enhanced_nav_item.dart';
import '../widgets/collapsed_nav_item.dart';
import '../widgets/nav_user_info_card.dart';
import 'home_page.dart';

import 'package:flutter_posresto_app/core/services/notification_service.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/floating_header.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';

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

class _DashboardPageState extends State<DashboardPage> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  TableModel? _selectedTable; // Shared table state
  bool _isSidebarVisible = true; // Sidebar visible (Rail) or hidden

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }
  
  void _toggleSidebar() {
    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
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
        onToggleSidebar: _toggleSidebar, // Pass callback to HomePage
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
        onToggleSidebar: _toggleSidebar,
      ),
      HistoryPage(onToggleSidebar: _toggleSidebar),
      SimpleDashboardPage(onToggleSidebar: _toggleSidebar), // ← CHANGED from ReportPage!
      PrinterConfigurationPage(onToggleSidebar: _toggleSidebar),
      SettingsPage(onToggleSidebar: _toggleSidebar),
    ];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Add observer
    
    // Initialize Notification Service
    NotificationService().init();
    
    // Start polling for new orders
    context.read<NotificationBloc>().add(const NotificationEvent.startPolling());
    
    _selectedIndex = widget.index!;
    _selectedTable = widget.table;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App is visible/active -> Start Polling
      print('📱 App Resumed: Starting Polling');
      context.read<NotificationBloc>().add(const NotificationEvent.startPolling());
      
      // Also refresh settings or other critical data if needed
      // context.read<SettingsBloc>().add(const SettingsEvent.fetchSettings());
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App is background/inactive -> Stop Polling
      print('zzz App Paused: Stopping Polling');
      context.read<NotificationBloc>().add(const NotificationEvent.stopPolling());
    }
  }

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return AppLocalizations.of(context)!.menu_order_title;
      case 1:
        return AppLocalizations.of(context)!.table_management_title;
      case 2:
        return AppLocalizations.of(context)!.history_title;
      case 3:
        return AppLocalizations.of(context)!.dashboard_title;
      case 4:
        return AppLocalizations.of(context)!.printer_title;
      case 5:
        return AppLocalizations.of(context)!.settings_title;
      default:
        return AppLocalizations.of(context)!.pos_resto_title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Animated Sidebar
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: _isSidebarVisible ? 80 : 0,
              // Removed fixed height calculation that caused negative values
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
                  // Navigation Items (Always Collapsed/Rail)
                    CollapsedNavItem(
                      iconPath: Assets.icons.homeResto.path,
                      isActive: _selectedIndex == 0,
                      onTap: () => _onItemTapped(0),
                    ),
                    CollapsedNavItem(
                      icon: Icons.table_restaurant,
                      isActive: _selectedIndex == 1,
                      onTap: () => _onItemTapped(1),
                    ),
                    BlocBuilder<NotificationBloc, NotificationState>(
                      builder: (context, state) {
                        return CollapsedNavItem(
                          iconPath: Assets.icons.history.path,
                          isActive: _selectedIndex == 2,
                          onTap: () => _onItemTapped(2),
                          badgeCount: state.orderCount,
                        );
                      },
                    ),
                    CollapsedNavItem(
                      iconPath: Assets.icons.dashboard.path,
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
                      // Online Indicator (Static)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.green.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.cloud_done,
                          color: Colors.green,
                          size: 24,
                        ),
                      ),

                      BlocListener<LogoutBloc, LogoutState>(
                        listener: (context, state) {
                          state.maybeMap(
                            orElse: () {},
                            error: (e) {
                              if (mounted) {
                                NotificationHelper.showError(context, e.message);
                              }
                            },
                            success: (value) {
                              AuthLocalDataSource().removeAuthData();
                              if (mounted) {
                                NotificationHelper.showSuccess(context, AppLocalizations.of(context)!.logout_success);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return const LoginPage();
                                }));
                              }
                            },
                          );
                        },
                        child: CollapsedNavItem(
                          iconPath: Assets.icons.logout.path,
                          isActive: false,
                          onTap: () {
                            context.read<LogoutBloc>().add(const LogoutEvent.logout());
                          },
                        ),
                      ),
                      
                      // SYNC SETTINGS BUTTON (NEW)
                      BlocListener<SettingsBloc, SettingsState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            loaded: (response) {
                              if (mounted) {
                                NotificationHelper.showSuccess(context, AppLocalizations.of(context)!.sync_settings_success);
                              }
                            },
                            error: (message) {
                              if (mounted) {
                                NotificationHelper.showError(context, AppLocalizations.of(context)!.sync_settings_failed);
                              
                              }
                            },
                            orElse: () {},
                          );
                        },
                        child: CollapsedNavItem(
                                icon: Icons.sync,
                                isActive: false,
                                onTap: () {
                                  NotificationHelper.showInfo(context, AppLocalizations.of(context)!.syncing_settings);
                                  context
                                      .read<SettingsBloc>()
                                      .add(const SettingsEvent.fetchSettings());
                                },
                              ),
                      ),
                    ],
                  ),
            ),
            Expanded(
              flex: 10,
              child: BlocListener<NotificationBloc, NotificationState>(
                listenWhen: (previous, current) => previous.orderCount != current.orderCount,
                listener: (context, state) {
                  // Trigger History Refresh when order count changes
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchPaidOrders(isRefresh: true));
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchCookingOrders(isRefresh: true));
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchCompletedOrders(isRefresh: true));
                  
                  // Optional: Show snackbar or toast
                  if (mounted) {
                    NotificationHelper.showSuccess(context, AppLocalizations.of(context)!.new_order_received);
                  }
                },
                child: IndexedStack(
                  index: _selectedIndex,
                  children: _getPages(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
