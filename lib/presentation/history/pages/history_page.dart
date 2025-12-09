import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/order_response_model.dart';
import 'package:flutter_posresto_app/presentation/history/bloc/history/history_bloc.dart';
import 'package:flutter_posresto_app/data/dataoutputs/print_dataoutputs.dart';
import 'package:google_fonts/google_fonts.dart'; // NEW
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';
import 'package:flutter_posresto_app/presentation/history/widgets/order_card.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/settings/settings_bloc.dart'; // NEW
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'dart:developer';
import 'package:flutter_posresto_app/core/extensions/string_ext.dart'; // NEW: Import String Ext
import 'package:flutter_posresto_app/data/models/response/product_response_model.dart'; // NEW: Import Product Model
import 'package:flutter_posresto_app/data/datasources/settings_local_datasource.dart'; // NEW
import 'package:flutter_posresto_app/presentation/home/bloc/notification/notification_bloc.dart'; // NEW IMPORT
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/presentation/home/widgets/floating_header.dart';
import 'package:flutter_posresto_app/core/components/modern_refresh_button.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';

class HistoryPage extends StatefulWidget {
  final VoidCallback? onToggleSidebar;
  
  const HistoryPage({
    Key? key,
    this.onToggleSidebar,
  }) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isFilterActive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load initial data
    context.read<HistoryBloc>().add(const HistoryEvent.fetchPaidOrders());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final index = _tabController.index;
    if (index == 0) {
      context.read<HistoryBloc>().add(const HistoryEvent.fetchPaidOrders());
    } else if (index == 1) {
      context.read<HistoryBloc>().add(const HistoryEvent.fetchCookingOrders());
    } else if (index == 2) {
      context.read<HistoryBloc>().add(const HistoryEvent.fetchCompletedOrders());
    }
  }

  Future<void> _refreshOrders() async {
    final index = _tabController.index;
    if (index == 0) {
      context.read<HistoryBloc>().add(const HistoryEvent.fetchPaidOrders(isRefresh: true));
    } else if (index == 1) {
      context.read<HistoryBloc>().add(const HistoryEvent.fetchCookingOrders(isRefresh: true));
    } else if (index == 2) {
      context.read<HistoryBloc>().add(const HistoryEvent.fetchCompletedOrders(isRefresh: true));
    }
  }
  
  // Show date picker dialog
  Future<void> _showDateFilterDialog() async {
    DateTime? pickedStartDate = _startDate;
    DateTime? pickedEndDate = _endDate;
    
    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.filter_date_range),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Start Date
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.blue),
                  title: Text(AppLocalizations.of(context)!.start_date),
                  subtitle: Text(
                    pickedStartDate != null
                        ? '${pickedStartDate!.day}/${pickedStartDate!.month}/${pickedStartDate!.year}'
                        : AppLocalizations.of(context)!.select_start_date,
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: pickedStartDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => pickedStartDate = date);
                    }
                  },
                ),
                const Divider(),
                // End Date
                ListTile(
                  leading: const Icon(Icons.event, color: Colors.blue),
                  title: Text(AppLocalizations.of(context)!.end_date),
                  subtitle: Text(
                    pickedEndDate != null
                        ? '${pickedEndDate!.day}/${pickedEndDate!.month}/${pickedEndDate!.year}'
                        : AppLocalizations.of(context)!.select_end_date,
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: pickedEndDate ?? DateTime.now(),
                      firstDate: pickedStartDate ?? DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setDialogState(() => pickedEndDate = date);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Clear filter
                setState(() {
                  _startDate = null;
                  _endDate = null;
                  _isFilterActive = false;
                });
                Navigator.pop(dialogContext);
                _onTabChanged(); // Refresh with no filter
              },
              child: Text(AppLocalizations.of(context)!.clear_filter),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (pickedStartDate != null && pickedEndDate != null) {
                  setState(() {
                    _startDate = pickedStartDate;
                    _endDate = pickedEndDate;
                    _isFilterActive = true;
                  });
                  Navigator.pop(dialogContext);
                  _onTabChanged(); // Refresh with filter
                  
                  NotificationHelper.showInfo(
                    context,
                    '📅 Filter: ${pickedStartDate!.day}/${pickedStartDate!.month} - ${pickedEndDate!.day}/${pickedEndDate!.month}',
                  );
                } else {
                  NotificationHelper.showWarning(context, AppLocalizations.of(context)!.select_start_date);
                }
              },

              child: Text(AppLocalizations.of(context)!.apply_filter),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, OrderResponseModel order) {
    String newStatus = '';
    
    // Determine next status based on current
    if (order.status == 'paid') {
      newStatus = 'cooking';
    } else if (order.status == 'cooking') {
      newStatus = 'complete';
    } else {
      return; // Already complete
    }

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.update_status,
                    style: GoogleFonts.quicksand(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.status == 'paid'
                        ? AppLocalizations.of(context)!.start_cooking_confirm
                        : AppLocalizations.of(context)!.mark_complete_confirm,
                    style: GoogleFonts.quicksand(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Order Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.receipt_long, color: Colors.blue),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.code,
                                style: GoogleFonts.quicksand(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                order.customerName ?? 'Guest',
                                style: GoogleFonts.quicksand(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  if (order.note != null && order.note!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.yellow[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.yellow.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.note, size: 16, color: Colors.orange[800]),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.order_note,
                                style: GoogleFonts.quicksand(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order.note!,
                            style: GoogleFonts.quicksand(
                              fontSize: 14,
                              color: Colors.orange[900],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: GoogleFonts.quicksand(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        context.read<HistoryBloc>().add(
                              HistoryEvent.updateOrderStatus(
                                orderId: order.id,
                                status: newStatus,
                              ),
                            );
                        
                        NotificationHelper.showInfo(context, '${AppLocalizations.of(context)!.update_status} $newStatus...');
                        
                        Future.delayed(const Duration(seconds: 1), () {
                          _onTabChanged();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.confirm,
                        style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
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

  // NEW: Handle Print Receipt
  Future<void> _handlePrintReceipt(OrderResponseModel order) async {
    try {
      NotificationHelper.showInfo(context, AppLocalizations.of(context)!.printing_receipt);

      final receiptPrinter = await ProductLocalDatasource.instance.getPrinterByCode('receipt');
      if (receiptPrinter == null) {
        NotificationHelper.showWarning(context, AppLocalizations.of(context)!.no_printer_found);
        return;
      }

      // Convert OrderItems to ProductQuantity for printing
      final products = order.orderItems.map((item) {
        return ProductQuantity(
          product: Product(
            id: item.productId,
            name: item.productName,
            price: item.price.toString(),
          ),
          quantity: item.quantity,
          note: item.note ?? '', // NEW: Pass item note for printing
        );
      }).toList();

      // Calculate total items
      final totalItem = order.orderItems.fold(0, (sum, item) => sum + item.quantity);

      final printValue = await PrintDataoutputs.instance.printOrderV3(
        products,
        totalItem,
        order.totalAmount,
        order.paymentMethod,
        order.paymentAmount ?? order.totalAmount, // Use actual paid amount
        order.changeAmount ?? 0, // Use actual change amount
        order.subtotal,
        order.discountAmount ?? 0,
        order.taxAmount ?? 0,
        order.serviceChargeAmount ?? 0,
        order.cashierName ?? 'Cashier', // Use dynamic cashier name
        order.customerName ?? 'Guest',
        receiptPrinter.paper.toIntegerFromText,
        order.taxPercentage ?? 0,
        order.serviceChargePercentage ?? 0,
        order.orderType ?? 'Dine In', // NEW
        order.tableNumber ?? '', // NEW
        order.note ?? '', // NEW: Global Order Note
        AppLocalizations.of(context)!, // NEW: Localization
      );

      if (receiptPrinter.type == 'Bluetooth') {
        await PrintBluetoothThermal.writeBytes(printValue);
      } else {
        final printer = PrinterNetworkManager(receiptPrinter.address);
        final connect = await printer.connect();
        if (connect == PosPrintResult.success) {
          await printer.printTicket(printValue);
          printer.disconnect();
        } else {
          log("Failed to connect to printer");
            NotificationHelper.showError(context, AppLocalizations.of(context)!.no_printer_found);
        }
      }
    } catch (e) {
      log('Error printing: $e');
      NotificationHelper.showError(context, AppLocalizations.of(context)!.error_printing(e.toString()));
    }
  }

  // NEW: Handle Share Receipt
  Future<void> _handleShareReceipt(OrderResponseModel order) async {
    try {
      // Convert OrderItems to ProductQuantity
      final products = order.orderItems.map((item) {
        return ProductQuantity(
          product: Product(
            id: item.productId,
            name: item.productName,
            price: item.price.toString(),
          ),
          quantity: item.quantity,
          note: item.note ?? '', // NEW: Pass item note for sharing
        );
      }).toList();

      // Calculate total items
      final totalItem = order.orderItems.fold(0, (sum, item) => sum + item.quantity);

      // Get current user for Cashier Name (Fallback)
      final authData = await AuthLocalDataSource().getAuthData();
      final currentCashier = authData?.user?.name ?? 'Cashier';

      final xFile = await PrintDataoutputs.instance.generateReceiptPdf(
        products,
        totalItem,
        order.totalAmount,
        order.paymentMethod,
        order.paymentAmount ?? order.totalAmount, // Use actual paid amount
        order.changeAmount ?? 0, // Use actual change amount
        order.subtotal,
        order.discountAmount ?? 0,
        order.taxAmount ?? 0,
        order.serviceChargeAmount ?? 0,
        order.cashierName ?? currentCashier, // Use order cashier or current user
        order.customerName ?? 'Guest',
        order.orderType ?? 'Dine In',
        order.tableNumber ?? '', // NEW
        order.taxPercentage ?? 0,
        order.serviceChargePercentage ?? 0,
        order.note ?? '', // NEW: Pass Global Note
        AppLocalizations.of(context)!,
      );

      // Fetch Settings for Share Text
      final settings = await SettingsLocalDatasource().getSettings();
      final appName = settings['app_name'] ?? 'Self Order POS';

      await Share.shareXFiles([xFile], text: 'Receipt from $appName');
    } catch (e) {
      log('Error sharing: $e');
      NotificationHelper.showError(context, '${AppLocalizations.of(context)!.error_printing(e.toString())}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FF), // App Background
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isTight = constraints.maxWidth < 600;
              final margin = isTight ? 16.0 : 24.0;
              
              return Padding(
                padding: EdgeInsets.only(top: 100.0, left: margin, right: margin),
                child: Column(
              children: [
                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.0), // Removed margin
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (_) => _onTabChanged(),
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.primary,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: GoogleFonts.quicksand(fontWeight: FontWeight.w600),
                    dividerColor: Colors.transparent, // Remove divider
                    padding: const EdgeInsets.all(6), // Add padding for pill effect
                    tabs: [
                      Tab(text: AppLocalizations.of(context)!.paid_status, icon: Icon(Icons.payment, size: 20)),
                      Tab(text: AppLocalizations.of(context)!.cooking_status, icon: Icon(Icons.restaurant, size: 20)),
                      Tab(text: AppLocalizations.of(context)!.completed_status, icon: Icon(Icons.check_circle, size: 20)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
          // Date Filter Indicator Banner
          if (_isFilterActive)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border(
                  bottom: BorderSide(color: Colors.blue.shade200),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 18, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    '${AppLocalizations.of(context)!.filter_active}: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _startDate = null;
                        _endDate = null;
                        _isFilterActive = false;
                      });
                      _onTabChanged();
                    },
                    icon: const Icon(Icons.close, size: 16),
                    label: Text(AppLocalizations.of(context)!.clear_filter),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ),
                ],
              ),
            ),
          // Main Content
          Expanded(
            child: BlocConsumer<HistoryBloc, HistoryState>(
              listener: (context, state) {
                if (state.isStatusUpdated) {
                  NotificationHelper.showSuccess(context, AppLocalizations.of(context)!.update_status);
                  // Refresh all tabs to ensure consistency
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchPaidOrders(isRefresh: true));
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchCookingOrders(isRefresh: true));
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchCompletedOrders(isRefresh: true));
                  
                  // Sync Notification Badge (Count of Paid Orders)
                  context.read<NotificationBloc>().add(const NotificationEvent.checkOrders());
                }
                
                if (state.errorMessage != null) {
                  NotificationHelper.showError(context, 'Error: ${state.errorMessage}');
                }
              },
              builder: (context, state) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    // Paid Orders Tab
                    RefreshIndicator(
                      onRefresh: () async {
                        context.read<HistoryBloc>().add(const HistoryEvent.fetchPaidOrders(isRefresh: true));
                      },
                      child: _buildOrdersList(context, state.paidOrders, state.isLoading, state.errorMessage, 'paid'),
                    ),
                    
                    // Cooking Orders Tab
                    RefreshIndicator(
                      onRefresh: () async {
                        context.read<HistoryBloc>().add(const HistoryEvent.fetchCookingOrders(isRefresh: true));
                      },
                      child: _buildOrdersList(context, state.cookingOrders, state.isLoading, state.errorMessage, 'cooking'),
                    ),
                    
                    // Completed Orders Tab
                    RefreshIndicator(
                      onRefresh: () async {
                        context.read<HistoryBloc>().add(const HistoryEvent.fetchCompletedOrders(isRefresh: true));
                      },
                      child: _buildOrdersList(context, state.completedOrders, state.isLoading, state.errorMessage, 'complete'),
                    ),
                  ],
                );
              },
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
              title: AppLocalizations.of(context)!.history_orders,
              onToggleSidebar: widget.onToggleSidebar ?? () {},
              isSidebarVisible: true,
              actions: [
                // Date Filter Button
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.filter_list_rounded, size: 20),
                      if (_isFilterActive)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 6,
                              minHeight: 6,
                            ),
                          ),
                        ),
                    ],
                  ),
                  tooltip: _isFilterActive 
                      ? AppLocalizations.of(context)!.filter_active
                      : AppLocalizations.of(context)!.filter_by_date,
                  onPressed: _showDateFilterDialog,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                  ),
                  color: AppColors.primary,
                ),
                
                const SizedBox(width: 8),
                
                // Refresh Button
                BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (context, state) {
                    final isLoading = state.isLoading;
                    return ModernRefreshButton(
                      isLoading: isLoading,
                      onPressed: () {
                        _refreshOrders();
                        NotificationHelper.showInfo(context, AppLocalizations.of(context)!.loading_data);
                      },
                      tooltip: AppLocalizations.of(context)!.tooltip_refresh_orders,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(
    BuildContext context, 
    List<OrderResponseModel> orders, 
    bool isLoading, 
    String? errorMessage, 
    String statusFilter
  ) {
    // Show loading only if list is empty and loading is true (initial load)
    if (isLoading && orders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // Show error if list is empty and error exists
    if (errorMessage != null && orders.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.error_loading_orders,
                  style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _refreshOrders,
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context)!.retry),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // CLIENT-SIDE DATE FILTERING
    var filteredOrders = orders;
    
    if (_isFilterActive && _startDate != null && _endDate != null) {
      filteredOrders = orders.where((order) {
        if (order.placedAt == null) return false;
        
        try {
          final orderDate = DateTime.parse(order.placedAt!);
          final startOfDay = DateTime(_startDate!.year, _startDate!.month, _startDate!.day, 0, 0, 0);
          final endOfDay = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
          
          return orderDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
                 orderDate.isBefore(endOfDay.add(const Duration(seconds: 1)));
        } catch (e) {
          print('Error parsing date for order ${order.id}: $e');
          return false;
        }
      }).toList();
    }
    
    if (filteredOrders.isEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Icon(
                  statusFilter == 'paid'
                      ? Icons.payment
                      : statusFilter == 'cooking'
                          ? Icons.restaurant
                          : Icons.check_circle,
                  size: 80,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  _isFilterActive 
                      ? 'No orders in date range' 
                      : 'No ${statusFilter} orders',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isFilterActive
                      ? 'No orders found between\n${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                      : statusFilter == 'paid'
                          ? 'New orders will appear here'
                          : statusFilter == 'cooking'
                              ? 'Orders being prepared will appear here'
                              : 'Completed orders will appear here',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return OrderCard(
          order: order,
          onStatusUpdate: () => _showStatusUpdateDialog(context, order),
          onPrint: () => _handlePrintReceipt(order),
          onShare: () => _handleShareReceipt(order),
        );
      },
    );
  }
}
