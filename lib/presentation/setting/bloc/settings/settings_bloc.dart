    import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_posresto_app/data/datasources/settings_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/settings_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/settings_response_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';
part 'settings_bloc.freezed.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRemoteDatasource remoteDatasource;
  final SettingsLocalDatasource localDatasource;

  SettingsBloc(this.remoteDatasource, this.localDatasource)
      : super(const _Initial()) {
    on<_FetchSettings>((event, emit) async {
      emit(const _Loading());
      final result = await remoteDatasource.getSettings();
      result.fold(
        (l) {
          print('❌ Error Fetching Settings: $l'); // DEBUG LOG
          emit(_Error(l));
        },
        (r) async {
          print('✅ Settings Fetched Successfully. Saving to local...'); // DEBUG LOG
          // Flatten settings for easier local storage
          final flattenedSettings = <String, String>{};
          r.data.settings.forEach((key, item) {
            flattenedSettings[key] = item.value;
            print('   - $key: ${item.value}'); // DEBUG LOG
          });
          
          await localDatasource.saveSettings(flattenedSettings);
          emit(_Loaded(r));
        },
      );
    });
  }
}
