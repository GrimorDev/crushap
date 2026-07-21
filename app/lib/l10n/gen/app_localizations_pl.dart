// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get serverSetupTitle => 'Połącz się z serwerem';

  @override
  String get serverSetupDescription =>
      'Podaj adres Twojego serwera Crushap (zobacz DEPLOYMENT.md) — coś w stylu http://203.0.113.5:3000.';

  @override
  String get serverSetupPlaceholder => 'http://adres-twojego-serwera:3000';

  @override
  String get serverSetupErrorFormat =>
      'Podaj adres zaczynający się od http:// lub https://';

  @override
  String get serverSetupErrorUnreachable =>
      'Nie udało się połączyć z serwerem. Sprawdź adres i czy serwer działa.';

  @override
  String get continueLabel => 'Dalej';

  @override
  String get checkingLabel => 'Sprawdzanie…';

  @override
  String get onboardingHeadline =>
      'Znajdź swoją iskrę już dziś. Bez gierek, tylko prawdziwe dopasowania.';

  @override
  String get onboardingSlide2Title => 'Przesuń. Dopasuj. Poznaj.';

  @override
  String get onboardingSlide2Body =>
      'Wystarczy jedno przesunięcie — polub osobę, która przyciągnie Twój wzrok, a my damy Ci znać, gdy to wzajemne.';

  @override
  String get onboardingSlide3Title => 'Rozmawiaj od razu';

  @override
  String get onboardingSlide3Body =>
      'Gdy tylko się dopasujecie, rozmowa zaczyna się natychmiast — wiadomości na żywo, bez czekania.';

  @override
  String get getStarted => 'Zaczynajmy';

  @override
  String get alreadyHaveAccount => 'Mam już konto';

  @override
  String get backWithArrow => 'Wstecz';

  @override
  String get nameStepTitle => 'Jak masz na imię?';

  @override
  String get firstNamePlaceholder => 'Imię';

  @override
  String get credentialsStepTitle => 'Skonfiguruj logowanie';

  @override
  String get emailPlaceholder => 'E-mail';

  @override
  String get passwordMinPlaceholder => 'Hasło (min. 6 znaków)';

  @override
  String get ageStepTitle => 'Ile masz lat?';

  @override
  String get agePlaceholder => 'Wiek';

  @override
  String get genderStepTitle => 'Co najlepiej Cię opisuje?';

  @override
  String get genderIdentityWoman => 'Kobieta';

  @override
  String get genderIdentityMan => 'Mężczyzna';

  @override
  String get genderIdentityNonBinary => 'Niebinarna/-y';

  @override
  String get interestsStepTitle => 'Wybierz kilka zainteresowań';

  @override
  String get photoStepTitle => 'Dodaj zdjęcie';

  @override
  String get photoStepSubtitle =>
      'Opcjonalne, ale profile z prawdziwym zdjęciem dostają dużo więcej dopasowań.';

  @override
  String get skipForNow => 'Pomiń na razie';

  @override
  String get startSwiping => 'Zacznij przesuwać';

  @override
  String get settingUpAccount => 'Konfigurowanie konta…';

  @override
  String get locationStepTitle => 'Udostępnij lokalizację';

  @override
  String get locationStepSubtitle =>
      'Zobacz prawdziwe odległości do osób w pobliżu i korzystaj z filtra odległości — to nigdy nie jest udostępniane jako dokładny adres, tylko używane do obliczenia dystansu.';

  @override
  String get locationSharedConfirmation =>
      'Gotowe — odległości będą wyświetlane dokładnie.';

  @override
  String get shareMyLocation => 'Udostępnij lokalizację';

  @override
  String get locatingLabel => 'Lokalizowanie…';

  @override
  String get welcomeBack => 'Witaj ponownie';

  @override
  String get logIn => 'Zaloguj się';

  @override
  String get loggingIn => 'Logowanie…';

  @override
  String get genericNetworkError =>
      'Nie udało się połączyć z serwerem. Spróbuj ponownie.';

  @override
  String get passwordPlaceholder => 'Hasło';

  @override
  String get takeAPhoto => 'Zrób zdjęcie';

  @override
  String get chooseFromGallery => 'Wybierz z galerii';

  @override
  String get cancelLabel => 'Anuluj';

  @override
  String get discoverTitle => 'Odkrywaj';

  @override
  String get filtersLabel => 'Filtry';

  @override
  String get filtersWidenedNotice =>
      'Trochę poszerzyliśmy wyszukiwanie, by znaleźć więcej osób.';

  @override
  String get undoLabel => 'Cofnij';

  @override
  String get passLabel => 'Pomiń';

  @override
  String get superlikeLabel => 'Super polubienie';

  @override
  String get likeLabel => 'Polub';

  @override
  String get findingPeopleNearby => 'Szukamy ludzi w pobliżu…';

  @override
  String get discoverLoadErrorTitle => 'Nie udało się wczytać';

  @override
  String get tryAgain => 'Spróbuj ponownie';

  @override
  String get allCaughtUpTitle => 'To wszyscy na teraz';

  @override
  String get allCaughtUpMessage =>
      'To już wszyscy w pobliżu. Nowe osoby pojawią się tu, gdy dołączą — zajrzyj później.';

  @override
  String get refresh => 'Odśwież';

  @override
  String get stampLike => 'POLUBIENIE';

  @override
  String get stampNope => 'PAS';

  @override
  String get stampSuperlike => 'SUPER POLUBIENIE';

  @override
  String get backLabel => 'Wstecz';

  @override
  String get maximumDistance => 'Maksymalna odległość';

  @override
  String distanceValueKm(int value) {
    return '$value km';
  }

  @override
  String distanceAwayKm(String value) {
    return '$value km stąd';
  }

  @override
  String get ageRange => 'Zakres wieku';

  @override
  String ageRangeValue(int max) {
    return '18 - $max';
  }

  @override
  String get showMe => 'Pokazuj mi';

  @override
  String get genderWomen => 'Kobiety';

  @override
  String get genderMen => 'Mężczyzn';

  @override
  String get genderEveryone => 'Wszystkich';

  @override
  String get verifiedProfilesOnly => 'Tylko zweryfikowane profile';

  @override
  String get hasPhotoOnly => 'Ma zdjęcie';

  @override
  String get refreshMyLocation => 'Odśwież moją lokalizację';

  @override
  String get applyFilters => 'Zastosuj filtry';

  @override
  String get chatTitle => 'Czat';

  @override
  String get noConversationsYet =>
      'Brak rozmów. Dopasuj się z kimś w Odkrywaj, żeby zacząć czatować.';

  @override
  String get sayHiPreview => 'Przywitaj się 👋';

  @override
  String get sendMessagePlaceholder => 'Napisz wiadomość';

  @override
  String get sendLabel => 'Wyślij';

  @override
  String matchedEmptyState(String name) {
    return 'Dopasowano Cię z $name. Przywitaj się 👋';
  }

  @override
  String get matchesTitle => 'Dopasowania';

  @override
  String get noMatchesYet =>
      'Twoje dopasowania pojawią się tutaj. Zacznij przesuwać w Odkrywaj.';

  @override
  String get searchPlaceholder => 'Szukaj po imieniu lub zainteresowaniu';

  @override
  String get noSearchResults => 'Nikt jeszcze nie pasuje.';

  @override
  String get aboutSection => 'O mnie';

  @override
  String get addBioPrompt => 'Dodaj opis, żeby inni mogli Cię lepiej poznać.';

  @override
  String get genderSection => 'Płeć';

  @override
  String get genderNotSet =>
      'Jeszcze nie ustawiono — dotknij „Edytuj profil”, aby dodać.';

  @override
  String get interestsSection => 'Zainteresowania';

  @override
  String get noInterestsYet => 'Nie dodano jeszcze zainteresowań.';

  @override
  String get bioEditPlaceholder => 'Napisz coś o sobie';

  @override
  String get saveLabel => 'Zapisz';

  @override
  String get savingLabel => 'Zapisywanie…';

  @override
  String get editProfileRow => 'Edytuj profil';

  @override
  String get notificationsRow => 'Powiadomienia';

  @override
  String get privacySafetyRow => 'Prywatność i bezpieczeństwo';

  @override
  String get subscriptionRow => 'Subskrypcja';

  @override
  String get serverRow => 'Serwer';

  @override
  String get logOutRow => 'Wyloguj się';

  @override
  String get editPhotoLabel => 'Zmień zdjęcie';

  @override
  String get addPhotoLabel => 'Dodaj zdjęcie';

  @override
  String get removePhotoLabel => 'Usuń zdjęcie';

  @override
  String get verifiedBadge => 'Zweryfikowany';

  @override
  String get languageRow => 'Język';

  @override
  String get languageSystem => 'Systemowy';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePolish => 'Polski';

  @override
  String get itsAMatch => 'To dopasowanie!';

  @override
  String matchedWithMessage(String name) {
    return 'Ty i $name polubiliście się nawzajem.';
  }

  @override
  String get sendAMessage => 'Wyślij wiadomość';

  @override
  String get keepSwiping => 'Przesuwaj dalej';

  @override
  String get notificationsTitle => 'Powiadomienia';

  @override
  String get notificationsNewMatches => 'Nowe dopasowania';

  @override
  String get notificationsNewMatchesDesc =>
      'Otrzymuj powiadomienie, gdy tylko ktoś się z Tobą dopasuje.';

  @override
  String get notificationsNewMessages => 'Nowe wiadomości';

  @override
  String get notificationsNewMessagesDesc =>
      'Otrzymuj powiadomienie, gdy dopasowanie wyśle Ci wiadomość.';

  @override
  String get notificationsLikes => 'Polubienia';

  @override
  String get notificationsLikesDesc =>
      'Otrzymuj powiadomienie, gdy ktoś polubi Twój profil.';

  @override
  String get notificationsAppUpdates => 'Aktualizacje aplikacji';

  @override
  String get notificationsAppUpdatesDesc =>
      'Nowości o nowych funkcjach i ulepszeniach.';

  @override
  String get privacyTitle => 'Prywatność i bezpieczeństwo';

  @override
  String get privacyShowDistance => 'Pokazuj moją odległość';

  @override
  String get privacyShowDistanceDesc =>
      'Pozwól innym widzieć, jak daleko się znajdujesz.';

  @override
  String get privacyShowOnlineStatus => 'Pokazuj status online';

  @override
  String get privacyShowOnlineStatusDesc =>
      'Pozwól swoim dopasowaniom widzieć, kiedy jesteś aktywny(-a).';

  @override
  String get privacyReadReceipts => 'Potwierdzenia odczytania';

  @override
  String get privacyReadReceiptsDesc =>
      'Pozwól dopasowaniom widzieć, że przeczytałeś(-aś) ich wiadomości.';

  @override
  String get privacyBlockedSection => 'Zablokowane konta';

  @override
  String get privacyNoBlockedUsers => 'Nikogo jeszcze nie zablokowano.';

  @override
  String get subscriptionTitle => 'Subskrypcja';

  @override
  String get subscriptionHeadline => 'Crushap Plus';

  @override
  String get subscriptionSubtitle =>
      'Odblokuj pełne możliwości i daj się zauważyć szybciej.';

  @override
  String get subscriptionFeatureUnlimitedLikes => 'Nielimitowane polubienia';

  @override
  String get subscriptionFeatureSeeWhoLikesYou => 'Zobacz, kto Cię polubił';

  @override
  String get subscriptionFeatureRewind => 'Cofnij ostatnie przesunięcie';

  @override
  String get subscriptionFeatureBoost => 'Comiesięczny boost profilu';

  @override
  String get subscriptionPrice => '39,99 zł / miesiąc';

  @override
  String get subscriptionCta => 'Powiadom mnie, gdy będzie gotowe';

  @override
  String get subscriptionComingSoon =>
      'Crushap Plus jest w przygotowaniu — ten ekran pokazuje, co nadchodzi, ale dziś nic nie zostanie pobrane.';

  @override
  String get subscriptionNotifyConfirmed => 'Jesteś na liście — damy Ci znać.';
}
