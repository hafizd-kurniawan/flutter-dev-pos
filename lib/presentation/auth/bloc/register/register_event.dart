part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String businessName;
  final String email;
  final String phone;
  final String address;
  final String password;

  RegisterSubmitted({
    required this.businessName,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
  });
}
