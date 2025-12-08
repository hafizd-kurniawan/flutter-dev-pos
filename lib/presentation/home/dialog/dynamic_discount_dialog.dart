
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';
import 'package:flutter_posresto_app/data/datasources/pos_settings_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/discount_response_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/pos_settings/pos_settings_bloc.dart';

import '../../../core/constants/colors.dart';

class DynamicDiscountDialog extends StatefulWidget {
  const DynamicDiscountDialog({super.key});

  @override
  State<DynamicDiscountDialog> createState() => _DynamicDiscountDialogState();
}

class _DynamicDiscountDialogState extends State<DynamicDiscountDialog> {
  final _localDatasource = PosSettingsLocalDatasource();
  int? _selectedDiscountId;

  @override
  void initState() {
    super.initState();
    _loadSelectedDiscount();
  }

  Future<void> _loadSelectedDiscount() async {
    final discountId = await _localDatasource.getSelectedDiscountId();
    setState(() {
      _selectedDiscountId = discountId;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            'Pilih Diskon',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close, color: Colors.grey),
            style: IconButton.styleFrom(
              backgroundColor: Colors.grey[100],
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
      content: BlocBuilder<PosSettingsBloc, PosSettingsState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            loading: () => const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (message) => SizedBox(
              height: 100,
              child: Center(child: Text('Error: $message')),
            ),
            loaded: (settings) {
              final discounts = settings.discounts;

              if (discounts.isEmpty) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text('Tidak ada diskon tersedia')),
                );
              }

              return SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Option: No discount
                      _buildDiscountOption(
                        context,
                        id: null,
                        name: 'Tanpa Diskon',
                        description: 'Tidak menggunakan diskon',
                        isSelected: _selectedDiscountId == null,
                        onTap: () async {
                          await _localDatasource.saveSelectedDiscount(null);
                          if (!context.mounted) return;
                          context.read<CheckoutBloc>().add(const CheckoutEvent.removeDiscount());
                          setState(() => _selectedDiscountId = null);
                          context.pop();
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // Available discounts
                      ...discounts.map((discount) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildDiscountOption(
                            context,
                            id: discount.id,
                            name: discount.name,
                            description: discount.displayText,
                            isSelected: _selectedDiscountId == discount.id,
                            onTap: () async {
                              await _localDatasource.saveSelectedDiscount(discount.id);
                              if (!context.mounted) return;
                              
                              context.read<CheckoutBloc>().add(
                                    CheckoutEvent.addDiscount(
                                      Discount(
                                        id: discount.id,
                                        name: discount.name,
                                        value: discount.value.toString(),
                                        type: discount.type,
                                      ),
                                    ),
                                  );
                              
                              setState(() => _selectedDiscountId = discount.id);
                              
                              NotificationHelper.showSuccess(context, 'Discount applied successfully');
                              context.pop();
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDiscountOption(
    BuildContext context, {
    required int? id,
    required String name,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                id == null ? Icons.money_off : Icons.percent,
                color: isSelected ? AppColors.primary : Colors.grey[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
