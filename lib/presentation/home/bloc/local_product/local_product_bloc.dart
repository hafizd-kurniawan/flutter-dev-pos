import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_posresto_app/data/datasources/product_remote_datasource.dart';

import '../../../../data/models/response/product_response_model.dart';

part 'local_product_bloc.freezed.dart';
part 'local_product_event.dart';
part 'local_product_state.dart';

class LocalProductBloc extends Bloc<LocalProductEvent, LocalProductState> {
  final ProductRemoteDatasource productRemoteDatasource;
  LocalProductBloc(
    this.productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_GetLocalProduct>((event, emit) async {
      emit(const _Loading());
      
      final result = await productRemoteDatasource.getProducts();
      
      result.fold(
        (error) {
          log("❌ Failed to fetch products from API: $error");
          emit(const _Loaded([])); // Or emit error state if available, but keeping signature safe
        },
        (data) {
          log("✅ Loaded ${data.data?.length ?? 0} products from API");
          emit(_Loaded(data.data ?? []));
        },
      );
    });
  }
}
