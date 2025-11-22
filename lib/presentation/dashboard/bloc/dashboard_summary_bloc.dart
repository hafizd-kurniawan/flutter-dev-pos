import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/dashboard_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/dashboard_summary_model.dart';

part 'dashboard_summary_event.dart';
part 'dashboard_summary_state.dart';

class DashboardSummaryBloc extends Bloc<DashboardSummaryEvent, DashboardSummaryState> {
  final DashboardRemoteDatasource datasource;

  DashboardSummaryBloc(this.datasource) : super(DashboardSummaryInitial()) {
    on<DashboardSummaryGetSummary>((event, emit) async {
      emit(DashboardSummaryLoading());
      
      final result = await datasource.getTodaySummary();
      
      result.fold(
        (error) => emit(DashboardSummaryError(error)),
        (response) => emit(DashboardSummarySuccess(response.data)),
      );
    });
    
    on<DashboardSummaryRefresh>((event, emit) async {
      final currentState = state;
      
      final result = await datasource.getTodaySummary();
      
      result.fold(
        (error) {
          if (currentState is DashboardSummarySuccess) {
            emit(currentState);
          } else {
            emit(DashboardSummaryError(error));
          }
        },
        (response) => emit(DashboardSummarySuccess(response.data)),
      );
    });
  }
}
