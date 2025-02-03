import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/resources/shared_event.dart';
import '../../../../../core/util/ethiopian_phone_validator.dart';
import '../../../../../injection_container.dart';
import '../../../domain/usecases/forgot_password.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<SharedEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(const ResetPasswordState()) {
    on<ContactEvent>((event, emit) {
      emit(state.copyWith(email: event.emailOrPhone));
    });
    on<ResetEmail>((event, emit) {
      emit(ResetToInitial());
    });
    on<PasswordEvent>(_passwordEvent);
    on<SubmitResetCode>(_submitResetCode);
    // on<SubmitNewPassword>(_submitNewPassword);
  }
  // void _submitNewPassword(
  //     SubmitNewPassword event, Emitter<ResetPasswordState> emit) async {
  //   emit(state.copyWith(isResetLoading: true));
  //   try {
  //     sl<AuthRepository>()
  //         .resetPassword(event.newPassword!, event.passwordConfirm!);
  //     emit(state.copyWith(
  //       isResetLoading: false,
  //       isResetSuccess: true,
  //       resetFailure: "",
  //     ));
  //   } catch (e) {
  //     emit(state.copyWith(
  //         isResetLoading: false,
  //         isResetSuccess: false,
  //         resetFailure: e.toString()));
  //   }
  // }

  Future<void> _submitResetCode(
      SubmitResetCode event, Emitter<ResetPasswordState> emit) async {
    emit(state.copyWith(isResetLoading: true));

    try {
      await sl<ForgotPasswordUsecase>().call(
          params: ForgotPasswordParams(
              email: event.email,
              phoneNumber:
                  EthiopianPhoneValidator.normalize(event.phoneNumber)));

      // sl<AuthRepository>().forgotPassword(event.email!);
      emit(state.copyWith(
          isResetSuccess: true, isResetLoading: false, resetFailure: ''));
    } catch (e) {
      emit(state.copyWith(
          isResetLoading: false,
          isResetSuccess: false,
          resetFailure: e.toString()));
    }
  }

  void _passwordEvent(PasswordEvent event, Emitter<ResetPasswordState> emit) {
    emit(
      state.copyWith(password: event.password, repassword: event.repassword),
    );
  }
}
