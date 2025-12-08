import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/core/services/local_notification_service.dart';
import 'package:flutter_posresto_app/data/datasources/notification_local_datasource.dart';

part 'notification_event.dart';
part 'notification_state.dart';
part 'notification_bloc.freezed.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final OrderRemoteDatasource _orderRemoteDatasource;
  Timer? _timer;

  NotificationBloc(this._orderRemoteDatasource) : super(const _Initial()) {
    on<_StartPolling>((event, emit) {
      _timer?.cancel();
      // Poll every 15 seconds
      _timer = Timer.periodic(const Duration(seconds: 15), (_) {
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
        (orders) async {
          // Sort by ID descending to get the latest
          orders.sort((a, b) => b.id.compareTo(a.id));
          
          if (orders.isEmpty) {
             if (state.orderCount != 0) {
                emit(state.copyWith(orderCount: 0, lastId: 0));
             }
             return;
          }

          final latestOrder = orders.first;
          final currentLastId = state.lastId;

          // Check if we have a new order
          if (currentLastId != 0 && latestOrder.id > currentLastId) {
             // New order detected!
             print('🔔 [NOTIF_BLOC] New Order Detected! ID: ${latestOrder.id}');
             
             // Check settings before playing sound
             final isSoundEnabled = await NotificationLocalDatasource().isSoundEnabled();
             final isNewOrderAlertEnabled = await NotificationLocalDatasource().isNewOrderAlertEnabled();
             
             if (isNewOrderAlertEnabled && isSoundEnabled) {
                await LocalNotificationService().showNotification(
                  id: DateTime.now().millisecond,
                  title: 'New Order Received!',
                  body: 'You have ${orders.length} paid orders.',
                  payload: 'new_order',
                );
             }
          }
          
          // Always update state if count or lastId changed
          if (state.orderCount != orders.length || state.lastId != latestOrder.id) {
            emit(state.copyWith(orderCount: orders.length, lastId: latestOrder.id));
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
