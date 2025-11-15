part of 'history_bloc.dart';

@freezed
class HistoryEvent with _$HistoryEvent {
  const factory HistoryEvent.started() = _Started;
  const factory HistoryEvent.fetchPaidOrders() = _FetchPaidOrders;
  const factory HistoryEvent.fetchCookingOrders() = _FetchCookingOrders;
  const factory HistoryEvent.fetchCompletedOrders() = _FetchCompletedOrders;
  const factory HistoryEvent.updateOrderStatus({
    required int orderId,
    required String status,
  }) = _UpdateOrderStatus;
}
