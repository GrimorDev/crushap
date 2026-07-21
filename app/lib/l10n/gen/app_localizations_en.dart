// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get serverSetupTitle => 'Connect to your server';

  @override
  String get serverSetupDescription =>
      'Enter the address of your Crushap server (see DEPLOYMENT.md) — something like http://203.0.113.5:3000.';

  @override
  String get serverSetupPlaceholder => 'http://your-server-ip:3000';

  @override
  String get serverSetupErrorFormat => 'Include http:// or https://';

  @override
  String get serverSetupErrorUnreachable =>
      'Couldn\'t reach that server. Double-check the address and that it\'s running.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get checkingLabel => 'Checking…';

  @override
  String get onboardingHeadline =>
      'Find your spark tonight. No games, just genuine matches.';

  @override
  String get onboardingSlide2Title => 'Swipe. Match. Connect.';

  @override
  String get onboardingSlide2Body =>
      'A quick swipe is all it takes — like who catches your eye, we\'ll tell you the moment it\'s mutual.';

  @override
  String get onboardingSlide3Title => 'Chat instantly';

  @override
  String get onboardingSlide3Body =>
      'Once you match, the conversation starts right away — real-time messages, no waiting around.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get alreadyHaveAccount => 'I already have an account';

  @override
  String get backWithArrow => '← Back';

  @override
  String get nameStepTitle => 'What\'s your name?';

  @override
  String get firstNamePlaceholder => 'First name';

  @override
  String get credentialsStepTitle => 'Set up your login';

  @override
  String get emailPlaceholder => 'Email';

  @override
  String get passwordMinPlaceholder => 'Password (min. 6 characters)';

  @override
  String get ageStepTitle => 'How old are you?';

  @override
  String get agePlaceholder => 'Age';

  @override
  String get interestsStepTitle => 'Pick a few interests';

  @override
  String get photoStepTitle => 'Add a photo';

  @override
  String get photoStepSubtitle =>
      'Optional, but profiles with a real photo get a lot more matches.';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get startSwiping => 'Start swiping';

  @override
  String get settingUpAccount => 'Setting up your account…';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get logIn => 'Log in';

  @override
  String get loggingIn => 'Logging in…';

  @override
  String get genericNetworkError => 'Couldn\'t reach the server. Try again.';

  @override
  String get passwordPlaceholder => 'Password';

  @override
  String get takeAPhoto => 'Take a photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get filtersLabel => 'Filters';

  @override
  String get undoLabel => 'Undo';

  @override
  String get passLabel => 'Pass';

  @override
  String get superlikeLabel => 'Superlike';

  @override
  String get likeLabel => 'Like';

  @override
  String get findingPeopleNearby => 'Finding people nearby…';

  @override
  String get discoverLoadErrorTitle => 'Couldn\'t load Discover';

  @override
  String get tryAgain => 'Try again';

  @override
  String get allCaughtUpTitle => 'You\'re all caught up';

  @override
  String get allCaughtUpMessage =>
      'That\'s everyone nearby for now. New people show up here as they join — check back soon.';

  @override
  String get refresh => 'Refresh';

  @override
  String get stampLike => 'LIKE';

  @override
  String get stampNope => 'NOPE';

  @override
  String get stampSuperlike => 'SUPER LIKE';

  @override
  String get backLabel => 'Back';

  @override
  String get maximumDistance => 'Maximum distance';

  @override
  String distanceValueKm(int value) {
    return '$value km';
  }

  @override
  String distanceAwayKm(String value) {
    return '$value km away';
  }

  @override
  String get ageRange => 'Age range';

  @override
  String ageRangeValue(int max) {
    return '18 - $max';
  }

  @override
  String get showMe => 'Show me';

  @override
  String get genderWomen => 'Women';

  @override
  String get genderMen => 'Men';

  @override
  String get genderEveryone => 'Everyone';

  @override
  String get verifiedProfilesOnly => 'Verified profiles only';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get chatTitle => 'Chat';

  @override
  String get noConversationsYet =>
      'No conversations yet. Match with someone on Discover to start chatting.';

  @override
  String get sayHiPreview => 'Say hi 👋';

  @override
  String get sendMessagePlaceholder => 'Send a message';

  @override
  String get sendLabel => 'Send';

  @override
  String matchedEmptyState(String name) {
    return 'You matched with $name. Say hi 👋';
  }

  @override
  String get matchesTitle => 'Matches';

  @override
  String get noMatchesYet =>
      'Your matches will show up here. Get swiping on Discover.';

  @override
  String get searchPlaceholder => 'Search by name or interest';

  @override
  String get noSearchResults => 'No one matches that yet.';

  @override
  String get aboutSection => 'About';

  @override
  String get addBioPrompt => 'Add a bio so people know a little about you.';

  @override
  String get interestsSection => 'Interests';

  @override
  String get noInterestsYet => 'No interests added yet.';

  @override
  String get bioEditPlaceholder => 'A little about you';

  @override
  String get saveLabel => 'Save';

  @override
  String get savingLabel => 'Saving…';

  @override
  String get editProfileRow => 'Edit profile';

  @override
  String get notificationsRow => 'Notifications';

  @override
  String get privacySafetyRow => 'Privacy & safety';

  @override
  String get subscriptionRow => 'Subscription';

  @override
  String get serverRow => 'Server';

  @override
  String get logOutRow => 'Log out';

  @override
  String get editPhotoLabel => 'Edit photo';

  @override
  String get verifiedBadge => 'Verified';

  @override
  String get languageRow => 'Language';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePolish => 'Polski';

  @override
  String get itsAMatch => 'It\'s a match!';

  @override
  String matchedWithMessage(String name) {
    return 'You and $name liked each other.';
  }

  @override
  String get sendAMessage => 'Send a Message';

  @override
  String get keepSwiping => 'Keep Swiping';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsNewMatches => 'New matches';

  @override
  String get notificationsNewMatchesDesc =>
      'Get notified the moment someone matches with you.';

  @override
  String get notificationsNewMessages => 'New messages';

  @override
  String get notificationsNewMessagesDesc =>
      'Get notified when a match sends you a message.';

  @override
  String get notificationsLikes => 'Likes';

  @override
  String get notificationsLikesDesc =>
      'Get notified when someone likes your profile.';

  @override
  String get notificationsAppUpdates => 'App updates';

  @override
  String get notificationsAppUpdatesDesc =>
      'News about new features and improvements.';

  @override
  String get privacyTitle => 'Privacy & safety';

  @override
  String get privacyShowDistance => 'Show my distance';

  @override
  String get privacyShowDistanceDesc =>
      'Let other people see how far away you are.';

  @override
  String get privacyShowOnlineStatus => 'Show online status';

  @override
  String get privacyShowOnlineStatusDesc =>
      'Let your matches see when you\'re active.';

  @override
  String get privacyReadReceipts => 'Read receipts';

  @override
  String get privacyReadReceiptsDesc =>
      'Let matches see when you\'ve read their messages.';

  @override
  String get privacyBlockedSection => 'Blocked accounts';

  @override
  String get privacyNoBlockedUsers => 'You haven\'t blocked anyone.';

  @override
  String get subscriptionTitle => 'Subscription';

  @override
  String get subscriptionHeadline => 'Crushap Plus';

  @override
  String get subscriptionSubtitle =>
      'Unlock the full experience and get noticed faster.';

  @override
  String get subscriptionFeatureUnlimitedLikes => 'Unlimited likes';

  @override
  String get subscriptionFeatureSeeWhoLikesYou => 'See who likes you';

  @override
  String get subscriptionFeatureRewind => 'Rewind your last swipe';

  @override
  String get subscriptionFeatureBoost => 'Monthly profile boost';

  @override
  String get subscriptionPrice => '\$9.99 / month';

  @override
  String get subscriptionCta => 'Notify me when it\'s ready';

  @override
  String get subscriptionComingSoon =>
      'Crushap Plus is in the works — this screen shows what\'s coming, but nothing will be charged today.';

  @override
  String get subscriptionNotifyConfirmed =>
      'You\'re on the list — we\'ll let you know.';
}
