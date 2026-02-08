import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// The main title of the application
  ///
  /// In en, this message translates to:
  /// **'Flowery ride'**
  String get appTitle;

  /// App Name Logo Text
  ///
  /// In en, this message translates to:
  /// **'Flowery'**
  String get flowery;

  /// No description provided for @onBoardingDescription.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Flowery rider app'**
  String get onBoardingDescription;

  /// Title for the login screen
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  ///  for the apply Button
  ///
  /// In en, this message translates to:
  /// **'Apply now'**
  String get applyButton;

  /// Title for the apply screen
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyTitle;

  /// Label for the email input field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// Hint text for the email input field
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// Label for the password input field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// Hint text for the password input field
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// Label for remember me checkbox
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Link text for forgot password
  ///
  /// In en, this message translates to:
  /// **'Forget password?'**
  String get forgotPasswordLink;

  ///  for the Continue Button
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Generic error message for invalid email format
  ///
  /// In en, this message translates to:
  /// **'This Email is not valid'**
  String get invalidEmailError;

  /// Generic error message for incorrect password
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPasswordError;

  /// Label for selecting or displaying the user's country
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Label for the first name input field
  ///
  /// In en, this message translates to:
  /// **'First legal name'**
  String get firstNameLabel;

  /// Hint text for the first name input field
  ///
  /// In en, this message translates to:
  /// **'Enter first legal name'**
  String get firstNameHint;

  /// No description provided for @secondNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Second legal name'**
  String get secondNameLabel;

  /// No description provided for @secondNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter second legal name'**
  String get secondNameHint;

  /// Label for selecting or entering the type of vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle type'**
  String get vehicleType;

  /// Label for entering the vehicle number
  ///
  /// In en, this message translates to:
  /// **'Vehicle number'**
  String get vehicleNumber;

  /// Label for entering the vehicle license
  ///
  /// In en, this message translates to:
  /// **'Vehicle license'**
  String get vehicleLicense;

  /// Label for the phone number input field
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneLabel;

  /// Hint text for the phone number input field
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneHint;

  /// Label for the ID number input field
  ///
  /// In en, this message translates to:
  /// **'ID number'**
  String get idNumberLabel;

  /// Hint text for the ID number input field
  ///
  /// In en, this message translates to:
  /// **'Enter national ID number'**
  String get idNumberHint;

  /// No description provided for @idImageLabel.
  ///
  /// In en, this message translates to:
  /// **'ID image'**
  String get idImageLabel;

  /// Hint text for the ID image
  ///
  /// In en, this message translates to:
  /// **'Upload ID image'**
  String get idHint;

  /// Label for the confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// Hint text for the confirm password input field
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordHint;

  /// Label for gender selection
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// Option for male gender
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// Option for female gender
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// Subtitle shown after successfully submitting an application
  ///
  /// In en, this message translates to:
  /// **'Your application has been submitted!'**
  String get successApplySubTitle;

  /// Message informing the user that their application will be reviewed and they will be contacted soon
  ///
  /// In en, this message translates to:
  /// **'Thank you for providing your application, we will review your application and will get back to you soon.'**
  String get successApplyDescription;

  /// Validation message when name is empty
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// Validation message when first name is empty
  ///
  /// In en, this message translates to:
  /// **'First legal name is required'**
  String get firstNameRequired;

  /// Validation message when second name is empty
  ///
  /// In en, this message translates to:
  /// **'Second legal name is required'**
  String get secondNameRequired;

  /// Error message shown when the selected or entered vehicle type is not valid
  ///
  /// In en, this message translates to:
  /// **'Vehicle type is invalid'**
  String get vehicleTypeInvalid;

  /// Error message shown when the vehicle type field is left empty
  ///
  /// In en, this message translates to:
  /// **'Vehicle type is required'**
  String get vehicleTypeRequired;

  /// Error message shown when the entered vehicle number is not valid
  ///
  /// In en, this message translates to:
  /// **'Vehicle number is invalid'**
  String get vehicleNumberInvalid;

  /// Error message shown when the vehicle number field is left empty
  ///
  /// In en, this message translates to:
  /// **'Vehicle number is required'**
  String get vehicleNumberRequired;

  /// Error message shown when the entered vehicle license is not valid
  ///
  /// In en, this message translates to:
  /// **'Vehicle license is invalid'**
  String get vehicleLicenseInvalid;

  /// Error message shown when the vehicle license field is left empty
  ///
  /// In en, this message translates to:
  /// **'Vehicle license is required'**
  String get vehicleLicenseRequired;

  /// Validation message when phone is empty
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// Validation message when phone format is wrong
  ///
  /// In en, this message translates to:
  /// **'Ensure the number starts with +20'**
  String get phoneInvalid;

  /// Validation message when ID number is empty
  ///
  /// In en, this message translates to:
  /// **'national ID number is required'**
  String get idNumberRequired;

  /// Validation message when ID number is wrong
  ///
  /// In en, this message translates to:
  /// **'National ID number is invalid'**
  String get idNumberInvalid;

  /// Error message shown when the uploaded ID image is not valid or corrupted
  ///
  /// In en, this message translates to:
  /// **'ID image is invalid'**
  String get idImageInvalid;

  /// Error message shown when the ID image field is left empty
  ///
  /// In en, this message translates to:
  /// **'ID image is required'**
  String get idImageRequired;

  /// Title for the forgot password screen
  ///
  /// In en, this message translates to:
  /// **'Forget password'**
  String get forgotPasswordTitle;

  /// Subtitle instructions for forgot password
  ///
  /// In en, this message translates to:
  /// **'Please enter your email associated to your account'**
  String get forgotPasswordSubTitle;

  /// Label for confirm buttons
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// Title for the email verification screen
  ///
  /// In en, this message translates to:
  /// **'Email verification'**
  String get verificationTitle;

  /// Validation message for incomplete OTP code
  ///
  /// In en, this message translates to:
  /// **'Please enter complete 6-digit code'**
  String get validationEnterCompleteCode;

  /// Generic error message for weak password validation
  ///
  /// In en, this message translates to:
  /// **'Password must not be empty and must contain 6 characters with upper case letter and one number at least'**
  String get weakPasswordError;

  /// Generic error message for invalid verification code
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get invalidCodeError;

  /// Subtitle instructions for email verification
  ///
  /// In en, this message translates to:
  /// **'Please enter your code that sent to your email address'**
  String get verificationSubTitle;

  /// Button text to resend verification code
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get resendCode;

  /// Button text to resend verification code
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// Title for the reset password screen
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// Subtitle instructions for reset password
  ///
  /// In en, this message translates to:
  /// **'Password must not be empty and must contain 6 characters with upper case letter and one number at least '**
  String get resetPasswordSubTitle;

  /// content of dialog
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully! Please login with your new password.'**
  String get resetSuccessfully;

  /// content of dialog
  ///
  /// In en, this message translates to:
  /// **'Your account has been created successfully! Please login to continue '**
  String get registerSuccessfully;

  /// success
  ///
  /// In en, this message translates to:
  /// **'success'**
  String get success;

  /// Label for the new password input field
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// Validation message when email is empty
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// Validation message when email format is wrong
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// Validation message when password is empty
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Validation message when password is short
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Validation message when password complexity is low
  ///
  /// In en, this message translates to:
  /// **'Password must contain uppercase, lowercase, number and special character'**
  String get passwordWeak;

  /// Validation message when confirm password fails
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordMismatch;

  /// Label for the cancel button in a dialog
  ///
  /// In en, this message translates to:
  /// **'cancel'**
  String get cancelDialog;

  /// Label for entering or displaying general information about the vehicle
  ///
  /// In en, this message translates to:
  /// **'Vehicle info'**
  String get vehicleInfo;

  /// Title for edit profile screen
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// Button text to change password
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Button text to update profile or password
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Label or button text for editing the vehicle information
  ///
  /// In en, this message translates to:
  /// **'Edit vehicle info'**
  String get editVehicleInfo;

  /// Profile menu item for logout
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Title for logout confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'LOGOUT'**
  String get logoutTitle;

  /// Message asking user to confirm logout
  ///
  /// In en, this message translates to:
  /// **'Confirm logout!!'**
  String get confirmLogout;

  /// Label for current password field
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// Hint for current password field
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordHint;

  /// Ok
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// Label for the home navigation tab
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for the Orders navigation tab
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get cart;

  /// Label for the profile navigation tab
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status: '**
  String get status;

  /// Label for a flower order
  ///
  /// In en, this message translates to:
  /// **'Flower order'**
  String get flowerOrder;

  /// Label for the address where the order will be picked up
  ///
  /// In en, this message translates to:
  /// **'Pickup address'**
  String get pickupAddress;

  /// Label for the address of the user receiving the order
  ///
  /// In en, this message translates to:
  /// **'User address'**
  String get userAddress;

  /// Action button text for accepting an order or request
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// Action button text for rejecting an order or request
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Label for viewing detailed information of an order
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetails;

  /// Status indicating that the order has been accepted
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// Label for displaying the unique identifier of an order
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get orderID;

  /// Label for the method used to pay for the order
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// Label for showing the total cost of the order
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Status indicating the order has reached the pickup location
  ///
  /// In en, this message translates to:
  /// **'Arrived at Pickup point'**
  String get arrivedAtPickupPointButton;

  /// Status indicating the order has been picked up from the pickup point
  ///
  /// In en, this message translates to:
  /// **'Picked'**
  String get picked;

  /// Action or status indicating that the delivery process has started
  ///
  /// In en, this message translates to:
  /// **'Start deliver'**
  String get startDeliverButton;

  /// Status indicating that the order is on its way to the user
  ///
  /// In en, this message translates to:
  /// **'Out for delivery'**
  String get outForDelivery;

  /// Status indicating that the order has arrived at the user's location
  ///
  /// In en, this message translates to:
  /// **'Arrived to the user'**
  String get arrivedToUserButton;

  /// General status indicating arrival at a location
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// Status indicating that the order has been successfully delivered to the user
  ///
  /// In en, this message translates to:
  /// **'Delivered to the user'**
  String get deliveredToUser;

  /// General status indicating delivery completed
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// Label indicating the user's current location
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocation;

  /// Message shown when the order has been delivered successfully
  ///
  /// In en, this message translates to:
  /// **'The order delivered successfully'**
  String get orderDeliveredSuccessfully;

  /// Action or status indicating a task or order is completed
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Status indicating the order has been cancelled
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Label for displaying the list of recent orders
  ///
  /// In en, this message translates to:
  /// **'Recent orders'**
  String get recentOrders;

  /// Status indicating that the order is prepared and ready to be delivered
  ///
  /// In en, this message translates to:
  /// **'Ready for delivery'**
  String get readyForDelivery;

  /// Status label for completed orders
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Status indicating that the order is still pending and not yet processed
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Button text to view all items
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Label for delivery location
  ///
  /// In en, this message translates to:
  /// **'Deliver to'**
  String get deliverTo;

  /// Button text to retry
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// Error message for connection timeout
  ///
  /// In en, this message translates to:
  /// **'Connection timeout. Please check your internet.'**
  String get connectionTimeoutError;

  /// Error message for send timeout
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please try again.'**
  String get sendTimeoutError;

  /// Error message for receive timeout
  ///
  /// In en, this message translates to:
  /// **'Server took too long to respond.'**
  String get receiveTimeoutError;

  /// Generic connection error message
  ///
  /// In en, this message translates to:
  /// **'Connection error. Please check your network.'**
  String get connectionError;

  /// Error message for no internet connection
  ///
  /// In en, this message translates to:
  /// **'No internet connection.'**
  String get noInternetError;

  /// Generic network error message
  ///
  /// In en, this message translates to:
  /// **'Network error occurred.'**
  String get networkError;

  /// Error message when request is cancelled
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled.'**
  String get requestCancelledError;

  /// Error message for bad SSL certificate
  ///
  /// In en, this message translates to:
  /// **'Security certificate error.'**
  String get badCertificateError;

  /// Error message for 400 Bad Request
  ///
  /// In en, this message translates to:
  /// **'Invalid request.'**
  String get badRequestError;

  /// Error message for 401 Unauthorized
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again.'**
  String get unauthorizedError;

  /// Error message for 403 Forbidden
  ///
  /// In en, this message translates to:
  /// **'Access denied.'**
  String get forbiddenError;

  /// Error message for 404 Not Found
  ///
  /// In en, this message translates to:
  /// **'Resource not found.'**
  String get notFoundError;

  /// Error message for 409 Conflict
  ///
  /// In en, this message translates to:
  /// **'Data conflict occurred.'**
  String get conflictError;

  /// Error message for 500 Internal Server Error
  ///
  /// In en, this message translates to:
  /// **'Server error. Try again later.'**
  String get internalServerError;

  /// Error message for 503 Service Unavailable
  ///
  /// In en, this message translates to:
  /// **'Service unavailable.'**
  String get serviceUnavailableError;

  /// Error message for format exception
  ///
  /// In en, this message translates to:
  /// **'Data format error.'**
  String get formatExceptionError;

  /// Error message for data parsing issues
  ///
  /// In en, this message translates to:
  /// **'Error parsing data. Please try again.'**
  String get parsingError;

  /// Firebase error: User not found
  ///
  /// In en, this message translates to:
  /// **'No user found for this email.'**
  String get firebaseUserNotFound;

  /// Firebase error: Wrong password
  ///
  /// In en, this message translates to:
  /// **'Wrong password.'**
  String get firebaseWrongPassword;

  /// Firebase error: Email in use
  ///
  /// In en, this message translates to:
  /// **'Email already in use.'**
  String get firebaseEmailInUse;

  /// Firebase error: Invalid email
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get firebaseInvalidEmail;

  /// Firebase error: Weak password
  ///
  /// In en, this message translates to:
  /// **'Password is too weak.'**
  String get firebaseWeakPassword;

  /// Firebase error: Account disabled
  ///
  /// In en, this message translates to:
  /// **'Account disabled.'**
  String get firebaseAccountDisabled;

  /// Firebase error: Too many requests
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Try again later.'**
  String get firebaseTooManyRequests;

  /// Firebase error: Unknown auth error
  ///
  /// In en, this message translates to:
  /// **'Authentication failed.'**
  String get firebaseAuthUnknown;

  /// Firebase error: Permission denied
  ///
  /// In en, this message translates to:
  /// **'Permission denied.'**
  String get firebasePermissionDenied;

  /// Firebase error: Service unavailable
  ///
  /// In en, this message translates to:
  /// **'Firebase service unavailable.'**
  String get firebaseUnavailable;

  /// Error message for Hive database issues
  ///
  /// In en, this message translates to:
  /// **'Database error (Hive).'**
  String get hiveError;

  /// Error message for platform exceptions
  ///
  /// In en, this message translates to:
  /// **'System error occurred.'**
  String get platformError;

  /// Fallback generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get defaultError;

  /// Fallback unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unknownError;

  /// Title for the session expired dialog
  ///
  /// In en, this message translates to:
  /// **'Session Expired'**
  String get sessionExpiredTitle;

  /// Content message for the session expired dialog
  ///
  /// In en, this message translates to:
  /// **'Please log in again to continue.'**
  String get sessionExpiredMessage;

  /// No description provided for @includeTax.
  ///
  /// In en, this message translates to:
  /// **'All prices include tax'**
  String get includeTax;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Label for the search input field
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// Hint text for search bar
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// Message displayed when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResults;

  /// No description provided for @searchFor.
  ///
  /// In en, this message translates to:
  /// **'Search For Any Product You Want'**
  String get searchFor;

  /// Button text to add an item to the cart
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// Profile menu item for notifications
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notifications;

  /// Profile menu item for language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Language option English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Language option Arabic
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// Title for language selection bottom sheet
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// Success message after profile update
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccess;

  /// No description provided for @photoUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Photo uploaded successfully'**
  String get photoUploadedSuccessfully;

  /// Success message after password change
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChangedSuccess;

  /// App version display text
  ///
  /// In en, this message translates to:
  /// **'v 6.3.0 - (446)'**
  String get appVersion;

  /// Error message when image selection fails
  ///
  /// In en, this message translates to:
  /// **'Failed to pick image: {error}'**
  String failedToPickImage(String error);

  /// Validation message when a required field is empty
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// Text to indicate user can tap to change location
  ///
  /// In en, this message translates to:
  /// **'Tap to change'**
  String get tapToChange;

  /// Label for address input field
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// Validation message when location is not selected
  ///
  /// In en, this message translates to:
  /// **'Please pick a location on map'**
  String get pleasePickLocation;

  /// Title for location picker screen
  ///
  /// In en, this message translates to:
  /// **'Pick Location'**
  String get pickLocation;

  /// Message when location services are disabled
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable them.'**
  String get locationServicesDisabled;

  /// Message when location permissions are denied
  ///
  /// In en, this message translates to:
  /// **'Location permissions are denied'**
  String get locationPermissionsDenied;

  /// Message when location permissions are permanently denied
  ///
  /// In en, this message translates to:
  /// **'Location permissions are permanently denied'**
  String get locationPermissionsPermanentlyDenied;

  /// Message when current location is selected
  ///
  /// In en, this message translates to:
  /// **'Current location selected'**
  String get currentLocationSelected;

  /// Error message prefix when getting location fails
  ///
  /// In en, this message translates to:
  /// **'Error getting location: '**
  String get errorGettingLocation;

  /// Option for cash on delivery
  ///
  /// In en, this message translates to:
  /// **'Cash on delivery'**
  String get cashOnDelivery;

  /// Option for credit card payment
  ///
  /// In en, this message translates to:
  /// **'Credit card'**
  String get creditCard;

  /// Label for delivery address
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// Button text to add a new address
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// Button text to edit an address
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Thank you message
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get thankYou;

  /// Button text to go to home
  ///
  /// In en, this message translates to:
  /// **'Go to home'**
  String get goToHome;

  /// loading...
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Status label for active orders
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Button text to track an order
  ///
  /// In en, this message translates to:
  /// **'Track order'**
  String get trackOrder;

  /// Label for delivery status
  ///
  /// In en, this message translates to:
  /// **'Delivered on'**
  String get deliveredOn;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
