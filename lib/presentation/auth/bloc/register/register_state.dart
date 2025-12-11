part of 'register_bloc.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final AuthResponseModel authResponseModel;
  RegisterSuccess(this.authResponseModel);
}

class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}
