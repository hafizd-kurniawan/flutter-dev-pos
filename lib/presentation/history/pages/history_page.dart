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
      body: BlocConsumer<HistoryBloc, HistoryState>(
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
              // Paid Orders Tab
              _buildOrdersList(context, state, 'paid'),
              
              // Cooking Orders Tab
              _buildOrdersList(context, state, 'cooking'),
              
              // Completed Orders Tab
              _buildOrdersList(context, state, 'complete'),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, HistoryState state, String statusFilter) {
    return state.when(
      initial: () => const Center(child: Text('Pull to refresh')),
      loading: () => const Center(child: CircularProgressIndicator()),
      loaded: (orders) {
        if (orders.isEmpty) {
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
                        'No ${statusFilter} orders',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        statusFilter == 'paid'
                            ? 'New orders will appear here'
                            : statusFilter == 'cooking'
                                ? 'Orders being prepared will appear here'
                                : 'Completed orders will appear here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
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
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
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
