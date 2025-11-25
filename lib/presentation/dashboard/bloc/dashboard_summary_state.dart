part of 'dashboard_summary_bloc.dart';

abstract class DashboardSummaryState {}

class DashboardSummaryInitial extends DashboardSummaryState {}

class DashboardSummaryLoading extends DashboardSummaryState {}

class DashboardSummarySuccess extends DashboardSummaryState {
  final DashboardSummaryData data;
  DashboardSummarySuccess(this.data);
}

class DashboardSummaryError extends DashboardSummaryState {
  final String message;
  DashboardSummaryError(this.message);
}
