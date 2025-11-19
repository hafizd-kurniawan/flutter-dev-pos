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
import 'package:flutter_posresto_app/presentation/report/pages/report_page.dart';
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

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
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
      ),
      TableManagementApiPage(
        onTableSelected: _onTableSelected,
      ),
      const HistoryPage(),
      const ReportPage(),
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
            Expanded(
              flex: 1,
              child: SizedBox(
                height: context.deviceHeight - 20.0,
                child: ColoredBox(
                  color: AppColors.primary,
                  child: ListView(
                    children: [
                      NavItem(
                        iconPath: Assets.icons.homeResto.path,
                        isActive: _selectedIndex == 0,
                        onTap: () => _onItemTapped(0),
                      ),
                      NavItem(
                        iconPath: Assets.icons.kelolaProduk.path,
                        isActive: _selectedIndex == 1,
                        onTap: () => _onItemTapped(1),
                      ),
                      NavItem(
                        iconPath: Assets.icons.dashboard.path, // History icon
                        isActive: _selectedIndex == 2,
                        onTap: () => _onItemTapped(2),
                      ),
                      NavItem(
                        iconPath: Assets.icons.report.path, // Report moved to 3
                        isActive: _selectedIndex == 3,
                        onTap: () => _onItemTapped(3),
                      ),
                      NavItem(
                        iconPath: Assets.icons.print.path,
                        isActive: _selectedIndex == 4,
                        onTap: () => _onItemTapped(4),
                      ),
                      NavItem(
                        iconPath: Assets.icons.setting.path,
                        isActive: _selectedIndex == 5,
                        onTap: () => _onItemTapped(5),
                      ),
                      //container flag online/offline
                      BlocBuilder<OnlineCheckerBloc, OnlineCheckerState>(
                        builder: (context, state) {
                          return state.maybeWhen(
                            orElse: () => Container(
                              width: 40,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: AppColors.red,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Icon(
                                Icons.signal_wifi_off,
                                color: AppColors.white,
                              ),
                            ),
                            online: () {
                              context.read<SyncOrderBloc>().add(
                                    const SyncOrderEvent.syncOrder(),
                                  );
                              return Container(
                                width: 40,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  Icons.wifi,
                                  color: AppColors.white,
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
              ),
            ),
            Expanded(
              flex: 10,
              child: _getPages()[_selectedIndex],
            ),
          ],
        ),
      ),
    );
  }
}
