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
      log("📝 OrderBloc Received Note: '${event.note}'"); // NEW: Debug log

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
        taxPercentage: event.taxPercentage, // NEW
        serviceChargePercentage: event.serviceChargePercentage, // NEW
        note: event.note, // NEW
        isSync: 0,
        orderItems: event.items,
      );
      log("Start 2");

      // check state online or offline
      
      // Save to remote datasource (backend API)
      final value = await orderRemoteDatasource.saveOrder(dataInput);
      
      int id = 0;
      
      // ONLINE ONLY: Skip local DB saving
      log("🌐 Online Only Mode: Skipping local database save");
      id = 0; 

      emit(_Loaded(
        dataInput,
        id,
      ));
    });

    on<_PaymentSuccess>((event, emit) async {
      emit(const _Loading());
      
      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.toIntegerFromText * element.quantity));

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
        orderType: event.orderType,
        taxPercentage: event.taxPercentage,
        serviceChargePercentage: event.serviceChargePercentage,
        note: event.note, // NEW
        isSync: 1, // Already synced (created on backend)
        orderItems: event.items,
      );

      int id = 0;
      
      // ONLINE ONLY: Skip local DB saving
      log("🌐 Online Only Mode: Skipping local database save (Payment Success)");
      id = 0;

      emit(_Loaded(
        dataInput,
        id,
      ));
    });
  }
}
