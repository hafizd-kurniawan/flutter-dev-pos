import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class OrderMenu extends StatelessWidget {
  final ProductQuantity data;
  const OrderMenu({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if we are in a very narrow container (e.g. tablet sidebar)
        final isCompact = constraints.maxWidth < 350;
        
        if (isCompact) {
          return _buildCompactLayout(context);
        } else {
          return _buildSpaciousLayout(context);
        }
      },
    );
  }

  // === SPACIOUS LAYOUT (Like ConfirmPaymentPage) ===
  Widget _buildSpaciousLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Image (Larger)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: data.product.image != null && data.product.image!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: data.product.image!.toImageUrl,
                    width: 64.0,
                    height: 64.0,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(
                      Icons.fastfood,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(
                    Icons.fastfood,
                    size: 64,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(width: 16),
          
          // 2. Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.product.name ?? "-",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (data.product.price ?? '0').toIntegerFromText.currencyFormatRp,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (data.note.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _showNoteDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Note: ${data.note}",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () => _showNoteDialog(context),
                    child: Text(
                      '+ Tambah Catatan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // 3. Qty & Total (Vertical Stack)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Qty Controls
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => context.read<CheckoutBloc>().add(CheckoutEvent.removeItem(data.product)),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Icons.remove, size: 16, color: AppColors.primary),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      child: Center(
                        child: Text(
                          data.quantity.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.read<CheckoutBloc>().add(CheckoutEvent.addItem(data.product)),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Icons.add, size: 16, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ((data.product.price ?? '0').toIntegerFromText * data.quantity)
                    .currencyFormatRp,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // === COMPACT LAYOUT (For Narrow Sidebar) ===
  Widget _buildCompactLayout(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: data.product.image != null && data.product.image!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: data.product.image!.toImageUrl,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(
                      Icons.fastfood,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  )
                : Icon(
                    Icons.fastfood,
                    size: 40,
                    color: AppColors.primary,
                  ),
          ),
          const SizedBox(width: 12),
          
          // 2. Product Details (Name, Price, Note)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                Text(
                  data.product.name ?? "-",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Price (Single Item)
                Text(
                  (data.product.price ?? '0').toIntegerFromText.currencyFormatRp,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                
                // Note (if any)
                if (data.note.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: () => _showNoteDialog(context),
                    child: Row(
                      children: [
                        Icon(Icons.edit_note, size: 14, color: AppColors.primary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            data.note,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Add Note Button (Small)
                  const SizedBox(height: 2),
                  InkWell(
                    onTap: () => _showNoteDialog(context),
                    child: Text(
                      '+ Catatan',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // 3. Qty & Total Price Column
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Qty Controls
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQtyButton(
                    context, 
                    icon: Icons.remove, 
                    onTap: () => context.read<CheckoutBloc>().add(CheckoutEvent.removeItem(data.product)),
                    isCompact: true,
                  ),
                  SizedBox(
                    width: 20,
                    child: Center(
                      child: Text(
                        data.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  _buildQtyButton(
                    context, 
                    icon: Icons.add, 
                    onTap: () => context.read<CheckoutBloc>().add(CheckoutEvent.addItem(data.product)),
                    isCompact: true,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              
              // Total Price
              Text(
                ((data.product.price ?? '0').toIntegerFromText * data.quantity)
                    .currencyFormatRp,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyButton(BuildContext context, {
    required IconData icon, 
    required VoidCallback onTap,
    required bool isCompact,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: isCompact ? 16 : 18,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _showNoteDialog(BuildContext context) {
    final noteController = TextEditingController(text: data.note);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          titlePadding: const EdgeInsets.all(24),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          actionsPadding: const EdgeInsets.all(24),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Catatan Item',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.grey),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: noteController,
                    maxLength: 100,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Contoh: Jangan pedas, Es sedikit',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                      counterText: "", // Hide default counter
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Maksimal 100 karakter',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CheckoutBloc>().add(
                            CheckoutEvent.addNoteToItem(data.product, noteController.text),
                          );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
