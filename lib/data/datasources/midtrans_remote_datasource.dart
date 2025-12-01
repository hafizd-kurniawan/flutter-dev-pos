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
  ) async {
    final authData = await AuthLocalDataSource().getAuthData();
    final tenantId = authData.tenant?.id;
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
      }).toList(),
      'payment_method': 'qris',
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
            'url': paymentUrl ?? ''
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

    final response = await http.get(
      Uri.parse('https://api.midtrans.com/v2/$orderId/status'),
      // Uri.parse('https://api.sandbox.midtrans.com/v2/$orderId/status'),
      headers: headers,
    );
    log("StatusCode: ${response.statusCode}");
    log("Body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return QrisStatusResponseModel.fromJson(response.body);
    } else {
      throw Exception('Failed to check payment status');
    }
  }
}
