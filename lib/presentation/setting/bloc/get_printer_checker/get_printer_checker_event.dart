part of 'get_printer_checker_bloc.dart';

@freezed
class GetPrinterCheckerEvent with _$GetPrinterCheckerEvent {
  const factory GetPrinterCheckerEvent.started() = _Started;
  const factory GetPrinterCheckerEvent.get() = _Get;
}
