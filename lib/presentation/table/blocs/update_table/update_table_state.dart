part of 'update_table_bloc.dart';

@freezed
class UpdateTableState with _$UpdateTableState {
  const factory UpdateTableState.initial() = _Initial;
  const factory UpdateTableState.loading() = _Loading;
  const factory UpdateTableState.success(String message) = _Success;
}
