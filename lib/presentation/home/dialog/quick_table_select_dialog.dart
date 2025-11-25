import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/get_table_status/get_table_status_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';

/// Quick Table Selection Dialog
/// Shows available tables for quick selection in POS
class QuickTableSelectDialog extends StatefulWidget {
  const QuickTableSelectDialog({Key? key}) : super(key: key);

  @override
  State<QuickTableSelectDialog> createState() => _QuickTableSelectDialogState();
}

class _QuickTableSelectDialogState extends State<QuickTableSelectDialog> {
  TableModel? _selectedTable;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Fetch available tables
    context.read<GetTableStatusBloc>().add(
          const GetTableStatusEvent.getTablesStatus('available'),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(
                  Icons.table_restaurant,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Pilih Meja',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SpaceHeight(16),

            // Search
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari meja...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SpaceHeight(16),

            // Table List
            Expanded(
              child: BlocBuilder<GetTableStatusBloc, GetTableStatusState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const Center(
                      child: Text('Tidak ada data meja'),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    success: (tables) {
                      if (tables.isEmpty) {
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.table_restaurant_outlined,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada meja tersedia',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Filter by search query
                      final filteredTables = tables.where((table) {
                        final name = (table.name ?? '').toLowerCase();
                        final category = (table.categoryName ?? '').toLowerCase();
                        return name.contains(_searchQuery) ||
                            category.contains(_searchQuery);
                      }).toList();

                      if (filteredTables.isEmpty && _searchQuery.isNotEmpty) {
                        return const Center(
                          child: Text(
                            'Meja tidak ditemukan',
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: filteredTables.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final table = filteredTables[index];
                          final isSelected = _selectedTable?.id == table.id;

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedTable = table;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.1)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  // Table Icon
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.table_restaurant,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Table Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          table.name ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? AppColors.primary
                                                : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${table.categoryName ?? 'N/A'} • ${table.capacity ?? 0} pax',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Check Icon
                                  if (isSelected)
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.primary,
                                      size: 28,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),

            const SpaceHeight(16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: Button.outlined(
                    onPressed: () => Navigator.pop(context),
                    label: 'Batal',
                  ),
                ),
                const SpaceWidth(12),
                Expanded(
                  child: _selectedTable == null
                      ? Opacity(
                          opacity: 0.5,
                          child: Button.filled(
                            onPressed: () {},
                            label: 'Pilih Meja',
                          ),
                        )
                      : Button.filled(
                          onPressed: () {
                            // Return selected table
                            Navigator.pop(context, _selectedTable);
                          },
                          label: 'Pilih Meja',
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
