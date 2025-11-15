part of 'create_table_bloc.dart';

@freezed
class CreateTableEvent with _$CreateTableEvent {
  const factory CreateTableEvent.started() = _Started;
  const factory CreateTableEvent.createTable(
      String tableName, Offset position) = _CreateTable;
}
