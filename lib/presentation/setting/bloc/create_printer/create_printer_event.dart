part of 'create_printer_bloc.dart';

@freezed
class CreatePrinterEvent with _$CreatePrinterEvent {
  const factory CreatePrinterEvent.started() = _Started;

  const factory CreatePrinterEvent.createPrinter(PrintModel print) =
      _CreatePrinter;
}
