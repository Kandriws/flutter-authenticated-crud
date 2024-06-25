import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier,
    LoginFormStateProvider>((ref) {
  final loginUserCallback = ref.watch(authProvider.notifier).login;

  return LoginFormNotifier(loginUserCallback: loginUserCallback);
});

class LoginFormStateProvider {
  final bool isPosting;
  final bool isFormPosted;
  final bool isFormValid;
  final Email email;
  final Password password;

  LoginFormStateProvider({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isFormValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  LoginFormStateProvider copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isFormValid,
    Email? email,
    Password? password,
  }) {
    return LoginFormStateProvider(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isFormValid: isFormValid ?? this.isFormValid,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() {
    return 'LoginFormStateProvider{isPosting: $isPosting, isFormPosted: $isFormPosted, isFormValid: $isFormValid, email: $email, password: $password}';
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormStateProvider> {
  final Function(String, String) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback,
  }) : super(LoginFormStateProvider());

  onEmailChange(String value) {
    final emailChanged = Email.dirty(value);
    state = state.copyWith(
      email: emailChanged,
      isFormValid: Formz.validate([emailChanged, state.password]),
    );
  }

  onPasswordChange(String value) {
    final passwordChanged = Password.dirty(value);
    state = state.copyWith(
      password: passwordChanged,
      isFormValid: Formz.validate([state.email, passwordChanged]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isFormValid) return;

    state = state.copyWith(isPosting: true);
    await loginUserCallback(state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final emailChanged = Email.dirty(state.email.value);
    final passwordChanged = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: emailChanged,
      password: passwordChanged,
      isFormValid: Formz.validate([emailChanged, passwordChanged]),
    );
  }
}
