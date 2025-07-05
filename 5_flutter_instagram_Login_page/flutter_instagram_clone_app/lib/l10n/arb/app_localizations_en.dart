// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get counterAppBarTitle => 'Counter';

  @override
  String get emailText => 'Email';

  @override
  String get passwordText => 'Password';

  @override
  String get login => 'Login';

  @override
  String get forgotText => 'Forgot password';

  @override
  String signInWithText(Object provider) {
    return 'Sign in with $provider';
  }

  @override
  String get noAccountText => 'Do not have an account?';

  @override
  String get signUpText => 'Sign up';
}
