part of 'update_table_bloc.dart';

@freezed
class UpdateTableEvent with _$UpdateTableEvent {
  const factory UpdateTableEvent.started() = _Started;
  const factory UpdateTableEvent.updateTable(TableModel table) = _UpdateTable;
}
