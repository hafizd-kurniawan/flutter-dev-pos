// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_posresto_app/core/extensions/build_context_ext.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_storage_helper.dart';
import 'package:flutter_posresto_app/data/datasources/stock_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/category/category_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/local_product/local_product_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/pos_settings/pos_settings_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/discount_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/dynamic_discount_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/dynamic_tax_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/dynamic_service_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/dialog/tax_dialog.dart';
import 'package:flutter_posresto_app/presentation/home/pages/confirm_payment_page.dart';
import 'package:flutter_posresto_app/presentation/home/pages/dashboard_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../../../core/components/spaces.dart';
import '../../../core/constants/colors.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../dialog/service_dialog.dart';
import '../widgets/column_button.dart';
import '../widgets/custom_tab_bar.dart';
import '../widgets/home_title.dart';
import '../widgets/order_menu.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  final bool isTable;
  final TableModel? table;
  const HomePage({
    Key? key,
    required this.isTable,
    this.table,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  Timer? _debounce;
  String _searchQuery = '';
  bool _isRefreshing = false;

  @override
  void initState() {
    print('🏠 HomePage initState - Starting fetch...');
    
    // Fetch categories from API
    context.read<CategoryBloc>().add(const CategoryEvent.getCategories());
    print('📂 CategoryBloc event triggered');
    
    // Fetch products from local storage
    context.read<LocalProductBloc>().add(const LocalProductEvent.getLocalProduct());
    print('📦 LocalProductBloc event triggered');
    
    // Fetch POS settings (discounts, taxes, services)
    context.read<PosSettingsBloc>().add(const PosSettingsEvent.getSettings());
    print('🔧 PosSettingsBloc event triggered');
    
    // Setup search listener with debounce
    searchController.addListener(_onSearchChanged);
    
    super.initState();
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
            // Mobile: SQLite
            await context.read<LocalProductBloc>().productLocalDatasource.deleteAllProducts();
            await context.read<LocalProductBloc>().productLocalDatasource.insertProducts(productResponse.data ?? []);
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Semua data berhasil diperbarui! ($successCount/$totalCount)'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('⚠️ Refresh selesai dengan ${errors.length} error:\n${errors.join('\n')}'),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Refresh error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Gagal refresh data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
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
        body: Row(
          children: [
            // LEFT SIDE: Products Grid (flex: 3)
            Expanded(
              flex: 3,
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Search Bar with Refresh Button
                        Row(
                          children: [
                            Expanded(
                              child: HomeTitle(
                                controller: searchController,
                                onChanged: (value) {
                                  // Debounce handled by listener
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Refresh Button (All Data)
                            IconButton(
                              onPressed: _isRefreshing ? null : _refreshAllData,
                              icon: _isRefreshing
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.refresh, size: 28),
                              color: AppColors.primary,
                              tooltip: 'Refresh semua data (Produk, Kategori, Settings)',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
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
                                  _buildProductGrid(null),
                                  
                                  // Dynamic category tabs - filter by category ID
                                  ...categories.map((category) => 
                                    _buildProductGrid(category.id)
                                  ),
                                ];
                                
                                return CustomTabBar(
                                  tabTitles: tabTitles,
                                  initialTabIndex: 0,
                                  tabViews: tabViews,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // RIGHT SIDE: Cart/Order (flex: 2)
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.topCenter,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Table Selection
                          GestureDetector(
                            onTap: () {
                              if (widget.table == null) {
                                context.push(DashboardPage(index: 1));
                              }
                            },
                            child: Text(
                              'Meja: ${widget.table == null ? 'Belum Pilih Meja' : '${widget.table!.id}'}',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SpaceHeight(8.0),
                          
                          // Order Number
                          Button.filled(
                            width: 180.0,
                            height: 40,
                            onPressed: () {},
                            label: 'Pesanan#',
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
                              SizedBox(width: 130),
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
                                    draftName) {
                                  if (products.isEmpty) {
                                    return const Center(
                                      child: Text('No Items'),
                                    );
                                  }
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => OrderMenu(data: products[index]),
                                    separatorBuilder: (context, index) => const SpaceHeight(1.0),
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
                                      ColumnButton(
                                        label: 'Diskon',
                                        svgGenImage: Assets.icons.diskon,
                                        onPressed: () => showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const DynamicDiscountDialog(),
                                        ),
                                      ),
                                    );
                                  }
                                  
                                  // Add Tax button if available
                                  if (settings.taxes.isNotEmpty) {
                                    buttons.add(
                                      ColumnButton(
                                        label: 'Pajak',
                                        svgGenImage: Assets.icons.pajak,
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => const DynamicTaxDialog(),
                                        ),
                                      ),
                                    );
                                  }
                                  
                                  // Add Service button if available
                                  if (settings.services.isNotEmpty) {
                                    buttons.add(
                                      ColumnButton(
                                        label: 'Layanan',
                                        svgGenImage: Assets.icons.layanan,
                                        onPressed: () => showDialog(
                                          context: context,
                                          builder: (context) => const DynamicServiceDialog(),
                                        ),
                                      ),
                                    );
                                  }
                                  
                                  // If no buttons, return empty
                                  if (buttons.isEmpty) {
                                    return const SizedBox.shrink();
                                  }
                                  
                                  // Return button row
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: buttons,
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
                                                loaded: (_, __, ___, ____, tax, _____, ______, _______, ________) {
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
                                                loaded: (_, __, ___, ____, _____, serviceCharge, ______, _______, ________) {
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
                                        tax, serviceCharge, totalQuantity, totalPrice, draftName) {
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
                                        tax, serviceCharge, totalQuantity, totalPrice, draftName) {
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
                                    tax, serviceCharge, totalQuantity, totalPrice, draftName) {
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
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Gagal validasi stok: $error'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              },
                                              (validation) {
                                                final isValid = validation['is_valid'] ?? false;
                                                
                                                if (isValid) {
                                                  // Stock validated, proceed to payment
                                                  context.push(ConfirmPaymentPage(
                                                    isTable: widget.isTable,
                                                    table: widget.table,
                                                  ));
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build product grid with optional category filter
  /// categoryId: null = show all, int = filter by category
  Widget _buildProductGrid(int? categoryId) {
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
            
            return GridView.builder(
              shrinkWrap: true,
              itemCount: filteredProducts.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.85,
                crossAxisCount: 3,
                crossAxisSpacing: 30.0,
                mainAxisSpacing: 30.0,
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
}

class _IsEmpty extends StatelessWidget {
  const _IsEmpty();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SpaceHeight(40),
        Assets.icons.noProduct.svg(),
        const SizedBox(height: 40.0),
        const Text(
          'Belum Ada Produk',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
