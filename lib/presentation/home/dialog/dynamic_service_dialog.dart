import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/data/datasources/pos_settings_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/pos_settings/pos_settings_bloc.dart';

import '../../../core/constants/colors.dart';

class DynamicServiceDialog extends StatefulWidget {
  const DynamicServiceDialog({super.key});

  @override
  State<DynamicServiceDialog> createState() => _DynamicServiceDialogState();
}

class _DynamicServiceDialogState extends State<DynamicServiceDialog> {
  final _localDatasource = PosSettingsLocalDatasource();
  int? _selectedServiceId;

  @override
  void initState() {
    super.initState();
    _loadSelectedService();
  }

  Future<void> _loadSelectedService() async {
    final serviceId = await _localDatasource.getSelectedServiceId();
    setState(() {
      _selectedServiceId = serviceId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'PILIH LAYANAN',
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
              final services = settings.services;

              if (services.isEmpty) {
                return const Text('Tidak ada layanan tersedia');
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Option: No service
                    RadioListTile<int?>(
                      title: const Text('Tidak ada layanan'),
                      subtitle: const Text('Tidak menggunakan biaya layanan'),
                      value: null,
                      groupValue: _selectedServiceId,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) async {
                        // Save selection
                        await _localDatasource.saveSelectedService(null);

                        // Remove service from checkout
                        context.read<CheckoutBloc>().add(
                              const CheckoutEvent.addServiceCharge(0),
                            );

                        // Update UI
                        setState(() {
                          _selectedServiceId = null;
                        });

                        // Close dialog
                        if (mounted) {
                          context.pop();
                        }
                      },
                    ),

                    const Divider(),

                    // Available services
                    ...services.map((service) {
                      return RadioListTile<int>(
                        title: Text(service.name),
                        subtitle: Text(service.displayText),
                        value: service.id,
                        groupValue: _selectedServiceId,
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (value) async {
                          // Save selection
                          await _localDatasource.saveSelectedService(value);

                          // Apply service to checkout
                          context.read<CheckoutBloc>().add(
                                CheckoutEvent.addServiceCharge(service.value.toInt()),
                              );

                          // Update UI
                          setState(() {
                            _selectedServiceId = value;
                          });

                          // Show success message
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('✅ Layanan ${service.name} diterapkan'),
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
