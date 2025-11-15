import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generate_table_event.dart';
part 'generate_table_state.dart';
part 'generate_table_bloc.freezed.dart';

class GenerateTableBloc extends Bloc<GenerateTableEvent, GenerateTableState> {
  GenerateTableBloc() : super(_Initial()) {
    on<_Generate>((event, emit) async {
      emit(_Loading());
      // await ProductLocalDatasource.instance
      //     .createTableManagement(event.count);
      emit(_Success('Generate Success'));
    });
  }
}
