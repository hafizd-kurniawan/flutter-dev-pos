import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_position_table_event.dart';
part 'change_position_table_state.dart';
part 'change_position_table_bloc.freezed.dart';

class ChangePositionTableBloc
    extends Bloc<ChangePositionTableEvent, ChangePositionTableState> {
  ChangePositionTableBloc() : super(_Initial()) {
    on<_ChangePositionTable>((event, emit) async {
      emit(_Loading());
      await ProductLocalDatasource.instance
          .changePositionTable(event.tableId, event.position);
      emit(_Success('Generate Success'));
    });
  }
}
