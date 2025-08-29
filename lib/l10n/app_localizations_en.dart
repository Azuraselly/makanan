// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'L’Atelier du Chef';

  @override
  String get subtitle => 'CHEF\'S WORKSHOP';

  @override
  String get description =>
      'Ready to enrich your home cooking collection? Explore all the recipes we offer and find new ideas for every dish!';

  @override
  String get createAccountButton => 'Create Account';

  @override
  String get loginButton => 'Login';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'example@domain.com';

  @override
  String get emailEmptyError => 'Email cannot be empty';

  @override
  String get emailInvalidError => 'Invalid email format';

  @override
  String get nameLabel => 'Name';

  @override
  String get nameHint => 'Full name';

  @override
  String get nameEmptyError => 'Name cannot be empty';

  @override
  String get bioLabel => 'Bio';

  @override
  String get bioHint => 'A short description about yourself';

  @override
  String get bioEmptyError => 'Bio cannot be empty';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get passwordEmptyError => 'Password cannot be empty';

  @override
  String get passwordMinLengthError => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Enter your password again';

  @override
  String get confirmPasswordEmptyError => 'Confirm password cannot be empty';

  @override
  String get confirmPasswordMismatchError => 'Passwords do not match';

  @override
  String get loginFailedTitle => 'Login Failed';

  @override
  String get loginFailedContent =>
      'Account does not exist or password is incorrect.';

  @override
  String get registerFailedTitle => 'Registration Failed';

  @override
  String get registerFailedContent =>
      'Account already exists. Use another email or log in.';

  @override
  String get genericErrorTitle => 'An Error Occurred';

  @override
  String get genericErrorContent => 'An error occurred. Please try again.';

  @override
  String get switchAuthTextLogin => 'Don\'t have an account? ';

  @override
  String get switchAuthTextRegister => 'Already have an account? ';

  @override
  String get switchAuthButton => 'Switch';

  @override
  String get ok => 'OK';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageIndonesian => 'Indonesian';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfileButton => 'Edit Profile';

  @override
  String get postsLabel => 'Posts';

  @override
  String get emptyRecipeMessage => 'No recipes added yet';

  @override
  String get recipeSectionTitle => 'My Recipes';

  @override
  String get saveButton => 'Save';

  @override
  String get profileNameLabel => 'Name';

  @override
  String get profileNameEmptyError => 'Name is required';

  @override
  String get profileBioLabel => 'Bio';

  @override
  String get defaultUserName => 'User';

  @override
  String get defaultBio => 'Add a bio to make it more interesting!';

  @override
  String get logoutConfirmationTitle => 'Confirm Logout';

  @override
  String get logoutConfirmationContent => 'Are you sure you want to log out?';

  @override
  String get logoutConfirmButton => 'Log Out';

  @override
  String get cancelButton => 'Cancel';

  @override
  String profileLoadError(Object error) {
    return 'Failed to load profile: $error';
  }

  @override
  String get profileUpdateSuccess => 'Profile updated successfully';

  @override
  String profileUpdateError(Object error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get userNotLoggedInError => 'User not logged in';

  @override
  String get searchHint => 'Search Recipes...';

  @override
  String get recommendedRecipeTitle => 'Recommended Recipe';

  @override
  String get seeAllButton => 'See All';

  @override
  String get noRecipesFound => 'No recipes found';

  @override
  String get category_all => 'All';

  @override
  String get category_appetizer => 'Appetizer';

  @override
  String get category_mainCourse => 'Main Course';

  @override
  String get category_dessert => 'Dessert';

  @override
  String get category_cake => 'Cake';

  @override
  String get deleteButton => 'Delete';

  @override
  String get deleteDialogTitle => 'Delete Recipe?';

  @override
  String get deleteDialogMessage =>
      'Are you sure you want to delete this recipe? This action cannot be undone.';

  @override
  String get confirmDeleteButton => 'Delete';

  @override
  String get deleteSuccessMessage => 'Recipe deleted successfully';

  @override
  String get deleteErrorMessage => 'Failed to delete recipe';

  @override
  String recipeLoadError(Object error) {
    return 'Failed to load recipes: $error';
  }

  @override
  String get menuProfile => 'Profile';

  @override
  String get menuLanguage => 'Language';

  @override
  String get menuBookmark => 'Bookmark';

  @override
  String get menuExit => 'Exit';

  @override
  String get ingredientsTab => 'Ingredients';

  @override
  String get stepsTab => 'Steps';

  @override
  String get ingredientsTitle => 'Ingredients';

  @override
  String get stepsTitle => 'Cooking Steps';

  @override
  String recipeImageLabel(Object title) {
    return 'Image of $title';
  }
}
