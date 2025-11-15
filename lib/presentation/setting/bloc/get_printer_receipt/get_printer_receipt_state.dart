part of 'get_printer_receipt_bloc.dart';

@freezed
class GetPrinterReceiptState with _$GetPrinterReceiptState {
  const factory GetPrinterReceiptState.initial() = _Initial;
  const factory GetPrinterReceiptState.loading() = _Loading;
  const factory GetPrinterReceiptState.success(PrintModel? printer) = _Success;
}
