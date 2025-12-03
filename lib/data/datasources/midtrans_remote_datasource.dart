import 'dart:convert';
import 'dart:developer';

import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/helpers/api_helper.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/qris_response_model.dart';
import 'package:flutter_posresto_app/data/models/response/qris_status_response_model.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:http/http.dart' as http;

class MidtransRemoteDatasource {
  String generateBasicAuthHeader(String serverKey) {
    final base64Credentials = base64Encode(utf8.encode('$serverKey:'));
    final authHeader = 'Basic $base64Credentials';

    return authHeader;
  }

  Future<QrisResponseModel> generateQRCode(
      String orderId,
      int grossAmount,
      List<ProductQuantity> items,
      String customerName,
      int tableNumber,
      String orderType,
      int discount,
      int tax,
      int serviceCharge,
      String notes,
  ) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final tenantId = authData.tenant?.id;
    final cashierName = authData.user?.name ?? 'Cashier'; // Get Cashier Name
    final headers = await ApiHelper.getHeaders(); // Use ApiHelper for Auth headers

    final body = jsonEncode({
      'tenant_id': tenantId,
      'customer_name': customerName,
      'table_number': tableNumber.toString(),
      'cart_items': items.map((e) => {
        'product_id': e.product.id,
        'qty': e.quantity,
        'price': e.product.price,
        'name': e.product.name,
        'note': e.note, // Send Item Note
      }).toList(),
      'payment_method': 'qris',
      'order_type': orderType,
      'discount_amount': discount,
      'tax_amount': tax,
      'service_charge_amount': serviceCharge,
      'notes': notes,
      'cashier_name': cashierName,
    });

    log("📤 Sending QRIS Request to Backend...");
    log("Body: $body");

    final response = await http.post(
      Uri.parse('${Variables.baseUrl}/api/order/create-qris'),
      headers: headers,
      body: body,
    );

    log("StatusCode: ${response.statusCode}");
    log("Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      
      // Map Laravel response to QrisResponseModel
      // Laravel returns: { success, order_id, order_code, qr_string, payment_url, ... }
      // QrisResponseModel expects: { actions: [{ url: ... }], ... }
      
      final paymentUrl = jsonResponse['payment_url'];
      final qrString = jsonResponse['qr_string'];
      final orderCode = jsonResponse['order_code'];
      
      final mappedJson = {
        'status_code': '201',
        'status_message': 'Success',
        'transaction_id': orderCode,
        'order_id': orderCode,
        'gross_amount': grossAmount.toString(),
        'payment_type': 'qris',
        'transaction_status': 'pending',
        'actions': [
          {
            'name': 'generate-qr-code',
            'method': 'GET',
            'url': qrString ?? paymentUrl ?? '' // Prioritize qrString over paymentUrl
          }
        ]
      };
      
      return QrisResponseModel.fromMap(mappedJson);
    } else {
      throw Exception('Failed to generate QR Code: ${response.body}');
    }
  }

  Future<QrisStatusResponseModel> checkPaymentStatus(String orderId) async {
    final serverKey = await AuthLocalDataSource().getMitransServerKey();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': generateBasicAuthHeader(serverKey),
    };

    try {
      // Call Laravel API instead of Midtrans directly
      // This handles both Real and Mock orders securely
      final response = await http.get(
        Uri.parse('${Variables.baseUrl}/api/order/$orderId/status'),
        headers: headers,
      );

      log("StatusCode: ${response.statusCode}");
      log("Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return QrisStatusResponseModel.fromMap(data);
      } else {
        throw Exception('Failed to check payment status');
      }
    } catch (e) {
      throw Exception('Error checking payment status: $e');
    }
  }
}
