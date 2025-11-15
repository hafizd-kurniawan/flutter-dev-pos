import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_table_event.dart';
part 'update_table_state.dart';
part 'update_table_bloc.freezed.dart';

class UpdateTableBloc extends Bloc<UpdateTableEvent, UpdateTableState> {
  UpdateTableBloc() : super(_Initial()) {
    on<_UpdateTable>((event, emit) async {
      emit(_Loading());
      await ProductLocalDatasource.instance.updateTable(
        event.table,
      );
      emit(_Success('Update Table Success'));
    });
  }
}
