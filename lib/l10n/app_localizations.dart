import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sr.dart';

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
    Locale('sr')
  ];

  /// No description provided for @addLocation.
  ///
  /// In en, this message translates to:
  /// **'Add location'**
  String get addLocation;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'address'**
  String get address;

  /// No description provided for @assetDelete.
  ///
  /// In en, this message translates to:
  /// **'Asset deleted.'**
  String get assetDelete;

  /// No description provided for @assetDetails.
  ///
  /// In en, this message translates to:
  /// **'Asset Details'**
  String get assetDetails;

  /// No description provided for @assetManager.
  ///
  /// In en, this message translates to:
  /// **'Asset Manger'**
  String get assetManager;

  /// No description provided for @assetNotDeleted.
  ///
  /// In en, this message translates to:
  /// **'Asset can not be deleted'**
  String get assetNotDeleted;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @barcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get barcode;

  /// No description provided for @barcodeNum.
  ///
  /// In en, this message translates to:
  /// **'Barcode must be a number'**
  String get barcodeNum;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @censusItemDetails.
  ///
  /// In en, this message translates to:
  /// **'Census item details'**
  String get censusItemDetails;

  /// No description provided for @censusList.
  ///
  /// In en, this message translates to:
  /// **'Census list'**
  String get censusList;

  /// No description provided for @censusListDelete.
  ///
  /// In en, this message translates to:
  /// **'Census list deleted'**
  String get censusListDelete;

  /// No description provided for @censusListNotDelete.
  ///
  /// In en, this message translates to:
  /// **'Census List can not be deleted'**
  String get censusListNotDelete;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Get current location'**
  String get currentLocation;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emptyBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode cannot be empty.'**
  String get emptyBarcode;

  /// No description provided for @emptyDate.
  ///
  /// In en, this message translates to:
  /// **'Date cannot be empty.'**
  String get emptyDate;

  /// No description provided for @emptyImage.
  ///
  /// In en, this message translates to:
  /// **'Image cannot be empty.'**
  String get emptyImage;

  /// No description provided for @emptyName.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty.'**
  String get emptyName;

  /// No description provided for @emptyPrice.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be empty.'**
  String get emptyPrice;

  /// No description provided for @existingLocation.
  ///
  /// In en, this message translates to:
  /// **'Existing location'**
  String get existingLocation;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @homeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Asset Manger'**
  String get homeScreenTitle;

  /// No description provided for @invalidInput.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalidInput;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @loadingError.
  ///
  /// In en, this message translates to:
  /// **'Error loading data'**
  String get loadingError;

  /// No description provided for @locationDelete.
  ///
  /// In en, this message translates to:
  /// **'Location deleted'**
  String get locationDelete;

  /// No description provided for @locationNotDeleted.
  ///
  /// In en, this message translates to:
  /// **'Location can not be deleted'**
  String get locationNotDeleted;

  /// No description provided for @locations.
  ///
  /// In en, this message translates to:
  /// **'Locations'**
  String get locations;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @newWorker.
  ///
  /// In en, this message translates to:
  /// **'New worker'**
  String get newWorker;

  /// No description provided for @noAddress.
  ///
  /// In en, this message translates to:
  /// **'No address found'**
  String get noAddress;

  /// No description provided for @noAsset.
  ///
  /// In en, this message translates to:
  /// **'No assets found'**
  String get noAsset;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItems;

  /// No description provided for @noLocation.
  ///
  /// In en, this message translates to:
  /// **'No locations found'**
  String get noLocation;

  /// No description provided for @noLocationChosen.
  ///
  /// In en, this message translates to:
  /// **'No locations  chosen'**
  String get noLocationChosen;

  /// No description provided for @noNewWorker.
  ///
  /// In en, this message translates to:
  /// **'New worker can not be empty'**
  String get noNewWorker;

  /// No description provided for @noOldLocation.
  ///
  /// In en, this message translates to:
  /// **'Old location cannot be empty'**
  String get noOldLocation;

  /// No description provided for @noOldWorker.
  ///
  /// In en, this message translates to:
  /// **'Old worker cannot be empty'**
  String get noOldWorker;

  /// No description provided for @noWorker.
  ///
  /// In en, this message translates to:
  /// **'No workers found'**
  String get noWorker;

  /// No description provided for @okay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get okay;

  /// No description provided for @oldWorker.
  ///
  /// In en, this message translates to:
  /// **'Old worker'**
  String get oldWorker;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @pickYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick your location'**
  String get pickYourLocation;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @scanBarcode.
  ///
  /// In en, this message translates to:
  /// **'Scan barcode'**
  String get scanBarcode;

  /// No description provided for @scanError.
  ///
  /// In en, this message translates to:
  /// **'Error while scanning'**
  String get scanError;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select location'**
  String get selectLocation;

  /// No description provided for @selectOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select on map'**
  String get selectOnMap;

  /// No description provided for @selectWorker.
  ///
  /// In en, this message translates to:
  /// **'Select worker'**
  String get selectWorker;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsScreenTitle;

  /// No description provided for @startScan.
  ///
  /// In en, this message translates to:
  /// **'Start scan'**
  String get startScan;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @uniqueBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode must be unique'**
  String get uniqueBarcode;

  /// No description provided for @unknownCity.
  ///
  /// In en, this message translates to:
  /// **'Unknown city'**
  String get unknownCity;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @workerDelete.
  ///
  /// In en, this message translates to:
  /// **'Worker deleted'**
  String get workerDelete;

  /// No description provided for @workerDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'Worker does not exist'**
  String get workerDoesNotExist;

  /// No description provided for @workerNotDeleted.
  ///
  /// In en, this message translates to:
  /// **'Worker can not be deleted'**
  String get workerNotDeleted;

  /// No description provided for @workers.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get workers;

  /// No description provided for @wrongLocation.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with getting the location'**
  String get wrongLocation;

  /// No description provided for @yourBarcode.
  ///
  /// In en, this message translates to:
  /// **'Your barcode'**
  String get yourBarcode;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocation;
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
      <String>['en', 'sr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
