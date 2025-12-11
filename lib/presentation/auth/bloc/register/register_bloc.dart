import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_posresto_app/data/models/response/auth_response_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRemoteDatasource authRemoteDatasource;

  RegisterBloc(this.authRemoteDatasource) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      final result = await authRemoteDatasource.register(
        event.businessName,
        event.email,
        event.phone,
        event.address,
        event.password,
      );
      result.fold(
        (l) => emit(RegisterFailure(l)),
        (r) => emit(RegisterSuccess(r)),
      );
    });
  }
}
