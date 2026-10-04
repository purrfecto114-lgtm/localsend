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
class TranslationsCs extends Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsCs({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.cs,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <cs>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  late final TranslationsCs _root = this; // ignore: unused_field

  @override
  TranslationsCs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsCs(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'LocalSend';
  @override
  late final _Translations$general$cs general = _Translations$general$cs._(_root);
  @override
  late final _Translations$receiveTab$cs receiveTab = _Translations$receiveTab$cs._(_root);
  @override
  late final _Translations$sendTab$cs sendTab = _Translations$sendTab$cs._(_root);
  @override
  late final _Translations$settingsTab$cs settingsTab = _Translations$settingsTab$cs._(_root);
  @override
  late final _Translations$troubleshootPage$cs troubleshootPage = _Translations$troubleshootPage$cs._(_root);
  @override
  late final _Translations$networkInterfacesPage$cs networkInterfacesPage = _Translations$networkInterfacesPage$cs._(_root);
  @override
  late final _Translations$receiveHistoryPage$cs receiveHistoryPage = _Translations$receiveHistoryPage$cs._(_root);
  @override
  late final _Translations$apkPickerPage$cs apkPickerPage = _Translations$apkPickerPage$cs._(_root);
  @override
  late final _Translations$selectedFilesPage$cs selectedFilesPage = _Translations$selectedFilesPage$cs._(_root);
  @override
  late final _Translations$deviceDetailsPage$cs deviceDetailsPage = _Translations$deviceDetailsPage$cs._(_root);
  @override
  late final _Translations$verifyPage$cs verifyPage = _Translations$verifyPage$cs._(_root);
  @override
  late final _Translations$receivePage$cs receivePage = _Translations$receivePage$cs._(_root);
  @override
  late final _Translations$receiveOptionsPage$cs receiveOptionsPage = _Translations$receiveOptionsPage$cs._(_root);
  @override
  late final _Translations$sendPage$cs sendPage = _Translations$sendPage$cs._(_root);
  @override
  late final _Translations$progressPage$cs progressPage = _Translations$progressPage$cs._(_root);
  @override
  late final _Translations$webSharePage$cs webSharePage = _Translations$webSharePage$cs._(_root);
  @override
  late final _Translations$webReceivePage$cs webReceivePage = _Translations$webReceivePage$cs._(_root);
  @override
  late final _Translations$aboutPage$cs aboutPage = _Translations$aboutPage$cs._(_root);
  @override
  late final _Translations$donationPage$cs donationPage = _Translations$donationPage$cs._(_root);
  @override
  late final _Translations$changelogPage$cs changelogPage = _Translations$changelogPage$cs._(_root);
  @override
  late final _Translations$whatsNewPage$cs whatsNewPage = _Translations$whatsNewPage$cs._(_root);
  @override
  late final _Translations$dialogs$cs dialogs = _Translations$dialogs$cs._(_root);
  @override
  late final _Translations$sanitization$cs sanitization = _Translations$sanitization$cs._(_root);
  @override
  late final _Translations$tray$cs tray = _Translations$tray$cs._(_root);
  @override
  late final _Translations$web$cs web = _Translations$web$cs._(_root);
  @override
  late final _Translations$assetPicker$cs assetPicker = _Translations$assetPicker$cs._(_root);
}

// Path: general
class _Translations$general$cs extends Translations$general$en {
  _Translations$general$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get accept => 'Přijmout';
  @override
  String get accepted => 'Přijato';
  @override
  String get add => 'Přidat';
  @override
  String get advanced => 'Pokročilé';
  @override
  String get cancel => 'Zrušit';
  @override
  String get close => 'Zavřít';
  @override
  String get confirm => 'Potvrdit';
  @override
  String get continueStr => 'Pokračovat';
  @override
  String get copy => 'Kopírovat';
  @override
  String get copiedToClipboard => 'Zkopírováno do schránky';
  @override
  String get decline => 'Odmítnout';
  @override
  String get done => 'Hotovo';
  @override
  String get delete => 'Vymazat';
  @override
  String get edit => 'Upravit';
  @override
  String get error => 'Chyba';
  @override
  String get example => 'Příklad';
  @override
  String get files => 'Soubory';
  @override
  String get finished => 'Hotovo';
  @override
  String get hide => 'Skrýt';
  @override
  String get off => 'Vypnuto';
  @override
  String get offline => 'Offline';
  @override
  String get on => 'Zapnuto';
  @override
  String get online => 'Online';
  @override
  String get open => 'Otevřít';
  @override
  String get queue => 'Fronta';
  @override
  String get quickSave => 'Rychlé uložení';
  @override
  String get quickSaveFromFavorites => 'Rychlé uložení pro "Oblíbené"';
  @override
  String get renamed => 'Přejmenováno';
  @override
  String get reset => 'Resetovat';
  @override
  String get restart => 'Restartovat';
  @override
  String get settings => 'Nastavení';
  @override
  String get skipped => 'Přeskočeno';
  @override
  String get start => 'Spustit';
  @override
  String get stop => 'Zastavit';
  @override
  String get save => 'Uložit';
  @override
  String get unchanged => 'Nezměněno';
  @override
  String get unknown => 'Neznámý';
  @override
  String get noItemInClipboard => 'Žádná položka ve schránce';
}

// Path: receiveTab
class _Translations$receiveTab$cs extends Translations$receiveTab$en {
  _Translations$receiveTab$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Příjmout';
  @override
  late final _Translations$receiveTab$infoBox$cs infoBox = _Translations$receiveTab$infoBox$cs._(_root);
  @override
  late final _Translations$receiveTab$quickSave$cs quickSave = _Translations$receiveTab$quickSave$cs._(_root);
  @override
  String get link => 'Přijmout přes odkaz';
}

// Path: sendTab
class _Translations$sendTab$cs extends Translations$sendTab$en {
  _Translations$sendTab$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Odeslat';
  @override
  late final _Translations$sendTab$selection$cs selection = _Translations$sendTab$selection$cs._(_root);
  @override
  late final _Translations$sendTab$picker$cs picker = _Translations$sendTab$picker$cs._(_root);
  @override
  String get shareIntentInfo => 'Pro snazší výběr souborů můžete také použít funkci "Sdílet" svého mobilního zařízení.';
  @override
  String get nearbyDevices => 'Zařízení v okolí';
  @override
  String get thisDevice => 'Toto zařízení';
  @override
  String get scan => 'Hledat zařízení';
  @override
  String get manualSending => 'Manuální odeslání';
  @override
  String get sendMode => 'Režim odesílání';
  @override
  late final _Translations$sendTab$sendModes$cs sendModes = _Translations$sendTab$sendModes$cs._(_root);
  @override
  String get sendModeHelp => 'Vysvětlení';
  @override
  String get help => 'Ujistěte se, že se požadovaný cíl nachází ve stejné síti Wi-Fi.';
  @override
  String get placeItems => 'Vložte položky, které chcete sdílet.';
  @override
  late final _Translations$sendTab$diagnosis$cs diagnosis = _Translations$sendTab$diagnosis$cs._(_root);
}

// Path: settingsTab
class _Translations$settingsTab$cs extends Translations$settingsTab$en {
  _Translations$settingsTab$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Nastavení';
  @override
  late final _Translations$settingsTab$general$cs general = _Translations$settingsTab$general$cs._(_root);
  @override
  late final _Translations$settingsTab$receive$cs receive = _Translations$settingsTab$receive$cs._(_root);
  @override
  late final _Translations$settingsTab$send$cs send = _Translations$settingsTab$send$cs._(_root);
  @override
  late final _Translations$settingsTab$network$cs network = _Translations$settingsTab$network$cs._(_root);
  @override
  late final _Translations$settingsTab$other$cs other = _Translations$settingsTab$other$cs._(_root);
  @override
  String get advancedSettings => 'Pokročilá nastavení';
}

// Path: troubleshootPage
class _Translations$troubleshootPage$cs extends Translations$troubleshootPage$en {
  _Translations$troubleshootPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Odstraňování problémů';
  @override
  String get subTitle => 'Tato aplikace nefunguje podle očekávání? Zde najdete častá řešení.';
  @override
  String get solution => 'Řešení:';
  @override
  String get fixButton => 'Opravit automaticky';
  @override
  late final _Translations$troubleshootPage$firewall$cs firewall = _Translations$troubleshootPage$firewall$cs._(_root);
  @override
  late final _Translations$troubleshootPage$noDiscovery$cs noDiscovery = _Translations$troubleshootPage$noDiscovery$cs._(_root);
  @override
  late final _Translations$troubleshootPage$noConnection$cs noConnection = _Translations$troubleshootPage$noConnection$cs._(_root);
}

// Path: networkInterfacesPage
class _Translations$networkInterfacesPage$cs extends Translations$networkInterfacesPage$en {
  _Translations$networkInterfacesPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Síťová rozhraní';
  @override
  String get info =>
      'Ve výchozím nastavení používá LocalSend všechna dostupná síťová rozhraní. Zde můžete vyloučit nežádoucí sítě. Chcete-li použít změny, musíte restartovat server.';
  @override
  String get preview => 'Náhled';
  @override
  String get whitelist => 'Seznam povolených';
  @override
  String get blacklist => 'Seznam zakázaných';
}

// Path: receiveHistoryPage
class _Translations$receiveHistoryPage$cs extends Translations$receiveHistoryPage$en {
  _Translations$receiveHistoryPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Historie';
  @override
  String get openFolder => 'Otevřít složku';
  @override
  String get deleteHistory => 'Smazat historii';
  @override
  String get empty => 'Historie je prázdná.';
  @override
  late final _Translations$receiveHistoryPage$entryActions$cs entryActions = _Translations$receiveHistoryPage$entryActions$cs._(_root);
}

// Path: apkPickerPage
class _Translations$apkPickerPage$cs extends Translations$apkPickerPage$en {
  _Translations$apkPickerPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Aplikace (APK)';
  @override
  String get excludeSystemApps => 'Vyloučit systémové aplikace';
  @override
  String get excludeAppsWithoutLaunchIntent => 'Vyloučit aplikace, které nelze spustit';
  @override
  String apps({required Object n}) => '${n} Aplikace';
}

// Path: selectedFilesPage
class _Translations$selectedFilesPage$cs extends Translations$selectedFilesPage$en {
  _Translations$selectedFilesPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get deleteAll => 'Smazat vše';
}

// Path: deviceDetailsPage
class _Translations$deviceDetailsPage$cs extends Translations$deviceDetailsPage$en {
  _Translations$deviceDetailsPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Podrobnosti o zařízení';
  @override
  String get favorite => 'Oblíbené';
  @override
  String get verify => 'Ověřit';
  @override
  late final _Translations$deviceDetailsPage$info$cs info = _Translations$deviceDetailsPage$info$cs._(_root);
  @override
  late final _Translations$deviceDetailsPage$logs$cs logs = _Translations$deviceDetailsPage$logs$cs._(_root);
}

// Path: verifyPage
class _Translations$verifyPage$cs extends Translations$verifyPage$en {
  _Translations$verifyPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ověřit';
  @override
  String get icons => 'Ikony';
  @override
  String get text => 'Text';
  @override
  String get question => 'Vypadá to na druhém zařízení stejně?';
}

// Path: receivePage
class _Translations$receivePage$cs extends Translations$receivePage$en {
  _Translations$receivePage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String subTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(
    n,
    one: 'vám chce poslat soubor',
    other: 'vám chce poslat několik souborů: ${n}',
  );
  @override
  String get subTitleMessage => 'vám poslal zprávu:';
  @override
  String get subTitleLink => 'vám poslal odkaz:';
  @override
  String get canceled => 'Odesílatel zrušil požadavek.';
}

// Path: receiveOptionsPage
class _Translations$receiveOptionsPage$cs extends Translations$receiveOptionsPage$en {
  _Translations$receiveOptionsPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Možnosti';
  @override
  String get destination => _root.settingsTab.receive.destination;
  @override
  String get appDirectory => '(LocalSend folder)';
  @override
  String get saveToGallery => _root.settingsTab.receive.saveToGallery;
  @override
  String get saveToGalleryOff => 'Automaticky vypnuto, protože existují adresáře.';
}

// Path: sendPage
class _Translations$sendPage$cs extends Translations$sendPage$en {
  _Translations$sendPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String calculatingChecksum({required Object curr, required Object n}) => 'Výpočet kontrolního součtu (${curr} / ${n})';
  @override
  String get waiting => 'Čekání na odpověď...';
  @override
  String get rejected => 'Příjemce žádost odmítl.';
  @override
  String get tooManyAttempts => _root.web.tooManyAttempts;
  @override
  String get busy => 'Příjemce je zaneprázdněn dalším požadavkem.';
}

// Path: progressPage
class _Translations$progressPage$cs extends Translations$progressPage$en {
  _Translations$progressPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get titleSending => 'Odesílání souborů';
  @override
  String get titleReceiving => 'Přijímání souborů';
  @override
  String get savedToGallery => 'Uloženo ve Fotkách';
  @override
  late final _Translations$progressPage$checksum$cs checksum = _Translations$progressPage$checksum$cs._(_root);
  @override
  late final _Translations$progressPage$total$cs total = _Translations$progressPage$total$cs._(_root);
  @override
  late final _Translations$progressPage$remainingTime$cs remainingTime = _Translations$progressPage$remainingTime$cs._(_root);
}

// Path: webSharePage
class _Translations$webSharePage$cs extends Translations$webSharePage$en {
  _Translations$webSharePage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Sdílet pomocí odkazu';
  @override
  String get loading => 'Spouštění serveru...';
  @override
  String get stopping => 'Zastavování serveru...';
  @override
  String get error => 'Při spouštění serveru došlo k chybě.';
  @override
  String openLink({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(
    n,
    one: 'Otevřete tento odkaz v prohlížeči:',
    other: 'Otevřete v prohlížeči jeden z těchto odkazů:',
  );
  @override
  String get requests => 'Žádosti';
  @override
  String get noRequests => 'Zatím žádné žádosti.';
  @override
  String get encryption => _root.settingsTab.network.encryption;
  @override
  String get autoAccept => 'Automaticky přijímat žádosti';
  @override
  String get requirePin => 'Vyžadovat PIN';
  @override
  String pinHint({required Object pin}) => 'PIN je "${pin}"';
  @override
  String get encryptionHint => 'LocalSend používá self-signed certifikát. Musíte ho přijmout ve vašem prohlížeči.';
  @override
  String pendingRequests({required Object n}) => 'Čekající žádosti: ${n}';
}

// Path: webReceivePage
class _Translations$webReceivePage$cs extends Translations$webReceivePage$en {
  _Translations$webReceivePage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Přijmout přes odkaz';
}

// Path: aboutPage
class _Translations$aboutPage$cs extends Translations$aboutPage$en {
  _Translations$aboutPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'O aplikaci LocalSend';
  @override
  List<String> get description => [
    'LocalSend je bezplatná aplikace s otevřeným zdrojovým kódem, která vám umožňuje bezpečně sdílet soubory a zprávy s okolními zařízeními přes vaši místní síť, aniž byste potřebovali připojení k internetu.',
    'Tato aplikace je dostupná pro Android, iOS, macOS, Windows a Linux. Všechny možnosti stahování najdete na oficiální domovské stránce.',
  ];
  @override
  String get author => 'Autor';
  @override
  String get contributors => 'Přispěvatelé';
  @override
  String get packagers => 'Baliči';
  @override
  String get translators => 'Překladatelé';
}

// Path: donationPage
class _Translations$donationPage$cs extends Translations$donationPage$en {
  _Translations$donationPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Darovat';
  @override
  String get info => 'LocalSend je zdarma, open source a bez reklam. Pokud se vám aplikace líbí, můžete její vývoj podpořit darem.';
  @override
  String donate({required Object amount}) => 'Darovat ${amount}';
  @override
  String get thanks => 'Děkuji mnohokrát!';
  @override
  String get restore => 'Obnovit';
}

// Path: changelogPage
class _Translations$changelogPage$cs extends Translations$changelogPage$en {
  _Translations$changelogPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Seznam změn';
}

// Path: whatsNewPage
class _Translations$whatsNewPage$cs extends Translations$whatsNewPage$en {
  _Translations$whatsNewPage$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String title({required Object version}) => 'Co je nového ve verzi ${version}';
  @override
  late final _Translations$whatsNewPage$changes$cs changes = _Translations$whatsNewPage$changes$cs._(_root);
}

// Path: dialogs
class _Translations$dialogs$cs extends Translations$dialogs$en {
  _Translations$dialogs$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$dialogs$addFile$cs addFile = _Translations$dialogs$addFile$cs._(_root);
  @override
  late final _Translations$dialogs$openFile$cs openFile = _Translations$dialogs$openFile$cs._(_root);
  @override
  late final _Translations$dialogs$addressInput$cs addressInput = _Translations$dialogs$addressInput$cs._(_root);
  @override
  late final _Translations$dialogs$cancelSession$cs cancelSession = _Translations$dialogs$cancelSession$cs._(_root);
  @override
  late final _Translations$dialogs$connectionError$cs connectionError = _Translations$dialogs$connectionError$cs._(_root);
  @override
  late final _Translations$dialogs$deleteSourceAfterSendDialog$cs deleteSourceAfterSendDialog =
      _Translations$dialogs$deleteSourceAfterSendDialog$cs._(_root);
  @override
  late final _Translations$dialogs$cannotOpenFile$cs cannotOpenFile = _Translations$dialogs$cannotOpenFile$cs._(_root);
  @override
  late final _Translations$dialogs$encryptionDisabledNotice$cs encryptionDisabledNotice = _Translations$dialogs$encryptionDisabledNotice$cs._(_root);
  @override
  late final _Translations$dialogs$errorDialog$cs errorDialog = _Translations$dialogs$errorDialog$cs._(_root);
  @override
  late final _Translations$dialogs$favoriteDialog$cs favoriteDialog = _Translations$dialogs$favoriteDialog$cs._(_root);
  @override
  late final _Translations$dialogs$favoriteDeleteDialog$cs favoriteDeleteDialog = _Translations$dialogs$favoriteDeleteDialog$cs._(_root);
  @override
  late final _Translations$dialogs$favoriteEditDialog$cs favoriteEditDialog = _Translations$dialogs$favoriteEditDialog$cs._(_root);
  @override
  late final _Translations$dialogs$fileInfo$cs fileInfo = _Translations$dialogs$fileInfo$cs._(_root);
  @override
  late final _Translations$dialogs$fileNameInput$cs fileNameInput = _Translations$dialogs$fileNameInput$cs._(_root);
  @override
  late final _Translations$dialogs$historyClearDialog$cs historyClearDialog = _Translations$dialogs$historyClearDialog$cs._(_root);
  @override
  late final _Translations$dialogs$localNetworkUnauthorized$cs localNetworkUnauthorized = _Translations$dialogs$localNetworkUnauthorized$cs._(_root);
  @override
  late final _Translations$dialogs$messageInput$cs messageInput = _Translations$dialogs$messageInput$cs._(_root);
  @override
  late final _Translations$dialogs$noFiles$cs noFiles = _Translations$dialogs$noFiles$cs._(_root);
  @override
  late final _Translations$dialogs$noPermission$cs noPermission = _Translations$dialogs$noPermission$cs._(_root);
  @override
  late final _Translations$dialogs$notAvailableOnPlatform$cs notAvailableOnPlatform = _Translations$dialogs$notAvailableOnPlatform$cs._(_root);
  @override
  late final _Translations$dialogs$qr$cs qr = _Translations$dialogs$qr$cs._(_root);
  @override
  late final _Translations$dialogs$quickActions$cs quickActions = _Translations$dialogs$quickActions$cs._(_root);
  @override
  late final _Translations$dialogs$quickSaveNotice$cs quickSaveNotice = _Translations$dialogs$quickSaveNotice$cs._(_root);
  @override
  late final _Translations$dialogs$quickSaveFromFavoritesNotice$cs quickSaveFromFavoritesNotice =
      _Translations$dialogs$quickSaveFromFavoritesNotice$cs._(_root);
  @override
  late final _Translations$dialogs$pin$cs pin = _Translations$dialogs$pin$cs._(_root);
  @override
  late final _Translations$dialogs$sendModeHelp$cs sendModeHelp = _Translations$dialogs$sendModeHelp$cs._(_root);
  @override
  late final _Translations$dialogs$startupError$cs startupError = _Translations$dialogs$startupError$cs._(_root);
  @override
  late final _Translations$dialogs$zoom$cs zoom = _Translations$dialogs$zoom$cs._(_root);
}

// Path: sanitization
class _Translations$sanitization$cs extends Translations$sanitization$en {
  _Translations$sanitization$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get empty => 'Název souboru nemůže být prázdný';
  @override
  String get invalid => 'Název souboru obsahuje neplatné znaky';
}

// Path: tray
class _Translations$tray$cs extends Translations$tray$en {
  _Translations$tray$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get open => _root.general.open;
  @override
  String get close => 'Ukončit LocalSend';
  @override
  String get closeWindows => 'Konec';
}

// Path: web
class _Translations$web$cs extends Translations$web$en {
  _Translations$web$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get waiting => _root.sendPage.waiting;
  @override
  String get enterPin => 'Vložit PIN';
  @override
  String get invalidPin => 'Neplatný PIN';
  @override
  String get tooManyAttempts => 'Příliš mnoho pokusů';
  @override
  String get rejected => 'Odmítnuto';
  @override
  String get files => 'Soubory';
  @override
  String get fileName => 'Název souboru';
  @override
  String get size => 'Velikost';
}

// Path: assetPicker
class _Translations$assetPicker$cs extends Translations$assetPicker$en {
  _Translations$assetPicker$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get confirm => 'Potvrdit';
  @override
  String get cancel => 'Zrušit';
  @override
  String get edit => 'Editovat';
  @override
  String get gifIndicator => 'GIF';
  @override
  String get loadFailed => 'Načtení se nezdařilo';
  @override
  String get original => 'Původ';
  @override
  String get preview => 'Náhled';
  @override
  String get select => 'Vybrat';
  @override
  String get emptyList => 'Prázdný seznam';
  @override
  String get unSupportedAssetType => 'Nepodporovaný typ souboru.';
  @override
  String get unableToAccessAll => 'Nelze získat přístup ke všem souborům v zařízení';
  @override
  String get viewingLimitedAssetsTip => 'Zobrazit pouze soubory a alba, ke kterým má aplikace přístup.';
  @override
  String get changeAccessibleLimitedAssets => 'Kliknutím aktualizujete přístupné soubory';
  @override
  String get accessAllTip =>
      'Aplikace má přístup pouze k některým souborům v zařízení. Přejděte do nastavení systému a povolte aplikaci přístup ke všem médiím v zařízení.';
  @override
  String get goToSystemSettings => 'Přejít do nastavení systému';
  @override
  String get accessLimitedAssets => 'Pokračovat s omezeným přístupem';
  @override
  String get accessiblePathName => 'Přístupné soubory';
  @override
  String get sTypeAudioLabel => 'Audio';
  @override
  String get sTypeImageLabel => 'Obrázek';
  @override
  String get sTypeVideoLabel => 'Video';
  @override
  String get sTypeOtherLabel => 'Ostatní média';
  @override
  String get sActionPlayHint => 'přehrát';
  @override
  String get sActionPreviewHint => 'náhled';
  @override
  String get sActionSelectHint => 'vybrat';
  @override
  String get sActionSwitchPathLabel => 'změnit cestu';
  @override
  String get sActionUseCameraHint => 'použít kameru';
  @override
  String get sNameDurationLabel => 'doba trvání';
  @override
  String get sUnitAssetCountLabel => 'počet';
}

// Path: receiveTab.infoBox
class _Translations$receiveTab$infoBox$cs extends Translations$receiveTab$infoBox$en {
  _Translations$receiveTab$infoBox$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get ip => 'IP:';
  @override
  String get port => 'Port:';
  @override
  String get alias => 'Alias:';
}

// Path: receiveTab.quickSave
class _Translations$receiveTab$quickSave$cs extends Translations$receiveTab$quickSave$en {
  _Translations$receiveTab$quickSave$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get off => _root.general.off;
  @override
  String get favorites => 'Oblíbené';
  @override
  String get on => _root.general.on;
}

// Path: sendTab.selection
class _Translations$sendTab$selection$cs extends Translations$sendTab$selection$en {
  _Translations$sendTab$selection$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Vybrat';
  @override
  String files({required Object files}) => 'Soubory: ${files}';
  @override
  String size({required Object size}) => 'Velikost: ${size}';
}

// Path: sendTab.picker
class _Translations$sendTab$picker$cs extends Translations$sendTab$picker$en {
  _Translations$sendTab$picker$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get file => 'Soubor';
  @override
  String get folder => 'Složka';
  @override
  String get media => 'Média';
  @override
  String get text => 'Text';
  @override
  String get app => 'Aplikace';
  @override
  String get clipboard => 'Vložit';
}

// Path: sendTab.sendModes
class _Translations$sendTab$sendModes$cs extends Translations$sendTab$sendModes$en {
  _Translations$sendTab$sendModes$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get single => 'Jediný příjemce';
  @override
  String get multiple => 'Více příjemců';
  @override
  String get link => 'Sdílet pomocí odkazu';
}

// Path: sendTab.diagnosis
class _Translations$sendTab$diagnosis$cs extends Translations$sendTab$diagnosis$en {
  _Translations$sendTab$diagnosis$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get scanning => 'Vyhledávání zařízení v okolí...';
  @override
  late final _Translations$sendTab$diagnosis$noInterface$cs noInterface = _Translations$sendTab$diagnosis$noInterface$cs._(_root);
  @override
  late final _Translations$sendTab$diagnosis$multicastUnavailable$cs multicastUnavailable = _Translations$sendTab$diagnosis$multicastUnavailable$cs._(
    _root,
  );
  @override
  late final _Translations$sendTab$diagnosis$scanNoResult$cs scanNoResult = _Translations$sendTab$diagnosis$scanNoResult$cs._(_root);
  @override
  String get rescan => 'Hledat znovu';
  @override
  String get bleHint =>
      'Zjišťování BLE je aktivní: zařízení jsou pomocí Bluetooth nalezena, jen pokud také používají tento fork se zapnutou možností; samotný přenos souborů stále probíhá přes síť.';
  @override
  late final _Translations$sendTab$diagnosis$manualFallback$cs manualFallback = _Translations$sendTab$diagnosis$manualFallback$cs._(_root);
}

// Path: settingsTab.general
class _Translations$settingsTab$general$cs extends Translations$settingsTab$general$en {
  _Translations$settingsTab$general$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Všeobecné';
  @override
  String get brightness => 'Motiv';
  @override
  late final _Translations$settingsTab$general$brightnessOptions$cs brightnessOptions = _Translations$settingsTab$general$brightnessOptions$cs._(
    _root,
  );
  @override
  String get color => 'Barva';
  @override
  late final _Translations$settingsTab$general$colorOptions$cs colorOptions = _Translations$settingsTab$general$colorOptions$cs._(_root);
  @override
  String get language => 'Jazyk';
  @override
  late final _Translations$settingsTab$general$languageOptions$cs languageOptions = _Translations$settingsTab$general$languageOptions$cs._(_root);
  @override
  String get saveWindowPlacement => 'Při ukončení uložit umístění okna';
  @override
  String get saveWindowPlacementWindows => 'Uložit polohu okna po ukončení';
  @override
  String get minimizeToTray => 'Při ukončení minimalizovat do lišty';
  @override
  String get launchAtStartup => 'Automatické spuštění po přihlášení';
  @override
  String get launchMinimized => 'Automatické spuštění: skrytý start';
  @override
  String get showInContextMenu => 'Zobrazit LocalSend v kontextové nabídce';
  @override
  String get animations => 'Animace';
}

// Path: settingsTab.receive
class _Translations$settingsTab$receive$cs extends Translations$settingsTab$receive$en {
  _Translations$settingsTab$receive$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Soubory';
  @override
  String get quickSave => _root.general.quickSave;
  @override
  String get quickSaveFromFavorites => _root.general.quickSaveFromFavorites;
  @override
  String get requirePin => _root.webSharePage.requirePin;
  @override
  String get autoFinish => 'Automatické dokončování';
  @override
  String get destination => 'Uložit do';
  @override
  String get downloads => '(Downloads)';
  @override
  String get saveToGallery => 'Uložit média do galerie';
  @override
  String get saveToHistory => 'Uložit do historie';
  @override
  String get verifyChecksums => 'Ověřovat kontrolní součty při přijímání souborů';
}

// Path: settingsTab.send
class _Translations$settingsTab$send$cs extends Translations$settingsTab$send$en {
  _Translations$settingsTab$send$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Poslat';
  @override
  String get shareViaLinkAutoAccept => 'Automaticky přijímat požadavky v režimu "Sdílet přes odkaz".';
  @override
  String get createChecksums => 'Vytvářet kontrolní součty při odesílání souborů';
  @override
  String get deleteSourceAfterSend => 'Po úspěšném odeslání smazat zdrojové soubory';
}

// Path: settingsTab.network
class _Translations$settingsTab$network$cs extends Translations$settingsTab$network$en {
  _Translations$settingsTab$network$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Síť';
  @override
  String get needRestart => 'Chcete-li použít nastavení, restartujte server!';
  @override
  String get server => 'Server';
  @override
  String get alias => 'Alias';
  @override
  String get deviceType => 'Typ zařízení';
  @override
  String get deviceModel => 'Model zařízení';
  @override
  String get port => 'Port';
  @override
  String get network => 'Síť';
  @override
  late final _Translations$settingsTab$network$networkOptions$cs networkOptions = _Translations$settingsTab$network$networkOptions$cs._(_root);
  @override
  String get discoveryTimeout => 'Časový limit zjišťování';
  @override
  String get maxInterfaces => 'Maximální počet rozhraní (chytré skenování)';
  @override
  String get vpnInterfaces => 'Zahrnout rozhraní VPN (chytré skenování)';
  @override
  String get vpnInterfacesHint =>
      'Skenovat také podsítě rozhraní VPN tunelů (Tailscale, WireGuard, ...). VPN obvykle nepřenáší vícesměrové vysílání, proto se jejich podsítě prozkoumávají náhradním HTTP skenováním.';
  @override
  String get useSystemName => 'Použít název systému';
  @override
  String get generateRandomAlias => 'Generovat náhodný alias';
  @override
  String portWarning({required Object defaultPort}) =>
      'Je možné, že vás ostatní zařízení nezjistí, protože používáte vlastní port. (výchozí: ${defaultPort})';
  @override
  String get encryption => 'Šifrování';
  @override
  String get multicastGroup => 'Multicast';
  @override
  String multicastGroupWarning({required Object defaultMulticast}) =>
      'Je možné, že vás ostatní zařízení nezjistí, protože používáte vlastní adresu vícesměrového vysílání. (výchozí: ${defaultMulticast})';
  @override
  String get bleDiscovery => 'Zjišťování BLE (experimentální)';
  @override
  String get bleDiscoveryHint =>
      'Najde okolní zařízení pomocí Bluetooth, i když síť blokuje vícesměrové vysílání (izolace AP). Funguje na Androidu, iOS, macOS a Windows; na Linuxu může toto zařízení najít ostatní, ale samo nalezeno být nemůže. Obě zařízení musí používat tento fork se zapnutou možností; samotný přenos souborů stále probíhá přes síť.';
  @override
  String get bleStatusActive =>
      'Aktivní: skenování i oznamování. Zařízení v okolí se zobrazí, jen pokud také používají tento fork se zapnutou možností.';
  @override
  String get bleStatusScanOnly =>
      'Aktivní: pouze skenování. Toto zařízení teď nemůže být přes Bluetooth zjištěno (tato platforma nepodporuje BLE oznamování, nebo ještě není k dispozici použitelná síťová adresa).';
  @override
  String get bleStatusPaused => 'Pozastaveno. Obnoví se, když se aplikace vrátí do popředí.';
  @override
  String get bleStatusPermissionDenied =>
      'Oprávnění k Bluetooth byla zamítnuta. Udělte oprávnění "Zařízení v okolí" (nebo "Poloha" na Androidu 11 a starším) v nastavení systému, pak tuto možnost vypněte a znovu zapněte.';
  @override
  String get bleStatusAdapterOff => 'Bluetooth je vypnuté nebo nedostupné. Zjišťování se samo restartuje, až bude Bluetooth znovu k dispozici.';
  @override
  String get bleStatusUnsupported => 'Na tomto zařízení nepodporováno: zjišťování BLE vyžaduje Android 7 a novější a rádio Bluetooth LE.';
  @override
  String get bleStatusLegacyLocation =>
      'V této verzi Androidu vyžaduje hledání jiných zařízení také zapnuté systémové služby určování polohy (oprávnění se vyžaduje automaticky; toto zařízení už může být ostatními nalezeno).';
  @override
  String get bleStatusError => 'Zjišťování BLE se nepodařilo spustit. Podrobnosti najdete v části Odstraňování problémů > Záznamy.';
  @override
  String get bleOpenSystemSettings => 'Otevřít nastavení systému';
}

// Path: settingsTab.other
class _Translations$settingsTab$other$cs extends Translations$settingsTab$other$en {
  _Translations$settingsTab$other$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ostatní';
  @override
  String get support => 'Podpora LocalSend';
  @override
  String get donate => 'Darovat';
  @override
  String get privacyPolicy => 'Zásady ochrany osobních údajů';
  @override
  String get termsOfUse => 'Podmínky použití';
}

// Path: troubleshootPage.firewall
class _Translations$troubleshootPage$firewall$cs extends Translations$troubleshootPage$firewall$en {
  _Translations$troubleshootPage$firewall$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Tato aplikace může odesílat soubory do jiných zařízení, ale jiná zařízení nemohou odesílat soubory do tohoto zařízení.';
  @override
  String solution({required Object port}) =>
      'S největší pravděpodobností se jedná o problém s firewallem. Můžete to vyřešit povolením příchozích připojení (UDP a TCP) na portu ${port}.';
  @override
  String get openFirewall => 'Otevřít bránu firewall';
}

// Path: troubleshootPage.noDiscovery
class _Translations$troubleshootPage$noDiscovery$cs extends Translations$troubleshootPage$noDiscovery$en {
  _Translations$troubleshootPage$noDiscovery$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Toto zařízení nemůže zjistit jiná zařízení.';
  @override
  String get solution =>
      'Ujistěte se, že jsou všechna zařízení ve stejné síti Wi-Fi a sdílejí stejnou konfiguraci (port, adresa vícesměrového vysílání, šifrování). Můžete zkusit zadat IP adresu cílového zařízení ručně. Pokud to funguje, zvažte přidání tohoto zařízení do oblíbených, aby mohlo být v budoucnu automaticky objeveno.';
}

// Path: troubleshootPage.noConnection
class _Translations$troubleshootPage$noConnection$cs extends Translations$troubleshootPage$noConnection$en {
  _Translations$troubleshootPage$noConnection$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Obě zařízení se nemohou navzájem objevit ani nemohou sdílet soubory.';
  @override
  String get solution =>
      'Problém je na obou stranách? Pak se musíte ujistit, že jsou obě zařízení ve stejné wifi síti a sdílejí stejnou konfiguraci (port, multicastová adresa, šifrování). Wifi nemusí umožňovat komunikaci mezi účastníky. V takovém případě musí být tato možnost povolena na routeru.';
}

// Path: receiveHistoryPage.entryActions
class _Translations$receiveHistoryPage$entryActions$cs extends Translations$receiveHistoryPage$entryActions$en {
  _Translations$receiveHistoryPage$entryActions$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get open => 'Otevřít soubor';
  @override
  String get showInFolder => 'Zobrazit ve složce';
  @override
  String get info => 'Informace';
  @override
  String get deleteFromHistory => 'Smazat z historie';
}

// Path: deviceDetailsPage.info
class _Translations$deviceDetailsPage$info$cs extends Translations$deviceDetailsPage$info$en {
  _Translations$deviceDetailsPage$info$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get name => 'Název';
  @override
  String get address => 'Adresa';
  @override
  String get version => 'Verze';
  @override
  String protocol({required Object version}) => 'Protokol v${version}';
}

// Path: deviceDetailsPage.logs
class _Translations$deviceDetailsPage$logs$cs extends Translations$deviceDetailsPage$logs$en {
  _Translations$deviceDetailsPage$logs$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Záznamy';
  @override
  String get empty => 'Žádné záznamy nejsou k dispozici.';
  @override
  String discovered({required Object protocol, required Object host}) => 'Objeveno přes ${protocol} (${host})';
  @override
  String updated({required Object protocol, required Object host}) => 'Aktualizováno přes ${protocol} (${host})';
}

// Path: progressPage.checksum
class _Translations$progressPage$checksum$cs extends Translations$progressPage$checksum$en {
  _Translations$progressPage$checksum$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get verified => 'Kontrolní součty ověřeny';
  @override
  String partiallyVerified({required Object curr, required Object n}) => 'Kontrolní součty ověřeny pro ${curr} / ${n} souborů';
  @override
  String get notVerifiable => 'Odesílatel neposkytl kontrolní součty';
  @override
  String get disabled => 'Ověřování kontrolních součtů je vypnuto';
  @override
  String attached({required Object curr, required Object n}) => 'Kontrolní součty připojeny (${curr} / ${n} souborů)';
}

// Path: progressPage.total
class _Translations$progressPage$total$cs extends Translations$progressPage$total$en {
  _Translations$progressPage$total$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$progressPage$total$title$cs title = _Translations$progressPage$total$title$cs._(_root);
  @override
  String count({required Object curr, required Object n}) => 'Soubory: ${curr} / ${n}';
  @override
  String size({required Object curr, required Object n}) => 'Velikost: ${curr} / ${n}';
  @override
  String speed({required Object speed}) => 'Rychlost: ${speed}/s';
}

// Path: progressPage.remainingTime
class _Translations$progressPage$remainingTime$cs extends Translations$progressPage$remainingTime$en {
  _Translations$progressPage$remainingTime$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String minutesUnit({required num m}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(
    m,
    other: '${m}m',
  );
  @override
  String hoursUnit({required num h}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('cs'))(
    h,
    other: '${h}h',
  );
  @override
  String minutes({required Object m, required Object ss}) => '${m}:${ss}';
  @override
  String hours({required num h, required num m}) =>
      '${_root.progressPage.remainingTime.hoursUnit(h: h)} ${_root.progressPage.remainingTime.minutesUnit(m: m)}';
}

// Path: whatsNewPage.changes
class _Translations$whatsNewPage$changes$cs extends Translations$whatsNewPage$changes$en {
  _Translations$whatsNewPage$changes$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$whatsNewPage$changes$v1_18_0$cs v1_18_0 = _Translations$whatsNewPage$changes$v1_18_0$cs._(_root);
}

// Path: dialogs.addFile
class _Translations$dialogs$addFile$cs extends Translations$dialogs$addFile$en {
  _Translations$dialogs$addFile$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Přidat do výběru';
  @override
  String get content => 'Co chcete přidat?';
}

// Path: dialogs.openFile
class _Translations$dialogs$openFile$cs extends Translations$dialogs$openFile$en {
  _Translations$dialogs$openFile$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Otevřít soubor';
  @override
  String get content => 'Chcete otevřít přijatý soubor?';
}

// Path: dialogs.addressInput
class _Translations$dialogs$addressInput$cs extends Translations$dialogs$addressInput$en {
  _Translations$dialogs$addressInput$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Zadat adresu';
  @override
  String get hashtag => 'Hashtag';
  @override
  String get ip => 'IP Adresa';
  @override
  String get recentlyUsed => 'Nedávno použité: ';
  @override
  String get noHashtagCandidates =>
      'Aktuální síť nemá IPv4 adresu, takže hashtag nelze rozšířit na kandidátskou adresu. Zadejte prosím celou adresu (např. 192.168.1.5 nebo fe80::1).';
  @override
  late final _Translations$dialogs$addressInput$validation$cs validation = _Translations$dialogs$addressInput$validation$cs._(_root);
}

// Path: dialogs.cancelSession
class _Translations$dialogs$cancelSession$cs extends Translations$dialogs$cancelSession$en {
  _Translations$dialogs$cancelSession$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Zrušit přenos souborů';
  @override
  String get content => 'Opravdu chcete zrušit přenos souborů?';
}

// Path: dialogs.connectionError
class _Translations$dialogs$connectionError$cs extends Translations$dialogs$connectionError$en {
  _Translations$dialogs$connectionError$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Připojení se nezdařilo';
  @override
  late final _Translations$dialogs$connectionError$timeout$cs timeout = _Translations$dialogs$connectionError$timeout$cs._(_root);
  @override
  late final _Translations$dialogs$connectionError$refused$cs refused = _Translations$dialogs$connectionError$refused$cs._(_root);
  @override
  late final _Translations$dialogs$connectionError$forbidden$cs forbidden = _Translations$dialogs$connectionError$forbidden$cs._(_root);
  @override
  late final _Translations$dialogs$connectionError$other$cs other = _Translations$dialogs$connectionError$other$cs._(_root);
  @override
  String get retry => 'Zkusit znovu';
  @override
  String get details => 'Podrobnosti chyby:';
}

// Path: dialogs.deleteSourceAfterSendDialog
class _Translations$dialogs$deleteSourceAfterSendDialog$cs extends Translations$dialogs$deleteSourceAfterSendDialog$en {
  _Translations$dialogs$deleteSourceAfterSendDialog$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Smazat zdrojové soubory';
  @override
  String get content => 'Po úspěšném odeslání budou soubory z tohoto zařízení smazány. Tuto akci nelze vrátit zpět.';
}

// Path: dialogs.cannotOpenFile
class _Translations$dialogs$cannotOpenFile$cs extends Translations$dialogs$cannotOpenFile$en {
  _Translations$dialogs$cannotOpenFile$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Nelze otevřít soubor';
  @override
  String content({required Object file}) => 'Nelze otevřít "${file}". Byl tento soubor přesunut, přejmenován nebo smazán?';
}

// Path: dialogs.encryptionDisabledNotice
class _Translations$dialogs$encryptionDisabledNotice$cs extends Translations$dialogs$encryptionDisabledNotice$en {
  _Translations$dialogs$encryptionDisabledNotice$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Šifrování zakázáno';
  @override
  String get content => 'Komunikace nyní probíhá prostřednictvím nešifrovaného protokolu HTTP. Chcete-li použít HTTPS, znovu povolte šifrování.';
}

// Path: dialogs.errorDialog
class _Translations$dialogs$errorDialog$cs extends Translations$dialogs$errorDialog$en {
  _Translations$dialogs$errorDialog$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.error;
}

// Path: dialogs.favoriteDialog
class _Translations$dialogs$favoriteDialog$cs extends Translations$dialogs$favoriteDialog$en {
  _Translations$dialogs$favoriteDialog$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Oblíbené';
  @override
  String get noFavorites => 'Zatím nemáte žádná oblíbená zařízení.';
  @override
  String get addFavorite => 'Přidat';
}

// Path: dialogs.favoriteDeleteDialog
class _Translations$dialogs$favoriteDeleteDialog$cs extends Translations$dialogs$favoriteDeleteDialog$en {
  _Translations$dialogs$favoriteDeleteDialog$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Smazat z oblíbených';
  @override
  String content({required Object name}) => 'Opravdu chcete smazat "${name}" z oblíbených?';
}

// Path: dialogs.favoriteEditDialog
class _Translations$dialogs$favoriteEditDialog$cs extends Translations$dialogs$favoriteEditDialog$en {
  _Translations$dialogs$favoriteEditDialog$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get titleAdd => 'Přidat k oblíbeným';
  @override
  String get titleEdit => 'Upravit';
  @override
  String get name => 'Název zařízení';
  @override
  String get auto => '(auto)';
  @override
  String get ip => 'IP adresa';
  @override
  String get port => 'Port';
}

// Path: dialogs.fileInfo
class _Translations$dialogs$fileInfo$cs extends Translations$dialogs$fileInfo$en {
  _Translations$dialogs$fileInfo$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Informace o souboru';
  @override
  String get fileName => 'Název souboru:';
  @override
  String get path => 'Cesta:';
  @override
  String get size => 'Velikost:';
  @override
  String get sender => 'Odesílatel:';
  @override
  String get time => 'Čas:';
}

// Path: dialogs.fileNameInput
class _Translations$dialogs$fileNameInput$cs extends Translations$dialogs$fileNameInput$en {
  _Translations$dialogs$fileNameInput$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Zadejte název souboru';
  @override
  String original({required Object original}) => 'Původní: ${original}';
}

// Path: dialogs.historyClearDialog
class _Translations$dialogs$historyClearDialog$cs extends Translations$dialogs$historyClearDialog$en {
  _Translations$dialogs$historyClearDialog$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Smazat historii';
  @override
  String get content => 'Opravdu chcete smazat celou historii?';
}

// Path: dialogs.localNetworkUnauthorized
class _Translations$dialogs$localNetworkUnauthorized$cs extends Translations$dialogs$localNetworkUnauthorized$en {
  _Translations$dialogs$localNetworkUnauthorized$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.dialogs.noPermission.title;
  @override
  String get description =>
      'LocalSend nemůže najít jiná zařízení, aniž by měl oprávnění skenovat místní síť. Udělte prosím toto oprávnění v nastavení.';
  @override
  String get gotoSettings => 'Nastavení';
}

// Path: dialogs.messageInput
class _Translations$dialogs$messageInput$cs extends Translations$dialogs$messageInput$en {
  _Translations$dialogs$messageInput$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Napište zprávu';
  @override
  String get multiline => 'Více řádků';
}

// Path: dialogs.noFiles
class _Translations$dialogs$noFiles$cs extends Translations$dialogs$noFiles$en {
  _Translations$dialogs$noFiles$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Žádný soubor nevybrán';
  @override
  String get content => 'Vyberte prosím alespoň jeden soubor.';
}

// Path: dialogs.noPermission
class _Translations$dialogs$noPermission$cs extends Translations$dialogs$noPermission$en {
  _Translations$dialogs$noPermission$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Žádné oprávnění';
  @override
  String get content => 'Neposkytli jste potřebná oprávnění. Prosím, udělte je v nastavení.';
}

// Path: dialogs.notAvailableOnPlatform
class _Translations$dialogs$notAvailableOnPlatform$cs extends Translations$dialogs$notAvailableOnPlatform$en {
  _Translations$dialogs$notAvailableOnPlatform$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Není k dispozici';
  @override
  String get content => 'Tato funkce je dostupná pouze na:';
}

// Path: dialogs.qr
class _Translations$dialogs$qr$cs extends Translations$dialogs$qr$en {
  _Translations$dialogs$qr$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'QR kód';
}

// Path: dialogs.quickActions
class _Translations$dialogs$quickActions$cs extends Translations$dialogs$quickActions$en {
  _Translations$dialogs$quickActions$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Rychlé akce';
  @override
  String get counter => 'Číslo';
  @override
  String get prefix => 'Předpona';
  @override
  String get padZero => 'Přidat nuly';
  @override
  String get sortBeforeCount => 'Nejprve seřadit abecedně';
  @override
  String get random => 'Náhodné jméno';
}

// Path: dialogs.quickSaveNotice
class _Translations$dialogs$quickSaveNotice$cs extends Translations$dialogs$quickSaveNotice$en {
  _Translations$dialogs$quickSaveNotice$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSave;
  @override
  String get content => 'Požadavky na soubor jsou automaticky přijímány. Uvědomte si, že každý v místní síti vám může posílat soubory.';
}

// Path: dialogs.quickSaveFromFavoritesNotice
class _Translations$dialogs$quickSaveFromFavoritesNotice$cs extends Translations$dialogs$quickSaveFromFavoritesNotice$en {
  _Translations$dialogs$quickSaveFromFavoritesNotice$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSaveFromFavorites;
  @override
  List<String> get content => [
    'Žádosti o soubory jsou nyní přijímány automaticky ze zařízení ve vašem seznamu oblíbených.',
  ];
}

// Path: dialogs.pin
class _Translations$dialogs$pin$cs extends Translations$dialogs$pin$en {
  _Translations$dialogs$pin$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Vložit PIN';
}

// Path: dialogs.sendModeHelp
class _Translations$dialogs$sendModeHelp$cs extends Translations$dialogs$sendModeHelp$en {
  _Translations$dialogs$sendModeHelp$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Režimy odesílání';
  @override
  String get single => 'Odešle soubory jednomu příjemci. Po dokončení přenosu souboru bude výběr vymazán.';
  @override
  String get multiple => 'Odešle soubory více příjemcům. Výběr nebude vymazán.';
  @override
  String get link => 'Příjemci, kteří nemají nainstalovaný LocalSend, si mohou vybrané soubory stáhnout otevřením odkazu ve svém prohlížeči.';
}

// Path: dialogs.startupError
class _Translations$dialogs$startupError$cs extends Translations$dialogs$startupError$en {
  _Translations$dialogs$startupError$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Server se nepodařilo spustit';
  @override
  String port({required Object port}) => 'Port: ${port}';
  @override
  late final _Translations$dialogs$startupError$windowsAccessDenied$cs windowsAccessDenied =
      _Translations$dialogs$startupError$windowsAccessDenied$cs._(_root);
  @override
  late final _Translations$dialogs$startupError$addressInUse$cs addressInUse = _Translations$dialogs$startupError$addressInUse$cs._(_root);
  @override
  late final _Translations$dialogs$startupError$generic$cs generic = _Translations$dialogs$startupError$generic$cs._(_root);
  @override
  String get details => 'Podrobnosti chyby:';
  @override
  String get copyDetails => 'Zkopírovat podrobnosti';
  @override
  String get openSettings => 'Otevřít nastavení';
}

// Path: dialogs.zoom
class _Translations$dialogs$zoom$cs extends Translations$dialogs$zoom$en {
  _Translations$dialogs$zoom$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'URL';
}

// Path: sendTab.diagnosis.noInterface
class _Translations$sendTab$diagnosis$noInterface$cs extends Translations$sendTab$diagnosis$noInterface$en {
  _Translations$sendTab$diagnosis$noInterface$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Žádné připojení k síti';
  @override
  String get advice => 'Toto zařízení není připojeno k žádné síti. Zkontrolujte připojení tohoto zařízení k síti Wi-Fi nebo kabelu.';
}

// Path: sendTab.diagnosis.multicastUnavailable
class _Translations$sendTab$diagnosis$multicastUnavailable$cs extends Translations$sendTab$diagnosis$multicastUnavailable$en {
  _Translations$sendTab$diagnosis$multicastUnavailable$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Vícesměrové vysílání není dostupné';
  @override
  String advice({required Object port}) =>
      'LocalSend nemůže v této síti použít zjišťování pomocí vícesměrového vysílání. Ujistěte se, že jsou obě zařízení ve stejné síti a že izolace AP ani firewall neblokují UDP port ${port}.';
  @override
  String reason({required Object reason}) => 'Příčina: ${reason}';
}

// Path: sendTab.diagnosis.scanNoResult
class _Translations$sendTab$diagnosis$scanNoResult$cs extends Translations$sendTab$diagnosis$scanNoResult$en {
  _Translations$sendTab$diagnosis$scanNoResult$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Nenalezena žádná zařízení';
  @override
  String get advice =>
      'Vyhledávání funguje, ale žádné zařízení neodpovědělo na oznámení ani na skenování sítě. Druhé zařízení může být offline, v režimu spánku nebo blokováno firewallem. Ujistěte se, že na druhém zařízení běží LocalSend.';
  @override
  String detail({required Object announcements, required Object scans}) =>
      'Odesláno ${announcements} oznámení a provedeno ${scans} skenování sítě bez odpovědi.';
}

// Path: sendTab.diagnosis.manualFallback
class _Translations$sendTab$diagnosis$manualFallback$cs extends Translations$sendTab$diagnosis$manualFallback$en {
  _Translations$sendTab$diagnosis$manualFallback$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get message =>
      'IP adresy se často mění. K zařízení, které není v seznamu, se stále můžete dostat: přidejte si ho do oblíbených nebo zadejte jeho adresu ručně.';
  @override
  String get openFavorites => 'Otevřít oblíbené';
  @override
  String get manualInput => 'Zadat adresu ručně';
}

// Path: settingsTab.general.brightnessOptions
class _Translations$settingsTab$general$brightnessOptions$cs extends Translations$settingsTab$general$brightnessOptions$en {
  _Translations$settingsTab$general$brightnessOptions$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Systém';
  @override
  String get dark => 'Tmavý';
  @override
  String get light => 'Světlý';
}

// Path: settingsTab.general.colorOptions
class _Translations$settingsTab$general$colorOptions$cs extends Translations$settingsTab$general$colorOptions$en {
  _Translations$settingsTab$general$colorOptions$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Systém';
  @override
  String get oled => 'OLED';
  @override
  String get custom => 'Vlastní';
}

// Path: settingsTab.general.languageOptions
class _Translations$settingsTab$general$languageOptions$cs extends Translations$settingsTab$general$languageOptions$en {
  _Translations$settingsTab$general$languageOptions$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Systém';
}

// Path: settingsTab.network.networkOptions
class _Translations$settingsTab$network$networkOptions$cs extends Translations$settingsTab$network$networkOptions$en {
  _Translations$settingsTab$network$networkOptions$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'Vše';
  @override
  String get filtered => 'Filtrované';
}

// Path: progressPage.total.title
class _Translations$progressPage$total$title$cs extends Translations$progressPage$total$title$en {
  _Translations$progressPage$total$title$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String sending({required Object time}) => 'Celkový průběh (${time})';
  @override
  String get finishedError => 'Dokončeno s chybou';
  @override
  String get canceledSender => 'Zrušeno odesílatelem';
  @override
  String get canceledReceiver => 'Zrušeno příjemcem';
}

// Path: whatsNewPage.changes.v1_18_0
class _Translations$whatsNewPage$changes$v1_18_0$cs extends Translations$whatsNewPage$changes$v1_18_0$en with WhatsNewStrings {
  _Translations$whatsNewPage$changes$v1_18_0$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  List<String> get changes => [
    'Šifrování již nezpomaluje přenosy. Pokud jste je dříve vypnuli, bylo na tomto zařízení znovu zapnuto.',
    'Požadavky od oblíbených zařízení jsou nyní přijímány automaticky. Tato funkce je ve výchozím nastavení zapnutá a lze ji v nastavení vypnout.',
    'Na Androidu přenosy pokračují, i když je aplikace na pozadí nebo je obrazovka vypnutá. Na iOS musí aplikace stále zůstat v popředí.',
  ];
}

// Path: dialogs.addressInput.validation
class _Translations$dialogs$addressInput$validation$cs extends Translations$dialogs$addressInput$validation$en {
  _Translations$dialogs$addressInput$validation$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get invalid => 'Zadejte platnou IPv4 adresu, IPv6 adresu nebo název hostitele.';
  @override
  String get scheme => 'Zadejte pouze adresu, bez "http://" nebo "https://".';
  @override
  String get port => 'Zadejte pouze adresu. Port se bere z nastavení.';
}

// Path: dialogs.connectionError.timeout
class _Translations$dialogs$connectionError$timeout$cs extends Translations$dialogs$connectionError$timeout$en {
  _Translations$dialogs$connectionError$timeout$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Zařízení včas neodpovědělo.';
  @override
  String get advice =>
      'Pravděpodobně je offline, v režimu spánku nebo připojení blokuje firewall. Ujistěte se, že na druhém zařízení běží LocalSend a že jsou obě zařízení ve stejné síti.';
}

// Path: dialogs.connectionError.refused
class _Translations$dialogs$connectionError$refused$cs extends Translations$dialogs$connectionError$refused$en {
  _Translations$dialogs$connectionError$refused$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Zařízení odmítlo připojení.';
  @override
  String get advice =>
      'Zdá se, že na cílovém zařízení LocalSend neběží, nebo naslouchá na jiném portu. Spusťte LocalSend na druhém zařízení nebo zkontrolujte port.';
}

// Path: dialogs.connectionError.forbidden
class _Translations$dialogs$connectionError$forbidden$cs extends Translations$dialogs$connectionError$forbidden$en {
  _Translations$dialogs$connectionError$forbidden$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Zařízení požadavek odmítlo.';
  @override
  String get advice =>
      'Možná je vyžadován PIN nebo se změnilo spárování se zařízením. Zkontrolujte PIN a nastavení rychlého uložení na cílovém zařízení.';
}

// Path: dialogs.connectionError.other
class _Translations$dialogs$connectionError$other$cs extends Translations$dialogs$connectionError$other$en {
  _Translations$dialogs$connectionError$other$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Připojení se nepodařilo navázat.';
  @override
  String get advice => 'Zkontrolujte adresu a port, ujistěte se, že na cílovém zařízení běží LocalSend a že připojení neblokuje firewall ani VPN.';
}

// Path: dialogs.startupError.windowsAccessDenied
class _Translations$dialogs$startupError$windowsAccessDenied$cs extends Translations$dialogs$startupError$windowsAccessDenied$en {
  _Translations$dialogs$startupError$windowsAccessDenied$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Windows zamítly přístup k portu (chyba soketu 10013).';
  @override
  String get advice =>
      'Obvykle je to způsobeno rozsahem portů rezervovaným pro Hyper-V, WSL nebo Docker, nebo poškozeným katalogem Winsock:\n• Změňte port v nastavení (Síť)\n• Zkontrolujte rezervované rozsahy příkazem: netsh interface ipv4 show excludedportrange protocol=tcp\n• Opravte Winsock jako správce příkazem: netsh winsock reset (následně restartujte počítač)';
}

// Path: dialogs.startupError.addressInUse
class _Translations$dialogs$startupError$addressInUse$cs extends Translations$dialogs$startupError$addressInUse$en {
  _Translations$dialogs$startupError$addressInUse$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Port již používá jiná aplikace.';
  @override
  String get advice =>
      'Na tomto portu naslouchá jiný program (nebo druhá instance LocalSend):\n• Zavřete druhou aplikaci, nebo\n• Změňte port v nastavení (Síť)';
}

// Path: dialogs.startupError.generic
class _Translations$dialogs$startupError$generic$cs extends Translations$dialogs$startupError$generic$en {
  _Translations$dialogs$startupError$generic$cs._(TranslationsCs root) : this._root = root, super.internal(root);

  final TranslationsCs _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Server se nepodařilo spustit.';
  @override
  String get advice => '• Zkontrolujte firewall a nastavení sítě\n• Zkuste změnit port v nastavení (Síť)';
}
