part of 'change_position_table_bloc.dart';

@freezed
class ChangePositionTableEvent with _$ChangePositionTableEvent {
  const factory ChangePositionTableEvent.started() = _Started;
  const factory ChangePositionTableEvent.changePositionTable({
    required int tableId,
    required Offset position,
  }) = _ChangePositionTable;
}
