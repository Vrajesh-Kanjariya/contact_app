import 'package:contact_app/constant/app_string.dart';

class CommonValidation {
  static String? emailValidate(String email) {
    if (email.isEmpty) {
      return AppString.emailEmpty;
    }
    if (!RegExp(AppString.emailRegex).hasMatch(email)) {
      return AppString.validateEmail;
    }
    return null;
  }

  static String? passwordValidate(String password) {
    if (password.isEmpty) {
      return AppString.passwordEmpty;
    }
    if (!RegExp(AppString.passwordRegex).hasMatch(password)) {
      return AppString.validatePassword;
    }
    return null;
  }

  static String? firstNameValidation(String name) {
    if (name.isEmpty) {
      return AppString.firstNameEmpty;
    }
    if (!RegExp(AppString.nameRegex).hasMatch(name)) {
      return AppString.characterOnly;
    }
    return null;
  }

  static String? lastNameValidation(String name) {
    if (name.isEmpty) {
      return AppString.lastNameEmpty;
    }
    if (!RegExp(AppString.nameRegex).hasMatch(name)) {
      return AppString.characterOnly;
    }
    return null;
  }

  static String? contactValidation(String contact) {
    if (contact.isEmpty) {
      return AppString.contactEmpty;
    }
    if (!RegExp(AppString.contactRegex).hasMatch(contact)) {
      return AppString.numberOnly;
    }
    return null;
  }

  static String? addressValidation(String address) {
    if (address.isEmpty) {
      return AppString.addressEmpty;
    }
    return null;
  }
}
