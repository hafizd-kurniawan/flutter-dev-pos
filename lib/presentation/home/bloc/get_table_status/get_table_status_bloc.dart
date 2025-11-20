import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_table_status_event.dart';
part 'get_table_status_state.dart';
part 'get_table_status_bloc.freezed.dart';

class GetTableStatusBloc
    extends Bloc<GetTableStatusEvent, GetTableStatusState> {
  GetTableStatusBloc() : super(_Initial()) {
    on<_GetTablesStatus>((event, emit) async {
      emit(_Loading());
      
      // Skip SQLite for web platform
      if (kIsWeb) {
        // For web, return empty list (table status not supported on web)
        emit(const _Success([]));
        return;
      }
      
      // For mobile, get from SQLite
      final tables =
          await ProductLocalDatasource.instance.getTableByStatus(event.status);
      emit(_Success(tables));
    });
  }
}
