import 'dart:math';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart'; // NEW
import 'package:pdf/widgets.dart' as pw; // NEW
import 'package:path_provider/path_provider.dart'; // NEW
import 'dart:io'; // NEW
import 'package:share_plus/share_plus.dart'; // NEW
import 'package:flutter/foundation.dart' show kIsWeb; // NEW: Check for Web
import 'package:flutter_posresto_app/data/datasources/settings_local_datasource.dart'; // NEW
import 'package:image/image.dart' as img;

class PrintDataoutputs {
  PrintDataoutputs._init();

  static final PrintDataoutputs instance = PrintDataoutputs._init();

  Future<List<int>> printOrder(
      List<ProductQuantity> products,
      int totalQuantity,
      int totalPrice,
      String paymentMethod,
      int nominalBayar,
      String namaKasir,
      int discount,
      int tax,
      int subTotal,
      int normalPrice,
      int sizeReceipt,
      int taxPercentage,
      int servicePercentage) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator =
        Generator(sizeReceipt == 58 ? PaperSize.mm58 : PaperSize.mm80, profile);

    final pajak = totalPrice * 0.11;
    final total = totalPrice + pajak;

    // Fetch Settings
    final settings = await SettingsLocalDatasource().getSettings();
    final appName = settings['app_name'] ?? 'Self Order POS';
    final address = settings['restaurant_address'] ?? 'Jl. Raya No. 123, Jakarta';
    final phone = settings['restaurant_phone'] ?? '';

    bytes += generator.reset();
    bytes += generator.text(appName,
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size1,
          width: PosTextSize.size1,
        ));

    bytes += generator.text(address,
        styles: const PosStyles(bold: true, align: PosAlign.center));
    if (phone.isNotEmpty) {
      bytes += generator.text(phone,
          styles: const PosStyles(bold: false, align: PosAlign.center));
    }
    bytes += generator.text(
        'Date : ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    bytes += generator.feed(1);
    bytes += generator.text('Pesanan:',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    for (final product in products) {
      bytes += generator.text(product.product.name!,
          styles: const PosStyles(align: PosAlign.left));

      bytes += generator.row([
        PosColumn(
          text:
              '${product.product.price!.toIntegerFromText.currencyFormatRp} x ${product.quantity}',
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: '${product.product.price!.toIntegerFromText * product.quantity}'
              .toIntegerFromText
              .currencyFormatRp,
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    bytes += generator.feed(1);

    bytes += generator.row([
      PosColumn(
        text: 'Normal price',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: normalPrice.currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Diskon',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: discount.currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Sub total',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: subTotal.currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Pajak PB1 ($taxPercentage%)',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: tax.ceil().currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Final total',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: totalPrice.currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Bayar',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: total.ceil().currencyFormatRp,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Pembayaran',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: paymentMethod,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.feed(1);
    final footer = settings['receipt_footer_text'] ?? 'Terima kasih';
    bytes += generator.text(footer,
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(3);

    return bytes;
  }

  Future<List<int>> printOrderV2(
      List<ProductQuantity> products, int orderId, int paper
      // OrderModel order,
      // Uint8List logo,
      // StoreModel store,
      // TemplateReceiptModel? template,
      ) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator =
        Generator(paper == 58 ? PaperSize.mm58 : PaperSize.mm80, profile);

    // final ByteData data = await rootBundle.load('assets/logo/mylogo.png');
    // final Uint8List bytesData = data.buffer.asUint8List();
    // final img.Image? orginalImage = img.decodeImage(logo);

    bytes += generator.reset();

    // if (orginalImage != null) {
    //   final img.Image grayscalledImage = img.grayscale(orginalImage);
    //   final img.Image resizedImage =
    //       img.copyResize(grayscalledImage, width: 240);
    //   bytes += generator.imageRaster(resizedImage, align: PosAlign.center);
    //   bytes += generator.feed(3);
    // }

    // Fetch Settings
    final settings = await SettingsLocalDatasource().getSettings();
    final appName = settings['app_name'] ?? 'Self Order POS';
    final address = settings['restaurant_address'] ?? 'Jl. Raya No. 123, Jakarta';
    final phone = settings['restaurant_phone'] ?? '';

    bytes += generator.text(appName,
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += generator.text(address,
        styles: const PosStyles(bold: false, align: PosAlign.center));
    if (phone.isNotEmpty) {
      bytes += generator.text(phone,
          styles: const PosStyles(bold: false, align: PosAlign.center));
    }

    bytes += generator.feed(1);

    bytes += generator.text(
        paper == 80
            ? '================================================'
            : '================================',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    // if (template.receiptType == 'Default') {
    //   bytes += generator.row([
    //     PosColumn(
    //       text: 'Antrian',
    //       width: 5,
    //       styles: const PosStyles(align: PosAlign.left),
    //     ),
    //     PosColumn(
    //       text: ':',
    //       width: 1,
    //       styles: const PosStyles(align: PosAlign.left),
    //     ),
    //     PosColumn(
    //       text: order.noQueue.toString(),
    //       width: 6,
    //       styles: const PosStyles(align: PosAlign.left),
    //     ),
    //   ]);
    // }
    bytes += generator.row([
      PosColumn(
        text: 'ID Transaksi',
        width: 5,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: orderId.toString(),
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Waktu',
        width: 5,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: DateFormat('dd MMM yy HH:mm').format(DateTime.now()),
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Order By',
        width: 5,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'Sarah',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Kasir',
        width: 5,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: ':',
        width: 1,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'Susan',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
    ]);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    for (final product in products) {
      bytes += generator.row([
        PosColumn(
          text: '${product.quantity} ${product.product.name}',
          width: 8,
          styles: const PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: (product.product.price!.toIntegerFromText * product.quantity)
              .currencyFormatRp,
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    // bytes += generator.row([
    //   PosColumn(
    //     text: 'Subtotal  Produk',
    //     width: 8,
    //     styles: const PosStyles(align: PosAlign.left),
    //   ),
    //   PosColumn(
    //     text: order.subTotal.currencyFormatRpV2,
    //     width: 4,
    //     styles: const PosStyles(align: PosAlign.right),
    //   ),
    // ]);

    // bytes += generator.row([
    //   PosColumn(
    //     text: 'Diskon',
    //     width: 8,
    //     styles: const PosStyles(align: PosAlign.left),
    //   ),
    //   PosColumn(
    //     text: order.discountAmount.currencyFormatRpV2,
    //     width: 4,
    //     styles: const PosStyles(align: PosAlign.right),
    //   ),
    // ]);
    // bytes += generator.row([
    //   PosColumn(
    //     text: 'PPN',
    //     width: 8,
    //     styles: const PosStyles(align: PosAlign.left),
    //   ),
    //   PosColumn(
    //     text: order.tax.currencyFormatRpV2,
    //     width: 4,
    //     styles: const PosStyles(align: PosAlign.right),
    //   ),
    // ]);
    // bytes += generator.row([
    //   PosColumn(
    //     text: 'Service',
    //     width: 8,
    //     styles: const PosStyles(align: PosAlign.left),
    //   ),
    //   PosColumn(
    //     text: order.serviceCharge.currencyFormatRpV2,
    //     width: 4,
    //     styles: const PosStyles(align: PosAlign.right),
    //   ),
    // ]);

    bytes += generator.row([
      PosColumn(
        text: 'Total Tagihan',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: (products[0].product.price!.toIntegerFromText *
                products[0].quantity)
            .currencyFormatRp,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.row([
      PosColumn(
        text: 'Metode Pembayaran',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'Tunai',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Total Bayar',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: (products[0].product.price!.toIntegerFromText *
                products[0].quantity)
            .currencyFormatRp,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Kembalian',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'Rp 0',
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.text(
        paper == 80
            ? '================================================'
            : '================================',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    // bytes += generator.text('Password: fic11jilid2',
    //     styles: const PosStyles(bold: false, align: PosAlign.center));
    // bytes += generator.feed(1);
    // bytes += generator.text('instagram: @codewithbahri',
    //     styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(1);
    bytes += generator.text(
        'Terbayar: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.text('dicetak oleh: Susan',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(1);
    bytes += generator.text('Terima kasih',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(3);
    bytes += generator.cut();
    return bytes;
  }

  Future<List<int>> printOrderV3(
    List<ProductQuantity> products,
    int totalQuantity,
    int totalPrice,
    String paymentMethod,
    int nominalBayar,
    int kembalian,
    int subTotal,
    int discount,
    int pajak,
    int serviceCharge,
    String namaKasir,
    String customerName,
    int paper,
    int taxPercentage,
    int servicePercentage,
    String orderType, // NEW
    String tableName, // NEW
  ) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator =
        Generator(paper == 58 ? PaperSize.mm58 : PaperSize.mm80, profile);

    final ByteData data = await rootBundle.load('assets/logo/mylogo.png');
    final Uint8List bytesData = data.buffer.asUint8List();
    final img.Image? orginalImage = img.decodeImage(bytesData);
    bytes += generator.reset();

    if (orginalImage != null) {
      final img.Image grayscalledImage = img.grayscale(orginalImage);
      final img.Image resizedImage =
          img.copyResize(grayscalledImage, width: 240);
      bytes += generator.imageRaster(resizedImage, align: PosAlign.center);
      bytes += generator.feed(3);
    }

    // Fetch Settings
    final settings = await SettingsLocalDatasource().getSettings();
    final appName = settings['app_name'] ?? 'Self Order POS';
    final address = settings['restaurant_address'] ?? 'Jl. Raya No. 123, Jakarta';
    final phone = settings['restaurant_phone'] ?? '';

    bytes += generator.text(appName,
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += generator.text(address,
        styles: const PosStyles(bold: false, align: PosAlign.center));
    if (phone.isNotEmpty) {
      bytes += generator.text(phone,
          styles: const PosStyles(bold: false, align: PosAlign.center));
    }

    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    bytes += generator.row([
      PosColumn(
        text: DateFormat('dd MMM yyyy').format(DateTime.now()),
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: DateFormat('HH:mm').format(DateTime.now()),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Receipt Number',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'JF-${DateFormat('yyyyMMddhhmm').format(DateTime.now())}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Customer',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: customerName,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Cashier',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: namaKasir,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    
    // Display Order Type
    String displayOrderType = 'Dine In';
    if (orderType.toLowerCase().contains('takeaway') || orderType.toLowerCase().contains('take_away')) {
      displayOrderType = 'Take Away';
    } else if (orderType.toLowerCase().contains('self')) {
      displayOrderType = 'Self Order';
    }
    
    bytes += generator.text(displayOrderType,
        styles: const PosStyles(bold: true, align: PosAlign.center));
        
    // Display Table Name if Dine In
    if ((displayOrderType == 'Dine In' || displayOrderType == 'Self Order') && tableName.isNotEmpty) {
       bytes += generator.text('Table: $tableName',
        styles: const PosStyles(bold: true, align: PosAlign.center));
    }
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    for (final product in products) {
      bytes += generator.row([
        PosColumn(
          text: '${product.quantity} x ${product.product.name}',
          width: 8,
          styles: const PosStyles(bold: true, align: PosAlign.left),
        ),
        PosColumn(
          text: '${product.product.price!.toIntegerFromText * product.quantity}'
              .currencyFormatRpV2,
          width: 4,
          styles: const PosStyles(bold: true, align: PosAlign.right),
        ),
      ]);
    }
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    final subTotalPrice = products.fold<int>(
        0,
        (previousValue, element) =>
            previousValue +
            (element.product.price!.toIntegerFromText * element.quantity));
    bytes += generator.row([
      PosColumn(
        text: 'Subtotal $totalQuantity Product',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: subTotalPrice.currencyFormatRpV2,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Discount',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: discount.currencyFormatRpV2,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);

    bytes += generator.row([
      PosColumn(
        text: 'Tax PB1 ($taxPercentage%)',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: pajak.currencyFormatRpV2,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Service Charge($servicePercentage%)',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: serviceCharge.currencyFormatRpV2,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.row([
      PosColumn(
        text: 'Total',
        width: 6,
        styles: const PosStyles(bold: true, align: PosAlign.left),
      ),
      PosColumn(
        text: '$totalPrice'.currencyFormatRpV2,
        width: 6,
        styles: const PosStyles(bold: true, align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Payment ($paymentMethod)',
        width: 8,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: nominalBayar.currencyFormatRpV2,
        width: 4,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Change',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: kembalian.currencyFormatRpV2,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.left));
    // bytes += generator.text('Notes',
    //     styles: const PosStyles(bold: false, align: PosAlign.center));
    // bytes += generator.text('Pass Wifi: fic14jilid2',
    //     styles: const PosStyles(bold: false, align: PosAlign.center));
    // //terima kasih
    // bytes += generator.text('Terima Kasih',
    //     styles: const PosStyles(bold: true, align: PosAlign.center));
    paper == 80 ? bytes += generator.feed(3) : bytes += generator.feed(1);
    if (paper == 80) {
      bytes += generator.cut();
    }
    return bytes;
  }

  Future<List<int>> printQRIS(
      int totalPrice, Uint8List imageQris, int paper) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator =
        Generator(paper == 58 ? PaperSize.mm58 : PaperSize.mm80, profile);

    final img.Image? orginalImage = img.decodeImage(imageQris);
    bytes += generator.reset();

    // final Uint8List bytesData = data.buffer.asUint8List();
    // final img.Image? orginalImage = img.decodeImage(bytesData);
    // bytes += generator.reset();

    bytes += generator.text('Scan QRIS Below for Payment',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(2);
    if (orginalImage != null) {
      final img.Image grayscalledImage = img.grayscale(orginalImage);
      final img.Image resizedImage =
          img.copyResize(grayscalledImage, width: 240);
      bytes += generator.imageRaster(resizedImage, align: PosAlign.center);
      bytes += generator.feed(1);
    }

    bytes += generator.text('Price : ${totalPrice.currencyFormatRp}',
        styles: const PosStyles(bold: false, align: PosAlign.center));

    bytes += generator.feed(4);
    bytes += generator.cut();

    return bytes;
  }

  /// Generate text version of receipt for sharing
  Future<String> generateReceiptText(
    List<ProductQuantity> products,
    int totalQuantity,
    int totalPrice,
    String paymentMethod,
    int nominalBayar,
    int kembalian,
    int subTotal,
    int discount,
    int pajak,
    int serviceCharge,
    String namaKasir,
    String customerName,
    int taxPercentage,
    int servicePercentage,
  ) async {
    final buffer = StringBuffer();
    final now = DateTime.now();
    
    // Note: generateReceiptText is synchronous, so we can't await here.
    // However, we can pass the settings as arguments or make this async.
    // For now, let's make it async and return Future<String>.
    // Wait, changing return type might break callers.
    // Let's check callers. Only used in Share.share?
    // If we can't make it async easily, we might need to rely on passed arguments.
    // But the user wants it dynamic.
    // Let's assume we can make it async or callers can handle Future.
    
    // Actually, to avoid breaking changes in this step, I will use a hack:
    // I'll assume the caller has already fetched settings or I'll use defaults if I can't await.
    // BUT, the user explicitly asked for this file to be checked.
    // I should change the signature to `Future<String>` and update callers.
    
    // ... wait, I can't easily update all callers in one go if I don't know them.
    // Let's look at `generateReceiptText` usage.
    // It's likely used in `HistoryPage` or `SuccessPaymentDialog`.
    
    // Alternative: Pass settings map to this method.
    // I'll stick to hardcoded replacement for now but add a TODO or try to make it async if possible.
    // Actually, `generateReceiptPdf` is async, so `generateReceiptText` should probably be async too.
    
    // Let's look at the method signature again.
    // String generateReceiptText(...)
    
    // I will change it to Future<String> generateReceiptText(...) async
    
    final settings = await SettingsLocalDatasource().getSettings();
    final appName = settings['app_name'] ?? 'Self Order POS';
    final address = settings['restaurant_address'] ?? 'Jl. Raya No. 123, Jakarta';
    final phone = settings['restaurant_phone'] ?? '';
    final footer = settings['receipt_footer_text'] ?? 'Terima Kasih';

    buffer.writeln(appName);
    buffer.writeln(address);
    if (phone.isNotEmpty) buffer.writeln(phone);
    buffer.writeln('--------------------------------');
    
    buffer.writeln('Date: ${DateFormat('dd MMM yyyy HH:mm').format(now)}');
    buffer.writeln('Receipt: JF-${DateFormat('yyyyMMddhhmm').format(now)}');
    buffer.writeln('Customer: $customerName');
    buffer.writeln('Cashier: $namaKasir');
    buffer.writeln('--------------------------------');
    buffer.writeln('Dine In');
    buffer.writeln('--------------------------------');
    
    for (final product in products) {
      buffer.writeln('${product.quantity}x ${product.product.name}');
      buffer.writeln('   ${(product.product.price!.toIntegerFromText * product.quantity).currencyFormatRp}');
    }
    
    buffer.writeln('--------------------------------');
    buffer.writeln('Subtotal: ${subTotal.currencyFormatRp}');
    if (discount > 0) {
      buffer.writeln('Discount: -${discount.currencyFormatRp}');
    }
    if (pajak > 0) {
      buffer.writeln('Tax ($taxPercentage%): ${pajak.currencyFormatRp}');
    }
    if (serviceCharge > 0) {
      buffer.writeln('Service ($servicePercentage%): ${serviceCharge.currencyFormatRp}');
    }
    buffer.writeln('--------------------------------');
    buffer.writeln('TOTAL: ${totalPrice.currencyFormatRp}');
    buffer.writeln('Payment ($paymentMethod): ${nominalBayar.currencyFormatRp}');
    buffer.writeln('Change: ${kembalian.currencyFormatRp}');
    buffer.writeln('--------------------------------');
    buffer.writeln(footer);
    
    return buffer.toString();
  }

  /// Generate PDF version of receipt for sharing
  Future<XFile> generateReceiptPdf(
    List<ProductQuantity> products,
    int totalQuantity,
    int totalPrice,
    String paymentMethod,
    int nominalBayar,
    int kembalian,
    int subTotal,
    int discount,
    int pajak,
    int serviceCharge,
    String namaKasir,
    String customerName,
    String orderType,
    String tableName, // NEW
    int taxPercentage, // NEW
    int servicePercentage, // NEW
  ) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateFormat = DateFormat('dd MMM yyyy HH:mm');

    // Fetch Settings
    final settings = await SettingsLocalDatasource().getSettings();
    final appName = settings['app_name'] ?? 'Self Order POS';
    final address = settings['restaurant_address'] ?? 'Jl. Raya No. 123, Jakarta';
    final phone = settings['restaurant_phone'] ?? '';
    final footer = settings['receipt_footer_text'] ?? 'Terima Kasih';

    // Format Order Type
    String formattedOrderType = 'Dine In';
    if (orderType.toLowerCase().contains('takeaway') || orderType.toLowerCase().contains('take_away')) {
      formattedOrderType = 'Take Away';
    } else if (orderType.toLowerCase().contains('self')) {
      formattedOrderType = 'Self Order';
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(child: pw.Text(appName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 16))),
              pw.Center(child: pw.Text(address, style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center)),
              if (phone.isNotEmpty)
                pw.Center(child: pw.Text(phone, style: const pw.TextStyle(fontSize: 10))),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Date:', style: const pw.TextStyle(fontSize: 10)),
                pw.Text(dateFormat.format(now), style: const pw.TextStyle(fontSize: 10)),
              ]),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Receipt:', style: const pw.TextStyle(fontSize: 10)),
                pw.Text('JF-${DateFormat('yyyyMMddhhmm').format(now)}', style: const pw.TextStyle(fontSize: 10)),
              ]),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Customer:', style: const pw.TextStyle(fontSize: 10)),
                pw.Text(customerName, style: const pw.TextStyle(fontSize: 10)),
              ]),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Cashier:', style: const pw.TextStyle(fontSize: 10)),
                pw.Text(namaKasir, style: const pw.TextStyle(fontSize: 10)),
              ]),
              pw.Divider(),
              pw.Center(child: pw.Text(formattedOrderType, style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              if ((formattedOrderType == 'Dine In' || formattedOrderType == 'Self Order') && tableName.isNotEmpty)
                pw.Center(child: pw.Text('Table: $tableName', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
              pw.Divider(),
              ...products.map((item) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('${item.quantity}x ${item.product.name}', style: const pw.TextStyle(fontSize: 10)),
                    pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                      pw.SizedBox(),
                      pw.Text((item.product.price!.toIntegerFromText * item.quantity).currencyFormatRp, style: const pw.TextStyle(fontSize: 10)),
                    ]),
                    pw.SizedBox(height: 4),
                  ],
                );
              }).toList(),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Subtotal:', style: const pw.TextStyle(fontSize: 10)),
                pw.Text(subTotal.currencyFormatRp, style: const pw.TextStyle(fontSize: 10)),
              ]),
              if (discount > 0)
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text('Discount:', style: const pw.TextStyle(fontSize: 10, color: PdfColors.red)),
                  pw.Text('-${discount.currencyFormatRp}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.red)),
                ]),
              if (pajak > 0)
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text('Tax ($taxPercentage%):', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(pajak.currencyFormatRp, style: const pw.TextStyle(fontSize: 10)),
                ]),
              if (serviceCharge > 0)
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                  pw.Text('Service ($servicePercentage%):', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(serviceCharge.currencyFormatRp, style: const pw.TextStyle(fontSize: 10)),
                ]),
              pw.Divider(),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text(totalPrice.currencyFormatRp, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              ]),
              pw.SizedBox(height: 4),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Payment ($paymentMethod):', style: const pw.TextStyle(fontSize: 10)),
                pw.Text(nominalBayar.currencyFormatRp, style: const pw.TextStyle(fontSize: 10)),
              ]),
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text('Change:', style: const pw.TextStyle(fontSize: 10)),
                pw.Text(kembalian.currencyFormatRp, style: const pw.TextStyle(fontSize: 10)),
              ]),
              pw.Divider(),
              pw.Center(child: pw.Text(footer)),
            ],
          );
        },
      ),
    );

    final bytes = await pdf.save();

    if (kIsWeb) {
      // For Web: Return XFile from bytes directly
      // Note: SharePlus on Web might trigger a download or open a new tab depending on browser support
      return XFile.fromData(
        bytes,
        mimeType: 'application/pdf',
        name: 'receipt_${DateFormat('yyyyMMddHHmmss').format(now)}.pdf',
      );
    } else {
      // For Mobile/Desktop: Save to temporary file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/receipt_${DateFormat('yyyyMMddHHmmss').format(now)}.pdf');
      await file.writeAsBytes(bytes);
      return XFile(file.path);
    }
  }

  Future<List<int>> printChecker(List<ProductQuantity> products,
      String tableName, String draftName, String cashierName, int paper) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator =
        Generator(paper == 58 ? PaperSize.mm58 : PaperSize.mm80, profile);

    bytes += generator.reset();

    bytes += generator.text('Table Checker',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.feed(1);
    bytes += generator.text(tableName,
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.feed(1);

    bytes += generator.row([
      PosColumn(
        text: 'Date',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    // bytes += generator.text(
    //     'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
    //     styles: const PosStyles(bold: false, align: PosAlign.left));
    //reciept number
    bytes += generator.row([
      PosColumn(
        text: 'Receipt',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'JF-${DateFormat('yyyyMMddhhmm').format(DateTime.now())}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    // bytes += generator.text(
    //     'Receipt: JF-${DateFormat('yyyyMMddhhmm').format(DateTime.now())}',
    //     styles: const PosStyles(bold: false, align: PosAlign.left));
//cashier name
    bytes += generator.row([
      PosColumn(
        text: 'Cashier',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: cashierName,
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    // bytes += generator.text('Cashier: $cashierName',
    //     styles: const PosStyles(bold: false, align: PosAlign.left));
    //customer name
    //column 2
    bytes += generator.row([
      PosColumn(
        text: 'Customer - $draftName',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'DINE IN',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //----
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(1);
    for (final product in products) {
      bytes += generator.text('${product.quantity} x  ${product.product.name}',
          styles: const PosStyles(
            align: PosAlign.left,
            bold: false,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ));
    }

    bytes += generator.feed(1);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    paper == 80 ? bytes += generator.feed(3) : bytes += generator.feed(1);
    //cut
    if (paper == 80) {
      bytes += generator.cut();
    }

    return bytes;
  }

  Future<List<int>> printKitchen(List<ProductQuantity> products,
      String tableNumber, String draftName, String cashierName, int paper) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator =
        Generator(paper == 58 ? PaperSize.mm58 : PaperSize.mm80, profile);

    bytes += generator.reset();

    bytes += generator.text('Table Kitchen',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.feed(1);
    if (tableNumber.isNotEmpty) {
      bytes += generator.text(tableNumber,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      bytes += generator.feed(1);
    }

    bytes += generator.row([
      PosColumn(
        text: 'Date',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    // bytes += generator.text(
    //     'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
    //     styles: const PosStyles(bold: false, align: PosAlign.left));
    //reciept number
    bytes += generator.row([
      PosColumn(
        text: 'Receipt',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'JF-${DateFormat('yyyyMMddhhmm').format(DateTime.now())}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Customer - $draftName',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'DINE IN',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //----
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(1);
    final kitchenProducts =
        products.where((p) => p.product.printerType == 'kitchen');
    for (final product in kitchenProducts) {
      bytes += generator.text('${product.quantity} x  ${product.product.name}',
          styles: const PosStyles(
            align: PosAlign.left,
            bold: false,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ));
    }

    bytes += generator.feed(1);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    paper == 80 ? bytes += generator.feed(3) : bytes += generator.feed(1);
    //cut
    if (paper == 80) {
      bytes += generator.cut();
    }

    return bytes;
  }

  Future<List<int>> printBar(List<ProductQuantity> products, String tableNumber,
      String draftName, String cashierName, int paper) async {
    List<int> bytes = [];

    final profile = await CapabilityProfile.load();
    final generator =
        Generator(paper == 58 ? PaperSize.mm58 : PaperSize.mm80, profile);

    bytes += generator.reset();

    bytes += generator.text('Table Bar',
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.feed(1);
    if (tableNumber.isNotEmpty) {
      bytes += generator.text(tableNumber.toString(),
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          ));
      bytes += generator.feed(1);
    }

    bytes += generator.row([
      PosColumn(
        text: 'Date',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now()),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    // bytes += generator.text(
    //     'Date: ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
    //     styles: const PosStyles(bold: false, align: PosAlign.left));
    //reciept number
    bytes += generator.row([
      PosColumn(
        text: 'Receipt',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'JF-${DateFormat('yyyyMMddhhmm').format(DateTime.now())}',
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
    bytes += generator.row([
      PosColumn(
        text: 'Customer - $draftName',
        width: 6,
        styles: const PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: 'DINE IN',
        width: 6,
        styles: const PosStyles(align: PosAlign.right, bold: true),
      ),
    ]);

    //----
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    bytes += generator.feed(1);
    final barProducts = products.where((p) => p.product.printerType == 'bar');
    for (final product in barProducts) {
      bytes += generator.text('${product.quantity} x  ${product.product.name}',
          styles: const PosStyles(
            align: PosAlign.left,
            bold: false,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          ));
    }

    bytes += generator.feed(1);
    bytes += generator.text(
        paper == 80
            ? '------------------------------------------------'
            : '--------------------------------',
        styles: const PosStyles(bold: false, align: PosAlign.center));
    paper == 80 ? bytes += generator.feed(3) : bytes += generator.feed(1);
    //cut
    if (paper == 80) {
      bytes += generator.cut();
    }

    return bytes;
  }
}
