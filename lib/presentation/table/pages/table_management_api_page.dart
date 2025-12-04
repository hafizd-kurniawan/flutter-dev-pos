import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/data/models/response/table_category_model.dart';
import 'package:flutter_posresto_app/presentation/table/blocs/get_table/get_table_bloc.dart';
import 'package:flutter_posresto_app/presentation/table/widgets/change_table_status_sheet.dart';
import 'package:flutter_posresto_app/presentation/table/widgets/table_info_card.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/floating_header.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/custom_tab_selector.dart';

class TableManagementApiPage extends StatefulWidget {
  final Function(TableModel)? onTableSelected;
  final VoidCallback? onToggleSidebar;
  
  const TableManagementApiPage({
    Key? key,
    this.onTableSelected,
    this.onToggleSidebar,
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
  int? _recentlyUpdatedTableId; // Track recently updated table for highlight
  Timer? _highlightTimer; // Timer to remove highlight after few seconds

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
    _highlightTimer?.cancel(); // Cancel highlight timer
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

  void _loadData({bool isRefresh = false}) {
    context.read<GetTableBloc>().add(GetTableEvent.getTables(isRefresh: isRefresh));
    context.read<GetTableBloc>().add(GetTableEvent.getCategories(isRefresh: isRefresh));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isTight = constraints.maxWidth < 600;
                // Reduce margin to 0 for mobile to maximize card width
                final margin = isTight ? 0.0 : 24.0;
                final filterPadding = isTight ? 8.0 : 16.0;
                
                return Padding(
                  padding: EdgeInsets.only(top: 100.0, left: margin, right: margin),
                  child: Column(
                children: [
                  // Filters Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: filterPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Tabs
                        _buildCategoryFilter(),
                        const SizedBox(height: 16),
                        
                        // Status Filters
                        _buildStatusFilters(),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tables Grid
                  Expanded(
                    child: _buildTablesGrid(),
                  ),
                ],
              ),
            );
          },
        ),
            
            // Floating Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: FloatingHeader(
                title: 'Table Management',
                onToggleSidebar: widget.onToggleSidebar ?? () {},
                isSidebarVisible: true,
                actions: [
                  // Search Bar
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isSmall = screenWidth < 400;
                      final isMobile = screenWidth < 600;
                      return SizedBox(
                        width: isSmall ? 100 : (isMobile ? 140 : 250), // Responsive width
                        height: 36,
                        child: TextField(
                      controller: _searchController,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: 'Search tables...',
                        hintStyle: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[500], size: 18),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.close, color: Colors.grey[600], size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                splashRadius: 16,
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value.toLowerCase());
                      },
                    ),
                  );
                },
              ),
                  
                  const SizedBox(width: 4),
                  
                  // Refresh Button
                  IconButton(
                    onPressed: () => _loadData(isRefresh: true),
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    color: AppColors.primary,
                    tooltip: 'Refresh Data',
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
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
          success: (tables, categories) {
            setState(() {
              _categories = categories;
            });
          },
          orElse: () {},
        );
      },
      child: CustomTabSelector(
        items: ['All Categories', ..._categories.map((e) => e.name)],
        badges: [null, ..._categories.map((e) => e.available)],
        selectedIndex: _selectedCategoryId == null 
            ? 0 
            : _categories.indexWhere((c) => c.id == _selectedCategoryId) + 1,
        onTap: (index) {
          final isAll = index == 0;
          final category = isAll ? null : _categories[index - 1];
          
          setState(() {
            _selectedCategoryId = isAll ? null : category?.id;
          });
          
          context.read<GetTableBloc>().add(
            GetTableEvent.filterByCategory(_selectedCategoryId),
          );
        },
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
                  borderRadius: BorderRadius.circular(30), // Rounded pills
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected ? color : Colors.grey[300]!,
                        width: 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected ? color : Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
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
          success: (tables, categories) {
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
                  childAspectRatio: 0.8, // Taller cards to prevent overflow
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: filteredTables.length,
                itemBuilder: (context, index) {
                final table = filteredTables[index];
                final isHighlighted = table.id == _recentlyUpdatedTableId; // Check if this table was recently updated
                return TableInfoCard(
                  table: table,
                  isHighlighted: isHighlighted, // Pass highlight flag
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
                      final updatedTableId = await showModalBottomSheet<int>(
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
                      
                      // Highlight the updated table
                      if (updatedTableId != null) {
                        setState(() {
                          _recentlyUpdatedTableId = updatedTableId;
                        });
                        
                        // Remove highlight after 5 seconds
                        _highlightTimer?.cancel();
                        _highlightTimer = Timer(const Duration(seconds: 5), () {
                          if (mounted) {
                            setState(() {
                              _recentlyUpdatedTableId = null;
                            });
                          }
                        });
                      }
                      
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
          onTap: () => _loadData(isRefresh: true),
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
