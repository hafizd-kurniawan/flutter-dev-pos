import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/midtrans_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/qris_response_model.dart';
import 'package:flutter_posresto_app/data/models/response/qris_status_response_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_posresto_app/presentation/home/models/product_quantity.dart';

part 'qris_event.dart';
part 'qris_state.dart';
part 'qris_bloc.freezed.dart';

class QrisBloc extends Bloc<QrisEvent, QrisState> {
  final MidtransRemoteDatasource datasource;
  QrisBloc(
    this.datasource,
  ) : super(const _Initial()) {
    on<_GenerateQRCode>((event, emit) async {
      emit(const QrisState.loading());
      try {
        final response = await datasource.generateQRCode(
          event.orderId,
          event.grossAmount,
          event.items,
          event.customerName,
          event.tableNumber,
          event.orderType,
          event.discount,
          event.tax,
          event.serviceCharge,
          event.notes,
        );
        log("response: ${response}");
        emit(_QrisResponse(response));
      } catch (e) {
        log("Error generating QR: $e");
        emit(QrisState.error(e.toString()));
      }
    });

    on<_CheckPaymentStatus>((event, emit) async {
      log("QRIS BLOC: Checking status for Order ID: ${event.orderId}");
      try {
        final response = await datasource.checkPaymentStatus(event.orderId);
        log("QRIS BLOC: Response Status: ${response.transactionStatus}");
        
        if (response.transactionStatus == 'settlement') {
          log("QRIS BLOC: Payment Settled! Emitting Success State.");
          emit(_Success('Pembayaran Berhasil'));
        } else {
          log("QRIS BLOC: Payment not settled yet (${response.transactionStatus})");
        }
      } catch (e) {
        log("QRIS BLOC: Error checking status: $e");
      }
    });
  }
}
