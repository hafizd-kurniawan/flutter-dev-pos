// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart'; // NEW: Google Fonts

import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/datasources/pos_settings_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_storage_helper.dart';
import 'package:flutter_posresto_app/data/datasources/stock_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/category/category_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/local_product/local_product_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/pos_settings/pos_settings_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/dynamic_discount_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/dynamic_tax_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/dynamic_service_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/pages/confirm_payment_page.dart';
import 'package:flutter_posresto_app/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_posresto_app/presentation/table/pages/table_management_api_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../widgets/action_card_button.dart';
import '../widgets/column_button.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/home_title.dart';
import '../widgets/order_menu.dart';
import '../widgets/product_card.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/floating_header.dart';
import 'package:flutter_posresto_app/core/components/modern_refresh_button.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';

class HomePage extends StatefulWidget {
  final bool isTable;
  final TableModel? table;
  final VoidCallback? onNavigateToTables;
  final VoidCallback? onToggleSidebar; // Callback to toggle sidebar
  final VoidCallback? onPaymentSuccess;
  
  const HomePage({
    Key? key,
    required this.isTable,
    this.table,
    this.onNavigateToTables,
    this.onToggleSidebar,
    this.onPaymentSuccess,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  bool _isRefreshing = false;
  bool _isSearchActive = false; // NEW: Track search bar visibility on mobile
  String _orderType = 'dine_in'; // dine_in or takeaway
  TableModel? _selectedTable;
  int _selectedTabIndex = 0; // 0: Menu, 1: Cart (For Mobile)

  // 🎯 RESPONSIVE UTILITIES (based on available width after sidebar)
  
  /// Get grid columns based on available content width
  /// Adjusted to be more conservative to prevent overflow
  int _getGridCrossAxisCount(double availableWidth) {
    if (availableWidth < 600) return 2;      // Mobile/Small Tablet
    if (availableWidth < 900) return 3;      // Medium Tablet
    if (availableWidth < 1200) return 4;     // Large Tablet/Desktop
    return 5;                                // XL Desktop
  }
  
  /// Products flex (left side) - based on available width
  int _getProductFlex(double availableWidth) {
    if (availableWidth < 600) return 1;      // Mobile: equal split (or stack)
    if (availableWidth < 800) return 3;      // Tablet: more space for products
    return 4;                                // Desktop: dominant products
  }
  
  /// Cart flex (right side) - ensure minimum viable width
  int _getCartFlex(double availableWidth) {
    if (availableWidth < 600) return 1;      // Mobile
    if (availableWidth < 800) return 2;      // Tablet: 3:2 ratio
    if (availableWidth < 1200) return 2;     // Desktop: 4:2 (2:1) ratio
    return 3;                                // Large Desktop: 5:3 ratio (Wider cart)
  }
  
  /// Grid spacing
  double _getGridSpacing(double availableWidth) {
    if (availableWidth < 600) return 12.0;
    return 16.0;  // Standard spacing
  }
  
  /// Cart padding
  EdgeInsets _getCartPadding(double availableWidth) {
    if (availableWidth > 1000) return const EdgeInsets.all(24.0); // Spacious padding
    return const EdgeInsets.all(16.0); // Standard padding
  }
  
  /// Products section padding
  EdgeInsets _getProductsPadding(double availableWidth) {
    return const EdgeInsets.symmetric(vertical: 16.0); // Vertical only, horizontal handled by children
  }
  
  /// Cart font size
  double _getCartFontSize(double availableWidth) {
    return 14.0; // Standard size
  }
  
  /// Should cart buttons wrap?
  bool _shouldWrapCartButtons(double availableWidth) {
    return availableWidth < 900;  // Wrap on tablets too
  }

  @override
  void initState() {
    super.initState();
    
    print('🏠 HomePage initState - Starting fetch...');
    
    // Initialize selected table from widget
    _selectedTable = widget.table;
    _orderType = widget.isTable ? 'dine_in' : 'takeaway';
    print('🏠 Init: orderType=$_orderType, table=${_selectedTable?.name}');
    
    // Fetch categories from API if not loaded
    final categoryState = context.read<CategoryBloc>().state;
    categoryState.maybeWhen(
      loaded: (_) => print('📂 Categories already loaded, skipping fetch'),
      orElse: () {
        context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
        print('📂 CategoryBloc event triggered');
      },
    );
    
    // Fetch products from local storage if not loaded
    final productState = context.read<LocalProductBloc>().state;
    productState.maybeWhen(
      loaded: (_) => print('📦 Products already loaded, skipping fetch'),
      orElse: () {
        context.read<LocalProductBloc>().add(const LocalProductEvent.getLocalProduct());
        print('📦 LocalProductBloc event triggered');
      },
    );
    
    // Fetch POS settings (discounts, taxes, services) if not loaded
    final settingsState = context.read<PosSettingsBloc>().state;
    settingsState.maybeWhen(
      loaded: (_) => print('🔧 Settings already loaded, skipping fetch'),
      orElse: () {
        context.read<PosSettingsBloc>().add(const PosSettingsEvent.getSettings());
        print('🔧 PosSettingsBloc event triggered');
      },
    );
    
    // Setup search listener with debounce
    searchController.addListener(_onSearchChanged);
    
    // Load saved settings AFTER build completes (avoid setState during build)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('📌 PostFrameCallback: Loading saved settings...');
      _loadSavedSettings();
    });
  }
  
  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update selected table when widget.table changes
    if (widget.table != oldWidget.table) {
      setState(() {
        _selectedTable = widget.table;
        print('✅ Table updated via didUpdateWidget: ${_selectedTable?.name}');
      });
    }
    
    // Update order type when widget.isTable changes
    if (widget.isTable != oldWidget.isTable) {
      setState(() {
        _orderType = widget.isTable ? 'dine_in' : 'takeaway';
        print('✅ Order type updated: $_orderType');
      });
    }
  }
  
  /// Load saved tax & service from local storage and apply to CheckoutBloc
  Future<void> _loadSavedSettings() async {
    try {
      print('🔄 [HomePage] _loadSavedSettings() called');
      
      final localDatasource = PosSettingsLocalDatasource();
      
      // Get saved tax ID
      final taxId = await localDatasource.getSelectedTaxId();
      print('📌 Saved Tax ID from storage: $taxId');
      
      // Get saved service ID
      final serviceId = await localDatasource.getSelectedServiceId();
      print('📌 Saved Service ID from storage: $serviceId');
      
      // Wait longer for PosSettingsBloc to load (increased from 500ms to 1000ms)
      print('⏳ Waiting for PosSettingsBloc to load...');
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (!mounted) {
        print('⚠️ Widget not mounted, aborting');
        return;
      }
      
      // Get PosSettings to find tax & service values
      final posSettingsState = context.read<PosSettingsBloc>().state;
      print('🔍 PosSettingsBloc state type: ${posSettingsState.runtimeType}');
      
      posSettingsState.maybeWhen(
        orElse: () {
          print('⚠️ PosSettings NOT loaded yet (state: ${posSettingsState.runtimeType})');
          print('⚠️ Will try to reload after 2 seconds...');
          // Retry after delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              print('🔄 Retrying _loadSavedSettings...');
              _loadSavedSettings();
            }
          });
        },
        loaded: (settings) {
          print('✅ PosSettings LOADED successfully!');
          print('   Available taxes: ${settings.taxes.length}');
          print('   Available services: ${settings.services.length}');
          
          // Apply saved tax if exists
          if (taxId != null && settings.taxes.isNotEmpty) {
            try {
              final tax = settings.taxes.firstWhere(
                (t) => t.id == taxId,
                orElse: () => settings.taxes.first,
              );
              print('🔧 Applying tax: ID=$taxId, Name=${tax.name}, Value=${tax.value}%');
              context.read<CheckoutBloc>().add(CheckoutEvent.addTax(tax.value.toInt()));
              print('✅ Tax applied successfully to CheckoutBloc');
            } catch (e) {
              print('❌ Error applying tax: $e');
            }
          } else {
            print('ℹ️ No tax to apply (taxId=$taxId, taxes available=${settings.taxes.length})');
          }
          
          // Apply saved service if exists
          if (serviceId != null && settings.services.isNotEmpty) {
            try {
              final service = settings.services.firstWhere(
                (s) => s.id == serviceId,
                orElse: () => settings.services.first,
              );
              print('🔧 Applying service: ID=$serviceId, Name=${service.name}, Value=${service.value}%');
              context.read<CheckoutBloc>().add(CheckoutEvent.addServiceCharge(service.value.toInt()));
              print('✅ Service applied successfully to CheckoutBloc');
            } catch (e) {
              print('❌ Error applying service: $e');
            }
          } else {
            print('ℹ️ No service to apply (serviceId=$serviceId, services available=${settings.services.length})');
          }
          
          if (taxId == null && serviceId == null) {
            print('ℹ️ No saved tax/service found in storage');
          }
        },
      );
    } catch (e) {
      print('❌ Error in _loadSavedSettings: $e');
      print('❌ Stack trace: ${StackTrace.current}');
    }
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    // Cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    // Start new timer (300ms debounce)
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = searchController.text.toLowerCase();
      });
      print('🔍 Search query: $_searchQuery');
    });
  }
  
  Future<void> _refreshAllData() async {
    if (_isRefreshing) return;
    
    setState(() => _isRefreshing = true);
    
    try {
      print('🔄 Refreshing ALL data from server...');
      
      int successCount = 0;
      int totalCount = 3; // Products, Categories, POS Settings
      final List<String> errors = [];
      
      // 1. Refresh Products
      print('📦 Refreshing products...');
      final productResult = await ProductRemoteDatasource().getProducts();
      await productResult.fold(
        (error) {
          errors.add('Products: $error');
        },
        (productResponse) async {
          // Save to storage
          if (kIsWeb) {
            await ProductStorageHelper.saveProducts(productResponse.data ?? []);
          } else {
            // Mobile: Online Only - Skip SQLite
            print('🌐 Online Only Mode: Skipping local DB save');
          }
          
          // Reload products
          context.read<LocalProductBloc>().add(const LocalProductEvent.getLocalProduct());
          successCount++;
          print('✅ Products refreshed: ${productResponse.data?.length ?? 0} items');
        },
      );
      
      // 2. Refresh Categories
      print('📂 Refreshing categories...');
      context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
      successCount++;
      print('✅ Categories refresh triggered');
      
      // 3. Refresh POS Settings (Discounts, Taxes, Services)
      print('🔧 Refreshing POS settings...');
      context.read<PosSettingsBloc>().add(const PosSettingsEvent.getSettings());
      successCount++;
      print('✅ POS settings refresh triggered');
      
      // Show result
      if (mounted) {
        if (errors.isEmpty) {
          NotificationHelper.showSuccess(
            context, 
            'Semua data berhasil diperbarui!'
          );
        } else {
          NotificationHelper.showWarning(
            context,
            'Refresh selesai dengan ${errors.length} error:\n${errors.join('\n')}'
          );
        }
      }
    } catch (e) {
      print('❌ Refresh error: $e');
      if (mounted) {
        NotificationHelper.showError(context, 'Gagal refresh data: $e');
      }
    } finally {
      setState(() => _isRefreshing = false);
    }
  }
  
  void onCategoryTap(int index) {
    searchController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'confirmation_screen',
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final isMobile = availableWidth < 800;

            // 📱 MOBILE LAYOUT (Tab View)
            if (isMobile) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: Scaffold(
                      body: IndexedStack(
                        index: _selectedTabIndex,
                        children: [
                          // Tab 0: Menu
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: _buildMenuSection(context, availableWidth),
                          ),
                          
                          // Tab 1: Cart
                          _buildCartSection(context, availableWidth),
                        ],
                      ),
                      bottomNavigationBar: NavigationBar(
                        selectedIndex: _selectedTabIndex,
                        onDestinationSelected: (index) {
                          setState(() => _selectedTabIndex = index);
                        },
                        destinations: [
                          const NavigationDestination(
                            icon: Icon(Icons.restaurant_menu),
                            label: 'Menu',
                          ),
                          NavigationDestination(
                            icon: BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                return Badge(
                                  label: state.maybeWhen(
                                    orElse: () => null,
                                    loaded: (products, _, __, ___, ____, _____, totalQty, _______, ________, _________) {
                                      return totalQty > 0 ? Text('$totalQty') : null;
                                    },
                                  ),
                                  isLabelVisible: state.maybeWhen(
                                    orElse: () => false,
                                    loaded: (products, _, __, ___, ____, _____, totalQty, _______, ________, _________) {
                                      return totalQty > 0;
                                    },
                                  ),
                                  child: const Icon(Icons.shopping_cart),
                                );
                              },
                            ),
                            label: 'Pesanan',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Floating Header (Mobile)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: FloatingHeader(
                      title: 'Menu',
                      onToggleSidebar: widget.onToggleSidebar ?? () {},
                      isSidebarVisible: true,
                      titleWidget: _isSearchActive
                          ? SizedBox(
                              height: 40,
                              child: TextField(
                                controller: searchController,
                                autofocus: true,
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Cari produk...',
                                  hintStyle: GoogleFonts.quicksand(color: Colors.grey[500], fontSize: 14),
                                  prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 20),
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false) _debounce!.cancel();
                                  _debounce = Timer(const Duration(milliseconds: 500), () {
                                    setState(() {
                                      _searchQuery = value.toLowerCase();
                                    });
                                  });
                                },
                              ),
                            )
                          : null,
                      actions: [
                        if (_isSearchActive)
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _isSearchActive = false;
                                searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        else ...[
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              setState(() {
                                _isSearchActive = true;
                              });
                            },
                          ),
                          const SizedBox(width: 4),
                          ModernRefreshButton(
                            isLoading: _isRefreshing,
                            onPressed: _refreshAllData,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }

            // 🖥️ DESKTOP LAYOUT (Split View)
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0, left: 24.0, right: 24.0),
                  child: Row(
                    children: [
                      // LEFT SIDE: Products Grid
                      Expanded(
                        flex: _getProductFlex(availableWidth),
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: Padding(
                            padding: _getProductsPadding(availableWidth),
                            child: _buildMenuSection(context, availableWidth),
                          ),
                        ),
                      ),
                      
                      // RIGHT SIDE: Cart with responsive constraints
                      Expanded(
                        flex: _getCartFlex(availableWidth),
                        child: Container(
                          margin: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _buildCartSection(context, availableWidth),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Floating Header
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0, // Stretch full width
                  child: FloatingHeader(
                    title: 'Menu',
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
                              controller: searchController,
                              style: const TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                hintText: 'Cari...',
                                hintStyle: GoogleFonts.quicksand(color: Colors.grey[500], fontSize: 13),
                                prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 18),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(Icons.close, size: 16),
                                        onPressed: () {
                                          setState(() {
                                            searchController.clear();
                                            _searchQuery = '';
                                          });
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
                                if (_debounce?.isActive ?? false) _debounce!.cancel();
                                _debounce = Timer(const Duration(milliseconds: 500), () {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                });
                              },
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(width: 4),
                      
                      // Refresh Button
                      ModernRefreshButton(
                        isLoading: _isRefreshing,
                        onPressed: _refreshAllData,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // 📦 EXTRACTED MENU SECTION
  Widget _buildMenuSection(BuildContext context, double availableWidth) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // DYNAMIC CATEGORIES WITH TABS
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, categoryState) {
              return categoryState.maybeWhen(
                orElse: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (message) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading categories',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                loaded: (categories) {
                  // Build dynamic tab titles
                  final tabTitles = [
                    'Semua',
                    ...categories.map((c) => c.name ?? 'Category')
                  ];
                  
                  // Build dynamic tab views
                  final tabViews = [
                    // "Semua" tab - show all products
                    _buildProductGrid(null, availableWidth),
                    
                    // Dynamic category tabs - filter by category ID
                    ...categories.map((category) => 
                      _buildProductGrid(category.id, availableWidth)
                    ),
                  ];
                  
                  return CustomTabBar(
                    tabTitles: tabTitles,
                    initialTabIndex: 0,
                    tabViews: tabViews,
                    padding: EdgeInsets.zero, // Aligns with parent padding
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // 🛒 EXTRACTED CART SECTION
  Widget _buildCartSection(BuildContext context, double availableWidth) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: _getCartPadding(availableWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Table Selection - Professional Design
            _buildTableSelector(),
            const SpaceHeight(8.0),
            
            // Order Number & Type Selector
            Row(
              children: [
                Button.filled(
                  width: 120.0,
                  height: 40,
                  onPressed: () {},
                  label: 'Pesanan#',
                ),
                const SpaceWidth(12),
                Expanded(
                  child: _buildOrderTypeSelector(),
                ),
              ],
            ),
            const SpaceHeight(12.0),
            
            // Global Order Note Input
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                final currentNote = state.maybeWhen(
                  orElse: () => '',
                  loaded: (_, __, ___, ____, _____, ______, _______, ________, _________, note) => note,
                );
                
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey[200]!),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: TextEditingController(text: currentNote)
                      ..selection = TextSelection.fromPosition(
                          TextPosition(offset: currentNote.length)),
                    maxLength: 100, // Limit to 100 chars
                    keyboardType: TextInputType.text,
                    scrollPadding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 20),
                    decoration: const InputDecoration(
                      labelText: 'Catatan Pesanan (Opsional)',
                      hintText: 'Contoh: Meja pojok, Bungkus dipisah',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(Icons.note_alt_outlined, color: AppColors.primary),
                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      counterText: "", // Hide default counter to keep it clean
                    ),
                    onChanged: (value) {
                      context.read<CheckoutBloc>().add(CheckoutEvent.addOrderNote(value));
                    },
                  ),
                );
              },
            ),
            const SpaceHeight(16.0),
            
            // Cart Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 50.0,
                  child: Text(
                    'Qty',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  child: Text(
                    'Price',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SpaceHeight(8),
            const Divider(),
            const SpaceHeight(8),
            
            // Cart Items List
            BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const Center(
                    child: Text('No Items'),
                  ),
                  loaded: (products,
                      discountModel,
                      discount,
                      discountAmount,
                      tax,
                      serviceCharge,
                      totalQuantity,
                      totalPrice,
                      draftName,
                      orderNote) {
                    if (products.isEmpty) {
                      return const Center(
                        child: Text('No Items'),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => OrderMenu(data: products[index]),
                      // Use wider spacing on large screens
                      separatorBuilder: (context, index) => SpaceHeight(availableWidth > 1000 ? 12.0 : 1.0),
                      itemCount: products.length,
                    );
                  },
                );
              },
            ),
            const SpaceHeight(8.0),
            
            // Discount, Tax, Service Buttons (DYNAMIC from API)
            BlocBuilder<PosSettingsBloc, PosSettingsState>(
              builder: (context, settingsState) {
                return settingsState.maybeWhen(
                  orElse: () => const SizedBox.shrink(), // Loading or error
                  loaded: (settings) {
                    // Build button list dynamically
                    final buttons = <Widget>[];
                    
                    // Add Discount button if available
                    if (settings.discounts.isNotEmpty) {
                      buttons.add(
                        Expanded(
                          child: ActionCardButton(
                            label: 'Diskon',
                            svgGenImage: Assets.icons.diskon,
                            onPressed: () => showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const DynamicDiscountDialog(),
                            ),
                          ),
                        ),
                      );
                    }
                    
                    // Add Tax button if available
                    if (settings.taxes.isNotEmpty) {
                      buttons.add(
                        Expanded(
                          child: ActionCardButton(
                            label: 'Pajak',
                            svgGenImage: Assets.icons.pajak,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => const DynamicTaxDialog(),
                            ),
                          ),
                        ),
                      );
                    }
                    
                    // Add Service button if available
                    if (settings.services.isNotEmpty) {
                      buttons.add(
                        Expanded(
                          child: ActionCardButton(
                            label: 'Layanan',
                            svgGenImage: Assets.icons.layanan,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => const DynamicServiceDialog(),
                            ),
                          ),
                        ),
                      );
                    }
                    
                    // If no buttons, return empty
                    if (buttons.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    // Add spacing
                    final spacedButtons = <Widget>[];
                    for (var i = 0; i < buttons.length; i++) {
                      spacedButtons.add(buttons[i]);
                      if (i < buttons.length - 1) {
                        spacedButtons.add(const SizedBox(width: 12));
                      }
                    }
                    
                    // Return button row
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: spacedButtons,
                    );
                  },
                );
              },
            ),
            const SpaceHeight(8.0),
            const Divider(),
            const SpaceHeight(8.0),
            
            // Tax Row - Only show if enabled in PosSettings
            BlocBuilder<PosSettingsBloc, PosSettingsState>(
              builder: (context, settingsState) {
                return settingsState.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loaded: (settings) {
                    // Hide if taxes disabled (empty)
                    if (settings.taxes.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    // Show tax row
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Pajak', style: TextStyle(color: AppColors.grey)),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final tax = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (_, __, ___, ____, tax, _____, ______, _______, ________, _________) {
                                    return tax;
                                  },
                                );
                                return Text(
                                  '$tax %',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                      ],
                    );
                  },
                );
              },
            ),
            
            // Service Charge Row - Only show if enabled in PosSettings
            BlocBuilder<PosSettingsBloc, PosSettingsState>(
              builder: (context, settingsState) {
                return settingsState.maybeWhen(
                  orElse: () => const SizedBox.shrink(),
                  loaded: (settings) {
                    // Hide if services disabled (empty)
                    if (settings.services.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    // Show service charge row
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Layanan', style: TextStyle(color: AppColors.grey)),
                            BlocBuilder<CheckoutBloc, CheckoutState>(
                              builder: (context, state) {
                                final serviceCharge = state.maybeWhen(
                                  orElse: () => 0,
                                  loaded: (_, __, ___, ____, _____, serviceCharge, ______, _______, ________, _________) {
                                    return serviceCharge;
                                  },
                                );
                                return Text(
                                  '$serviceCharge %',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SpaceHeight(8.0),
                      ],
                    );
                  },
                );
              },
            ),
            
            // Discount Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Diskon', style: TextStyle(color: AppColors.grey)),
                BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      orElse: () => const Text(
                        '-',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      loaded: (products, discountModel, discount, discountAmount,
                          tax, serviceCharge, totalQuantity, totalPrice, draftName, orderNote) {
                        if (discountModel == null) {
                          return const Text(
                            '-',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }
                        
                        final value = discountModel.value!.replaceAll('.00', '').toIntegerFromText;
                        final displayText = discountModel.type == 'percentage'
                            ? '$value %'
                            : 'Rp ${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
                        
                        return Text(
                          displayText,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SpaceHeight(8.0),
            
            // Subtotal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sub total',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    final price = state.maybeWhen(
                      orElse: () => 0,
                      loaded: (products, discountModel, discount, discountAmount,
                          tax, serviceCharge, totalQuantity, totalPrice, draftName, orderNote) {
                        if (products.isEmpty) return 0;
                        return products
                            .map((e) => (e.product.price ?? '0').toIntegerFromText * e.quantity)
                            .reduce((value, element) => value + element);
                      },
                    );
                    return Text(
                      price.currencyFormatRp,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SpaceHeight(100.0),
            ],
          ),
        ),
        
        // Payment Button (Fixed at bottom)
        Align(
          alignment: Alignment.bottomCenter,
          child: ColoredBox(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: BlocBuilder<CheckoutBloc, CheckoutState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => Button.filled(
                      onPressed: () {},
                      label: 'Lanjutkan Pembayaran',
                    ),
                    loaded: (products, discountModel, discount, discountAmount,
                        tax, serviceCharge, totalQuantity, totalPrice, draftName, orderNote) {
                      if (products.isEmpty) {
                        return Button.filled(
                          onPressed: () {},
                          label: 'Lanjutkan Pembayaran',
                        );
                      }
                      
                      return Button.filled(
                        onPressed: () async {
                                // Show loading
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                                
                                // Validate stock for all cart items
                                final items = products.map((item) => {
                                  'product_id': item.product.id,
                                  'quantity': item.quantity,
                                }).toList();
                                
                                final result = await StockRemoteDatasource().validateOrder(items);
                                
                                if (!context.mounted) return;
                                Navigator.pop(context); // Close loading
                                
                                result.fold(
                                  (error) {
                                    // Network error
                                    NotificationHelper.showError(context, 'Gagal validasi stok: $error');
                                  },
                                  (validation) async { // ADDED: async for await
                                    final isValid = validation['is_valid'] ?? false;
                                    
                                    if (isValid) {
                                      // Validate: Dine-in must have table selected
                                      if (_orderType == 'dine_in' && _selectedTable == null && widget.table == null) {
                                        NotificationHelper.showWarning(context, 'Pilih meja terlebih dahulu untuk Dine In');
                                        return;
                                      }
                                      
                                      // Stock validated, proceed to payment
                                      // Stock validated, proceed to payment
                                      await context.push(ConfirmPaymentPage(
                                        isTable: _orderType == 'dine_in',
                                        table: _selectedTable ?? widget.table,
                                        orderType: _orderType,
                                        onPaymentSuccess: () {
                                          // Reset local state
                                          setState(() {
                                            _selectedTable = null;
                                            print('✅ HomePage: Table selection reset after payment (via callback)');
                                          });
                                          
                                          // Refresh products and stock
                                          print('🔄 Refreshing data after payment...');
                                          _refreshAllData();
                                          
                                          // Also reset DashboardPage state
                                          if (widget.onPaymentSuccess != null) {
                                            widget.onPaymentSuccess!();
                                            print('✅ Notified DashboardPage to reset table');
                                          }
                                        },
                                      ));
                                      
                                      // NOTE: Result check removed because popToRoot() returns null
                                      // The callback above handles the reset logic.
                                    } else {
                                      // Stock insufficient
                                      final errors = validation['errors'] as Map<String, dynamic>?;
                                      final errorMessages = errors?.values.join('\n') ?? 'Stok tidak cukup';
                                      
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('❌ Stok Tidak Cukup'),
                                          content: Text(errorMessages),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                );
                              },
                        label: 'Lanjutkan Pembayaran',
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // Professional Table Selector
  Widget _buildTableSelector() {
    final hasTable = _selectedTable != null;
    final isTakeaway = _orderType == 'takeaway';
    
    return GestureDetector(
      onTap: isTakeaway ? null : () async {
        // Disabled for takeaway - only enabled for dine_in
        // Navigate to Table Management and WAIT for table selection
        if (widget.onNavigateToTables != null) {
          widget.onNavigateToTables!();
          print('📋 Navigated to Table Management - navbar visible!');
          
          // Wait for result (selected table)
          // Note: DashboardPage needs to pass selected table to HomePage
          // For now, we'll trigger a rebuild after return
          await Future.delayed(const Duration(milliseconds: 500));
          if (mounted) setState(() {});
        }
      },
      child: Opacity(
        opacity: isTakeaway ? 0.4 : 1.0, // Dim if takeaway
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: hasTable
                ? LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      (isTakeaway ? Colors.grey : Colors.orange).withOpacity(0.1),
                      (isTakeaway ? Colors.grey : Colors.orange).withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasTable
                  ? AppColors.primary.withOpacity(0.3)
                  : (isTakeaway ? Colors.grey : Colors.orange).withOpacity(0.4),
              width: 2,
            ),
          ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: hasTable
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                hasTable ? Icons.table_restaurant : Icons.add_circle_outline,
                color: hasTable ? AppColors.primary : Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasTable ? 'Meja Dipilih' : 'Pilih Meja',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isTakeaway 
                        ? 'Takeaway (No Table)'
                        : (hasTable ? _selectedTable!.name : 'Tap untuk memilih meja'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isTakeaway 
                          ? Colors.grey 
                          : (hasTable ? AppColors.primary : Colors.orange),
                    ),
                  ),
                  if (isTakeaway) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Tidak perlu pilih meja',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ] else if (hasTable && _selectedTable!.categoryName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${_selectedTable!.categoryName} • ${_selectedTable!.capacity} pax',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Action Icon
            Icon(
              hasTable ? Icons.check_circle : Icons.arrow_forward_ios,
              color: hasTable ? Colors.green : Colors.grey[400],
              size: hasTable ? 28 : 20,
            ),
          ],
        ),
        ),
      ),
    );
  }
  
  Widget _buildOrderTypeSelector() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          Expanded(
            child: _buildTypeButton(
              type: 'dine_in',
              label: 'Dine In',
              icon: Icons.restaurant_menu_rounded,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _buildTypeButton(
              type: 'takeaway',
              label: 'Takeaway',
              icon: Icons.shopping_bag_rounded,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeButton({
    required String type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _orderType == type;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _orderType = type;
              // Clear table selection when switching to takeaway
              if (type == 'takeaway') {
                _selectedTable = null;
                print('🚫 Table selection cleared (Takeaway mode)');
              }
            });
            print('📝 Order Type changed to: $type');
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.grey[700],
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build product grid with optional category filter
  /// categoryId: null = show all, int = filter by category
  /// availableWidth: available content width for responsive grid
  Widget _buildProductGrid(int? categoryId, double availableWidth) {
    return BlocBuilder<LocalProductBloc, LocalProductState>(
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          loaded: (products) {
            // Filter by category if provided
            var filteredProducts = categoryId == null
                ? products
                : products.where((p) => p.category?.id == categoryId).toList();
            
            // Filter by search query
            if (_searchQuery.isNotEmpty) {
              filteredProducts = filteredProducts.where((p) {
                final name = (p.name ?? '').toLowerCase();
                final category = (p.category?.name ?? '').toLowerCase();
                return name.contains(_searchQuery) || category.contains(_searchQuery);
              }).toList();
            }
            
            if (filteredProducts.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No Items',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            
            // Dynamic aspect ratio based on width
            // Wider screen = wider cards (higher ratio)
            // Narrow screen = taller cards (lower ratio)
            double aspectRatio = 0.6; // Default for narrow
            if (availableWidth > 1000) {
              aspectRatio = 0.8;
            } else if (availableWidth > 600) {
              aspectRatio = 0.7;
            }

            // Calculate maxCrossAxisExtent to ensure at least 2 columns
            // If availableWidth is small (e.g. sidebar open on tablet), 200 might force 1 column
            // We want min 2 columns, so maxExtent should be at least availableWidth / 2
            // But we also don't want it too small.
            double maxExtent = 200;
            if (availableWidth < 450) { // Threshold for very narrow spaces
               maxExtent = (availableWidth / 2) - 24; // Force 2 columns minus spacing
            }

            return GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              itemCount: filteredProducts.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: maxExtent < 160 ? 160 : maxExtent, // Min width 160
                childAspectRatio: aspectRatio,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) => ProductCard(
                data: filteredProducts[index],
                onCartButton: () {},
              ),
            );
          },
        );
      },
    );
  }
  // 🔝 NEW HEADER WIDGET

}


