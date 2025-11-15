import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_storage_helper.dart';

import '../../../../data/models/response/product_response_model.dart';

part 'local_product_bloc.freezed.dart';
part 'local_product_event.dart';
part 'local_product_state.dart';

class LocalProductBloc extends Bloc<LocalProductEvent, LocalProductState> {
  final ProductLocalDatasource productLocalDatasource;
  LocalProductBloc(
    this.productLocalDatasource,
  ) : super(const _Initial()) {
    on<_GetLocalProduct>((event, emit) async {
      emit(const _Loading());
      
      List<Product> result = [];
      
      if (kIsWeb) {
        // Web: Load from SharedPreferences
        result = await ProductStorageHelper.getProducts();
        log("Loaded ${result.length} products from SharedPreferences (web)");
      } else {
        // Mobile/Desktop: Load from SQLite
        result = await productLocalDatasource.getProducts();
        log("Loaded ${result.length} products from SQLite (mobile)");
      }
      
      emit(_Loaded(result));
    });
  }
}
