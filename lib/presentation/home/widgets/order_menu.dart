import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; // NEW: Google Fonts
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';

import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';

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
            child: SizedBox(
              width: 64,
              height: 64,
              child: data.product.image != null && data.product.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: data.product.image!.toImageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[100],
                        child: Icon(Icons.fastfood, size: 32, color: AppColors.primary.withOpacity(0.5)),
                      ),
                    )
                  : Container(
                      color: Colors.grey[100],
                      child: Icon(Icons.fastfood, size: 32, color: AppColors.primary.withOpacity(0.5)),
                    ),
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
                  style: GoogleFonts.quicksand(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  (data.product.price ?? '0').toIntegerFromText.currencyFormatRp,
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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
                        style: GoogleFonts.quicksand(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
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
                      '+ ${AppLocalizations.of(context)!.add_note}',
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
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
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.remove, size: 16, color: AppColors.primary),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      child: Center(
                        child: Text(
                          data.quantity.toString(),
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.read<CheckoutBloc>().add(CheckoutEvent.addItem(data.product)),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
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
                style: GoogleFonts.quicksand(
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
            child: SizedBox(
              width: 40,
              height: 40,
              child: data.product.image != null && data.product.image!.isNotEmpty
                  ? (data.product.image!.contains('http')
                      ? CachedNetworkImage(
                          imageUrl: data.product.image!.toImageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[100],
                            child: Icon(Icons.fastfood, size: 20, color: AppColors.primary.withOpacity(0.5)),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: data.product.image!.toImageUrl,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[100],
                            child: Icon(Icons.fastfood, size: 20, color: AppColors.primary.withOpacity(0.5)),
                          ),
                        ))
                  : Container(
                      color: Colors.grey[100],
                      child: Icon(Icons.fastfood, size: 20, color: AppColors.primary.withOpacity(0.5)),
                    ),
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
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                
                // Price (Single Item)
                Text(
                  (data.product.price ?? '0').toIntegerFromText.currencyFormatRp,
                  style: GoogleFonts.quicksand(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
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
                            style: GoogleFonts.quicksand(
                              fontSize: 11,
                              color: AppColors.primary,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
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
                      '+ ${AppLocalizations.of(context)!.add_note}',
                      style: GoogleFonts.quicksand(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
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
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.black87,
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
                style: GoogleFonts.quicksand(
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
              Text(
                AppLocalizations.of(context)!.item_note,
                style: GoogleFonts.quicksand(
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
                    style: GoogleFonts.quicksand(fontWeight: FontWeight.w500),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.order_note_example,
                      hintStyle: GoogleFonts.quicksand(color: Colors.grey[400]),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      counterText: "", // Hide default counter
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    AppLocalizations.of(context)!.max_chars,
                    style: GoogleFonts.quicksand(
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
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: GoogleFonts.quicksand(
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
                    child: Text(
                      AppLocalizations.of(context)!.save,
                      style: GoogleFonts.quicksand(
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
