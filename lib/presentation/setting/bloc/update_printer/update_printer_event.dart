part of 'update_printer_bloc.dart';

@freezed
class UpdatePrinterEvent with _$UpdatePrinterEvent {
  const factory UpdatePrinterEvent.started() = _Started;
  const factory UpdatePrinterEvent.updatePrinter(PrintModel print) =
      _UpdatePrinter;
}
