import 'package:formz/formz.dart';

// Define input validation errors
enum TitleError { empty, length }

// Extend FormzInput and provide the input type and error type.
class Title extends FormzInput<String, TitleError> {
  // Call super.pure to represent an unmodified form input.
  const Title.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Title.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == TitleError.empty) return 'El campo es requerido';
    if (displayError == TitleError.length) {
      return 'El campo debe tener al menos 3 caracteres';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  TitleError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return TitleError.empty;
    if (value.length < 3) return TitleError.length;

    return null;
  }
}
