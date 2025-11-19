part of 'get_table_bloc.dart';

@freezed
class GetTableEvent with _$GetTableEvent {
  const factory GetTableEvent.started() = _Started;
  const factory GetTableEvent.getTables() = _GetTables;
  const factory GetTableEvent.getAvailableTables() = _GetAvailableTables;
  const factory GetTableEvent.getCategories() = _GetCategories;
  const factory GetTableEvent.filterByCategory(int? categoryId) = _FilterByCategory;
  const factory GetTableEvent.filterByStatus(Set<String> statuses) = _FilterByStatus;
  const factory GetTableEvent.updateTableStatus({
    required int tableId,
    required String status,
    String? customerName,
    String? customerPhone,
    int? partySize,
  }) = _UpdateTableStatus;
}
