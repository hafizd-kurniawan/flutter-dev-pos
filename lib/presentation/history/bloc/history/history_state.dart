part of 'history_bloc.dart';

@freezed
@freezed
class HistoryState with _$HistoryState {
  const factory HistoryState({
    @Default([]) List<OrderResponseModel> paidOrders,
    @Default([]) List<OrderResponseModel> cookingOrders,
    @Default([]) List<OrderResponseModel> completedOrders,
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(false) bool isStatusUpdated,
  }) = _HistoryState;

  factory HistoryState.initial() => const HistoryState();
}
