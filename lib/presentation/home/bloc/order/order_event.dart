part of 'order_bloc.dart';

@freezed
class OrderEvent with _$OrderEvent {
  const factory OrderEvent.started() = _Started;
  const factory OrderEvent.order(
    List<ProductQuantity> items,
    int discount,
    int discountAmount,
    int tax,
    int serviceCharge,
    int paymentAmount,
    String customerName,
    int tableNumber,
    String status,
    String paymentStatus,
    String paymentMethod,
    int totalPriceFinal,
    String orderType, // Added: 'dine_in' or 'takeaway'
    int taxPercentage, // NEW
    int serviceChargePercentage, // NEW
    String note, // NEW
  ) = _Order;

  const factory OrderEvent.paymentSuccess(
    List<ProductQuantity> items,
    int discount,
    int discountAmount,
    int tax,
    int serviceCharge,
    int paymentAmount,
    String customerName,
    int tableNumber,
    String status,
    String paymentStatus,
    String paymentMethod,
    int totalPriceFinal,
    String orderType,
    int taxPercentage,
    int serviceChargePercentage,
    String note, // NEW
  ) = _PaymentSuccess;
}
