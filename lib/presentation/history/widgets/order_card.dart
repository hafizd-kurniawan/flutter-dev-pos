import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/models/response/order_response_model.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final OrderResponseModel order;
  final VoidCallback onStatusUpdate;
  final VoidCallback? onPrint; // NEW
  final VoidCallback? onShare; // NEW

  const OrderCard({
    Key? key,
    required this.order,
    required this.onStatusUpdate,
    this.onPrint, // NEW
    this.onShare, // NEW
  }) : super(key: key);

  Color _getStatusColor() {
    switch (order.status.toLowerCase()) {
      case 'paid':
        return Colors.blue;
      case 'cooking':
        return Colors.orange;
      case 'complete':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (order.status.toLowerCase()) {
      case 'paid':
        return Icons.payment;
      case 'cooking':
        return Icons.restaurant;
      case 'complete':
        return Icons.check_circle;
      default:
        return Icons.receipt;
    }
  }

  String _getButtonText() {
    switch (order.status.toLowerCase()) {
      case 'paid':
        return 'Start Cooking';
      case 'cooking':
        return 'Mark Complete';
      default:
        return 'Done';
    }
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null) return '-';
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat('dd MMM yyyy, HH:mm').format(date);
    } catch (e) {
      return dateTime;
    }
  }

  // NEW: Get order source color
  Color _getOrderSourceColor() {
    final type = order.orderType?.toLowerCase() ?? '';
    if (type.contains('self')) return Colors.purple;
    if (type == 'takeaway') return Colors.orange;
    if (type == 'dine_in') return Colors.blue;
    return Colors.grey;
  }

  // NEW: Get order source icon
  IconData _getOrderSourceIcon() {
    final type = order.orderType?.toLowerCase() ?? '';
    if (type.contains('self')) return Icons.phone_android;
    if (type == 'takeaway') return Icons.shopping_bag;
    if (type == 'dine_in') return Icons.restaurant_menu;
    return Icons.receipt;
  }

  // NEW: Get order source text
  String _getOrderSourceText() {
    final type = order.orderType?.toLowerCase() ?? '';
    if (type.contains('self')) return 'Self-Order';
    if (type == 'takeaway') return 'Takeaway';
    if (type == 'dine_in') return 'Dine In';
    return 'Walk-in';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getStatusColor().withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order Code & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order.code,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(),
                        size: 16,
                        color: _getStatusColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 24),

            // Order Source Info - NEW
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getOrderSourceColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
                border:
                    Border.all(color: _getOrderSourceColor().withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getOrderSourceIcon(),
                      size: 14, color: _getOrderSourceColor()),
                  const SizedBox(width: 4),
                  Text(
                    _getOrderSourceText(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getOrderSourceColor(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Customer Info
            if (order.customerName != null) ...[
              Row(
                children: [
                  const Icon(Icons.person, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    order.customerName!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Table Number
            if (order.tableNumber != null) ...[
              Row(
                children: [
                  const Icon(Icons.table_restaurant,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Table: ${order.tableNumber}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Time
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(order.placedAt),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Order Items
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Items:',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...order.orderItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.productName}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            Text(
                              item.total.currencyFormatRp,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Pricing Breakdown - ALWAYS SHOW for full transparency
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💰 Rincian Pembayaran',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtotal - ALWAYS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(fontSize: 13)),
                      Text(
                        order.subtotal.currencyFormatRp,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  // Discount - ALWAYS (show even if 0)
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Diskon:',
                        style: TextStyle(
                          fontSize: 13,
                          color: (order.discountAmount != null &&
                                  order.discountAmount! > 0)
                              ? Colors.green
                              : Colors.grey[600],
                        ),
                      ),
                      Text(
                        (order.discountAmount != null &&
                                order.discountAmount! > 0)
                            ? '- ${order.discountAmount!.currencyFormatRp}'
                            : 'Rp 0',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: (order.discountAmount != null &&
                                  order.discountAmount! > 0)
                              ? Colors.green
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  // Tax - ALWAYS (show even if 0)
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pajak${(order.taxPercentage != null && order.taxPercentage! > 0) ? " (${order.taxPercentage}%)" : ""}:',
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        (order.taxAmount ?? 0).currencyFormatRp,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  // Service - ALWAYS (show even if 0)
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Layanan${(order.serviceChargePercentage != null && order.serviceChargePercentage! > 0) ? " (${order.serviceChargePercentage}%)" : ""}:',
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        (order.serviceChargeAmount ?? 0).currencyFormatRp,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 16),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  order.totalAmount.currencyFormatRp,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            // Payment Method
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  order.paymentMethod.toLowerCase() == 'cash'
                      ? Icons.money
                      : Icons.qr_code,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  order.paymentMethod.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),



            // Action Buttons (Status Update, Print, Share)
            const SizedBox(height: 16),
            Row(
              children: [
                // Status Update Button (Expanded)
                if (order.status != 'complete') 
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onStatusUpdate,
                      icon: Icon(
                        order.status == 'paid'
                            ? Icons.restaurant
                            : Icons.check_circle,
                      ),
                      label: Text(_getButtonText()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getStatusColor(),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                
                if (order.status != 'complete') const SizedBox(width: 8),

                // Print Button
                if (onPrint != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.print, color: Colors.black87),
                      tooltip: 'Print Receipt',
                      onPressed: onPrint,
                    ),
                  ),

                const SizedBox(width: 8),

                // Share Button
                if (onShare != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.blue),
                      tooltip: 'Share Receipt',
                      onPressed: onShare,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
