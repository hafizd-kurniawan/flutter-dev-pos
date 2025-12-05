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
        padding: const EdgeInsets.all(16.0),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.card),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpaceHeight(8),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.disabled.withOpacity(0.4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(40.0)),
                    child: (data.image != null && data.image!.isNotEmpty && data.image != 'null')
                        ? CachedNetworkImage(
                            imageUrl: data.image!.toImageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: Icon(Icons.fastfood, size: 30, color: Colors.grey[400]),
                            ),
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
                ),
                const Spacer(),
                Text(
                  data.name ?? 'Unknown Product',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stock indicator
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (data.stock ?? 0) > 0 ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: (data.stock ?? 0) > 0 ? Colors.green : Colors.red,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Stock: ${data.stock ?? 0}',
                          style: TextStyle(
                            color: (data.stock ?? 0) > 0 ? Colors.green.shade700 : Colors.red.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Price
                    Flexible(
                      child: Text(
                        (data.price ?? '0').toIntegerFromText.currencyFormatRp,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.0)),
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
                                          fontSize: 20,
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
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9.0)),
                                    color: AppColors.primary,
                                  ),
                                  child: Assets.icons.shoppingBasket.svg(),
                                ),
                              )
                        : Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 36,
                              height: 36,
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9.0)),
                                color: AppColors.primary,
                              ),
                              child: Assets.icons.shoppingBasket.svg(),
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
