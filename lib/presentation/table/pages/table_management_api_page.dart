import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/data/models/response/table_category_model.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/get_table/get_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/widgets/change_table_status_sheet.dart';
import 'package:flutter_posresto_app/presentation/table/widgets/table_info_card.dart';

class TableManagementApiPage extends StatefulWidget {
  final Function(TableModel)? onTableSelected;
  
  const TableManagementApiPage({
    Key? key,
    this.onTableSelected,
  }) : super(key: key);

  @override
  State<TableManagementApiPage> createState() => _TableManagementApiPageState();
}

class _TableManagementApiPageState extends State<TableManagementApiPage> 
    with WidgetsBindingObserver {
  int? _selectedCategoryId;
  final Set<String> _selectedStatuses = {'all'};
  List<TableCategoryModel> _categories = [];
  Timer? _autoRefreshTimer;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<TableModel> _cachedTables = []; // Cache to prevent rebuild

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh when app comes to foreground
    if (state == AppLifecycleState.resumed) {
      _loadData();
    }
  }

  void _startAutoRefresh() {
    // Disabled periodic refresh to prevent flicker
    // Use manual refresh or real-time updates instead
    _autoRefreshTimer?.cancel();
  }

  void _loadData() {
    context.read<GetTableBloc>().add(const GetTableEvent.getTables());
    context.read<GetTableBloc>().add(const GetTableEvent.getCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Table Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Column(
          children: [
            // Filters Section - Professional Design
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Row 1: Search + Refresh
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSearchBar(),
                        ),
                        const SizedBox(width: 12),
                        _buildRefreshButton(),
                      ],
                    ),
                  ),
                  
                  // Row 2: Category + Status Filters
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Filter
                        SizedBox(
                          width: 200,
                          child: _buildCategoryFilter(),
                        ),
                        const SizedBox(width: 16),
                        // Vertical Divider
                        Container(
                          height: 40,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 16),
                        // Status Filters
                        Expanded(
                          child: _buildStatusFilters(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Tables Grid
            Expanded(
              child: _buildTablesGrid(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return BlocListener<GetTableBloc, GetTableState>(
      listener: (context, state) {
        state.maybeWhen(
          categoriesLoaded: (categories) {
            setState(() {
              _categories = categories;
            });
          },
          orElse: () {},
        );
      },
      child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _selectedCategoryId != null ? AppColors.primary.withOpacity(0.3) : Colors.grey[300]!,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButton<int?>(
              value: _selectedCategoryId,
              isExpanded: true,
              underline: const SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: _selectedCategoryId != null ? AppColors.primary : Colors.grey[600],
                size: 24,
              ),
              hint: Row(
                children: [
                  Icon(
                    Icons.category_rounded,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'All Categories',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Row(
                    children: [
                      Icon(Icons.category_rounded, size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 10),
                      const Text('All Categories'),
                    ],
                  ),
                ),
                ..._categories.map((category) {
                  return DropdownMenuItem<int?>(
                    value: category.id,
                    child: Row(
                      children: [
                        Icon(Icons.label_rounded, size: 16, color: AppColors.primary.withOpacity(0.7)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            category.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '${category.available}/${category.total}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategoryId = value;
                });
                context.read<GetTableBloc>().add(
                  GetTableEvent.filterByCategory(value),
                );
              },
            ),
          ),
    );
  }

  Widget _buildStatusFilters() {
    final statuses = [
      {'value': 'all', 'label': 'All', 'icon': Icons.grid_view_rounded, 'color': Colors.blue},
      {'value': 'available', 'label': 'Available', 'icon': Icons.check_circle_rounded, 'color': Colors.green},
      {'value': 'occupied', 'label': 'Occupied', 'icon': Icons.people_rounded, 'color': Colors.red},
      {'value': 'reserved', 'label': 'Reserved', 'icon': Icons.event_rounded, 'color': Colors.orange},
      {'value': 'pending_bill', 'label': 'Pending', 'icon': Icons.receipt_rounded, 'color': Colors.amber},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: statuses.map((status) {
            final isSelected = _selectedStatuses.contains(status['value']);
            final color = status['color'] as Color;
            final icon = status['icon'] as IconData;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final selected = !isSelected;
                setState(() {
                  if (status['value'] == 'all') {
                    _selectedStatuses.clear();
                    _selectedStatuses.add('all');
                  } else {
                    _selectedStatuses.remove('all');
                    if (selected) {
                      _selectedStatuses.add(status['value'] as String);
                    } else {
                      _selectedStatuses.remove(status['value']);
                      if (_selectedStatuses.isEmpty) {
                        _selectedStatuses.add('all');
                      }
                    }
                  }
                });

                    // Apply filter
                    context.read<GetTableBloc>().add(
                      GetTableEvent.filterByStatus(_selectedStatuses),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.15) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey[300]!,
                        width: isSelected ? 2 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected ? color : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status['label'] as String,
                          style: TextStyle(
                            color: isSelected ? color : Colors.grey[700],
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
      ),
    );
  }

  Widget _buildTablesGrid() {
    return BlocConsumer<GetTableBloc, GetTableState>(
      listener: (context, state) {
        // Update cache silently WITHOUT setState - no flicker!
        state.maybeWhen(
          success: (tables) {
            _cachedTables = tables;
            // Force a single rebuild after cache update
            if (mounted) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() {});
              });
            }
          },
          orElse: () {},
        );
      },
      buildWhen: (previous, current) {
        // NEVER rebuild from BLoC state changes (except first load)
        return current.maybeWhen(
          loading: () => _cachedTables.isEmpty,
          error: (_) => true,
          orElse: () => false,
        );
      },
      builder: (context, state) {
        // Show loading only on first load
        if (state is GetTableState && _cachedTables.isEmpty) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        
        // Always render from cache (no flicker)
        if (_cachedTables.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.table_restaurant,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No tables found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        
        // Apply search filter
        var filteredTables = _cachedTables;
        if (_searchQuery.isNotEmpty) {
          filteredTables = filteredTables.where((table) {
            final nameMatch = table.name?.toLowerCase().contains(_searchQuery) ?? false;
            final customerMatch = table.customerName?.toLowerCase().contains(_searchQuery) ?? false;
            return nameMatch || customerMatch;
          }).toList();
        }
        
        if (filteredTables.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.table_restaurant,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No tables found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your filters',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredTables.length,
                itemBuilder: (context, index) {
                final table = filteredTables[index];
                return TableInfoCard(
                  table: table,
                  onTap: () async {
                    // Show selection dialog
                    final action = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Meja ${table.name}'),
                        content: Text('Pilih aksi untuk meja ini:'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'select'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle, color: Colors.green),
                                SizedBox(width: 8),
                                Text('Pilih Meja Ini'),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'change_status'),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text('Ubah Status'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                    
                    if (action == 'select') {
                      // Use callback to update Dashboard and navigate back to home
                      if (widget.onTableSelected != null) {
                        widget.onTableSelected!(table);
                        print('✅ Table selected via callback: ${table.name}');
                      } else {
                        // Fallback: return via Navigator for full-screen mode
                        Navigator.pop(context, table);
                      }
                    } else if (action == 'change_status') {
                      // Show status change bottom sheet
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: ChangeTableStatusSheet(table: table),
                        ),
                      );
                      _loadData();
                    }
                  },
                );
              },
            );
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1400) return 6;
    if (width > 1100) return 5;
    if (width > 900) return 4;
    if (width > 600) return 3;
    return 2;
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _searchQuery.isNotEmpty ? AppColors.primary.withOpacity(0.3) : Colors.grey[300]!,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search table or customer name...',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: _searchQuery.isNotEmpty ? AppColors.primary : Colors.grey[500],
            size: 22,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600], size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                  splashRadius: 20,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) {
          setState(() => _searchQuery = value.toLowerCase());
        },
      ),
    );
  }

  Widget _buildRefreshButton() {
    return Container(
      height: 48,
      width: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _loadData,
          borderRadius: BorderRadius.circular(12),
          child: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
