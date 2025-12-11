import 'dart:io';

import 'package:flutter_posresto_app/core/extensions/date_time_ext.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/models/response/summary_response_model.dart';
import 'package:flutter/services.dart';

import 'package:flutter_posresto_app/core/utils/helper_pdf_service.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RevenueInvoice {
  static late Font ttf;
  static Future<File> generate(
    SummaryModel summaryModel,
    String searchDateFormatted,
    Map<String, String> strings,
  ) async {
    final pdf = Document();
    // var data = await rootBundle.load("assets/fonts/noto-sans.ttf");
    // ttf = Font.ttf(data);
    final ByteData dataImage = await rootBundle.load('assets/images/logo.png');
    final Uint8List bytes = dataImage.buffer.asUint8List();

    // Membuat objek Image dari gambar
    final image = pw.MemoryImage(bytes);

    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(summaryModel, image, searchDateFormatted, strings),
          SizedBox(height: 1 * PdfPageFormat.cm),
          buildTotal(summaryModel, strings),
        ],
        footer: (context) => buildFooter(summaryModel, strings),
      ),
    );

    return HelperPdfService.saveDocument(
      name:
          'HayoPOS | Summary Sales Report | ${DateTime.now().millisecondsSinceEpoch}.pdf',
      pdf: pdf,
    );
  }

  static Widget buildHeader(
    SummaryModel invoice,
    MemoryImage image,
    String searchDateFormatted,
    Map<String, String> strings,
  ) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1 * PdfPageFormat.cm),
            Text(strings['report_title_summary'] ?? 'HayoPOS | Summary Sales Report',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 0.2 * PdfPageFormat.cm),
            Text(
              strings['data_date']?.replaceAll('{date}', searchDateFormatted) ?? "Data: $searchDateFormatted",
            ),
            Text(
              strings['created_at']?.replaceAll('{date}', DateTime.now().toFormattedDate3()) ?? 'Created At: ${DateTime.now().toFormattedDate3()}',
            ),
          ],
        ),
        Image(
          image,
          width: 80.0,
          height: 80.0,
          fit: BoxFit.fill,
        ),
      ]);

  static Widget buildTotal(SummaryModel summaryModel, Map<String, String> strings) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildText(
            title: strings['revenue'] ?? 'Revenue',
            value: int.parse(summaryModel.totalRevenue!).currencyFormatRp,
            unite: true,
          ),
          Divider(),
          buildText(
            title: strings['sub_total'] ?? 'Sub Total',
            titleStyle: TextStyle(fontWeight: FontWeight.normal),
            value: int.parse(summaryModel.totalSubtotal!).currencyFormatRp,
            unite: true,
          ),
          buildText(
            title: strings['discount'] ?? 'Discount',
            titleStyle: TextStyle(fontWeight: FontWeight.normal),
            value:
                "- ${int.parse(summaryModel.totalDiscount!.replaceAll('.00', '')).currencyFormatRp}",
            unite: true,
            textStyle: TextStyle(
              color: PdfColor.fromHex('#FF0000'),
              fontWeight: FontWeight.bold,
            ),
          ),
          buildText(
            title: strings['tax'] ?? 'Tax',
            titleStyle: TextStyle(fontWeight: FontWeight.normal),
            value: "- ${int.parse(summaryModel.totalTax!).currencyFormatRp}",
            textStyle: TextStyle(
              color: PdfColor.fromHex('#FF0000'),
              fontWeight: FontWeight.bold,
            ),
            unite: true,
          ),
          buildText(
            title: strings['service_charge'] ?? 'Service Charge',
            titleStyle: TextStyle(
              fontWeight: FontWeight.normal,
            ),
            value: int.parse(summaryModel.totalServiceCharge!).currencyFormatRp,
            unite: true,
          ),
          Divider(),
          buildText(
            title: strings['total'] ?? 'Total ',
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            value: summaryModel.total!.currencyFormatRp,
            unite: true,
          ),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Container(height: 1, color: PdfColors.grey400),
          SizedBox(height: 0.5 * PdfPageFormat.mm),
          Container(height: 1, color: PdfColors.grey400),
        ],
      ),
    );
  }

  static Widget buildFooter(SummaryModel summaryModel, Map<String, String> strings) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: strings['address'] ?? 'Address',
              value:
                  'Jalan Melati No. 12, Mranggen, Demak, Central Java, 89568'),
          SizedBox(height: 1 * PdfPageFormat.mm),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    TextStyle? textStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);
    final style2 = textStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: style2),
        ],
      ),
    );
  }
}
