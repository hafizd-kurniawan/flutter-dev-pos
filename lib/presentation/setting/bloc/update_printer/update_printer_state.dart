part of 'update_printer_bloc.dart';

@freezed
class UpdatePrinterState with _$UpdatePrinterState {
  const factory UpdatePrinterState.initial() = _Initial;
  const factory UpdatePrinterState.loading() = _Loading;
  const factory UpdatePrinterState.success(String message) = _Success;
}
