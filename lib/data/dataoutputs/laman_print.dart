// import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
// import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
// import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
// import 'package:imin_printer/column_maker.dart';
// import 'package:imin_printer/enums.dart';
// import 'package:imin_printer/imin_printer.dart';
// import 'package:imin_printer/imin_style.dart';
// import 'package:intl/intl.dart';

// class LamanPrint {
//   LamanPrint._init();

//   static final LamanPrint instance = LamanPrint._init();
//   static IminPrinter? _iminPrinter;

//   static Future init() async {
//     _iminPrinter = IminPrinter();
//     await _iminPrinter!.initPrinter();
//   }

//   Future<void> printOrderV3(
//     List<ProductQuantity> products,
//     int totalQuantity,
//     int totalPrice,
//     String paymentMethod,
//     int nominalBayar,
//     int kembalian,
//     int subTotal,
//     int discount,
//     int pajak,
//     int serviceCharge,
//     String namaKasir,
//     String customerName,
//     int paper,
//   ) async {
//     final iminPrinter = _iminPrinter!;

//     await iminPrinter.printText(
//       'Jago Resto',
//       style: IminTextStyle(align: IminPrintAlign.center, fontSize: 24),
//     );

//     await iminPrinter.printText(
//       'Jl. Kebun Raya No. 1, Sinduhadi, Ngaglik, Sleman',
//       style: IminTextStyle(align: IminPrintAlign.center, fontSize: 20),
//     );

//     await iminPrinter.printText(
//       '------------------------------------------------------',
//       style: IminTextStyle(align: IminPrintAlign.center, fontSize: 20),
//     );

//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: DateFormat('dd MMM yyyy').format(DateTime.now()),
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: DateFormat('HH:mm').format(DateTime.now()),
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );

//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Receipt Number',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: 'JF-${DateFormat('yyyyMMddhhmm').format(DateTime.now())}',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );

//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Kasir',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: namaKasir,
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );

//     for (final product in products) {
//       await iminPrinter.printColumnsText(
//         cols: [
//           ColumnMaker(
//             text: '${product.quantity} x ${product.product.name}',
//             width: 2,
//             fontSize: 20,
//             align: IminPrintAlign.left,
//           ),
//           ColumnMaker(
//             text:
//                 '${product.product.price!.toIntegerFromText * product.quantity}'
//                     .currencyFormatRpV2,
//             width: 2,
//             fontSize: 20,
//             align: IminPrintAlign.right,
//           ),
//         ],
//       );
//     }

//     // await iminPrinter.printText(
//     //   '--------------------------------',
//     //   style: IminTextStyle(align: IminPrintAlign.center, fontSize: 20),
//     // );

//     final subTotalPrice = products.fold<int>(
//         0,
//         (previousValue, element) =>
//             previousValue +
//             (element.product.price!.toIntegerFromText * element.quantity));

//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Subtotal $totalQuantity Product',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: subTotalPrice.currencyFormatRpV2,
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );

//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Discount',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: discount.currencyFormatRpV2,
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );
//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Tax PB1 (10%)',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: '${(totalPrice * 0.1).ceil()}'.currencyFormatRpV2,
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );
//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Service Charge(5%)',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: '${(totalPrice * 0.05).ceil()}'.currencyFormatRpV2,
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );
//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Total',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: totalPrice.currencyFormatRpV2,
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );

//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Bayar',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: nominalBayar.currencyFormatRpV2,
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );
//     await iminPrinter.printColumnsText(
//       cols: [
//         ColumnMaker(
//           text: 'Kembali',
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.left,
//         ),
//         ColumnMaker(
//           text: kembalian.currencyFormatRpV2,
//           width: 2,
//           fontSize: 20,
//           align: IminPrintAlign.right,
//         ),
//       ],
//     );

//     await iminPrinter.printText(
//       'Terima Kasih',
//       style: IminTextStyle(align: IminPrintAlign.center, fontSize: 20),
//     );

//     await iminPrinter.printAndFeedPaper(100);
//     await iminPrinter.partialCut();
//   }
// }
