part of 'get_table_bloc.dart';

@freezed
class GetTableState with _$GetTableState {
  const factory GetTableState.initial() = _Initial;
  const factory GetTableState.loading() = _Loading;
  const factory GetTableState.success(List<TableModel> tables) = _Success;
  const factory GetTableState.categoriesLoaded(List<TableCategoryModel> categories) = _CategoriesLoaded;
  const factory GetTableState.error(String message) = _Error;
}
