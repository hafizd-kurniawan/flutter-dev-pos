part of 'get_printer_bar_bloc.dart';

@freezed
class GetPrinterBarEvent with _$GetPrinterBarEvent {
  const factory GetPrinterBarEvent.started() = _Started;
  const factory GetPrinterBarEvent.get() = _Get;
}
