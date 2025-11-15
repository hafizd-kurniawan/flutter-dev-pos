part of 'get_printer_bar_bloc.dart';

@freezed
class GetPrinterBarState with _$GetPrinterBarState {
  const factory GetPrinterBarState.initial() = _Initial;
  const factory GetPrinterBarState.loading() = _Loading;
  const factory GetPrinterBarState.success(PrintModel? printer) = _Success;
}
