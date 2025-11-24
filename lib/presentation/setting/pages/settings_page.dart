import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/manage_printer_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/sync_data_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/notifications_settings_page.dart';
import 'package:flutter_posresto_app/presentation/setting/pages/about_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

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
      body: Row(
        children: [
          // LEFT CONTENT
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SpaceHeight(16.0),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: Assets.icons.kelolaPajak.svg(),
                    title: const Text('Sync Data'),
                    subtitle:
                        const Text('Sinkronisasi data dari dan ke server'),
                    textColor: AppColors.primary,
                    tileColor: currentIndex == 0
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(0),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    subtitle:
                        const Text('Manage notification preferences'),
                    textColor: AppColors.primary,
                    tileColor: currentIndex == 1
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(1),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.all(12.0),
                    leading: const Icon(Icons.info),
                    title: const Text('About & Help'),
                    subtitle:
                        const Text('App info and support'),
                    textColor: AppColors.primary,
                    tileColor: currentIndex == 2
                        ? AppColors.blueLight
                        : Colors.transparent,
                    onTap: () => indexValue(2),
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
                    SyncDataPage(),
                    NotificationsSettingsPage(),
                    AboutPage(),
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
