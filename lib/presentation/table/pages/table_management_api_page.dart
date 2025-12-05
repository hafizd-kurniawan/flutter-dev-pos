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
import 'package:google_fonts/google_fonts.dart';

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
  bool _isManualRefresh = false; // Track manual refresh

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
    if (isRefresh) {
      setState(() => _isManualRefresh = true);
    }
    context.read<GetTableBloc>().add(GetTableEvent.getTables(isRefresh: isRefresh));
    context.read<GetTableBloc>().add(GetTableEvent.getCategories(isRefresh: isRefresh));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetTableBloc, GetTableState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (tables, _) {
            if (_isManualRefresh) {
              setState(() => _isManualRefresh = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '✅ Data meja berhasil diperbarui',
                    style: GoogleFonts.quicksand(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final isTight = constraints.maxWidth < 600;
                  // Reduce margin to 0 for mobile to maximize card width
                  final margin = isTight ? 16.0 : 24.0;
                  
                  return Padding(
                    padding: const EdgeInsets.only(top: 100.0), // No horizontal padding here
                    child: Column(
                      children: [
                        // Filters Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Tabs
                            _buildCategoryFilter(padding: EdgeInsets.symmetric(horizontal: margin)),
                            const SizedBox(height: 16),
                            
                            // Status Filters
                            _buildStatusFilters(padding: EdgeInsets.symmetric(horizontal: margin)),
                          ],
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Tables Grid
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: margin),
                            child: _buildTablesGrid(),
                          ),
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
      ),
    );
  }

  Widget _buildCategoryFilter({EdgeInsetsGeometry? padding}) {
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
        padding: padding,
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

  Widget _buildStatusFilters({EdgeInsetsGeometry? padding}) {
    final statuses = [
      {'value': 'all', 'label': 'All', 'icon': Icons.grid_view_rounded, 'color': Colors.blue},
      {'value': 'available', 'label': 'Available', 'icon': Icons.check_circle_rounded, 'color': Colors.green},
      {'value': 'occupied', 'label': 'Occupied', 'icon': Icons.people_rounded, 'color': Colors.red},
      {'value': 'reserved', 'label': 'Reserved', 'icon': Icons.event_rounded, 'color': Colors.orange},
      {'value': 'pending_bill', 'label': 'Pending', 'icon': Icons.receipt_rounded, 'color': Colors.amber},
    ];

    return SizedBox(
      height: 40, // Reduced height
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatuses.contains(status['value']);
          final color = status['color'] as Color;
          final icon = status['icon'] as IconData;
          final label = status['label'] as String;

          return GestureDetector(
            onTap: () {
              setState(() {
                if (status['value'] == 'all') {
                  _selectedStatuses.clear();
                  _selectedStatuses.add('all');
                } else {
                  _selectedStatuses.remove('all');
                  if (isSelected) {
                    _selectedStatuses.remove(status['value']);
                    if (_selectedStatuses.isEmpty) _selectedStatuses.add('all');
                  } else {
                    _selectedStatuses.add(status['value'] as String);
                  }
                }
              });

              // Apply filter
              context.read<GetTableBloc>().add(
                GetTableEvent.filterByStatus(_selectedStatuses),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Adjusted padding
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected ? color : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.2), // Lighter shadow
                          blurRadius: 4, // Reduced blur
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null, // No shadow for unselected
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 16, // Slightly smaller icon
                    color: isSelected ? Colors.white : color,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.quicksand(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                      fontSize: 13, // Slightly smaller font
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            
            // Calculate crossAxisCount based on available width
            int crossAxisCount = 2;
            if (width > 1400) crossAxisCount = 6;
            else if (width > 1100) crossAxisCount = 5;
            else if (width > 900) crossAxisCount = 4;
            else if (width > 600) crossAxisCount = 3;
            
            // Calculate aspect ratio dynamically
            // Ensure minimum card height of ~110px to prevent overflow
            // Width per card = (totalWidth - (crossAxisCount - 1) * spacing - padding) / crossAxisCount
            final padding = 24.0; // Total horizontal padding
            final spacing = 10.0;
            final cardWidth = (width - padding - (crossAxisCount - 1) * spacing) / crossAxisCount;
            
            // Target height around 100-110px
            // Aspect Ratio = width / height
            // So height = width / aspectRatio => aspectRatio = width / targetHeight
            
            double childAspectRatio = 1.1; // Default for larger screens
            if (cardWidth < 160) {
              // If card is narrow, make it taller
              childAspectRatio = cardWidth / 125; // Ensure ~125px height
            }

            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: filteredTables.length,
              itemBuilder: (context, index) {
                final table = filteredTables[index];
                final isHighlighted = table.id == _recentlyUpdatedTableId;
                return TableInfoCard(
                  table: table,
                  isHighlighted: isHighlighted,
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
                      if (widget.onTableSelected != null) {
                        widget.onTableSelected!(table);
                      } else {
                        Navigator.pop(context, table);
                      }
                    } else if (action == 'change_status') {
                      final updatedTableId = await showDialog<int>(
                        context: context,
                        builder: (dialogContext) => BlocProvider.value(
                          value: context.read<GetTableBloc>(),
                          child: ChangeTableStatusSheet(table: table),
                        ),
                      );
                      
                      if (updatedTableId != null) {
                        setState(() {
                          _recentlyUpdatedTableId = updatedTableId;
                        });
                        
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
      },
    );
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
