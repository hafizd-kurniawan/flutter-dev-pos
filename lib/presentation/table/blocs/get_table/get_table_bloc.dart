import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/table_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/table_model.dart';
import 'package:flutter_posresto_app/data/models/response/table_category_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_table_event.dart';
part 'get_table_state.dart';
part 'get_table_bloc.freezed.dart';

class GetTableBloc extends Bloc<GetTableEvent, GetTableState> {
  final TableRemoteDatasource _datasource;
  List<TableModel> _allTables = [];
  List<TableCategoryModel> _categories = [];

  GetTableBloc(this._datasource) : super(const _Initial()) {
    on<_GetTables>(_onGetTables);
    on<_GetAvailableTables>(_onGetAvailableTables);
    on<_GetCategories>(_onGetCategories);
    on<_FilterByCategory>(_onFilterByCategory);
    on<_FilterByStatus>(_onFilterByStatus);
    on<_UpdateTableStatus>(_onUpdateTableStatus);
  }

  Future<void> _onGetTables(
    _GetTables event,
    Emitter<GetTableState> emit,
  ) async {
    // Only show loading on initial load
    if (_allTables.isEmpty) {
      emit(const _Loading());
    }
    
    final result = await _datasource.getTables();
    
    result.fold(
      (error) => emit(_Error(error)),
      (tables) {
        _allTables = tables;
        emit(_Success(List.from(tables)));
      },
    );
  }

  Future<void> _onGetAvailableTables(
    _GetAvailableTables event,
    Emitter<GetTableState> emit,
  ) async {
    emit(const _Loading());
    
    final result = await _datasource.getAvailableTables();
    
    result.fold(
      (error) => emit(_Error(error)),
      (tables) {
        _allTables = tables;
        emit(_Success(tables));
      },
    );
  }

  Future<void> _onGetCategories(
    _GetCategories event,
    Emitter<GetTableState> emit,
  ) async {
    final result = await _datasource.getCategories();
    
    result.fold(
      (error) => emit(_Error(error)),
      (categories) {
        _categories = categories;
        emit(_CategoriesLoaded(categories));
      },
    );
  }

  Future<void> _onFilterByCategory(
    _FilterByCategory event,
    Emitter<GetTableState> emit,
  ) async {
    if (event.categoryId == null) {
      // Show all tables
      emit(_Success(_allTables));
    } else {
      emit(const _Loading());
      
      final result = await _datasource.getTablesByCategory(event.categoryId!);
      
      result.fold(
        (error) => emit(_Error(error)),
        (tables) => emit(_Success(tables)),
      );
    }
  }

  Future<void> _onFilterByStatus(
    _FilterByStatus event,
    Emitter<GetTableState> emit,
  ) async {
    if (event.statuses.isEmpty || event.statuses.contains('all')) {
      emit(_Success(_allTables));
    } else {
      final filtered = _allTables
          .where((table) => event.statuses.contains(table.status))
          .toList();
      emit(_Success(filtered));
    }
  }

  Future<void> _onUpdateTableStatus(
    _UpdateTableStatus event,
    Emitter<GetTableState> emit,
  ) async {
    // Don't emit loading to prevent flicker
    final currentState = state;
    
    final result = await _datasource.updateStatus(
      tableId: event.tableId,
      status: event.status,
      customerName: event.customerName,
      customerPhone: event.customerPhone,
      partySize: event.partySize,
    );

    result.fold(
      (error) => emit(_Error(error)),
      (updatedTable) {
        // Silent update - update table in the list without loading state
        final index = _allTables.indexWhere((t) => t.id == updatedTable.id);
        if (index != -1) {
          _allTables[index] = updatedTable;
        }
        
        // Emit new list directly (no loading state)
        emit(_Success(List.from(_allTables)));
      },
    );
  }
}
