import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/models/response/print_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/datasources/product_local_datasource.dart';

part 'get_printer_checker_event.dart';
part 'get_printer_checker_state.dart';
part 'get_printer_checker_bloc.freezed.dart';

class GetPrinterCheckerBloc
    extends Bloc<GetPrinterCheckerEvent, GetPrinterCheckerState> {
  GetPrinterCheckerBloc() : super(_Initial()) {
    on<_Get>((event, emit) async {
      emit(_Loading());
      final result =
          await ProductLocalDatasource.instance.getPrinterByCode('checker');
      emit(_Success(result));
    });
  }
}
