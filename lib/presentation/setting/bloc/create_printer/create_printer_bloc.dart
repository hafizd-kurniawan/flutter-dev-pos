import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/print_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_printer_event.dart';
part 'create_printer_state.dart';
part 'create_printer_bloc.freezed.dart';

class CreatePrinterBloc extends Bloc<CreatePrinterEvent, CreatePrinterState> {
  CreatePrinterBloc() : super(_Initial()) {
    on<_CreatePrinter>((event, emit) async {
      emit(const _Loading());
      try {
        await ProductLocalDatasource.instance.createPrinter(
          event.print,
        );
        emit(const _Success('Create Printer Success'));
      } catch (e) {
        emit(_Error(e.toString()));
      }
    });
  }
}
