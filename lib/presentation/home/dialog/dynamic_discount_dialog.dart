import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
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
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'PILIH DISKON',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.cancel,
                color: AppColors.primary,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      content: BlocBuilder<PosSettingsBloc, PosSettingsState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            error: (message) => Center(
              child: Text('Error: $message'),
            ),
            loaded: (settings) {
              final discounts = settings.discounts;

              if (discounts.isEmpty) {
                return const Text('Tidak ada diskon tersedia');
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Option: No discount
                    RadioListTile<int?>(
                      title: const Text('Tidak ada diskon'),
                      subtitle: const Text('Tidak menggunakan diskon'),
                      value: null,
                      groupValue: _selectedDiscountId,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) async {
                        // Save selection
                        await _localDatasource.saveSelectedDiscount(null);

                        // Remove discount from checkout
                        context.read<CheckoutBloc>().add(
                              const CheckoutEvent.removeDiscount(),
                            );

                        // Update UI
                        setState(() {
                          _selectedDiscountId = null;
                        });

                        // Close dialog
                        if (mounted) {
                          context.pop();
                        }
                      },
                    ),

                    const Divider(),

                    // Available discounts
                    ...discounts.map((discount) {
                      final isSelected = _selectedDiscountId == discount.id;
                      return InkWell(
                        onTap: () async {
                          print('🔵 Discount tapped: ${discount.name}, ID: ${discount.id}');
                          print('   Current selected: $_selectedDiscountId');
                          
                          // Save selection
                          await _localDatasource.saveSelectedDiscount(discount.id);
                          print('✅ Saved to local storage');

                          // Apply discount to checkout (ALWAYS apply, even if already selected)
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
                          print('✅ Applied to CheckoutBloc');

                          // Update UI
                          setState(() {
                            _selectedDiscountId = discount.id;
                          });

                          // Show success message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('✅ Diskon ${discount.name} diterapkan'),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              ),
                            );

                            // Close dialog
                            context.pop();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Radio indicator
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : Colors.grey,
                                    width: 2,
                                  ),
                                ),
                                child: isSelected
                                    ? Center(
                                        child: Container(
                                          width: 10,
                                          height: 10,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                              // Text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      discount.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      discount.displayText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: isSelected ? AppColors.primary : Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
