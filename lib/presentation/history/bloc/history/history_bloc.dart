import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/order_response_model.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final OrderRemoteDatasource orderRemoteDatasource;

  List<OrderResponseModel> _paidOrders = [];
  List<OrderResponseModel> _cookingOrders = [];
  List<OrderResponseModel> _completedOrders = [];

  HistoryBloc(this.orderRemoteDatasource) : super(const _Initial()) {
    on<_FetchPaidOrders>((event, emit) async {
      final isRefresh = event.isRefresh ?? false;
      
      if (!isRefresh && _paidOrders.isNotEmpty) {
        emit(_Loaded(_paidOrders));
        return;
      }
      
      emit(const _Loading());
      final result = await orderRemoteDatasource.getPaidOrders();
      result.fold(
        (error) => emit(_Error(error)),
        (orders) {
          _paidOrders = orders;
          emit(_Loaded(orders));
        },
      );
    });

    on<_FetchCookingOrders>((event, emit) async {
      final isRefresh = event.isRefresh ?? false;
      
      if (!isRefresh && _cookingOrders.isNotEmpty) {
        emit(_Loaded(_cookingOrders));
        return;
      }
      
      emit(const _Loading());
      final result = await orderRemoteDatasource.getCookingOrders();
      result.fold(
        (error) => emit(_Error(error)),
        (orders) {
          _cookingOrders = orders;
          emit(_Loaded(orders));
        },
      );
    });

    on<_FetchCompletedOrders>((event, emit) async {
      final isRefresh = event.isRefresh ?? false;
      
      if (!isRefresh && _completedOrders.isNotEmpty) {
        emit(_Loaded(_completedOrders));
        return;
      }
      
      emit(const _Loading());
      final result = await orderRemoteDatasource.getCompletedOrders();
      result.fold(
        (error) => emit(_Error(error)),
        (orders) {
          _completedOrders = orders;
          emit(_Loaded(orders));
        },
      );
    });

    on<_UpdateOrderStatus>((event, emit) async {
      final result = await orderRemoteDatasource.updateOrderStatus(
        event.orderId,
        event.status,
      );
      result.fold(
        (error) => emit(_Error(error)),
        (success) => emit(const _StatusUpdated()),
      );
    });
  }
}
