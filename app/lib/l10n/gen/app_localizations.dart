import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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
    Locale('pl'),
  ];

  /// No description provided for @serverSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect to your server'**
  String get serverSetupTitle;

  /// No description provided for @serverSetupDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the address of your Crushap server (see DEPLOYMENT.md) — something like http://203.0.113.5:3000.'**
  String get serverSetupDescription;

  /// No description provided for @serverSetupPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'http://your-server-ip:3000'**
  String get serverSetupPlaceholder;

  /// No description provided for @serverSetupErrorFormat.
  ///
  /// In en, this message translates to:
  /// **'Include http:// or https://'**
  String get serverSetupErrorFormat;

  /// No description provided for @serverSetupErrorUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach that server. Double-check the address and that it\'s running.'**
  String get serverSetupErrorUnreachable;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @checkingLabel.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get checkingLabel;

  /// No description provided for @onboardingHeadline.
  ///
  /// In en, this message translates to:
  /// **'Find your spark tonight. No games, just genuine matches.'**
  String get onboardingHeadline;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Swipe. Match. Connect.'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'A quick swipe is all it takes — like who catches your eye, we\'ll tell you the moment it\'s mutual.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Chat instantly'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Once you match, the conversation starts right away — real-time messages, no waiting around.'**
  String get onboardingSlide3Body;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get alreadyHaveAccount;

  /// No description provided for @backWithArrow.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backWithArrow;

  /// No description provided for @nameStepTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get nameStepTitle;

  /// No description provided for @firstNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNamePlaceholder;

  /// No description provided for @credentialsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up your login'**
  String get credentialsStepTitle;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailPlaceholder;

  /// No description provided for @passwordMinPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password (min. 6 characters)'**
  String get passwordMinPlaceholder;

  /// No description provided for @ageStepTitle.
  ///
  /// In en, this message translates to:
  /// **'How old are you?'**
  String get ageStepTitle;

  /// No description provided for @agePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get agePlaceholder;

  /// No description provided for @genderStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Which best describes you?'**
  String get genderStepTitle;

  /// No description provided for @genderIdentityWoman.
  ///
  /// In en, this message translates to:
  /// **'Woman'**
  String get genderIdentityWoman;

  /// No description provided for @genderIdentityMan.
  ///
  /// In en, this message translates to:
  /// **'Man'**
  String get genderIdentityMan;

  /// No description provided for @genderIdentityNonBinary.
  ///
  /// In en, this message translates to:
  /// **'Non-binary'**
  String get genderIdentityNonBinary;

  /// No description provided for @interestsStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a few interests'**
  String get interestsStepTitle;

  /// No description provided for @photoStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get photoStepTitle;

  /// No description provided for @photoStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Optional, but profiles with a real photo get a lot more matches.'**
  String get photoStepSubtitle;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @startSwiping.
  ///
  /// In en, this message translates to:
  /// **'Start swiping'**
  String get startSwiping;

  /// No description provided for @settingUpAccount.
  ///
  /// In en, this message translates to:
  /// **'Setting up your account…'**
  String get settingUpAccount;

  /// No description provided for @locationStepTitle.
  ///
  /// In en, this message translates to:
  /// **'Share your location'**
  String get locationStepTitle;

  /// No description provided for @locationStepSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See real distances to people nearby, and use the distance filter — this is never shared as an exact address, just used to calculate distance.'**
  String get locationStepSubtitle;

  /// No description provided for @locationSharedConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Got it — distances will be shown accurately.'**
  String get locationSharedConfirmation;

  /// No description provided for @shareMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Share my location'**
  String get shareMyLocation;

  /// No description provided for @locatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Locating…'**
  String get locatingLabel;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @loggingIn.
  ///
  /// In en, this message translates to:
  /// **'Logging in…'**
  String get loggingIn;

  /// No description provided for @genericNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Try again.'**
  String get genericNetworkError;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordPlaceholder;

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takeAPhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// No description provided for @filtersLabel.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersLabel;

  /// No description provided for @filtersWidenedNotice.
  ///
  /// In en, this message translates to:
  /// **'We widened your search a little to find more people.'**
  String get filtersWidenedNotice;

  /// No description provided for @undoLabel.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoLabel;

  /// No description provided for @passLabel.
  ///
  /// In en, this message translates to:
  /// **'Pass'**
  String get passLabel;

  /// No description provided for @superlikeLabel.
  ///
  /// In en, this message translates to:
  /// **'Superlike'**
  String get superlikeLabel;

  /// No description provided for @likeLabel.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get likeLabel;

  /// No description provided for @findingPeopleNearby.
  ///
  /// In en, this message translates to:
  /// **'Finding people nearby…'**
  String get findingPeopleNearby;

  /// No description provided for @discoverLoadErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load Discover'**
  String get discoverLoadErrorTitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @allCaughtUpTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get allCaughtUpTitle;

  /// No description provided for @allCaughtUpMessage.
  ///
  /// In en, this message translates to:
  /// **'That\'s everyone nearby for now. New people show up here as they join — check back soon.'**
  String get allCaughtUpMessage;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @stampLike.
  ///
  /// In en, this message translates to:
  /// **'LIKE'**
  String get stampLike;

  /// No description provided for @stampNope.
  ///
  /// In en, this message translates to:
  /// **'NOPE'**
  String get stampNope;

  /// No description provided for @stampSuperlike.
  ///
  /// In en, this message translates to:
  /// **'SUPER LIKE'**
  String get stampSuperlike;

  /// No description provided for @backLabel.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backLabel;

  /// No description provided for @maximumDistance.
  ///
  /// In en, this message translates to:
  /// **'Maximum distance'**
  String get maximumDistance;

  /// No description provided for @distanceValueKm.
  ///
  /// In en, this message translates to:
  /// **'{value} km'**
  String distanceValueKm(int value);

  /// No description provided for @distanceAwayKm.
  ///
  /// In en, this message translates to:
  /// **'{value} km away'**
  String distanceAwayKm(String value);

  /// No description provided for @ageRange.
  ///
  /// In en, this message translates to:
  /// **'Age range'**
  String get ageRange;

  /// No description provided for @ageRangeValue.
  ///
  /// In en, this message translates to:
  /// **'18 - {max}'**
  String ageRangeValue(int max);

  /// No description provided for @showMe.
  ///
  /// In en, this message translates to:
  /// **'Show me'**
  String get showMe;

  /// No description provided for @genderWomen.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get genderWomen;

  /// No description provided for @genderMen.
  ///
  /// In en, this message translates to:
  /// **'Men'**
  String get genderMen;

  /// No description provided for @genderEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get genderEveryone;

  /// No description provided for @verifiedProfilesOnly.
  ///
  /// In en, this message translates to:
  /// **'Verified profiles only'**
  String get verifiedProfilesOnly;

  /// No description provided for @hasPhotoOnly.
  ///
  /// In en, this message translates to:
  /// **'Has a photo'**
  String get hasPhotoOnly;

  /// No description provided for @refreshMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Refresh my location'**
  String get refreshMyLocation;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFilters;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatTitle;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet. Match with someone on Discover to start chatting.'**
  String get noConversationsYet;

  /// No description provided for @sayHiPreview.
  ///
  /// In en, this message translates to:
  /// **'Say hi 👋'**
  String get sayHiPreview;

  /// No description provided for @sendMessagePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Send a message'**
  String get sendMessagePlaceholder;

  /// No description provided for @sendLabel.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendLabel;

  /// No description provided for @matchedEmptyState.
  ///
  /// In en, this message translates to:
  /// **'You matched with {name}. Say hi 👋'**
  String matchedEmptyState(String name);

  /// No description provided for @matchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matchesTitle;

  /// No description provided for @noMatchesYet.
  ///
  /// In en, this message translates to:
  /// **'Your matches will show up here. Get swiping on Discover.'**
  String get noMatchesYet;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search by name or interest'**
  String get searchPlaceholder;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No one matches that yet.'**
  String get noSearchResults;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @addBioPrompt.
  ///
  /// In en, this message translates to:
  /// **'Add a bio so people know a little about you.'**
  String get addBioPrompt;

  /// No description provided for @genderSection.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderSection;

  /// No description provided for @genderNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set yet — tap Edit profile to add it.'**
  String get genderNotSet;

  /// No description provided for @interestsSection.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interestsSection;

  /// No description provided for @noInterestsYet.
  ///
  /// In en, this message translates to:
  /// **'No interests added yet.'**
  String get noInterestsYet;

  /// No description provided for @bioEditPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'A little about you'**
  String get bioEditPlaceholder;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @savingLabel.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingLabel;

  /// No description provided for @editProfileRow.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileRow;

  /// No description provided for @notificationsRow.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsRow;

  /// No description provided for @privacySafetyRow.
  ///
  /// In en, this message translates to:
  /// **'Privacy & safety'**
  String get privacySafetyRow;

  /// No description provided for @subscriptionRow.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionRow;

  /// No description provided for @serverRow.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get serverRow;

  /// No description provided for @logOutRow.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOutRow;

  /// No description provided for @editPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit photo'**
  String get editPhotoLabel;

  /// No description provided for @addPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhotoLabel;

  /// No description provided for @removePhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get removePhotoLabel;

  /// No description provided for @verifiedBadge.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedBadge;

  /// No description provided for @languageRow.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageRow;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polski'**
  String get languagePolish;

  /// No description provided for @itsAMatch.
  ///
  /// In en, this message translates to:
  /// **'It\'s a match!'**
  String get itsAMatch;

  /// No description provided for @matchedWithMessage.
  ///
  /// In en, this message translates to:
  /// **'You and {name} liked each other.'**
  String matchedWithMessage(String name);

  /// No description provided for @sendAMessage.
  ///
  /// In en, this message translates to:
  /// **'Send a Message'**
  String get sendAMessage;

  /// No description provided for @keepSwiping.
  ///
  /// In en, this message translates to:
  /// **'Keep Swiping'**
  String get keepSwiping;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsNewMatches.
  ///
  /// In en, this message translates to:
  /// **'New matches'**
  String get notificationsNewMatches;

  /// No description provided for @notificationsNewMatchesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified the moment someone matches with you.'**
  String get notificationsNewMatchesDesc;

  /// No description provided for @notificationsNewMessages.
  ///
  /// In en, this message translates to:
  /// **'New messages'**
  String get notificationsNewMessages;

  /// No description provided for @notificationsNewMessagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when a match sends you a message.'**
  String get notificationsNewMessagesDesc;

  /// No description provided for @notificationsLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get notificationsLikes;

  /// No description provided for @notificationsLikesDesc.
  ///
  /// In en, this message translates to:
  /// **'Get notified when someone likes your profile.'**
  String get notificationsLikesDesc;

  /// No description provided for @notificationsAppUpdates.
  ///
  /// In en, this message translates to:
  /// **'App updates'**
  String get notificationsAppUpdates;

  /// No description provided for @notificationsAppUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'News about new features and improvements.'**
  String get notificationsAppUpdatesDesc;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy & safety'**
  String get privacyTitle;

  /// No description provided for @privacyShowDistance.
  ///
  /// In en, this message translates to:
  /// **'Show my distance'**
  String get privacyShowDistance;

  /// No description provided for @privacyShowDistanceDesc.
  ///
  /// In en, this message translates to:
  /// **'Let other people see how far away you are.'**
  String get privacyShowDistanceDesc;

  /// No description provided for @privacyShowOnlineStatus.
  ///
  /// In en, this message translates to:
  /// **'Show online status'**
  String get privacyShowOnlineStatus;

  /// No description provided for @privacyShowOnlineStatusDesc.
  ///
  /// In en, this message translates to:
  /// **'Let your matches see when you\'re active.'**
  String get privacyShowOnlineStatusDesc;

  /// No description provided for @privacyReadReceipts.
  ///
  /// In en, this message translates to:
  /// **'Read receipts'**
  String get privacyReadReceipts;

  /// No description provided for @privacyReadReceiptsDesc.
  ///
  /// In en, this message translates to:
  /// **'Let matches see when you\'ve read their messages.'**
  String get privacyReadReceiptsDesc;

  /// No description provided for @privacyBlockedSection.
  ///
  /// In en, this message translates to:
  /// **'Blocked accounts'**
  String get privacyBlockedSection;

  /// No description provided for @privacyNoBlockedUsers.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t blocked anyone.'**
  String get privacyNoBlockedUsers;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionHeadline.
  ///
  /// In en, this message translates to:
  /// **'Crushap Plus'**
  String get subscriptionHeadline;

  /// No description provided for @subscriptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock the full experience and get noticed faster.'**
  String get subscriptionSubtitle;

  /// No description provided for @subscriptionFeatureUnlimitedLikes.
  ///
  /// In en, this message translates to:
  /// **'Unlimited likes'**
  String get subscriptionFeatureUnlimitedLikes;

  /// No description provided for @subscriptionFeatureSeeWhoLikesYou.
  ///
  /// In en, this message translates to:
  /// **'See who likes you'**
  String get subscriptionFeatureSeeWhoLikesYou;

  /// No description provided for @subscriptionFeatureRewind.
  ///
  /// In en, this message translates to:
  /// **'Rewind your last swipe'**
  String get subscriptionFeatureRewind;

  /// No description provided for @subscriptionFeatureBoost.
  ///
  /// In en, this message translates to:
  /// **'Monthly profile boost'**
  String get subscriptionFeatureBoost;

  /// No description provided for @subscriptionPrice.
  ///
  /// In en, this message translates to:
  /// **'\$9.99 / month'**
  String get subscriptionPrice;

  /// No description provided for @subscriptionCta.
  ///
  /// In en, this message translates to:
  /// **'Notify me when it\'s ready'**
  String get subscriptionCta;

  /// No description provided for @subscriptionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Crushap Plus is in the works — this screen shows what\'s coming, but nothing will be charged today.'**
  String get subscriptionComingSoon;

  /// No description provided for @subscriptionNotifyConfirmed.
  ///
  /// In en, this message translates to:
  /// **'You\'re on the list — we\'ll let you know.'**
  String get subscriptionNotifyConfirmed;
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
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
