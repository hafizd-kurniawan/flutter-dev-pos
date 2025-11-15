part of 'create_table_bloc.dart';

@freezed
class CreateTableState with _$CreateTableState {
  const factory CreateTableState.initial() = _Initial;
  // loading
  const factory CreateTableState.loading() = _Loading;
  // success
  const factory CreateTableState.success(String message) = _Success;
}
