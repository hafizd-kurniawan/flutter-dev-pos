part of 'get_printer_receipt_bloc.dart';

@freezed
class GetPrinterReceiptEvent with _$GetPrinterReceiptEvent {
  const factory GetPrinterReceiptEvent.started() = _Started;
  const factory GetPrinterReceiptEvent.get() = _Get;
}
