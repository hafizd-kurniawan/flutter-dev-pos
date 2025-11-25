part of 'dashboard_summary_bloc.dart';

abstract class DashboardSummaryEvent {}

class DashboardSummaryGetSummary extends DashboardSummaryEvent {}

class DashboardSummaryRefresh extends DashboardSummaryEvent {}
