import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/core/components/spaces.dart';
import 'package:flutter_posresto_app/core/constants/colors.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/core/extensions/int_ext.dart';
import 'package:flutter_posresto_app/data/models/response/dashboard_summary_model.dart';
import 'package:flutter_posresto_app/presentation/dashboard/bloc/dashboard_summary_bloc.dart';
import 'package:flutter_posresto_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_posresto_app/core/helpers/notification_helper.dart';

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
                Text(AppLocalizations.of(context)!.error_message(state.message)),
                const SpaceHeight(16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<DashboardSummaryBloc>().add(
                      DashboardSummaryGetSummary(),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: Text(AppLocalizations.of(context)!.retry),
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
            _buildTodayPerformance(context, data.today),
            const SpaceHeight(16),
            _buildOrderTypes(context, data.orderTypes),
            const SpaceHeight(16),
            if (data.topProducts.isNotEmpty) _buildTopProducts(context, data.topProducts),
            const SpaceHeight(16),
            if (data.alerts.lowStockCount > 0 || data.alerts.pendingOrders > 0)
              _buildAlerts(context, data.alerts),
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

  Widget _buildTodayPerformance(BuildContext context, TodayStats stats) {
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
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                SpaceWidth(8),
                Text(
                  AppLocalizations.of(context)!.todays_performance,
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
                          AppLocalizations.of(context)!.total_sales,
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
                      context: context,
                      icon: Icons.shopping_cart,
                      label: AppLocalizations.of(context)!.orders,
                      value: stats.totalOrders.toString(),
                      color: Colors.blue,
                    ),
                ),
                Expanded(
                    child: _buildSmallStat(
                      context: context,
                      icon: Icons.trending_up,
                      label: AppLocalizations.of(context)!.avg_order,
                      value: stats.averageOrder.currencyFormatRp,
                      color: Colors.orange,
                    ),
                ),
              ],
            ),
            const SpaceHeight(12),
            _buildSmallStat(
              context: context,
              icon: Icons.people,
              label: AppLocalizations.of(context)!.customers,
              value: stats.uniqueCustomers.toString(),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStat({
    required BuildContext context,
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

  Widget _buildOrderTypes(BuildContext context, OrderTypesStats stats) {
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
            Row(
              children: [
                Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
                SpaceWidth(8),
                Text(
                  AppLocalizations.of(context)!.order_types,
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
                    context: context,
                    label: AppLocalizations.of(context)!.dine_in,
                    count: stats.dineIn,
                    total: total,
                    color: Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildOrderTypeColumn(
                    context: context,
                    label: AppLocalizations.of(context)!.takeaway,
                    count: stats.takeaway,
                    total: total,
                    color: Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildOrderTypeColumn(
                    context: context,
                    label: AppLocalizations.of(context)!.delivery,
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
    required BuildContext context,
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

  Widget _buildTopProducts(BuildContext context, List<TopProduct> products) {
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
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.amber, size: 20),
                SpaceWidth(8),
                Text(
                  AppLocalizations.of(context)!.top_3_products,
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
                              AppLocalizations.of(context)!.sold_count(product.totalSold),
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

  Widget _buildAlerts(BuildContext context, AlertsData alerts) {
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
                Text(AppLocalizations.of(context)!.alerts, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
            const SpaceHeight(12),
            if (alerts.lowStockCount > 0)
              Text('• ${AppLocalizations.of(context)!.low_stock_count(alerts.lowStockCount)}'),
            if (alerts.pendingOrders > 0)
              Text('• ${AppLocalizations.of(context)!.pending_orders_count(alerts.pendingOrders)}'),
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
            Text(
              AppLocalizations.of(context)!.unlock_full_analytics,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SpaceHeight(12),
            Text(AppLocalizations.of(context)!.upgrade_premium_desc, style: const TextStyle(fontSize: 13)),
            const SpaceHeight(12),
            ...[
              AppLocalizations.of(context)!.feature_profit_analysis,
              AppLocalizations.of(context)!.feature_customer_insights,
              AppLocalizations.of(context)!.feature_sales_trends,
              AppLocalizations.of(context)!.feature_export,
              AppLocalizations.of(context)!.feature_advanced_reports,
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
                    label: Text(AppLocalizations.of(context)!.view_dashboard),
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
                    label: Text(AppLocalizations.of(context)!.upgrade),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SpaceWidth(8),
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.free_trial_remaining,
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
      NotificationHelper.showError(context, AppLocalizations.of(context)!.error_open_web);
    }
  }

  void _openUpgradePage(BuildContext context) async {
    final upgradeUrl = Uri.parse('${Variables.baseUrl}/admin/upgrade');
    
    if (await canLaunchUrl(upgradeUrl)) {
      await launchUrl(upgradeUrl, mode: LaunchMode.externalApplication);
    } else {
      NotificationHelper.showError(context, AppLocalizations.of(context)!.error_open_upgrade);
    }
  }
}
