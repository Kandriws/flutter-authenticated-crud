import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/shared.dart';

final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>(
  (ref) => RegisterFormNotifier(),
);

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isFormValid;
  final Fullname fullname;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isFormValid = false,
    this.fullname = const Fullname.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isFormValid,
    Fullname? fullname,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
  }) {
    return RegisterFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isFormValid: isFormValid ?? this.isFormValid,
      fullname: fullname ?? this.fullname,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }

  @override
  String toString() {
    return 'RegisterFormState{isPosting: $isPosting, isFormPosted: $isFormPosted, isFormValid: $isFormValid, email: $email, password: $password, confirmPassword: $confirmPassword}';
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  onFullnameChange(String value) {
    final fullnameChanged = Fullname.dirty(value);
    state = state.copyWith(
      fullname: fullnameChanged,
      isFormValid: Formz.validate([
        fullnameChanged,
        state.email,
        state.password,
        state.confirmPassword,
      ]),
    );
  }

  onEmailChange(String value) {
    final emailChanged = Email.dirty(value);
    state = state.copyWith(
      email: emailChanged,
      isFormValid: Formz.validate([
        state.fullname,
        emailChanged,
        state.password,
        state.confirmPassword,
      ]),
    );
  }

  onPasswordChange(String value) {
    final passwordChanged = Password.dirty(value);
    state = state.copyWith(
      password: passwordChanged,
      isFormValid: Formz.validate([
        state.fullname,
        state.email,
        passwordChanged,
        state.confirmPassword,
      ]),
    );
  }

  onConfirmPasswordChange(String value) {
    final confirmPasswordChanged = ConfirmPassword.dirty(
      password: state.password.value,
      value: value,
    );
    state = state.copyWith(
      confirmPassword: confirmPasswordChanged,
      isFormValid: Formz.validate([
        state.fullname,
        state.email,
        state.password,
        confirmPasswordChanged,
      ]),
    );
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isFormValid) return;
    state = state.copyWith(isPosting: true);
  }

  _touchEveryField() {
    final fullnameChanged = Fullname.dirty(state.fullname.value);
    final emailChanged = Email.dirty(state.email.value);
    final passwordChanged = Password.dirty(state.password.value);
    final confirmPasswordChanged = ConfirmPassword.dirty(
      password: state.password.value,
      value: state.confirmPassword.value,
    );

    state = state.copyWith(
      isFormPosted: true,
      fullname: fullnameChanged,
      email: emailChanged,
      password: passwordChanged,
      confirmPassword: confirmPasswordChanged,
      isFormValid: Formz.validate([
        fullnameChanged,
        emailChanged,
        passwordChanged,
        confirmPasswordChanged,
      ]),
    );
  }
}
