import 'package:flutter/material.dart';
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

class PrinterConfigurationPage extends StatefulWidget {
  const PrinterConfigurationPage({super.key});

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
      body: Row(
        children: [
          // LEFT CONTENT
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                ),
                children: [
                  const Text(
                    'Printer Configuration',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SpaceHeight(16.0),
                  ListTile(
                    // contentPadding: const EdgeInsets.all(12.0),
                    // leading: Assets.icons.kelolaDiskon.svg(),
                    title: const Text('Receipt Printer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    subtitle: const Text('To Print bill and receipt'),
                    textColor: AppColors.primary,
                    tileColor:
                        currentIndex == 0 ? AppColors.card : Colors.transparent,
                    onTap: () => indexValue(0),
                  ),
                  ListTile(
                    // contentPadding: const EdgeInsets.all(12.0),
                    // leading: Assets.icons.kelolaPrinter.svg(),
                    title: const Text('Checker Printer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    subtitle: const Text('Print checker chit'),
                    textColor: AppColors.primary,
                    tileColor: currentIndex == 1
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(1),
                  ),
                  ListTile(
                    // contentPadding: const EdgeInsets.all(12.0),
                    // leading: Assets.icons.kelolaPajak.svg(),
                    title: const Text('Kitchen Printer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    subtitle: const Text('To print food to kitchen'),
                    textColor: AppColors.primary,
                    tileColor: currentIndex == 2
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(2),
                  ),
                  ListTile(
                    // contentPadding: const EdgeInsets.all(12.0),
                    // leading: Assets.icons.kelolaPajak.svg(),
                    title: const Text('Bar Printer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    subtitle: const Text('To print drink to bar'),
                    textColor: AppColors.primary,
                    tileColor: currentIndex == 3
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(3),
                  ),
                  ListTile(
                    // contentPadding: const EdgeInsets.all(12.0),
                    // leading: Image.asset(Assets.images.manageQr.path,
                    //     fit: BoxFit.contain),
                    title: const Text('Additional Printer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    subtitle:
                        const Text('To print additional kitchen/bar printer'),

                    textColor: AppColors.primary,
                    tileColor: currentIndex == 4
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(4),
                  ),
                ],
              ),
            ),
          ),

          // RIGHT CONTENT
          Expanded(
            flex: 4,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: IndexedStack(
                  index: currentIndex,
                  children: [
                    ReceiptPrinterPage(),
                    CheckerPrinterPage(),
                    KitchenPrinterPage(),
                    BarPrinterPage(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
