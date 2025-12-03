import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/order_response_model.dart';

part 'history_event.dart';
part 'history_state.dart';
part 'history_bloc.freezed.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final OrderRemoteDatasource orderRemoteDatasource;

  HistoryBloc(this.orderRemoteDatasource) : super(HistoryState.initial()) {
    on<_FetchPaidOrders>((event, emit) async {
      final isRefresh = event.isRefresh ?? false;
      
      if (!isRefresh && state.paidOrders.isNotEmpty) {
        return;
      }
      
      // Reset isStatusUpdated to prevent infinite loop
      emit(state.copyWith(isLoading: true, errorMessage: null, isStatusUpdated: false));
      final result = await orderRemoteDatasource.getPaidOrders();
      result.fold(
        (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
        (orders) {
          // Sort Ascending (Oldest -> Newest)
          orders.sort((a, b) => a.id.compareTo(b.id));
          emit(state.copyWith(isLoading: false, paidOrders: orders));
        },
      );
    });

    on<_FetchCookingOrders>((event, emit) async {
      final isRefresh = event.isRefresh ?? false;
      
      if (!isRefresh && state.cookingOrders.isNotEmpty) {
        return;
      }
      
      // Reset isStatusUpdated to prevent infinite loop
      emit(state.copyWith(isLoading: true, errorMessage: null, isStatusUpdated: false));
      final result = await orderRemoteDatasource.getCookingOrders();
      result.fold(
        (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
        (orders) {
          // Sort Ascending (Oldest -> Newest)
          orders.sort((a, b) => a.id.compareTo(b.id));
          emit(state.copyWith(isLoading: false, cookingOrders: orders));
        },
      );
    });

    on<_FetchCompletedOrders>((event, emit) async {
      final isRefresh = event.isRefresh ?? false;
      
      if (!isRefresh && state.completedOrders.isNotEmpty) {
        return;
      }
      
      // Reset isStatusUpdated to prevent infinite loop
      emit(state.copyWith(isLoading: true, errorMessage: null, isStatusUpdated: false));
      final result = await orderRemoteDatasource.getCompletedOrders();
      result.fold(
        (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
        (orders) {
          // Sort Ascending (Oldest -> Newest)
          orders.sort((a, b) => a.id.compareTo(b.id));
          emit(state.copyWith(isLoading: false, completedOrders: orders));
        },
      );
    });

    on<_UpdateOrderStatus>((event, emit) async {
      emit(state.copyWith(isLoading: true, errorMessage: null, isStatusUpdated: false));
      
      final result = await orderRemoteDatasource.updateOrderStatus(
        event.orderId,
        event.status,
      );
      
      result.fold(
        (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
        (success) {
           emit(state.copyWith(isLoading: false, isStatusUpdated: true));
           // Reset status updated flag after a short delay or let UI handle it
           // Ideally, we should trigger fetch events here, but Bloc cannot add events to itself easily inside handler 
           // without using `add`. But we can just re-fetch manually or let UI do it.
           // BETTER APPROACH: We can't await `add` here.
           // The UI will listen to `isStatusUpdated` and trigger refresh.
        },
      );
    });
  }
}
