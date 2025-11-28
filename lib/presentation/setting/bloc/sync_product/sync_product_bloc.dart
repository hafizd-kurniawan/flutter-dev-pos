import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_posresto_app/data/datasources/product_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/product_response_model.dart';

import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';

part 'sync_product_bloc.freezed.dart';
part 'sync_product_event.dart';
part 'sync_product_state.dart';

class SyncProductBloc extends Bloc<SyncProductEvent, SyncProductState> {
  final ProductRemoteDatasource productRemoteDatasource;
  SyncProductBloc(
    this.productRemoteDatasource,
  ) : super(const _Initial()) {
    on<_SyncProduct>((event, emit) async {
      emit(const _Loading());
      final result = await productRemoteDatasource.getProducts();
      await result.fold(
        (l) async => emit(_Error(l)),
        (r) async {
          try {
            await ProductLocalDatasource.instance.deleteAllProducts();
            await ProductLocalDatasource.instance.insertProducts(
              r.data ?? [],
            );
            emit(_Loaded(r));
          } catch (e) {
            emit(_Error(e.toString()));
          }
        },
      );
    });
  }
}
