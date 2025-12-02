import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';

part 'notification_event.dart';
part 'notification_state.dart';
part 'notification_bloc.freezed.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final OrderRemoteDatasource _orderRemoteDatasource;
  Timer? _timer;

  NotificationBloc(this._orderRemoteDatasource) : super(const _Initial()) {
    on<_StartPolling>((event, emit) {
      _timer?.cancel();
      // Poll every 60 seconds
      _timer = Timer.periodic(const Duration(seconds: 60), (_) {
        add(const _CheckOrders());
      });
      // Check immediately
      add(const _CheckOrders());
    });

    on<_StopPolling>((event, emit) {
      _timer?.cancel();
    });

    on<_CheckOrders>((event, emit) async {
      final result = await _orderRemoteDatasource.getPaidOrders();
      result.fold(
        (error) => null, // Ignore errors during silent polling
        (orders) {
          // Only emit if count changed to avoid unnecessary rebuilds
          if (state.orderCount != orders.length) {
            emit(state.copyWith(orderCount: orders.length));
          }
        },
      );
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
