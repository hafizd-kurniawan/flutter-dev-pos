import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/local_product/local_product_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_product/sync_product_bloc.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sync Data',
            style: GoogleFonts.quicksand(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sinkronisasi data dari dan ke server',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          BlocConsumer<SyncProductBloc, SyncProductState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                error: (message) {
                  NotificationHelper.showError(context, message);
                },
                loaded: (productResponseModel) {
                  // Reload home page
                  if (context.mounted) {
                    context.read<LocalProductBloc>().add(
                          const LocalProductEvent.getLocalProduct(),
                        );
                  }
                  
                  if (context.mounted) {
                    NotificationHelper.showSuccess(context, '${productResponseModel.data?.length ?? 0} produk berhasil disinkronkan!');
                  }
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return _buildSyncButton(
                    onPressed: () {
                      context
                          .read<SyncProductBloc>()
                          .add(const SyncProductEvent.syncProduct());
                    },
                    icon: Icons.sync,
                    label: AppLocalizations.of(context)!.sync_products_now,
                    color: AppColors.primary,
                  );
                },
                loading: () {
                  return _buildLoadingButton('Syncing...');
                },
              );
            },
          ),
          const SizedBox(height: 16),
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                error: (message) {
                  NotificationHelper.showError(context, message);
                },
                loaded: () {
                  NotificationHelper.showSuccess(context, 'Sync Order Success');
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return _buildSyncButton(
                    onPressed: () {
                      context
                          .read<SyncOrderBloc>()
                          .add(const SyncOrderEvent.syncOrder());
                    },
                    icon: Icons.cloud_upload,
                    label: AppLocalizations.of(context)!.sync_orders_now,
                    color: Colors.green,
                  );
                },
                loading: () {
                  return _buildLoadingButton('Syncing...');
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSyncButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildLoadingButton(String label) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
      ),
      child: ElevatedButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.white),
          ),
        ),
        label: Text(
          label,
          style: GoogleFonts.quicksand(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
