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
        );
        log("response: ${response}");
        emit(_QrisResponse(response));
      } catch (e) {
        log("Error generating QR: $e");
        // emit error state if possible, or just log for now
      }
    });

    on<_CheckPaymentStatus>((event, emit) async {
      // emit(const QrisState.loading());
      final response = await datasource.checkPaymentStatus(event.orderId);
      log(" OrderID: ${event.orderId} | response: ${response}");
      // Future.delayed(const Duration(seconds: 5));
      // emit(QrisState.statusCheck(response));
      if (response.transactionStatus == 'settlement') {
        emit(_Success('Pembayaran Berhasil'));
      }
    });
  }
}
