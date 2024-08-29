import 'package:formz/formz.dart';

// Define input validation errors
enum SlugError { empty, length, format }

// Extend FormzInput and provide the input type and error type.
class Slug extends FormzInput<String, SlugError> {
  static final RegExp slugRegExp = RegExp(r'^[a-z0-9-_]+$');

  // Call super.pure to represent an unmodified form input.
  const Slug.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const Slug.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == SlugError.empty) return 'El campo es requerido';
    if (displayError == SlugError.length) {
      return 'El campo debe tener al menos 3 caracteres';
    }
    if (displayError == SlugError.format) {
      return 'El campo solo puede contener letras minúsculas, números y guiones';
    }

    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  SlugError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return SlugError.empty;
    if (value.length < 3) return SlugError.length;
    if (!slugRegExp.hasMatch(value)) return SlugError.format;
    return null;
  }
}
