import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'L’Atelier du Chef'**
  String get appName;

  /// No description provided for @subtitle.
  ///
  /// In en, this message translates to:
  /// **'CHEF\'S WORKSHOP'**
  String get subtitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Ready to enrich your home cooking collection? Explore all the recipes we offer and find new ideas for every dish!'**
  String get description;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountButton;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@domain.com'**
  String get emailHint;

  /// No description provided for @emailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailEmptyError;

  /// No description provided for @emailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInvalidError;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get nameHint;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameEmptyError;

  /// No description provided for @bioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bioLabel;

  /// No description provided for @bioHint.
  ///
  /// In en, this message translates to:
  /// **'A short description about yourself'**
  String get bioHint;

  /// No description provided for @bioEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Bio cannot be empty'**
  String get bioEmptyError;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmptyError;

  /// No description provided for @passwordMinLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLengthError;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password again'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Confirm password cannot be empty'**
  String get confirmPasswordEmptyError;

  /// No description provided for @confirmPasswordMismatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get confirmPasswordMismatchError;

  /// No description provided for @loginFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Login Failed'**
  String get loginFailedTitle;

  /// No description provided for @loginFailedContent.
  ///
  /// In en, this message translates to:
  /// **'Account does not exist or password is incorrect.'**
  String get loginFailedContent;

  /// No description provided for @registerFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Failed'**
  String get registerFailedTitle;

  /// No description provided for @registerFailedContent.
  ///
  /// In en, this message translates to:
  /// **'Account already exists. Use another email or log in.'**
  String get registerFailedContent;

  /// No description provided for @genericErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'An Error Occurred'**
  String get genericErrorTitle;

  /// No description provided for @genericErrorContent.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get genericErrorContent;

  /// No description provided for @switchAuthTextLogin.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get switchAuthTextLogin;

  /// No description provided for @switchAuthTextRegister.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get switchAuthTextRegister;

  /// No description provided for @switchAuthButton.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchAuthButton;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageIndonesian;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @editProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileButton;

  /// No description provided for @postsLabel.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get postsLabel;

  /// No description provided for @emptyRecipeMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t created any recipes yet 🍳'**
  String get emptyRecipeMessage;

  /// No description provided for @recipeSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'My Recipes'**
  String get recipeSectionTitle;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @profileNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get profileNameLabel;

  /// No description provided for @profileNameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get profileNameEmptyError;

  /// No description provided for @profileBioLabel.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get profileBioLabel;

  /// No description provided for @defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUserName;

  /// No description provided for @defaultBio.
  ///
  /// In en, this message translates to:
  /// **'Add a bio to make it more interesting!'**
  String get defaultBio;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile: {error}'**
  String profileLoadError(Object error);

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdateSuccess;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String profileUpdateError(Object error);

  /// No description provided for @userNotLoggedInError.
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get userNotLoggedInError;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search Recipes...'**
  String get searchHint;

  /// No description provided for @recommendedRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended Recipe'**
  String get recommendedRecipeTitle;

  /// No description provided for @seeAllButton.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAllButton;

  /// No description provided for @noRecipesFound.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get noRecipesFound;

  /// No description provided for @category_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get category_all;

  /// No description provided for @category_appetizer.
  ///
  /// In en, this message translates to:
  /// **'Appetizer'**
  String get category_appetizer;

  /// No description provided for @category_mainCourse.
  ///
  /// In en, this message translates to:
  /// **'Main Course'**
  String get category_mainCourse;

  /// No description provided for @category_dessert.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get category_dessert;

  /// No description provided for @category_cake.
  ///
  /// In en, this message translates to:
  /// **'Cake'**
  String get category_cake;

  /// No description provided for @recipeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load recipes: {error}'**
  String recipeLoadError(Object error);

  /// No description provided for @menuProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get menuProfile;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @menuBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get menuBookmark;

  /// No description provided for @menuExit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get menuExit;

  /// No description provided for @ingredientsTab.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredientsTab;

  /// No description provided for @stepsTab.
  ///
  /// In en, this message translates to:
  /// **'Steps'**
  String get stepsTab;

  /// No description provided for @ingredientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredientsTitle;

  /// No description provided for @stepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cooking Steps'**
  String get stepsTitle;

  /// No description provided for @recipeImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Image of {title}'**
  String recipeImageLabel(Object title);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
