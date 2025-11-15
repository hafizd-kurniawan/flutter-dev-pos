import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/print_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_printer_event.dart';
part 'update_printer_state.dart';
part 'update_printer_bloc.freezed.dart';

class UpdatePrinterBloc extends Bloc<UpdatePrinterEvent, UpdatePrinterState> {
  UpdatePrinterBloc() : super(_Initial()) {
    on<_UpdatePrinter>((event, emit) async {
      emit(_Loading());
      await ProductLocalDatasource.instance.updatePrinter(
        event.print,
        event.print.id!,
      );
      emit(_Success('Update Table Success'));
    });
  }
}
