///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsDa extends Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsDa({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.da,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <da>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  late final TranslationsDa _root = this; // ignore: unused_field

  @override
  TranslationsDa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDa(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'LocalSend';
  @override
  late final _Translations$general$da general = _Translations$general$da._(_root);
  @override
  late final _Translations$receiveTab$da receiveTab = _Translations$receiveTab$da._(_root);
  @override
  late final _Translations$sendTab$da sendTab = _Translations$sendTab$da._(_root);
  @override
  late final _Translations$settingsTab$da settingsTab = _Translations$settingsTab$da._(_root);
  @override
  late final _Translations$troubleshootPage$da troubleshootPage = _Translations$troubleshootPage$da._(_root);
  @override
  late final _Translations$networkInterfacesPage$da networkInterfacesPage = _Translations$networkInterfacesPage$da._(_root);
  @override
  late final _Translations$receiveHistoryPage$da receiveHistoryPage = _Translations$receiveHistoryPage$da._(_root);
  @override
  late final _Translations$apkPickerPage$da apkPickerPage = _Translations$apkPickerPage$da._(_root);
  @override
  late final _Translations$selectedFilesPage$da selectedFilesPage = _Translations$selectedFilesPage$da._(_root);
  @override
  late final _Translations$deviceDetailsPage$da deviceDetailsPage = _Translations$deviceDetailsPage$da._(_root);
  @override
  late final _Translations$verifyPage$da verifyPage = _Translations$verifyPage$da._(_root);
  @override
  late final _Translations$receivePage$da receivePage = _Translations$receivePage$da._(_root);
  @override
  late final _Translations$receiveOptionsPage$da receiveOptionsPage = _Translations$receiveOptionsPage$da._(_root);
  @override
  late final _Translations$sendPage$da sendPage = _Translations$sendPage$da._(_root);
  @override
  late final _Translations$progressPage$da progressPage = _Translations$progressPage$da._(_root);
  @override
  late final _Translations$webSharePage$da webSharePage = _Translations$webSharePage$da._(_root);
  @override
  late final _Translations$webReceivePage$da webReceivePage = _Translations$webReceivePage$da._(_root);
  @override
  late final _Translations$aboutPage$da aboutPage = _Translations$aboutPage$da._(_root);
  @override
  late final _Translations$donationPage$da donationPage = _Translations$donationPage$da._(_root);
  @override
  late final _Translations$changelogPage$da changelogPage = _Translations$changelogPage$da._(_root);
  @override
  late final _Translations$whatsNewPage$da whatsNewPage = _Translations$whatsNewPage$da._(_root);
  @override
  late final _Translations$dialogs$da dialogs = _Translations$dialogs$da._(_root);
  @override
  late final _Translations$sanitization$da sanitization = _Translations$sanitization$da._(_root);
  @override
  late final _Translations$tray$da tray = _Translations$tray$da._(_root);
  @override
  late final _Translations$web$da web = _Translations$web$da._(_root);
  @override
  late final _Translations$assetPicker$da assetPicker = _Translations$assetPicker$da._(_root);
}

// Path: general
class _Translations$general$da extends Translations$general$en {
  _Translations$general$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get accept => 'Acceptér';
  @override
  String get accepted => 'Accepteret';
  @override
  String get add => 'Tilføj';
  @override
  String get advanced => 'Avanceret';
  @override
  String get cancel => 'Afbryd';
  @override
  String get close => 'Luk';
  @override
  String get confirm => 'Bekræft';
  @override
  String get continueStr => 'Fortsæt';
  @override
  String get copy => 'Kopiér';
  @override
  String get copiedToClipboard => 'Kopieret til udklipsholder';
  @override
  String get decline => 'Afvis';
  @override
  String get done => 'Færdig';
  @override
  String get delete => 'Slet';
  @override
  String get edit => 'Rediger';
  @override
  String get error => 'Fejl';
  @override
  String get example => 'Eksempel';
  @override
  String get files => 'Filer';
  @override
  String get finished => 'Fuldført';
  @override
  String get hide => 'Skjul';
  @override
  String get off => 'Fra';
  @override
  String get offline => 'Offline';
  @override
  String get on => 'Til';
  @override
  String get online => 'Online';
  @override
  String get open => 'Åbn';
  @override
  String get queue => 'Kø';
  @override
  String get quickSave => 'Gem hurtigt';
  @override
  String get quickSaveFromFavorites => 'Gem hurtigt til "Favoritter"';
  @override
  String get renamed => 'Omdøbt';
  @override
  String get reset => 'Fortryd ændringer';
  @override
  String get restart => 'Genstart';
  @override
  String get settings => 'Indstillinger';
  @override
  String get skipped => 'Sprunget over';
  @override
  String get start => 'Start';
  @override
  String get stop => 'Stop';
  @override
  String get save => 'Gem';
  @override
  String get unchanged => 'Uændret';
  @override
  String get unknown => 'Ukendt';
  @override
  String get noItemInClipboard => 'Ingen elementer i udklipsholder.';
}

// Path: receiveTab
class _Translations$receiveTab$da extends Translations$receiveTab$en {
  _Translations$receiveTab$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Modtag';
  @override
  late final _Translations$receiveTab$infoBox$da infoBox = _Translations$receiveTab$infoBox$da._(_root);
  @override
  late final _Translations$receiveTab$quickSave$da quickSave = _Translations$receiveTab$quickSave$da._(_root);
  @override
  String get link => 'Modtag via link';
}

// Path: sendTab
class _Translations$sendTab$da extends Translations$sendTab$en {
  _Translations$sendTab$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Send';
  @override
  late final _Translations$sendTab$selection$da selection = _Translations$sendTab$selection$da._(_root);
  @override
  late final _Translations$sendTab$picker$da picker = _Translations$sendTab$picker$da._(_root);
  @override
  String get shareIntentInfo => 'Du kan også bruge din mobilenheds "Del"-funktion til nemmere at vælge filer.';
  @override
  String get nearbyDevices => 'Enheder i nærheden';
  @override
  String get thisDevice => 'Denne enhed';
  @override
  String get scan => 'Søg efter enheder';
  @override
  String get manualSending => 'Manuel afsendelse';
  @override
  String get sendMode => 'Send-tilstand';
  @override
  late final _Translations$sendTab$sendModes$da sendModes = _Translations$sendTab$sendModes$da._(_root);
  @override
  String get sendModeHelp => 'Forklaring';
  @override
  String get help => 'Sørg for, at den ønskede enhed er på det samme Wi-Fi-netværk.';
  @override
  String get placeItems => 'Placer filer til deling.';
  @override
  late final _Translations$sendTab$diagnosis$da diagnosis = _Translations$sendTab$diagnosis$da._(_root);
}

// Path: settingsTab
class _Translations$settingsTab$da extends Translations$settingsTab$en {
  _Translations$settingsTab$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Indstillinger';
  @override
  late final _Translations$settingsTab$general$da general = _Translations$settingsTab$general$da._(_root);
  @override
  late final _Translations$settingsTab$receive$da receive = _Translations$settingsTab$receive$da._(_root);
  @override
  late final _Translations$settingsTab$send$da send = _Translations$settingsTab$send$da._(_root);
  @override
  late final _Translations$settingsTab$network$da network = _Translations$settingsTab$network$da._(_root);
  @override
  late final _Translations$settingsTab$other$da other = _Translations$settingsTab$other$da._(_root);
  @override
  String get advancedSettings => 'Avancerede indstillinger';
}

// Path: troubleshootPage
class _Translations$troubleshootPage$da extends Translations$troubleshootPage$en {
  _Translations$troubleshootPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Fejlsøgning';
  @override
  String get subTitle => 'Fungerer appen ikke som forventet? Her finder du løsninger på almindelige problemer.';
  @override
  String get solution => 'Løsning:';
  @override
  String get fixButton => 'Løs automatisk';
  @override
  late final _Translations$troubleshootPage$firewall$da firewall = _Translations$troubleshootPage$firewall$da._(_root);
  @override
  late final _Translations$troubleshootPage$noDiscovery$da noDiscovery = _Translations$troubleshootPage$noDiscovery$da._(_root);
  @override
  late final _Translations$troubleshootPage$noConnection$da noConnection = _Translations$troubleshootPage$noConnection$da._(_root);
}

// Path: networkInterfacesPage
class _Translations$networkInterfacesPage$da extends Translations$networkInterfacesPage$en {
  _Translations$networkInterfacesPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Netværksgrænseflader';
  @override
  String get info =>
      'Som standard bruger LocalSend alle tilgængelige netværksgrænseflader. Du kan ekskludere uønskede netværk her. Du skal genstarte serveren for at anvende ændringerne.';
  @override
  String get preview => 'Forhåndsvisning';
  @override
  String get whitelist => 'Hvidliste';
  @override
  String get blacklist => 'Sortliste';
}

// Path: receiveHistoryPage
class _Translations$receiveHistoryPage$da extends Translations$receiveHistoryPage$en {
  _Translations$receiveHistoryPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Historik';
  @override
  String get openFolder => 'Åbn mappe';
  @override
  String get deleteHistory => 'Slet historik';
  @override
  String get empty => 'Historikken er tom.';
  @override
  late final _Translations$receiveHistoryPage$entryActions$da entryActions = _Translations$receiveHistoryPage$entryActions$da._(_root);
}

// Path: apkPickerPage
class _Translations$apkPickerPage$da extends Translations$apkPickerPage$en {
  _Translations$apkPickerPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Apps (APK)';
  @override
  String get excludeSystemApps => 'Ekskluder systemapps';
  @override
  String get excludeAppsWithoutLaunchIntent => 'Ekskluder ikke-startbare apps';
  @override
  String apps({required Object n}) => '${n} Apps';
}

// Path: selectedFilesPage
class _Translations$selectedFilesPage$da extends Translations$selectedFilesPage$en {
  _Translations$selectedFilesPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get deleteAll => 'Slet alle';
}

// Path: deviceDetailsPage
class _Translations$deviceDetailsPage$da extends Translations$deviceDetailsPage$en {
  _Translations$deviceDetailsPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Enhedsdetaljer';
  @override
  String get favorite => 'Favorit';
  @override
  String get verify => 'Verificer';
  @override
  late final _Translations$deviceDetailsPage$info$da info = _Translations$deviceDetailsPage$info$da._(_root);
  @override
  late final _Translations$deviceDetailsPage$logs$da logs = _Translations$deviceDetailsPage$logs$da._(_root);
}

// Path: verifyPage
class _Translations$verifyPage$da extends Translations$verifyPage$en {
  _Translations$verifyPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Verificer';
  @override
  String get icons => 'Ikoner';
  @override
  String get text => 'Tekst';
  @override
  String get question => 'Ser det ens ud på den anden enhed?';
}

// Path: receivePage
class _Translations$receivePage$da extends Translations$receivePage$en {
  _Translations$receivePage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String subTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('da'))(
    n,
    one: 'vil sende dig en fil',
    other: 'vil sende dig ${n} filer',
  );
  @override
  String get subTitleMessage => 'sendte dig en besked:';
  @override
  String get subTitleLink => 'sendte dig et link:';
  @override
  String get canceled => 'Afsenderen har afbrudt delingen.';
}

// Path: receiveOptionsPage
class _Translations$receiveOptionsPage$da extends Translations$receiveOptionsPage$en {
  _Translations$receiveOptionsPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Muligheder';
  @override
  String get destination => _root.settingsTab.receive.destination;
  @override
  String get appDirectory => '(LocalSend mappe)';
  @override
  String get saveToGallery => _root.settingsTab.receive.saveToGallery;
  @override
  String get saveToGalleryOff => 'Slået fra automatisk, fordi der er mapper.';
}

// Path: sendPage
class _Translations$sendPage$da extends Translations$sendPage$en {
  _Translations$sendPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String calculatingChecksum({required Object curr, required Object n}) => 'Beregner kontrolsum (${curr} / ${n})';
  @override
  String get waiting => 'Venter på svar…';
  @override
  String get rejected => 'Modtageren har afvist delingen.';
  @override
  String get tooManyAttempts => _root.web.tooManyAttempts;
  @override
  String get busy => 'Modtageren er optaget med en anden deling.';
}

// Path: progressPage
class _Translations$progressPage$da extends Translations$progressPage$en {
  _Translations$progressPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get titleSending => 'Sender filer';
  @override
  String get titleReceiving => 'Modtager filer';
  @override
  String get savedToGallery => 'Gemt i fotos';
  @override
  late final _Translations$progressPage$checksum$da checksum = _Translations$progressPage$checksum$da._(_root);
  @override
  late final _Translations$progressPage$total$da total = _Translations$progressPage$total$da._(_root);
  @override
  late final _Translations$progressPage$remainingTime$da remainingTime = _Translations$progressPage$remainingTime$da._(_root);
}

// Path: webSharePage
class _Translations$webSharePage$da extends Translations$webSharePage$en {
  _Translations$webSharePage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Del med link';
  @override
  String get loading => 'Starter server…';
  @override
  String get stopping => 'Stopper server…';
  @override
  String get error => 'En fejl opstod, mens serveren blev startet.';
  @override
  String openLink({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('da'))(
    n,
    one: 'Åbn dette link i din browser:',
    other: 'Åbn et af disse links i din browser:',
  );
  @override
  String get requests => 'Forespørgsler';
  @override
  String get noRequests => 'Ingen forespørgsler endnu.';
  @override
  String get encryption => _root.settingsTab.network.encryption;
  @override
  String get autoAccept => 'Accepter automatisk anmodninger';
  @override
  String get requirePin => 'Kræv PIN-kode';
  @override
  String pinHint({required Object pin}) => 'PIN-koden er "${pin}"';
  @override
  String get encryptionHint => 'LocalSend bruger et selvsigneret certifikat. Du skal acceptere det i din browser.';
  @override
  String pendingRequests({required Object n}) => 'Afventende forespørgsler: ${n}';
}

// Path: webReceivePage
class _Translations$webReceivePage$da extends Translations$webReceivePage$en {
  _Translations$webReceivePage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Modtag via link';
}

// Path: aboutPage
class _Translations$aboutPage$da extends Translations$aboutPage$en {
  _Translations$aboutPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Om LocalSend';
  @override
  List<String> get description => [
    'LocalSend er en gratis, open source-app, der lader dig dele filer og beskeder sikkert med enheder i nærheden over dit lokale netværk uden behov for en internetforbindelse.',
    'Appen er tilgængelig på Android, iOS, macOS, Windows og Linux. Du finder alle downloadmuligheder på den officielle hjemmeside.',
  ];
  @override
  String get author => 'Skaber';
  @override
  String get contributors => 'Bidragydere';
  @override
  String get packagers => 'Pakkere';
  @override
  String get translators => 'Oversættere';
}

// Path: donationPage
class _Translations$donationPage$da extends Translations$donationPage$en {
  _Translations$donationPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Donér';
  @override
  String get info => 'LocalSend er gratis, open source og uden annoncer. Hvis du kan lide appen, kan du støtte udviklingen med en donation.';
  @override
  String donate({required Object amount}) => 'Donér ${amount}';
  @override
  String get thanks => 'Tusind tak for din støtte!';
  @override
  String get restore => 'Gendan køb';
}

// Path: changelogPage
class _Translations$changelogPage$da extends Translations$changelogPage$en {
  _Translations$changelogPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ændringslog';
}

// Path: whatsNewPage
class _Translations$whatsNewPage$da extends Translations$whatsNewPage$en {
  _Translations$whatsNewPage$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String title({required Object version}) => 'Nyheder i ${version}';
  @override
  late final _Translations$whatsNewPage$changes$da changes = _Translations$whatsNewPage$changes$da._(_root);
}

// Path: dialogs
class _Translations$dialogs$da extends Translations$dialogs$en {
  _Translations$dialogs$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$dialogs$addFile$da addFile = _Translations$dialogs$addFile$da._(_root);
  @override
  late final _Translations$dialogs$openFile$da openFile = _Translations$dialogs$openFile$da._(_root);
  @override
  late final _Translations$dialogs$addressInput$da addressInput = _Translations$dialogs$addressInput$da._(_root);
  @override
  late final _Translations$dialogs$cancelSession$da cancelSession = _Translations$dialogs$cancelSession$da._(_root);
  @override
  late final _Translations$dialogs$connectionError$da connectionError = _Translations$dialogs$connectionError$da._(_root);
  @override
  late final _Translations$dialogs$deleteSourceAfterSendDialog$da deleteSourceAfterSendDialog =
      _Translations$dialogs$deleteSourceAfterSendDialog$da._(_root);
  @override
  late final _Translations$dialogs$cannotOpenFile$da cannotOpenFile = _Translations$dialogs$cannotOpenFile$da._(_root);
  @override
  late final _Translations$dialogs$encryptionDisabledNotice$da encryptionDisabledNotice = _Translations$dialogs$encryptionDisabledNotice$da._(_root);
  @override
  late final _Translations$dialogs$errorDialog$da errorDialog = _Translations$dialogs$errorDialog$da._(_root);
  @override
  late final _Translations$dialogs$favoriteDialog$da favoriteDialog = _Translations$dialogs$favoriteDialog$da._(_root);
  @override
  late final _Translations$dialogs$favoriteDeleteDialog$da favoriteDeleteDialog = _Translations$dialogs$favoriteDeleteDialog$da._(_root);
  @override
  late final _Translations$dialogs$favoriteEditDialog$da favoriteEditDialog = _Translations$dialogs$favoriteEditDialog$da._(_root);
  @override
  late final _Translations$dialogs$fileInfo$da fileInfo = _Translations$dialogs$fileInfo$da._(_root);
  @override
  late final _Translations$dialogs$fileNameInput$da fileNameInput = _Translations$dialogs$fileNameInput$da._(_root);
  @override
  late final _Translations$dialogs$historyClearDialog$da historyClearDialog = _Translations$dialogs$historyClearDialog$da._(_root);
  @override
  late final _Translations$dialogs$localNetworkUnauthorized$da localNetworkUnauthorized = _Translations$dialogs$localNetworkUnauthorized$da._(_root);
  @override
  late final _Translations$dialogs$messageInput$da messageInput = _Translations$dialogs$messageInput$da._(_root);
  @override
  late final _Translations$dialogs$noFiles$da noFiles = _Translations$dialogs$noFiles$da._(_root);
  @override
  late final _Translations$dialogs$noPermission$da noPermission = _Translations$dialogs$noPermission$da._(_root);
  @override
  late final _Translations$dialogs$notAvailableOnPlatform$da notAvailableOnPlatform = _Translations$dialogs$notAvailableOnPlatform$da._(_root);
  @override
  late final _Translations$dialogs$qr$da qr = _Translations$dialogs$qr$da._(_root);
  @override
  late final _Translations$dialogs$quickActions$da quickActions = _Translations$dialogs$quickActions$da._(_root);
  @override
  late final _Translations$dialogs$quickSaveNotice$da quickSaveNotice = _Translations$dialogs$quickSaveNotice$da._(_root);
  @override
  late final _Translations$dialogs$quickSaveFromFavoritesNotice$da quickSaveFromFavoritesNotice =
      _Translations$dialogs$quickSaveFromFavoritesNotice$da._(_root);
  @override
  late final _Translations$dialogs$pin$da pin = _Translations$dialogs$pin$da._(_root);
  @override
  late final _Translations$dialogs$sendModeHelp$da sendModeHelp = _Translations$dialogs$sendModeHelp$da._(_root);
  @override
  late final _Translations$dialogs$startupError$da startupError = _Translations$dialogs$startupError$da._(_root);
  @override
  late final _Translations$dialogs$zoom$da zoom = _Translations$dialogs$zoom$da._(_root);
}

// Path: sanitization
class _Translations$sanitization$da extends Translations$sanitization$en {
  _Translations$sanitization$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get empty => 'Filnavn må ikke være tomt';
  @override
  String get invalid => 'Filnavn indeholder ugyldige tegn';
}

// Path: tray
class _Translations$tray$da extends Translations$tray$en {
  _Translations$tray$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get open => _root.general.open;
  @override
  String get close => 'Afslut LocalSend';
  @override
  String get closeWindows => 'Luk';
}

// Path: web
class _Translations$web$da extends Translations$web$en {
  _Translations$web$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get waiting => _root.sendPage.waiting;
  @override
  String get enterPin => 'Indtast PIN-kode';
  @override
  String get invalidPin => 'Ugyldig PIN-kode';
  @override
  String get tooManyAttempts => 'For mange forsøg';
  @override
  String get rejected => 'Afvist';
  @override
  String get files => 'Filer';
  @override
  String get fileName => 'Filnavn';
  @override
  String get size => 'Størrelse';
}

// Path: assetPicker
class _Translations$assetPicker$da extends Translations$assetPicker$en {
  _Translations$assetPicker$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get confirm => 'Bekræft';
  @override
  String get cancel => 'Afbryd';
  @override
  String get edit => 'Rediger';
  @override
  String get gifIndicator => 'GIF';
  @override
  String get loadFailed => 'Indlæsning mislykkedes';
  @override
  String get original => 'Original';
  @override
  String get preview => 'Forhåndsvisning';
  @override
  String get select => 'Vælg';
  @override
  String get emptyList => 'Tom liste';
  @override
  String get unSupportedAssetType => 'Ikke-understøttet filtype.';
  @override
  String get unableToAccessAll => 'Kan ikke tilgå alle filer på enheden';
  @override
  String get viewingLimitedAssetsTip => 'Vis kun filer og mapper tilgængelige for appen.';
  @override
  String get changeAccessibleLimitedAssets => 'Klik for at opdatere tilgængelige filer';
  @override
  String get accessAllTip =>
      'Appen kan kun tilgå nogle filer på enheden. Gå til systemindstillingerne, og giv den adgang til alle medier på enheden.';
  @override
  String get goToSystemSettings => 'Gå til systemindstillinger';
  @override
  String get accessLimitedAssets => 'Fortsæt med begrænset adgang';
  @override
  String get accessiblePathName => 'Tilgængelige filer';
  @override
  String get sTypeAudioLabel => 'Lyd';
  @override
  String get sTypeImageLabel => 'Billede';
  @override
  String get sTypeVideoLabel => 'Video';
  @override
  String get sTypeOtherLabel => 'Andre medier';
  @override
  String get sActionPlayHint => 'Afspil';
  @override
  String get sActionPreviewHint => 'Forhåndsvisning';
  @override
  String get sActionSelectHint => 'Vælg';
  @override
  String get sActionSwitchPathLabel => 'Ændr filsti';
  @override
  String get sActionUseCameraHint => 'Brug kamera';
  @override
  String get sNameDurationLabel => 'Varighed';
  @override
  String get sUnitAssetCountLabel => 'Antal';
}

// Path: receiveTab.infoBox
class _Translations$receiveTab$infoBox$da extends Translations$receiveTab$infoBox$en {
  _Translations$receiveTab$infoBox$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get ip => 'IP:';
  @override
  String get port => 'Port:';
  @override
  String get alias => 'Enhedsnavn:';
}

// Path: receiveTab.quickSave
class _Translations$receiveTab$quickSave$da extends Translations$receiveTab$quickSave$en {
  _Translations$receiveTab$quickSave$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get off => _root.general.off;
  @override
  String get favorites => 'Favoritter';
  @override
  String get on => _root.general.on;
}

// Path: sendTab.selection
class _Translations$sendTab$selection$da extends Translations$sendTab$selection$en {
  _Translations$sendTab$selection$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Valg';
  @override
  String files({required Object files}) => 'Filer: ${files}';
  @override
  String size({required Object size}) => 'Størrelse: ${size}';
}

// Path: sendTab.picker
class _Translations$sendTab$picker$da extends Translations$sendTab$picker$en {
  _Translations$sendTab$picker$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get file => 'Fil';
  @override
  String get folder => 'Mappe';
  @override
  String get media => 'Medie';
  @override
  String get text => 'Tekst';
  @override
  String get app => 'App';
  @override
  String get clipboard => 'Indsæt';
}

// Path: sendTab.sendModes
class _Translations$sendTab$sendModes$da extends Translations$sendTab$sendModes$en {
  _Translations$sendTab$sendModes$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get single => 'Enkel modtager';
  @override
  String get multiple => 'Flere modtagere';
  @override
  String get link => 'Del med link';
}

// Path: sendTab.diagnosis
class _Translations$sendTab$diagnosis$da extends Translations$sendTab$diagnosis$en {
  _Translations$sendTab$diagnosis$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get scanning => 'Søger efter enheder i nærheden…';
  @override
  late final _Translations$sendTab$diagnosis$noInterface$da noInterface = _Translations$sendTab$diagnosis$noInterface$da._(_root);
  @override
  late final _Translations$sendTab$diagnosis$multicastUnavailable$da multicastUnavailable = _Translations$sendTab$diagnosis$multicastUnavailable$da._(
    _root,
  );
  @override
  late final _Translations$sendTab$diagnosis$scanNoResult$da scanNoResult = _Translations$sendTab$diagnosis$scanNoResult$da._(_root);
  @override
  String get rescan => 'Søg igen';
  @override
  String get bleHint =>
      'BLE-opdagelse er aktiv: Enheder findes kun via Bluetooth, hvis de også kører denne fork med indstillingen slået til; selve overførslen foregår stadig over netværket.';
  @override
  late final _Translations$sendTab$diagnosis$manualFallback$da manualFallback = _Translations$sendTab$diagnosis$manualFallback$da._(_root);
}

// Path: settingsTab.general
class _Translations$settingsTab$general$da extends Translations$settingsTab$general$en {
  _Translations$settingsTab$general$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Generelt';
  @override
  String get brightness => 'Tema';
  @override
  late final _Translations$settingsTab$general$brightnessOptions$da brightnessOptions = _Translations$settingsTab$general$brightnessOptions$da._(
    _root,
  );
  @override
  String get color => 'Farve';
  @override
  late final _Translations$settingsTab$general$colorOptions$da colorOptions = _Translations$settingsTab$general$colorOptions$da._(_root);
  @override
  String get language => 'Sprog';
  @override
  late final _Translations$settingsTab$general$languageOptions$da languageOptions = _Translations$settingsTab$general$languageOptions$da._(_root);
  @override
  String get saveWindowPlacement => 'Gem vinduesposition ved afslutning';
  @override
  String get saveWindowPlacementWindows => 'Gem vinduesposition ved lukning';
  @override
  String get minimizeToTray => 'Minimer til systembakken/menulinjen ved lukning';
  @override
  String get launchAtStartup => 'Autostart efter login';
  @override
  String get launchMinimized => 'Autostart: Start skjult';
  @override
  String get showInContextMenu => 'Vis LocalSend i kontekstmenu';
  @override
  String get animations => 'Animationer';
}

// Path: settingsTab.receive
class _Translations$settingsTab$receive$da extends Translations$settingsTab$receive$en {
  _Translations$settingsTab$receive$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Modtag';
  @override
  String get quickSave => _root.general.quickSave;
  @override
  String get quickSaveFromFavorites => _root.general.quickSaveFromFavorites;
  @override
  String get requirePin => _root.webSharePage.requirePin;
  @override
  String get autoFinish => 'Auto-fuldfør';
  @override
  String get destination => 'Gem til mappe';
  @override
  String get downloads => '(Overførsler)';
  @override
  String get saveToGallery => 'Gem medier til galleri';
  @override
  String get saveToHistory => 'Gem til historik';
  @override
  String get verifyChecksums => 'Verificer kontrolsummer ved modtagelse af filer';
}

// Path: settingsTab.send
class _Translations$settingsTab$send$da extends Translations$settingsTab$send$en {
  _Translations$settingsTab$send$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Send';
  @override
  String get shareViaLinkAutoAccept => 'Acceptér automatisk anmodninger i "Del med link"-tilstand';
  @override
  String get createChecksums => 'Opret kontrolsummer ved afsendelse af filer';
  @override
  String get deleteSourceAfterSend => 'Slet kildefiler efter vellykket afsendelse';
}

// Path: settingsTab.network
class _Translations$settingsTab$network$da extends Translations$settingsTab$network$en {
  _Translations$settingsTab$network$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Netværk';
  @override
  String get needRestart => 'Genstart serveren for at anvende ændringerne!';
  @override
  String get server => 'Server';
  @override
  String get alias => 'Enhedsnavn';
  @override
  String get deviceType => 'Enhedstype';
  @override
  String get deviceModel => 'Enhedsmodel';
  @override
  String get port => 'Port';
  @override
  String get network => 'Netværk';
  @override
  late final _Translations$settingsTab$network$networkOptions$da networkOptions = _Translations$settingsTab$network$networkOptions$da._(_root);
  @override
  String get discoveryTimeout => 'Timeout for søgning';
  @override
  String get maxInterfaces => 'Maks. grænseflader (Smartscanning)';
  @override
  String get vpnInterfaces => 'Medtag VPN-grænseflader (Smartscanning)';
  @override
  String get vpnInterfacesHint =>
      'Scanner også subnettene på VPN-tunnelgrænseflader (Tailscale, WireGuard, ...). VPN-forbindelser understøtter normalt ikke multicast, så deres subnet kontrolleres i stedet med HTTP-fallbackscanningen.';
  @override
  String get useSystemName => 'Brug systemnavn';
  @override
  String get generateRandomAlias => 'Generér tilfældigt alias';
  @override
  String portWarning({required Object defaultPort}) =>
      'Andre enheder registrerer dig muligvis ikke, da du bruger en brugerdefineret port (standard: ${defaultPort}).';
  @override
  String get encryption => 'Kryptering';
  @override
  String get multicastGroup => 'Multicast-adresse';
  @override
  String multicastGroupWarning({required Object defaultMulticast}) =>
      'Andre enheder registrerer dig muligvis ikke, da du bruger en brugerdefineret multicast-adresse (standard: ${defaultMulticast}).';
  @override
  String get bleDiscovery => 'BLE-opdagelse (eksperimentel)';
  @override
  String get bleDiscoveryHint =>
      'Finder enheder i nærheden via Bluetooth, selv når netværket blokerer multicast (AP-isolering). Virker på Android, iOS, macOS og Windows; på Linux kan denne enhed finde andre, men kan ikke selv findes. Begge enheder skal have denne fork med indstillingen slået til; selve filoverførslen bruger stadig netværket.';
  @override
  String get bleStatusActive =>
      'Aktiv: Scanner og annoncerer. Enheder i nærheden vises kun, hvis de også kører denne fork med indstillingen slået til.';
  @override
  String get bleStatusScanOnly =>
      'Aktiv: Kun scanning. Denne enhed kan i øjeblikket ikke opdages via Bluetooth (ingen understøttelse af BLE-advertising på denne platform, eller endnu ingen brugbar netværksadresse).';
  @override
  String get bleStatusPaused => 'På pause. Genoptages, når appen kommer tilbage i forgrunden.';
  @override
  String get bleStatusPermissionDenied =>
      'Bluetooth-tilladelser afvist. Giv tilladelsen "Enheder i nærheden" (eller "Placering" på Android 11 og tidligere) i systemindstillingerne, og slå derefter denne indstilling fra og til igen.';
  @override
  String get bleStatusAdapterOff =>
      'Bluetooth er slukket eller utilgængelig. Opdagelsen genstarter af sig selv, når Bluetooth bliver tilgængelig igen.';
  @override
  String get bleStatusUnsupported => 'Understøttes ikke på denne enhed: BLE-opdagelse kræver Android 7 eller nyere samt en Bluetooth LE-radio.';
  @override
  String get bleStatusLegacyLocation =>
      'På denne Android-version skal systemets placeringstjenester også være slået til for at finde andre enheder (tilladelsen anmodes om automatisk; denne enhed kan allerede findes af andre).';
  @override
  String get bleStatusError => 'BLE-opdagelsen kunne ikke starte. Se Fejlsøgning > Logfiler for detaljer.';
  @override
  String get bleOpenSystemSettings => 'Åbn systemindstillinger';
}

// Path: settingsTab.other
class _Translations$settingsTab$other$da extends Translations$settingsTab$other$en {
  _Translations$settingsTab$other$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Andet';
  @override
  String get support => 'Støt LocalSend';
  @override
  String get donate => 'Donér';
  @override
  String get privacyPolicy => 'Privatlivspolitik';
  @override
  String get termsOfUse => 'Brugsbetingelser';
}

// Path: troubleshootPage.firewall
class _Translations$troubleshootPage$firewall$da extends Translations$troubleshootPage$firewall$en {
  _Translations$troubleshootPage$firewall$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Denne enhed kan sende filer til andre enheder, men andre kan ikke sende til denne enhed.';
  @override
  String solution({required Object port}) =>
      'Dette er sandsynligvis et firewall-problem. Løs det ved at tillade indgående forbindelser (UDP og TCP) på port ${port}.';
  @override
  String get openFirewall => 'Åbn firewall';
}

// Path: troubleshootPage.noDiscovery
class _Translations$troubleshootPage$noDiscovery$da extends Translations$troubleshootPage$noDiscovery$en {
  _Translations$troubleshootPage$noDiscovery$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Denne enhed kan ikke finde andre enheder.';
  @override
  String get solution =>
      'Sørg for, at alle enheder er på samme Wi-Fi-netværk og har den samme konfiguration (port, multicast-adresse, kryptering). Du kan prøve at indtaste den ønskede enheds IP-adresse manuelt. Hvis det virker, kan du føje enheden til favoritter, så den kan findes automatisk fremover.';
}

// Path: troubleshootPage.noConnection
class _Translations$troubleshootPage$noConnection$da extends Translations$troubleshootPage$noConnection$en {
  _Translations$troubleshootPage$noConnection$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Begge enheder kan hverken se hinanden eller dele data.';
  @override
  String get solution =>
      'Er problemet der på begge enheder? Hvis ja, skal du sikre, at begge er på samme Wi-Fi-netværk og har den samme konfiguration (port, multicast-adresse, kryptering). Det kan være, at Wi-Fi-netværket forhindrer kommunikation mellem enheder grundet Access Point (AP) Isolation. I så fald skal denne indstilling deaktiveres på routeren.';
}

// Path: receiveHistoryPage.entryActions
class _Translations$receiveHistoryPage$entryActions$da extends Translations$receiveHistoryPage$entryActions$en {
  _Translations$receiveHistoryPage$entryActions$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get open => 'Åbn fil';
  @override
  String get showInFolder => 'Vis i mappe';
  @override
  String get info => 'Information';
  @override
  String get deleteFromHistory => 'Slet fra historik';
}

// Path: deviceDetailsPage.info
class _Translations$deviceDetailsPage$info$da extends Translations$deviceDetailsPage$info$en {
  _Translations$deviceDetailsPage$info$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get name => 'Navn';
  @override
  String get address => 'Adresse';
  @override
  String get version => 'Version';
  @override
  String protocol({required Object version}) => 'Protokol v${version}';
}

// Path: deviceDetailsPage.logs
class _Translations$deviceDetailsPage$logs$da extends Translations$deviceDetailsPage$logs$en {
  _Translations$deviceDetailsPage$logs$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Logfiler';
  @override
  String get empty => 'Ingen logfiler tilgængelige.';
  @override
  String discovered({required Object protocol, required Object host}) => 'Opdaget via ${protocol} (${host})';
  @override
  String updated({required Object protocol, required Object host}) => 'Opdateret via ${protocol} (${host})';
}

// Path: progressPage.checksum
class _Translations$progressPage$checksum$da extends Translations$progressPage$checksum$en {
  _Translations$progressPage$checksum$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get verified => 'Kontrolsummer verificeret';
  @override
  String partiallyVerified({required Object curr, required Object n}) => 'Kontrolsummer verificeret for ${curr} / ${n} filer';
  @override
  String get notVerifiable => 'Ingen kontrolsummer angivet af afsenderen';
  @override
  String get disabled => 'Verificering af kontrolsummer er deaktiveret';
  @override
  String attached({required Object curr, required Object n}) => 'Kontrolsummer vedhæftet (${curr} / ${n} filer)';
}

// Path: progressPage.total
class _Translations$progressPage$total$da extends Translations$progressPage$total$en {
  _Translations$progressPage$total$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$progressPage$total$title$da title = _Translations$progressPage$total$title$da._(_root);
  @override
  String count({required Object curr, required Object n}) => 'Filer: ${curr} / ${n}';
  @override
  String size({required Object curr, required Object n}) => 'Størrelse: ${curr} / ${n}';
  @override
  String speed({required Object speed}) => 'Hastighed: ${speed}/s';
}

// Path: progressPage.remainingTime
class _Translations$progressPage$remainingTime$da extends Translations$progressPage$remainingTime$en {
  _Translations$progressPage$remainingTime$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String minutesUnit({required num m}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('da'))(
    m,
    other: '${m}m',
  );
  @override
  String hoursUnit({required num h}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('da'))(
    h,
    other: '${h}t',
  );
  @override
  String minutes({required Object m, required Object ss}) => '${m}:${ss}';
  @override
  String hours({required num h, required num m}) =>
      '${_root.progressPage.remainingTime.hoursUnit(h: h)} ${_root.progressPage.remainingTime.minutesUnit(m: m)}';
}

// Path: whatsNewPage.changes
class _Translations$whatsNewPage$changes$da extends Translations$whatsNewPage$changes$en {
  _Translations$whatsNewPage$changes$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$whatsNewPage$changes$v1_18_0$da v1_18_0 = _Translations$whatsNewPage$changes$v1_18_0$da._(_root);
}

// Path: dialogs.addFile
class _Translations$dialogs$addFile$da extends Translations$dialogs$addFile$en {
  _Translations$dialogs$addFile$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Føj til valg';
  @override
  String get content => 'Hvad vil du tilføje?';
}

// Path: dialogs.openFile
class _Translations$dialogs$openFile$da extends Translations$dialogs$openFile$en {
  _Translations$dialogs$openFile$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Åbn fil';
  @override
  String get content => 'Vil du åbne den modtagne fil?';
}

// Path: dialogs.addressInput
class _Translations$dialogs$addressInput$da extends Translations$dialogs$addressInput$en {
  _Translations$dialogs$addressInput$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Indtast adresse';
  @override
  String get hashtag => 'Hashtag';
  @override
  String get ip => 'IP-adresse';
  @override
  String get recentlyUsed => 'Senest brugt: ';
  @override
  String get noHashtagCandidates =>
      'Det aktuelle netværk har ingen IPv4-adresse, så hashtagget kan ikke udvides til en kandidatadresse. Indtast i stedet den fulde adresse (f.eks. 192.168.1.5 eller fe80::1).';
  @override
  late final _Translations$dialogs$addressInput$validation$da validation = _Translations$dialogs$addressInput$validation$da._(_root);
}

// Path: dialogs.cancelSession
class _Translations$dialogs$cancelSession$da extends Translations$dialogs$cancelSession$en {
  _Translations$dialogs$cancelSession$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Afbryd filoverførsel';
  @override
  String get content => 'Vil du virkelig afbryde filoverførslen?';
}

// Path: dialogs.connectionError
class _Translations$dialogs$connectionError$da extends Translations$dialogs$connectionError$en {
  _Translations$dialogs$connectionError$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Forbindelsen mislykkedes';
  @override
  late final _Translations$dialogs$connectionError$timeout$da timeout = _Translations$dialogs$connectionError$timeout$da._(_root);
  @override
  late final _Translations$dialogs$connectionError$refused$da refused = _Translations$dialogs$connectionError$refused$da._(_root);
  @override
  late final _Translations$dialogs$connectionError$forbidden$da forbidden = _Translations$dialogs$connectionError$forbidden$da._(_root);
  @override
  late final _Translations$dialogs$connectionError$other$da other = _Translations$dialogs$connectionError$other$da._(_root);
  @override
  String get retry => 'Prøv igen';
  @override
  String get details => 'Fejldetaljer:';
}

// Path: dialogs.deleteSourceAfterSendDialog
class _Translations$dialogs$deleteSourceAfterSendDialog$da extends Translations$dialogs$deleteSourceAfterSendDialog$en {
  _Translations$dialogs$deleteSourceAfterSendDialog$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Slet kildefiler';
  @override
  String get content => 'Når filerne er blevet sendt, bliver de slettet fra denne enhed. Dette kan ikke fortrydes.';
}

// Path: dialogs.cannotOpenFile
class _Translations$dialogs$cannotOpenFile$da extends Translations$dialogs$cannotOpenFile$en {
  _Translations$dialogs$cannotOpenFile$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Kan ikke åbne filen';
  @override
  String content({required Object file}) => 'Filen "${file}" kunne ikke åbnes. Er denne fil blevet flyttet, omdøbt eller slettet?';
}

// Path: dialogs.encryptionDisabledNotice
class _Translations$dialogs$encryptionDisabledNotice$da extends Translations$dialogs$encryptionDisabledNotice$en {
  _Translations$dialogs$encryptionDisabledNotice$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Kryptering deaktiveret';
  @override
  String get content => 'Kommunikationen sker nu via den ukrypterede HTTP-protokol. Aktivér kryptering igen for at bruge HTTPS.';
}

// Path: dialogs.errorDialog
class _Translations$dialogs$errorDialog$da extends Translations$dialogs$errorDialog$en {
  _Translations$dialogs$errorDialog$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.error;
}

// Path: dialogs.favoriteDialog
class _Translations$dialogs$favoriteDialog$da extends Translations$dialogs$favoriteDialog$en {
  _Translations$dialogs$favoriteDialog$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Favoritter';
  @override
  String get noFavorites => 'Ingen favoritter endnu.';
  @override
  String get addFavorite => 'Tilføj';
}

// Path: dialogs.favoriteDeleteDialog
class _Translations$dialogs$favoriteDeleteDialog$da extends Translations$dialogs$favoriteDeleteDialog$en {
  _Translations$dialogs$favoriteDeleteDialog$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Slet favorit';
  @override
  String content({required Object name}) => 'Vil du virkelig slette "${name}"?';
}

// Path: dialogs.favoriteEditDialog
class _Translations$dialogs$favoriteEditDialog$da extends Translations$dialogs$favoriteEditDialog$en {
  _Translations$dialogs$favoriteEditDialog$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get titleAdd => 'Føj til favoritter';
  @override
  String get titleEdit => 'Rediger favorit';
  @override
  String get name => 'Enhedsnavn';
  @override
  String get auto => '(auto)';
  @override
  String get ip => 'IP-adresse';
  @override
  String get port => 'Port';
}

// Path: dialogs.fileInfo
class _Translations$dialogs$fileInfo$da extends Translations$dialogs$fileInfo$en {
  _Translations$dialogs$fileInfo$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Filoplysninger';
  @override
  String get fileName => 'Filnavn:';
  @override
  String get path => 'Sti:';
  @override
  String get size => 'Størrelse:';
  @override
  String get sender => 'Afsender:';
  @override
  String get time => 'Tidspunkt:';
}

// Path: dialogs.fileNameInput
class _Translations$dialogs$fileNameInput$da extends Translations$dialogs$fileNameInput$en {
  _Translations$dialogs$fileNameInput$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Angiv filnavn';
  @override
  String original({required Object original}) => 'Original: ${original}';
}

// Path: dialogs.historyClearDialog
class _Translations$dialogs$historyClearDialog$da extends Translations$dialogs$historyClearDialog$en {
  _Translations$dialogs$historyClearDialog$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ryd historik';
  @override
  String get content => 'Vil du virkelig slette hele historikken?';
}

// Path: dialogs.localNetworkUnauthorized
class _Translations$dialogs$localNetworkUnauthorized$da extends Translations$dialogs$localNetworkUnauthorized$en {
  _Translations$dialogs$localNetworkUnauthorized$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.dialogs.noPermission.title;
  @override
  String get description =>
      'LocalSend kan ikke finde andre enheder uden tilladelse til at scanne det lokale netværk. Giv venligst tilladelse i systemindstillingerne.';
  @override
  String get gotoSettings => 'Indstillinger';
}

// Path: dialogs.messageInput
class _Translations$dialogs$messageInput$da extends Translations$dialogs$messageInput$en {
  _Translations$dialogs$messageInput$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Skriv besked';
  @override
  String get multiline => 'Flerlinjet';
}

// Path: dialogs.noFiles
class _Translations$dialogs$noFiles$da extends Translations$dialogs$noFiles$en {
  _Translations$dialogs$noFiles$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ingen fil valgt';
  @override
  String get content => 'Vælg mindst én fil.';
}

// Path: dialogs.noPermission
class _Translations$dialogs$noPermission$da extends Translations$dialogs$noPermission$en {
  _Translations$dialogs$noPermission$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ingen tilladelse';
  @override
  String get content => 'Du har ikke givet de nødvendige tilladelser. Giv venligst tilladelse i systemindstillingerne.';
}

// Path: dialogs.notAvailableOnPlatform
class _Translations$dialogs$notAvailableOnPlatform$da extends Translations$dialogs$notAvailableOnPlatform$en {
  _Translations$dialogs$notAvailableOnPlatform$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ikke tilgængelig';
  @override
  String get content => 'Denne funktion er ikke tilgængelig:';
}

// Path: dialogs.qr
class _Translations$dialogs$qr$da extends Translations$dialogs$qr$en {
  _Translations$dialogs$qr$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'QR-kode';
}

// Path: dialogs.quickActions
class _Translations$dialogs$quickActions$da extends Translations$dialogs$quickActions$en {
  _Translations$dialogs$quickActions$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Hurtighandlinger';
  @override
  String get counter => 'Tæller';
  @override
  String get prefix => 'Præfiks';
  @override
  String get padZero => 'Fyld med nuller';
  @override
  String get sortBeforeCount => 'Sortér alfabetisk på forhånd (A-Å)';
  @override
  String get random => 'Tilfældig';
}

// Path: dialogs.quickSaveNotice
class _Translations$dialogs$quickSaveNotice$da extends Translations$dialogs$quickSaveNotice$en {
  _Translations$dialogs$quickSaveNotice$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSave;
  @override
  String get content => 'Filoverførsler accepteres nu automatisk. Bemærk, at alle på det lokale netværk kan sende dig filer.';
}

// Path: dialogs.quickSaveFromFavoritesNotice
class _Translations$dialogs$quickSaveFromFavoritesNotice$da extends Translations$dialogs$quickSaveFromFavoritesNotice$en {
  _Translations$dialogs$quickSaveFromFavoritesNotice$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSaveFromFavorites;
  @override
  List<String> get content => [
    'Filoverførsler accepteres nu automatisk fra enheder på din favoritliste.',
  ];
}

// Path: dialogs.pin
class _Translations$dialogs$pin$da extends Translations$dialogs$pin$en {
  _Translations$dialogs$pin$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Indtast PIN-kode';
}

// Path: dialogs.sendModeHelp
class _Translations$dialogs$sendModeHelp$da extends Translations$dialogs$sendModeHelp$en {
  _Translations$dialogs$sendModeHelp$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Send-tilstande';
  @override
  String get single => 'Sender filer til én modtager. Valget ryddes efter filoverførsel er færdig.';
  @override
  String get multiple => 'Sender filer til flere modtager. Valget ryddes ikke efter filoverførsel er færdig.';
  @override
  String get link => 'Modtagere, der ikke har LocalSend installeret, kan hente de valgte filer ved at åbne linket i deres browser.';
}

// Path: dialogs.startupError
class _Translations$dialogs$startupError$da extends Translations$dialogs$startupError$en {
  _Translations$dialogs$startupError$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Serveren kunne ikke startes';
  @override
  String port({required Object port}) => 'Port: ${port}';
  @override
  late final _Translations$dialogs$startupError$windowsAccessDenied$da windowsAccessDenied =
      _Translations$dialogs$startupError$windowsAccessDenied$da._(_root);
  @override
  late final _Translations$dialogs$startupError$addressInUse$da addressInUse = _Translations$dialogs$startupError$addressInUse$da._(_root);
  @override
  late final _Translations$dialogs$startupError$generic$da generic = _Translations$dialogs$startupError$generic$da._(_root);
  @override
  String get details => 'Fejldetaljer:';
  @override
  String get copyDetails => 'Kopiér detaljer';
  @override
  String get openSettings => 'Åbn indstillinger';
}

// Path: dialogs.zoom
class _Translations$dialogs$zoom$da extends Translations$dialogs$zoom$en {
  _Translations$dialogs$zoom$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'URL';
}

// Path: sendTab.diagnosis.noInterface
class _Translations$sendTab$diagnosis$noInterface$da extends Translations$sendTab$diagnosis$noInterface$en {
  _Translations$sendTab$diagnosis$noInterface$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ingen netværksforbindelse';
  @override
  String get advice => 'Denne enhed er ikke forbundet til noget netværk. Tjek enhedens Wi-Fi- eller kabelforbindelse.';
}

// Path: sendTab.diagnosis.multicastUnavailable
class _Translations$sendTab$diagnosis$multicastUnavailable$da extends Translations$sendTab$diagnosis$multicastUnavailable$en {
  _Translations$sendTab$diagnosis$multicastUnavailable$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Multicast er ikke tilgængelig';
  @override
  String advice({required Object port}) =>
      'LocalSend kan ikke bruge multicast til at finde enheder på dette netværk. Sørg for, at begge enheder er på samme netværk, og at AP-isolering eller en firewall ikke blokerer UDP-port ${port}.';
  @override
  String reason({required Object reason}) => 'Årsag: ${reason}';
}

// Path: sendTab.diagnosis.scanNoResult
class _Translations$sendTab$diagnosis$scanNoResult$da extends Translations$sendTab$diagnosis$scanNoResult$en {
  _Translations$sendTab$diagnosis$scanNoResult$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ingen enheder fundet';
  @override
  String get advice =>
      'Søgningen virker, men ingen enheder svarede på annonceringerne eller netværksscanningen. Den anden enhed er måske offline, i dvale eller blokeret af en firewall. Sørg for, at LocalSend kører på den anden enhed.';
  @override
  String detail({required Object announcements, required Object scans}) =>
      'Sendte ${announcements} annonceringer og ${scans} netværksscanninger uden svar.';
}

// Path: sendTab.diagnosis.manualFallback
class _Translations$sendTab$diagnosis$manualFallback$da extends Translations$sendTab$diagnosis$manualFallback$en {
  _Translations$sendTab$diagnosis$manualFallback$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get message =>
      'IP-adresser ændrer sig ofte. Du kan stadig nå en enhed, der ikke er på listen: Føj den til dine favoritter, eller indtast dens adresse manuelt.';
  @override
  String get openFavorites => 'Åbn favoritter';
  @override
  String get manualInput => 'Indtast adresse manuelt';
}

// Path: settingsTab.general.brightnessOptions
class _Translations$settingsTab$general$brightnessOptions$da extends Translations$settingsTab$general$brightnessOptions$en {
  _Translations$settingsTab$general$brightnessOptions$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'System';
  @override
  String get dark => 'Mørk';
  @override
  String get light => 'Lys';
}

// Path: settingsTab.general.colorOptions
class _Translations$settingsTab$general$colorOptions$da extends Translations$settingsTab$general$colorOptions$en {
  _Translations$settingsTab$general$colorOptions$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'System';
  @override
  String get oled => 'OLED';
  @override
  String get custom => 'Brugerdefineret';
}

// Path: settingsTab.general.languageOptions
class _Translations$settingsTab$general$languageOptions$da extends Translations$settingsTab$general$languageOptions$en {
  _Translations$settingsTab$general$languageOptions$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'System';
}

// Path: settingsTab.network.networkOptions
class _Translations$settingsTab$network$networkOptions$da extends Translations$settingsTab$network$networkOptions$en {
  _Translations$settingsTab$network$networkOptions$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'Alle';
  @override
  String get filtered => 'Filtreret';
}

// Path: progressPage.total.title
class _Translations$progressPage$total$title$da extends Translations$progressPage$total$title$en {
  _Translations$progressPage$total$title$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String sending({required Object time}) => 'Samlet tid (${time})';
  @override
  String get finishedError => 'Fuldført med fejl';
  @override
  String get canceledSender => 'Afbrudt af afsender';
  @override
  String get canceledReceiver => 'Afbrudt af modtager';
}

// Path: whatsNewPage.changes.v1_18_0
class _Translations$whatsNewPage$changes$v1_18_0$da extends Translations$whatsNewPage$changes$v1_18_0$en with WhatsNewStrings {
  _Translations$whatsNewPage$changes$v1_18_0$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  List<String> get changes => [
    'Kryptering gør ikke længere overførsler langsommere. Den er blevet genaktiveret på denne enhed, hvis du tidligere havde slået den fra.',
    'Anmodninger fra favoritter accepteres nu automatisk. Dette er slået til som standard og kan deaktiveres i indstillingerne.',
    'På Android fortsætter overførsler, mens appen er i baggrunden, eller skærmen er slukket. På iOS skal appen stadig forblive i forgrunden.',
  ];
}

// Path: dialogs.addressInput.validation
class _Translations$dialogs$addressInput$validation$da extends Translations$dialogs$addressInput$validation$en {
  _Translations$dialogs$addressInput$validation$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get invalid => 'Indtast en gyldig IPv4-adresse, IPv6-adresse eller værtsnavn.';
  @override
  String get scheme => 'Indtast kun adressen, uden "http://" eller "https://".';
  @override
  String get port => 'Indtast kun adressen. Porten hentes fra indstillingerne.';
}

// Path: dialogs.connectionError.timeout
class _Translations$dialogs$connectionError$timeout$da extends Translations$dialogs$connectionError$timeout$en {
  _Translations$dialogs$connectionError$timeout$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Enheden svarede ikke i tide.';
  @override
  String get advice =>
      'Den er sandsynligvis offline, i dvale, eller en firewall blokerer forbindelsen. Sørg for, at LocalSend kører på den anden enhed, og at begge enheder er på samme netværk.';
}

// Path: dialogs.connectionError.refused
class _Translations$dialogs$connectionError$refused$da extends Translations$dialogs$connectionError$refused$en {
  _Translations$dialogs$connectionError$refused$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Enheden afviste forbindelsen.';
  @override
  String get advice =>
      'LocalSend ser ikke ud til at køre på målenheden, eller den lytter på en anden port. Start LocalSend på den anden enhed, eller tjek porten.';
}

// Path: dialogs.connectionError.forbidden
class _Translations$dialogs$connectionError$forbidden$da extends Translations$dialogs$connectionError$forbidden$en {
  _Translations$dialogs$connectionError$forbidden$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Enheden afviste anmodningen.';
  @override
  String get advice =>
      'Der kræves måske en PIN-kode, eller parringen med enheden er ændret. Tjek PIN-koden og indstillingerne for "Gem hurtigt" på målenheden.';
}

// Path: dialogs.connectionError.other
class _Translations$dialogs$connectionError$other$da extends Translations$dialogs$connectionError$other$en {
  _Translations$dialogs$connectionError$other$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Forbindelsen kunne ikke oprettes.';
  @override
  String get advice => 'Tjek adresse og port, sørg for, at LocalSend kører på målenheden, og at ingen firewall eller VPN blokerer forbindelsen.';
}

// Path: dialogs.startupError.windowsAccessDenied
class _Translations$dialogs$startupError$windowsAccessDenied$da extends Translations$dialogs$startupError$windowsAccessDenied$en {
  _Translations$dialogs$startupError$windowsAccessDenied$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Windows nægtede adgang til porten (socketfejl 10013).';
  @override
  String get advice =>
      'Dette skyldes normalt et portinterval reserveret af Hyper-V, WSL eller Docker, eller en beskadiget Winsock-katalog:\n• Ændr porten i indstillingerne (Netværk)\n• Tjek de reserverede intervaller med: netsh interface ipv4 show excludedportrange protocol=tcp\n• Reparér Winsock som administrator med: netsh winsock reset (genstart bagefter)';
}

// Path: dialogs.startupError.addressInUse
class _Translations$dialogs$startupError$addressInUse$da extends Translations$dialogs$startupError$addressInUse$en {
  _Translations$dialogs$startupError$addressInUse$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Porten bruges allerede af et andet program.';
  @override
  String get advice =>
      'Et andet program (eller en anden LocalSend-instans) lytter på denne port:\n• Luk det andet program, eller\n• Ændr porten i indstillingerne (Netværk)';
}

// Path: dialogs.startupError.generic
class _Translations$dialogs$startupError$generic$da extends Translations$dialogs$startupError$generic$en {
  _Translations$dialogs$startupError$generic$da._(TranslationsDa root) : this._root = root, super.internal(root);

  final TranslationsDa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Serveren kunne ikke startes.';
  @override
  String get advice => '• Tjek dine firewall- og netværksindstillinger\n• Prøv at ændre porten i indstillingerne (Netværk)';
}
