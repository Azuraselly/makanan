import 'package:resep/l10n/app_localizations.dart';

extension AppLocalizationsExtension on AppLocalizations {
  String getMenuTitle(String value) {
    switch (value) {
      case 'profile':
        return menuProfile;
      case 'bookmark':
        return menuBookmark;
      case 'exit':
        return menuExit;
      default:
        return '';
    }
  }
}