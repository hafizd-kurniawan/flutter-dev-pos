import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/local_product/local_product_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_product/sync_product_bloc.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Data'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          BlocConsumer<SyncProductBloc, SyncProductState>(
            listener: (context, state) {
              state.maybeWhen(
                orElse: () {},
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                loaded: (productResponseModel) async {
                  await ProductLocalDatasource.instance.deleteAllProducts();
                  await ProductLocalDatasource.instance.insertProducts(
                    productResponseModel.data ?? [],
                  );
                  
                  // Reload home page
                  if (context.mounted) {
                    context.read<LocalProductBloc>().add(
                          const LocalProductEvent.getLocalProduct(),
                        );
                  }
                  
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '✅ ${productResponseModel.data?.length ?? 0} produk berhasil disinkronkan!',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<SyncProductBloc>()
                          .add(const SyncProductEvent.syncProduct());
                    },
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync Produk Sekarang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  );
                },
                loading: () {
                  return ElevatedButton.icon(
                    onPressed: null,
                    icon: const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    label: const Text('Syncing...'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  );
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                loaded: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sync Order Success'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () {
                  return ElevatedButton.icon(
                    onPressed: () {
                      context
                          .read<SyncOrderBloc>()
                          .add(const SyncOrderEvent.syncOrder());
                    },
                    icon: const Icon(Icons.cloud_upload),
                    label: const Text('Sync Order Sekarang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  );
                },
                loading: () {
                  return ElevatedButton.icon(
                    onPressed: null,
                    icon: const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    label: const Text('Syncing...'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
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
