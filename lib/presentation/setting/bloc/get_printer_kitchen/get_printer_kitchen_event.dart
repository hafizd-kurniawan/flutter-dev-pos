part of 'get_printer_kitchen_bloc.dart';

@freezed
class GetPrinterKitchenEvent with _$GetPrinterKitchenEvent {
  const factory GetPrinterKitchenEvent.started() = _Started;
  const factory GetPrinterKitchenEvent.get() = _Get;
}
