import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_posresto_app/core/extensions/string_ext.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/order_remote_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';

import '../../models/order_model.dart';
import '../../models/product_quantity.dart';

part 'order_bloc.freezed.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRemoteDatasource orderRemoteDatasource;
  OrderBloc(
    this.orderRemoteDatasource,
  ) : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());
      log("Start 1");

      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.toIntegerFromText * element.quantity));
      // final total = subTotal + event.tax + event.serviceCharge - event.discount;

      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);

      final userData = await AuthLocalDataSource().getAuthData();

      final dataInput = OrderModel(
        subTotal: subTotal,
        paymentAmount: event.paymentAmount,
        tax: event.tax,
        discount: event.discount,
        discountAmount: event.discountAmount,
        serviceCharge: event.serviceCharge,
        total: event.totalPriceFinal,
        paymentMethod: event.paymentMethod,
        totalItem: totalItem,
        idKasir: userData.user?.id ?? 1,
        namaKasir: userData.user?.name ?? 'Kasir A',
        transactionTime: DateTime.now().toIso8601String(),
        customerName: event.customerName,
        tableNumber: event.tableNumber,
        status: event.status,
        paymentStatus: event.paymentStatus,
        orderType: event.orderType, // Added: dine_in or takeaway
        isSync: 0,
        orderItems: event.items,
      );
      log("Start 2");

      //check state online or offline
      
      // Save to remote datasource (backend API)
      final value = await orderRemoteDatasource.saveOrder(dataInput);
      
      int id = 0;
      
      // Only save to local database if NOT web (SQLite not supported in web)
      if (!kIsWeb) {
        log("📱 Mobile: Saving to local SQLite database...");
        if (value) {
          id = await ProductLocalDatasource.instance
              .saveOrder(dataInput.copyWith(isSync: 1));
        } else {
          id = await ProductLocalDatasource.instance
              .saveOrder(dataInput.copyWith(isSync: 1));
        }
        log("✅ Saved to local database with ID: $id");
      } else {
        log("🌐 Web: Skipping local database save (SQLite not supported)");
        id = 0; // Use 0 for web since we don't have local ID
      }

      emit(_Loaded(
        dataInput,
        id,
      ));
    });
  }
}
