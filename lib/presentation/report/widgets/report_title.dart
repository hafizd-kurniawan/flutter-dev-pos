import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/components/components.dart';
import 'package:flutter_posresto_app/core/extensions/date_time_ext.dart';

import '../../../core/constants/colors.dart';



import 'package:flutter_posresto_app/l10n/app_localizations.dart';

class ReportTitle extends StatelessWidget {
  const ReportTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.report_title,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SpaceHeight(4.0),
        Text(
          DateTime.now().toFormattedDate(),
          style: const TextStyle(
            color: AppColors.subtitle,
            fontSize: 16,
          ),
        ),
        const SpaceHeight(20.0),
        const Divider(),
      ],
    );
  }
}
