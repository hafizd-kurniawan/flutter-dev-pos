import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_table_event.dart';
part 'create_table_state.dart';
part 'create_table_bloc.freezed.dart';

class CreateTableBloc extends Bloc<CreateTableEvent, CreateTableState> {
  CreateTableBloc() : super(_Initial()) {
    on<_CreateTable>((event, emit) async {
      emit(_Loading());
      await ProductLocalDatasource.instance
          .createTableManagement(event.tableName, event.position);
      emit(_Success('Create Table Success'));
    });
  }
}
