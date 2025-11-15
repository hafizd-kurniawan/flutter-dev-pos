part of 'get_printer_checker_bloc.dart';

@freezed
class GetPrinterCheckerState with _$GetPrinterCheckerState {
  const factory GetPrinterCheckerState.initial() = _Initial;
  const factory GetPrinterCheckerState.loading() = _Loading;
  const factory GetPrinterCheckerState.success(PrintModel? printer) = _Success;
}
