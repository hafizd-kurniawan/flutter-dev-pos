// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

class TableModel {
  int? id;
  final String tableName;
  final String startTime;
  final String status;
  final int orderId;
  final int paymentAmount;
  final Offset position;

  TableModel({
    this.id,
    required this.tableName,
    required this.startTime,
    required this.status,
    required this.orderId,
    required this.paymentAmount,
    required this.position,
  });

  @override

  // from map
  factory TableModel.fromMap(Map<String, dynamic> map) {
    return TableModel(
      id: map['id'],
      tableName: map['table_name'],
      startTime: map['start_time'],
      status: map['status'],
      orderId: map['order_id'],
      paymentAmount: map['payment_amount'],
      position: Offset(map['x_position'], map['y_position']),
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      'table_name': tableName,
      'status': status,
      'start_time': startTime,
      'order_id': orderId,
      'payment_amount': paymentAmount,
      'x_position': position.dx,
      'y_position': position.dy,
    };
  }

  @override
  bool operator ==(covariant TableModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.tableName == tableName &&
        other.startTime == startTime &&
        other.status == status &&
        other.orderId == orderId &&
        other.paymentAmount == paymentAmount &&
        other.position == position;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tableName.hashCode ^
        startTime.hashCode ^
        status.hashCode ^
        orderId.hashCode ^
        paymentAmount.hashCode ^
        position.hashCode;
  }
}
