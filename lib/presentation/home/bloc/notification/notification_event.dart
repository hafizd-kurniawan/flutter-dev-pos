part of 'notification_bloc.dart';

@freezed
class NotificationEvent with _$NotificationEvent {
  const factory NotificationEvent.startPolling() = _StartPolling;
  const factory NotificationEvent.stopPolling() = _StopPolling;
  const factory NotificationEvent.checkOrders() = _CheckOrders;
}
