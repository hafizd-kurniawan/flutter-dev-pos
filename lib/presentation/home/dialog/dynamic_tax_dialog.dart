import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/data/datasources/pos_settings_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/pos_settings/pos_settings_bloc.dart';

import '../../../core/constants/colors.dart';

class DynamicTaxDialog extends StatefulWidget {
  const DynamicTaxDialog({super.key});

  @override
  State<DynamicTaxDialog> createState() => _DynamicTaxDialogState();
}

class _DynamicTaxDialogState extends State<DynamicTaxDialog> {
  final _localDatasource = PosSettingsLocalDatasource();
  int? _selectedTaxId;

  @override
  void initState() {
    super.initState();
    _loadSelectedTax();
  }

  Future<void> _loadSelectedTax() async {
    final taxId = await _localDatasource.getSelectedTaxId();
    setState(() {
      _selectedTaxId = taxId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'PILIH PAJAK',
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
              final taxes = settings.taxes;

              if (taxes.isEmpty) {
                return const Text('Tidak ada pajak tersedia');
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Option: No tax
                    RadioListTile<int?>(
                      title: const Text('Tidak ada pajak'),
                      subtitle: const Text('Tidak menggunakan pajak'),
                      value: null,
                      groupValue: _selectedTaxId,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) async {
                        // Save selection
                        await _localDatasource.saveSelectedTax(null);

                        // Remove tax from checkout
                        context.read<CheckoutBloc>().add(
                              const CheckoutEvent.addTax(0),
                            );

                        // Update UI
                        setState(() {
                          _selectedTaxId = null;
                        });

                        // Close dialog
                        if (mounted) {
                          context.pop();
                        }
                      },
                    ),

                    const Divider(),

                    // Available taxes
                    ...taxes.map((tax) {
                      return RadioListTile<int>(
                        title: Text(tax.name),
                        subtitle: Text(tax.displayText),
                        value: tax.id,
                        groupValue: _selectedTaxId,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) async {
                          // Save selection
                          await _localDatasource.saveSelectedTax(value);

                          // Debug log
                          print('🔧 Applying tax: ${tax.name} = ${tax.value.toInt()}%');

                          // Apply tax to checkout
                          context.read<CheckoutBloc>().add(
                                CheckoutEvent.addTax(tax.value.toInt()),
                              );

                          // Update UI
                          setState(() {
                            _selectedTaxId = value;
                          });

                          // Show success message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('✅ Pajak ${tax.name} diterapkan'),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 1),
                              ),
                            );

                            // Close dialog
                            context.pop();
                          }
                        },
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
