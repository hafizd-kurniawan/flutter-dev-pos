part of 'get_printer_kitchen_bloc.dart';

@freezed
class GetPrinterKitchenState with _$GetPrinterKitchenState {
  const factory GetPrinterKitchenState.initial() = _Initial;
  const factory GetPrinterKitchenState.loading() = _Loading;
  const factory GetPrinterKitchenState.success(PrintModel? printer) = _Success;
}
