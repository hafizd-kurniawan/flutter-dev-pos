class DashboardSummaryResponse {
  final bool success;
  final DashboardSummaryData data;

  DashboardSummaryResponse({
    required this.success,
    required this.data,
  });

  factory DashboardSummaryResponse.fromJson(Map<String, dynamic> json) =>
      DashboardSummaryResponse(
        success: json["success"] ?? false,
        data: DashboardSummaryData.fromJson(json["data"]),
      );
}

class DashboardSummaryData {
  final TodayStats today;
  final OrderTypesStats orderTypes;
  final List<TopProduct> topProducts;
  final AlertsData alerts;
  final SubscriptionData subscription;

  DashboardSummaryData({
    required this.today,
    required this.orderTypes,
    required this.topProducts,
    required this.alerts,
    required this.subscription,
  });

  factory DashboardSummaryData.fromJson(Map<String, dynamic> json) =>
      DashboardSummaryData(
        today: TodayStats.fromJson(json["today"]),
        orderTypes: OrderTypesStats.fromJson(json["order_types"]),
        topProducts: (json["top_products"] as List)
            .map((x) => TopProduct.fromJson(x))
            .toList(),
        alerts: AlertsData.fromJson(json["alerts"]),
        subscription: SubscriptionData.fromJson(json["subscription"]),
      );
}

class TodayStats {
  final int totalSales;
  final int totalOrders;
  final int averageOrder;
  final int uniqueCustomers;

  TodayStats({
    required this.totalSales,
    required this.totalOrders,
    required this.averageOrder,
    required this.uniqueCustomers,
  });

  factory TodayStats.fromJson(Map<String, dynamic> json) => TodayStats(
        totalSales: json["total_sales"] ?? 0,
        totalOrders: json["total_orders"] ?? 0,
        averageOrder: json["average_order"] ?? 0,
        uniqueCustomers: json["unique_customers"] ?? 0,
      );
}

class OrderTypesStats {
  final int dineIn;
  final int takeaway;
  final int delivery;

  OrderTypesStats({
    required this.dineIn,
    required this.takeaway,
    required this.delivery,
  });

  factory OrderTypesStats.fromJson(Map<String, dynamic> json) =>
      OrderTypesStats(
        dineIn: json["dine_in"] ?? 0,
        takeaway: json["takeaway"] ?? 0,
        delivery: json["delivery"] ?? 0,
      );
}

class TopProduct {
  final String name;
  final int totalSold;
  final String totalRevenue;

  TopProduct({
    required this.name,
    required this.totalSold,
    required this.totalRevenue,
  });

  factory TopProduct.fromJson(Map<String, dynamic> json) => TopProduct(
        name: json["name"] ?? "",
        totalSold: json["total_sold"] ?? 0,
        totalRevenue: json["total_revenue"] ?? "0",
      );
}

class AlertsData {
  final int lowStockCount;
  final int pendingOrders;

  AlertsData({
    required this.lowStockCount,
    required this.pendingOrders,
  });

  factory AlertsData.fromJson(Map<String, dynamic> json) => AlertsData(
        lowStockCount: json["low_stock_count"] ?? 0,
        pendingOrders: json["pending_orders"] ?? 0,
      );
}

class SubscriptionData {
  final String tier;
  final bool canAccessFullReports;

  SubscriptionData({
    required this.tier,
    required this.canAccessFullReports,
  });

  factory SubscriptionData.fromJson(Map<String, dynamic> json) =>
      SubscriptionData(
        tier: json["tier"] ?? "free",
        canAccessFullReports: json["can_access_full_reports"] ?? false,
      );
}
