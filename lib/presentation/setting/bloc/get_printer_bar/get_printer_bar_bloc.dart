
import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/print_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_printer_bar_event.dart';
part 'get_printer_bar_state.dart';
part 'get_printer_bar_bloc.freezed.dart';

class GetPrinterBarBloc extends Bloc<GetPrinterBarEvent, GetPrinterBarState> {
  GetPrinterBarBloc() : super(_Initial()) {
    on<_Get>((event, emit) async {
      emit(_Loading());
      final result =
          await ProductLocalDatasource.instance.getPrinterByCode('bar');
      emit(_Success(result));
    });
  }
}
