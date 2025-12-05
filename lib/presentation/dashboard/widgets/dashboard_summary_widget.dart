import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/components/spaces.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/models/response/dashboard_summary_model.dart';
import 'package:flutter_posresto_app/presentation/dashboard/bloc/dashboard_summary_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardSummaryWidget extends StatelessWidget {
  const DashboardSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardSummaryBloc, DashboardSummaryState>(
      builder: (context, state) {
        if (state is DashboardSummaryInitial) {
          return const SizedBox();
        } else if (state is DashboardSummaryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardSummaryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SpaceHeight(16),
                Text('Error: ${state.message}'),
                const SpaceHeight(16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<DashboardSummaryBloc>().add(
                      DashboardSummaryGetSummary(),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (state is DashboardSummarySuccess) {
          return _buildDashboard(context, state.data);
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardSummaryData data) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardSummaryBloc>().add(
          DashboardSummaryRefresh(),
        );
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header removed as requested
            _buildTodayPerformance(data.today),
            const SpaceHeight(16),
            _buildOrderTypes(data.orderTypes),
            const SpaceHeight(16),
            if (data.topProducts.isNotEmpty) _buildTopProducts(data.topProducts),
            const SpaceHeight(16),
            if (data.alerts.lowStockCount > 0 || data.alerts.pendingOrders > 0)
              _buildAlerts(data.alerts),
            const SpaceHeight(16),
            if (data.subscription.tier == 'free' || 
                data.subscription.tier == '' || 
                data.subscription.tier == 'null')
              _buildUpgradeCTA(context, data.subscription),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayPerformance(TodayStats stats) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                SpaceWidth(8),
                Text(
                  'TODAY\'S PERFORMANCE',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SpaceHeight(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on, color: AppColors.primary, size: 24),
                      const SpaceWidth(8),
                      Flexible(
                        child: Text(
                          'Total Sales',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  stats.totalSales.currencyFormatRp,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSmallStat(
                    icon: Icons.shopping_cart,
                    label: 'Orders',
                    value: stats.totalOrders.toString(),
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildSmallStat(
                    icon: Icons.trending_up,
                    label: 'Avg Order',
                    value: stats.averageOrder.currencyFormatRp,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SpaceHeight(12),
            _buildSmallStat(
              icon: Icons.people,
              label: 'Customers',
              value: stats.uniqueCustomers.toString(),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SpaceWidth(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SpaceHeight(2),
              Text(
                value,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTypes(OrderTypesStats stats) {
    final total = stats.dineIn + stats.takeaway + stats.delivery;
    if (total == 0) return const SizedBox();
    
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
                SpaceWidth(8),
                Text(
                  'ORDER TYPES',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SpaceHeight(16),
            Row(
              children: [
                Expanded(
                  child: _buildOrderTypeColumn(
                    label: 'Dine-In',
                    count: stats.dineIn,
                    total: total,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildOrderTypeColumn(
                    label: 'Takeaway',
                    count: stats.takeaway,
                    total: total,
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildOrderTypeColumn(
                    label: 'Delivery',
                    count: stats.delivery,
                    total: total,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeColumn({
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    final percentage = total > 0 ? (count / total * 100).toStringAsFixed(0) : '0';
    
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SpaceHeight(8),
        Text(
          count.toString(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
        ),
        const SpaceHeight(4),
        Text('$percentage%', style: TextStyle(fontSize: 11, color: color)),
      ],
    );
  }

  Widget _buildTopProducts(List<TopProduct> products) {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                SpaceWidth(8),
                Text(
                  'TOP 3 PRODUCTS',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SpaceHeight(16),
            ...products.asMap().entries.map((entry) {
              final index = entry.key;
              final product = entry.value;
              
              return Column(
                children: [
                  if (index > 0) const Divider(height: 24),
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _getRankColor(index),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SpaceWidth(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SpaceHeight(4),
                            Text(
                              '${product.totalSold} sold',
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0: return Colors.amber;
      case 1: return Colors.grey;
      case 2: return Colors.brown;
      default: return Colors.grey;
    }
  }

  Widget _buildAlerts(AlertsData alerts) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700),
                const SpaceWidth(8),
                const Text('ALERTS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SpaceHeight(12),
            if (alerts.lowStockCount > 0)
              Text('• ${alerts.lowStockCount} products low stock'),
            if (alerts.pendingOrders > 0)
              Text('• ${alerts.pendingOrders} pending orders'),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeCTA(BuildContext context, SubscriptionData subscription) {
    return Card(
      color: AppColors.primary.withOpacity(0.1),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.primary),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.lock_outline, size: 48, color: AppColors.primary),
            const SpaceHeight(16),
            const Text(
              'UNLOCK FULL ANALYTICS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SpaceHeight(12),
            const Text('Upgrade to Premium to get:', style: TextStyle(fontSize: 13)),
            const SpaceHeight(12),
            ...[
              '✅ Profit Analysis',
              '✅ Customer Insights',
              '✅ Sales Trends (7-30 days)',
              '✅ Export PDF/Excel',
              '✅ Advanced Reports',
            ].map((text) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(text, style: const TextStyle(fontSize: 13)),
              ),
            )).toList(),
            const SpaceHeight(20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openWebDashboard(context),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text('View Dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SpaceWidth(12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openUpgradePage(context),
                    icon: const Icon(Icons.star),
                    label: const Text('Upgrade'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            if (subscription.canAccessFullReports) ...[
              const SpaceHeight(12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SpaceWidth(8),
                    Flexible(
                      child: Text(
                        'You have 1 FREE trial view remaining!',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _openWebDashboard(BuildContext context) async {
    final webUrl = Uri.parse('${Variables.baseUrl}/admin/reports');
    
    if (await canLaunchUrl(webUrl)) {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open web dashboard')),
      );
    }
  }

  void _openUpgradePage(BuildContext context) async {
    final upgradeUrl = Uri.parse('${Variables.baseUrl}/admin/upgrade');
    
    if (await canLaunchUrl(upgradeUrl)) {
      await launchUrl(upgradeUrl, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open upgrade page')),
      );
    }
  }
}
