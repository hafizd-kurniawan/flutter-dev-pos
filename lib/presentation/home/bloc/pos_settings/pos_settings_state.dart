part of 'pos_settings_bloc.dart';

@freezed
class PosSettingsState with _$PosSettingsState {
  const factory PosSettingsState.initial() = _Initial;
  const factory PosSettingsState.loading() = _Loading;
  const factory PosSettingsState.loaded(PosSettingsModel settings) = _Loaded;
  const factory PosSettingsState.error(String message) = _Error;
}
