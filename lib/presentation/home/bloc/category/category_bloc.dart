import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_posresto_app/data/datasources/category_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/category_response_model.dart';

part 'category_bloc.freezed.dart';
part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRemoteDatasource categoryRemoteDatasource;
  
  CategoryBloc(this.categoryRemoteDatasource) : super(const _Initial()) {
    on<_GetCategories>((event, emit) async {
      emit(const _Loading());
      
      log('🔄 Fetching categories from API...');
      
      final result = await categoryRemoteDatasource.getCategories();
      
      result.fold(
        (error) {
          log('❌ Category fetch error: $error');
          emit(_Error(error));
        },
        (categoryResponse) {
          log('✅ Categories loaded: ${categoryResponse.data.length} categories');
          emit(_Loaded(categoryResponse.data));
        },
      );
    });
  }
}
