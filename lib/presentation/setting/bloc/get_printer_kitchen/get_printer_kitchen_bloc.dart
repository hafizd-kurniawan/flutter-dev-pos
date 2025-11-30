import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/print_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_printer_kitchen_event.dart';
part 'get_printer_kitchen_state.dart';
part 'get_printer_kitchen_bloc.freezed.dart';

class GetPrinterKitchenBloc
    extends Bloc<GetPrinterKitchenEvent, GetPrinterKitchenState> {
  GetPrinterKitchenBloc() : super(_Initial()) {
    on<_Get>((event, emit) async {
      emit(_Loading());
      try {
        final result =
            await ProductLocalDatasource.instance.getPrinterByCode('kitchen');
        emit(_Success(result));
      } catch (e) {
        emit(const _Success(null));
      }
    });
  }
}
