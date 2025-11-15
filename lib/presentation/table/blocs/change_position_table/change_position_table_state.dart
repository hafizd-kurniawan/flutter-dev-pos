part of 'change_position_table_bloc.dart';

@freezed
class ChangePositionTableState with _$ChangePositionTableState {
  const factory ChangePositionTableState.initial() = _Initial;

  const factory ChangePositionTableState.loading() = _Loading;

  const factory ChangePositionTableState.success(String message) = _Success;
}
