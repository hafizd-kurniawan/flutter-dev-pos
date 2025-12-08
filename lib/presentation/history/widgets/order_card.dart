import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart'; // NEW
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/models/response/order_response_model.dart';
import 'package:intl/intl.dart';

import 'package:google_fonts/google_fonts.dart'; // NEW

class OrderCard extends StatelessWidget {
  final OrderResponseModel order;
  final VoidCallback onStatusUpdate;
  final VoidCallback? onPrint;
  final VoidCallback? onShare;

  const OrderCard({
    Key? key,
    required this.order,
    required this.onStatusUpdate,
    this.onPrint,
    this.onShare,
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

  Color _getOrderSourceColor() {
    final type = order.orderType?.toLowerCase() ?? '';
    if (type.contains('self')) return Colors.purple;
    if (type == 'takeaway') return Colors.orange;
    if (type == 'dine_in') return Colors.blue;
    return Colors.grey;
  }

  IconData _getOrderSourceIcon() {
    final type = order.orderType?.toLowerCase() ?? '';
    if (type.contains('self')) return Icons.phone_android;
    if (type == 'takeaway') return Icons.shopping_bag;
    if (type == 'dine_in') return Icons.restaurant_menu;
    return Icons.receipt;
  }

  String _getOrderSourceText() {
    final type = order.orderType?.toLowerCase() ?? '';
    if (type.contains('self')) return 'Self-Order';
    if (type == 'takeaway') return 'Takeaway';
    if (type == 'dine_in') return 'Dine In';
    return 'Walk-in';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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
                        style: GoogleFonts.quicksand(
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

            const Divider(height: 24, color: Color(0xFFEEEEEE)),

            // Order Source Info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _getOrderSourceColor().withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getOrderSourceColor().withOpacity(0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getOrderSourceIcon(),
                      size: 14, color: _getOrderSourceColor()),
                  const SizedBox(width: 6),
                  Text(
                    _getOrderSourceText(),
                    style: GoogleFonts.quicksand(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getOrderSourceColor(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Customer Info
            if (order.customerName != null) ...[
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    order.customerName!,
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Table Number
            if (order.tableNumber != null) ...[
              Row(
                children: [
                  const Icon(Icons.table_restaurant_outlined,
                      size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Table: ${order.tableNumber}',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Cashier Info
            if (order.cashierName != null) ...[
              Row(
                children: [
                  const Icon(Icons.badge_outlined, size: 18, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Cashier: ${order.cashierName}',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
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
                  style: GoogleFonts.quicksand(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            // Global Note
            if (order.note != null && order.note!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellow.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan Pesanan:',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.note!,
                      style: GoogleFonts.quicksand(
                        fontSize: 13,
                        color: Colors.orange[900],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Order Items
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items:',
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...order.orderItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.quantity}x ${item.productName}',
                                    style: GoogleFonts.quicksand(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (item.note != null && item.note!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Text(
                                        'Note: ${item.note}',
                                        style: GoogleFonts.quicksand(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              item.total.currencyFormatRp,
                              style: GoogleFonts.quicksand(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pricing Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50]!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💰 Rincian Pembayaran',
                    style: GoogleFonts.quicksand(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Subtotal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal:', style: GoogleFonts.quicksand(fontSize: 13, color: Colors.grey[700])),
                      Text(
                        order.subtotal.currencyFormatRp,
                        style: GoogleFonts.quicksand(
                            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),

                  // Discount
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Diskon:',
                          style: GoogleFonts.quicksand(
                            fontSize: 13,
                            color: (order.discountAmount != null &&
                                    order.discountAmount! > 0)
                                ? Colors.green[700]
                                : Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        (order.discountAmount != null &&
                                order.discountAmount! > 0)
                            ? '- ${order.discountAmount!.currencyFormatRp}'
                            : 'Rp 0',
                        style: GoogleFonts.quicksand(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: (order.discountAmount != null &&
                                  order.discountAmount! > 0)
                              ? Colors.green[700]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  // Tax
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Pajak${(order.taxPercentage != null && order.taxPercentage! > 0) ? " (${order.taxPercentage}%)" : ""}:',
                          style: GoogleFonts.quicksand(fontSize: 13, color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (order.taxAmount ?? 0).currencyFormatRp,
                        style: GoogleFonts.quicksand(
                            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),

                  // Service
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          'Layanan${(order.serviceChargePercentage != null && order.serviceChargePercentage! > 0) ? " (${order.serviceChargePercentage}%)" : ""}:',
                          style: GoogleFonts.quicksand(fontSize: 13, color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        (order.serviceChargeAmount ?? 0).currencyFormatRp,
                        style: GoogleFonts.quicksand(
                            fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 32, color: Color(0xFFEEEEEE)),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: GoogleFonts.quicksand(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  order.totalAmount.currencyFormatRp,
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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
                  style: GoogleFonts.quicksand(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            // Action Buttons
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                // Check if we have enough space for the full button
                // Print (~52px) + Share (~52px) + Status Button (~120px) = ~224px
                final isTight = constraints.maxWidth < 280;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Print Button
                    if (onPrint != null)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.print_outlined, size: 20, color: Colors.black87),
                          tooltip: 'Print Receipt',
                          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                          padding: EdgeInsets.zero,
                          onPressed: onPrint,
                        ),
                      ),

                    // Share Button
                    if (onShare != null)
                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.share_outlined, size: 20, color: Colors.blue),
                          tooltip: 'Share Receipt',
                          constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                          padding: EdgeInsets.zero,
                          onPressed: onShare,
                        ),
                      ),

                    // Status Update Button
                    if (order.status != 'complete')
                      Flexible(
                        child: isTight
                            ? Container(
                                decoration: BoxDecoration(
                                  color: _getStatusColor(),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: onStatusUpdate,
                                  icon: Icon(
                                    order.status == 'paid'
                                        ? Icons.restaurant
                                        : Icons.check_circle_outline,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  tooltip: _getButtonText(),
                                  constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                                  padding: EdgeInsets.zero,
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: onStatusUpdate,
                                icon: Icon(
                                  order.status == 'paid'
                                      ? Icons.restaurant
                                      : Icons.check_circle_outline,
                                  size: 18,
                                ),
                                label: Text(
                                  _getButtonText(),
                                  style: GoogleFonts.quicksand(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _getStatusColor(),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
