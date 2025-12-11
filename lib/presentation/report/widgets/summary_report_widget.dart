// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter_posresto_app/core/components/dashed_line.dart';
import 'package:flutter_posresto_app/core/components/spaces.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/utils/helper_pdf_service.dart';
import 'package:flutter_posresto_app/core/utils/permession_handler.dart';
import 'package:flutter_posresto_app/data/models/response/summary_response_model.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/utils/revenue_invoice.dart';

class SummaryReportWidget extends StatelessWidget {
  final String title;
  final String searchDateFormatted;
  final SummaryModel summary;
  const SummaryReportWidget({
    super.key,
    required this.title,
    required this.searchDateFormatted,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 255),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceHeight(24.0),
            Center(
              child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 16.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    searchDateFormatted,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final status = await PermessionHelper().checkPermission();
                      if (status) {
                        final Map<String, String> strings = {
                          'report_title_summary': AppLocalizations.of(context)!.report_title_summary,
                          'data_date': AppLocalizations.of(context)!.data_date(''),
                          'created_at': AppLocalizations.of(context)!.created_at(''),
                          'revenue': AppLocalizations.of(context)!.revenue,
                          'sub_total': AppLocalizations.of(context)!.sub_total,
                          'discount': AppLocalizations.of(context)!.discount,
                          'tax': AppLocalizations.of(context)!.tax,
                          'service_charge': AppLocalizations.of(context)!.service_charge,
                          'total': AppLocalizations.of(context)!.total,
                          'address': AppLocalizations.of(context)!.address,
                        };
                        final pdfFile = await RevenueInvoice.generate(
                            summary, searchDateFormatted, strings);
                        log("pdfFile: $pdfFile");
                        HelperPdfService.openFile(pdfFile);
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.pdf_label,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Icon(
                          Icons.download_outlined,
                          color: AppColors.primary,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SpaceHeight(16.0),
            Text(
              AppLocalizations.of(context)!.revenue_label(int.parse(summary.totalRevenue!).currencyFormatRp),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SpaceHeight(8.0),
            const DashedLine(),
            const DashedLine(),
            const SpaceHeight(8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.subtotal),
                Text(
                  int.parse(summary.totalSubtotal!).currencyFormatRp,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SpaceHeight(4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.discount),
                Text(
                  "- ${int.parse(summary.totalDiscount!.replaceAll('.00', '')).currencyFormatRp}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SpaceHeight(4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.tax),
                Text(
                  "- ${int.parse(summary.totalTax!).currencyFormatRp}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SpaceHeight(4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.service_charge),
                Text(
                  int.parse(summary.totalServiceCharge!).currencyFormatRp,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SpaceHeight(8.0),
            const DashedLine(),
            const DashedLine(),
            const SpaceHeight(8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.total_caps),
                Text(
                  summary.total!.currencyFormatRp,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
