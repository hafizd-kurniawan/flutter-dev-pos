import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/datasources/stock_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/product_response_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

class ProductCard extends StatelessWidget {
  final Product data;
  final VoidCallback onCartButton;

  const ProductCard({
    super.key,
    required this.data,
    required this.onCartButton,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Get current quantity in cart
        final checkoutState = context.read<CheckoutBloc>().state;
        int currentQtyInCart = 0;
        
        checkoutState.maybeWhen(
          orElse: () {},
          loaded: (products, _, __, ___, ____, _____, ______, _______, ________, _________) {
            final existingItem = products.where((p) => p.product.id == data.id).firstOrNull;
            currentQtyInCart = existingItem?.quantity ?? 0;
          },
        );
        
        // Check if adding 1 more will exceed stock
        final requestedQty = currentQtyInCart + 1;
        final availableStock = data.stock ?? 0;
        
        if (requestedQty > availableStock) {
          // Stock insufficient
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Stok tidak cukup! Tersedia: $availableStock, Di keranjang: $currentQtyInCart'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }
        
        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
        
        // Validate stock from server
        final result = await StockRemoteDatasource().getProductStock(data.id ?? 0);
        
        if (!context.mounted) return;
        Navigator.pop(context); // Close loading
        
        result.fold(
          (error) {
            // Network error, allow add with local stock check
            context.read<CheckoutBloc>().add(CheckoutEvent.addItem(data));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('⚠️ Tidak dapat verifikasi stok online. Ditambahkan berdasarkan stok lokal.'),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          (stockData) {
            final serverStock = stockData['current_stock'] ?? 0;
            final isAvailable = stockData['is_available'] ?? false;
            
            if (!isAvailable || serverStock < requestedQty) {
              // Stock not available on server
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ Stok tidak cukup! Server stock: $serverStock'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else {
              // Stock available, add to cart
              context.read<CheckoutBloc>().add(CheckoutEvent.addItem(data));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ ${data.name} ditambahkan ke keranjang'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
        );
      },
      child: Container(
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
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section (Full Width, Expanded)
                  Expanded(
                    flex: 1, // Changed from 4 to 1 (Equal split)
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[50],
                      child: (data.image != null && data.image!.isNotEmpty && data.image != 'null')
                          ? CachedNetworkImage(
                              imageUrl: data.image!.toImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: Icon(Icons.fastfood, size: 40, color: Colors.grey[300]),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(Icons.fastfood, size: 40, color: AppColors.primary),
                              ),
                            )
                          : Center(
                              child: Icon(Icons.fastfood, size: 50, color: AppColors.primary),
                            ),
                    ),
                  ),
                  
                  // Details Section
                  Expanded(
                    flex: 1, // Changed from 3 to 1 (Equal split)
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), // Reduced from 12.0
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Name
                          Text(
                            data.name ?? 'Unknown Product',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14, // Reduced from 15
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                              height: 1.2,
                            ),
                          ),
                          
                          // Price & Stock
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (data.price ?? '0').toIntegerFromText.currencyFormatRp,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(height: 2), // Reduced from 6
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (data.stock ?? 0) > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  (data.stock ?? 0) > 0 ? 'Stok: ${data.stock}' : 'Habis',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: (data.stock ?? 0) > 0 ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity Badge / Add Button
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const SizedBox(),
                  loaded: (products,
                      discountModel,
                      discount,
                      discountAmount,
                      tax,
                      serviceCharge,
                      totalQuantity,
                      totalPrice,
                      draftName,
                      orderNote) {
                    return products.any((element) => element.product == data)
                        ? products
                                    .firstWhere(
                                        (element) => element.product == data)
                                    .quantity >
                                0
                            ? Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(16),
                                      bottomLeft: Radius.circular(16),
                                    ),
                                    color: AppColors.primary,
                                  ),
                                  child: Center(
                                    child: Text(
                                      products
                                          .firstWhere((element) =>
                                              element.product == data)
                                          .quantity
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: AppColors.primary,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.4),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              )
                        : Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 36,
                              height: 36,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.primary,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
