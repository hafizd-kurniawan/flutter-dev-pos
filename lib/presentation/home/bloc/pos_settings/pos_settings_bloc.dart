import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_posresto_app/data/datasources/pos_settings_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/pos_settings_model.dart';

part 'pos_settings_bloc.freezed.dart';
part 'pos_settings_event.dart';
part 'pos_settings_state.dart';

class PosSettingsBloc extends Bloc<PosSettingsEvent, PosSettingsState> {
  final PosSettingsRemoteDatasource datasource;
  
  PosSettingsBloc(this.datasource) : super(const _Initial()) {
    on<_GetSettings>((event, emit) async {
      emit(const _Loading());
      
      log('🔧 Fetching POS settings from API...');
      
      final result = await datasource.getSettings();
      
      result.fold(
        (error) {
          log('❌ POS Settings fetch error: $error');
          emit(_Error(error));
        },
        (settings) {
          log('✅ POS Settings loaded:');
          log('   Discounts: ${settings.discounts.length}');
          log('   Taxes: ${settings.taxes.length}');
          log('   Services: ${settings.services.length}');
          emit(_Loaded(settings));
        },
      );
    });
  }
}
