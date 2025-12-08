part of 'history_bloc.dart';

@freezed
class HistoryEvent with _$HistoryEvent {
  const factory HistoryEvent.started() = _Started;
  const factory HistoryEvent.fetchPaidOrders({bool? isRefresh}) = _FetchPaidOrders;
  const factory HistoryEvent.fetchCookingOrders({bool? isRefresh}) = _FetchCookingOrders;
  const factory HistoryEvent.fetchCompletedOrders({bool? isRefresh}) = _FetchCompletedOrders;
  const factory HistoryEvent.updateOrderStatus({
    required int orderId,
    required String status,
  }) = _UpdateOrderStatus;
}
