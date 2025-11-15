part of 'pos_settings_bloc.dart';

@freezed
class PosSettingsEvent with _$PosSettingsEvent {
  const factory PosSettingsEvent.started() = _Started;
  const factory PosSettingsEvent.getSettings() = _GetSettings;
}
