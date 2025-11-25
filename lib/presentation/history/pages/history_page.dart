import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/order_response_model.dart';
import 'package:flutter_posresto_app/presentation/history/bloc/history/history_bloc.dart';
import 'package:flutter_posresto_app/presentation/history/widgets/order_card.dart';

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
    _onTabChanged();
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
        content: Text(
          order.status == 'paid'
              ? 'Start cooking order ${order.code}?'
              : 'Mark order ${order.code} as completed?',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Management'),
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
                    _onTabChanged();
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
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchPaidOrders());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: _buildOrdersList(context, state, 'paid'),
              ),
              
              // Cooking Orders Tab - with pull-to-refresh
              RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchCookingOrders());
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: _buildOrdersList(context, state, 'cooking'),
              ),
              
              // Completed Orders Tab - with pull-to-refresh
              RefreshIndicator(
                onRefresh: () async {
                  context.read<HistoryBloc>().add(const HistoryEvent.fetchCompletedOrders());
                  await Future.delayed(const Duration(seconds: 1));
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
