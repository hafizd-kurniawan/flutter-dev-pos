import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/order_response_model.dart';
import 'package:flutter_posresto_app/presentation/history/bloc/history/history_bloc.dart';
import 'package:flutter_posresto_app/data/dataoutputs/print_dataoutputs.dart';
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

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

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
          title: const Text('Filter by Date Range'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Start Date
                ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.blue),
                  title: const Text('Start Date'),
                  subtitle: Text(
                    pickedStartDate != null
                        ? '${pickedStartDate!.day}/${pickedStartDate!.month}/${pickedStartDate!.year}'
                        : 'Select start date',
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
                  title: const Text('End Date'),
                  subtitle: Text(
                    pickedEndDate != null
                        ? '${pickedEndDate!.day}/${pickedEndDate!.month}/${pickedEndDate!.year}'
                        : 'Select end date',
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
              child: const Text('Clear Filter'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
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
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '📅 Filter: ${pickedStartDate!.day}/${pickedStartDate!.month} - ${pickedEndDate!.day}/${pickedEndDate!.month}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⚠️ Please select both start and end dates'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Apply Filter'),
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
      newStatus = 'complete'; // Changed from 'completed' to 'complete'
    } else {
      return; // Already complete
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.status == 'paid'
                  ? 'Start cooking order ${order.code}?'
                  : 'Mark order ${order.code} as completed?',
            ),
            if (order.note != null && order.note!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan Pesanan:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.note!,
                      style: TextStyle(
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
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<HistoryBloc>().add(
                    HistoryEvent.updateOrderStatus(
                      orderId: order.id,
                      status: newStatus,
                    ),
                  );
              
              // Show snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Updating order status to $newStatus...'),
                  duration: const Duration(seconds: 2),
                ),
              );
              
              // Refresh after short delay
              Future.delayed(const Duration(seconds: 1), () {
                _onTabChanged();
              });
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // NEW: Handle Print Receipt
  Future<void> _handlePrintReceipt(OrderResponseModel order) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🖨️ Printing receipt...')),
      );

      final receiptPrinter = await ProductLocalDatasource.instance.getPrinterByCode('receipt');
      if (receiptPrinter == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ No receipt printer found')),
        );
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
        order.totalAmount, // Assuming exact payment for history
        0, // No change info in history
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('❌ Failed to connect to printer')),
          );
        }
      }
    } catch (e) {
      log('Error printing: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error printing: $e')),
      );
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

      final xFile = await PrintDataoutputs.instance.generateReceiptPdf(
        products,
        totalItem,
        order.totalAmount,
        order.paymentMethod,
        order.totalAmount,
        0,
        order.subtotal,
        order.discountAmount ?? 0,
        order.taxAmount ?? 0,

        order.serviceChargeAmount ?? 0,
        order.cashierName ?? 'Cashier',
        order.customerName ?? 'Guest',
        order.orderType ?? 'Dine In',
        order.tableNumber ?? '', // NEW
        order.taxPercentage ?? 0,
        order.serviceChargePercentage ?? 0,
        order.note ?? '', // NEW: Pass Global Note
      );

      // Fetch Settings for Share Text
      final settings = await SettingsLocalDatasource().getSettings();
      final appName = settings['app_name'] ?? 'Self Order POS';

      await Share.shareXFiles([xFile], text: 'Receipt from $appName');
    } catch (e) {
      log('Error sharing: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error sharing: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        actions: [

          // Date Filter Button
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.filter_list_rounded, size: 26),
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
                        minWidth: 8,
                        minHeight: 8,
                      ),
                    ),
                  ),
              ],
            ),
            tooltip: _isFilterActive 
                ? 'Filter Active: ${_startDate!.day}/${_startDate!.month} - ${_endDate!.day}/${_endDate!.month}'
                : 'Filter by Date',
            onPressed: _showDateFilterDialog,
          ),
          // Refresh Button - Modern Design
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) {
              final isLoading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.refresh_rounded, size: 28),
                  tooltip: 'Refresh Orders',
                  onPressed: isLoading ? null : () {
                    _refreshOrders();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('🔄 Memuat data terbaru...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) => _onTabChanged(),
          tabs: const [
            Tab(text: 'Paid', icon: Icon(Icons.payment)),
            Tab(text: 'Cooking', icon: Icon(Icons.restaurant)),
            Tab(text: 'Completed', icon: Icon(Icons.check_circle)),
          ],
        ),
      ),
      body: Column(
        children: [
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
                    'Filter: ${_startDate!.day}/${_startDate!.month}/${_startDate!.year} - ${_endDate!.day}/${_endDate!.month}/${_endDate!.year}',
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
                    label: const Text('Clear'),
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
                state.maybeWhen(
                  statusUpdated: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Order status updated successfully!'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    _onTabChanged();
                  },
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('❌ Error: $message'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  orElse: () {},
                );
              },
              builder: (context, state) {
                return TabBarView(
                  controller: _tabController,
                  children: [
              // Paid Orders Tab - with pull-to-refresh
              RefreshIndicator(
                onRefresh: () async {
                  await _refreshOrders();
                },
                child: _buildOrdersList(context, state, 'paid'),
              ),
              
              // Cooking Orders Tab - with pull-to-refresh
              RefreshIndicator(
                onRefresh: () async {
                  await _refreshOrders();
                },
                child: _buildOrdersList(context, state, 'cooking'),
              ),
              
              // Completed Orders Tab - with pull-to-refresh
              RefreshIndicator(
                onRefresh: () async {
                  await _refreshOrders();
                },
                child: _buildOrdersList(context, state, 'complete'),
              ),
            ],
          );
        },
      ),
        ),
      ],
    ),
    );
  }

  Widget _buildOrdersList(BuildContext context, HistoryState state, String statusFilter) {
    return state.when(
      initial: () => const Center(child: Text('Pull to refresh')),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (orders) {
        // CLIENT-SIDE DATE FILTERING
        var filteredOrders = orders;
        
        if (_isFilterActive && _startDate != null && _endDate != null) {
          filteredOrders = orders.where((order) {
            if (order.placedAt == null) return false;
            
            try {
              final orderDate = DateTime.parse(order.placedAt!);
              
              // Set start date to beginning of day (00:00:00)
              final startOfDay = DateTime(_startDate!.year, _startDate!.month, _startDate!.day, 0, 0, 0);
              
              // Set end date to end of day (23:59:59)
              final endOfDay = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);
              
              // Check if order date is within range
              return orderDate.isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
                     orderDate.isBefore(endOfDay.add(const Duration(seconds: 1)));
            } catch (e) {
              print('Error parsing date for order ${order.id}: $e');
              return false;
            }
          }).toList();
        }
        
        if (filteredOrders.isEmpty) {
          return RefreshIndicator(
            onRefresh: _refreshOrders,
            child: ListView(
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
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refreshOrders,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              final order = filteredOrders[index];
              return OrderCard(
                order: order,
                onStatusUpdate: () => _showStatusUpdateDialog(context, order),
                onPrint: () => _handlePrintReceipt(order), // NEW
                onShare: () => _handleShareReceipt(order), // NEW
              );
            },
          ),
        );
      },
      error: (message) => RefreshIndicator(
        onRefresh: _refreshOrders,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading orders',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _refreshOrders,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      statusUpdated: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
