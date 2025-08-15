import 'package:flutter/widgets.dart';
import 'package:reel_views/l10n/gen/app_localizations.dart';

export 'package:reel_views/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
