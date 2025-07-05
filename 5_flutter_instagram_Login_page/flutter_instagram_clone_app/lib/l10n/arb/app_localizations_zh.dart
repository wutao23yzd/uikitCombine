// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get counterAppBarTitle => '计数器';

  @override
  String get emailText => '邮箱';

  @override
  String get passwordText => '密码';

  @override
  String get login => '登录';

  @override
  String get forgotText => '忘记密码';

  @override
  String signInWithText(Object provider) {
    return '使用$provider登录';
  }

  @override
  String get noAccountText => '还没有账号？';

  @override
  String get signUpText => '注册';
}
