part of 'create_printer_bloc.dart';

@freezed
class CreatePrinterState with _$CreatePrinterState {
  const factory CreatePrinterState.initial() = _Initial;
  const factory CreatePrinterState.loading() = _Loading;
  const factory CreatePrinterState.success(String message) = _Success;
}
