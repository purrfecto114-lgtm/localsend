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
class TranslationsCa extends Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsCa({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ca,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <ca>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  late final TranslationsCa _root = this; // ignore: unused_field

  @override
  TranslationsCa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsCa(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'LocalSend';
  @override
  late final _Translations$general$ca general = _Translations$general$ca._(_root);
  @override
  late final _Translations$receiveTab$ca receiveTab = _Translations$receiveTab$ca._(_root);
  @override
  late final _Translations$sendTab$ca sendTab = _Translations$sendTab$ca._(_root);
  @override
  late final _Translations$settingsTab$ca settingsTab = _Translations$settingsTab$ca._(_root);
  @override
  late final _Translations$troubleshootPage$ca troubleshootPage = _Translations$troubleshootPage$ca._(_root);
  @override
  late final _Translations$networkInterfacesPage$ca networkInterfacesPage = _Translations$networkInterfacesPage$ca._(_root);
  @override
  late final _Translations$receiveHistoryPage$ca receiveHistoryPage = _Translations$receiveHistoryPage$ca._(_root);
  @override
  late final _Translations$apkPickerPage$ca apkPickerPage = _Translations$apkPickerPage$ca._(_root);
  @override
  late final _Translations$selectedFilesPage$ca selectedFilesPage = _Translations$selectedFilesPage$ca._(_root);
  @override
  late final _Translations$deviceDetailsPage$ca deviceDetailsPage = _Translations$deviceDetailsPage$ca._(_root);
  @override
  late final _Translations$verifyPage$ca verifyPage = _Translations$verifyPage$ca._(_root);
  @override
  late final _Translations$receivePage$ca receivePage = _Translations$receivePage$ca._(_root);
  @override
  late final _Translations$receiveOptionsPage$ca receiveOptionsPage = _Translations$receiveOptionsPage$ca._(_root);
  @override
  late final _Translations$sendPage$ca sendPage = _Translations$sendPage$ca._(_root);
  @override
  late final _Translations$progressPage$ca progressPage = _Translations$progressPage$ca._(_root);
  @override
  late final _Translations$webSharePage$ca webSharePage = _Translations$webSharePage$ca._(_root);
  @override
  late final _Translations$webReceivePage$ca webReceivePage = _Translations$webReceivePage$ca._(_root);
  @override
  late final _Translations$aboutPage$ca aboutPage = _Translations$aboutPage$ca._(_root);
  @override
  late final _Translations$donationPage$ca donationPage = _Translations$donationPage$ca._(_root);
  @override
  late final _Translations$changelogPage$ca changelogPage = _Translations$changelogPage$ca._(_root);
  @override
  late final _Translations$whatsNewPage$ca whatsNewPage = _Translations$whatsNewPage$ca._(_root);
  @override
  late final _Translations$aliasGenerator$ca aliasGenerator = _Translations$aliasGenerator$ca._(_root);
  @override
  late final _Translations$dialogs$ca dialogs = _Translations$dialogs$ca._(_root);
  @override
  late final _Translations$sanitization$ca sanitization = _Translations$sanitization$ca._(_root);
  @override
  late final _Translations$tray$ca tray = _Translations$tray$ca._(_root);
  @override
  late final _Translations$web$ca web = _Translations$web$ca._(_root);
  @override
  late final _Translations$assetPicker$ca assetPicker = _Translations$assetPicker$ca._(_root);
}

// Path: general
class _Translations$general$ca extends Translations$general$en {
  _Translations$general$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get accept => 'Accepta';
  @override
  String get accepted => 'Acceptat';
  @override
  String get add => 'Afegeix';
  @override
  String get advanced => 'Avançades';
  @override
  String get cancel => 'Cancel·la';
  @override
  String get close => 'Tanca';
  @override
  String get confirm => 'Confirma';
  @override
  String get continueStr => 'Continua';
  @override
  String get copy => 'Copia';
  @override
  String get copiedToClipboard => 'S\'ha copiat al porta-retalls';
  @override
  String get decline => 'Rebutja';
  @override
  String get done => 'Fet';
  @override
  String get delete => 'Elimina';
  @override
  String get edit => 'Edita';
  @override
  String get error => 'Error';
  @override
  String get example => 'Exemple';
  @override
  String get files => 'Fitxers';
  @override
  String get finished => 'Finalitzat';
  @override
  String get hide => 'Amaga';
  @override
  String get off => 'Desactivat';
  @override
  String get offline => 'Desconnectat';
  @override
  String get on => 'Activat';
  @override
  String get online => 'En línia';
  @override
  String get open => 'Obre';
  @override
  String get queue => 'Cua';
  @override
  String get quickSave => 'Desat ràpid';
  @override
  String get quickSaveFromFavorites => 'Desat ràpid per als «Preferits»';
  @override
  String get renamed => 'Canvia el nom';
  @override
  String get reset => 'Desfés els canvis';
  @override
  String get restart => 'Reinicia';
  @override
  String get settings => 'Configuració';
  @override
  String get skipped => 'Omès';
  @override
  String get start => 'Inicia';
  @override
  String get stop => 'Atura';
  @override
  String get save => 'Desa';
  @override
  String get unchanged => 'Sense canvis';
  @override
  String get unknown => 'Desconegut';
  @override
  String get noItemInClipboard => 'No hi ha elements al porta-retalls.';
}

// Path: receiveTab
class _Translations$receiveTab$ca extends Translations$receiveTab$en {
  _Translations$receiveTab$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Recepció';
  @override
  late final _Translations$receiveTab$infoBox$ca infoBox = _Translations$receiveTab$infoBox$ca._(_root);
  @override
  late final _Translations$receiveTab$quickSave$ca quickSave = _Translations$receiveTab$quickSave$ca._(_root);
  @override
  String get link => 'Rebre mitjançant enllaç';
}

// Path: sendTab
class _Translations$sendTab$ca extends Translations$sendTab$en {
  _Translations$sendTab$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Envia';
  @override
  late final _Translations$sendTab$selection$ca selection = _Translations$sendTab$selection$ca._(_root);
  @override
  late final _Translations$sendTab$picker$ca picker = _Translations$sendTab$picker$ca._(_root);
  @override
  String get shareIntentInfo =>
      'També podeu utilitzar l\'opció «Comparteix» del vostre dispositiu mòbil per a seleccionar fitxers d\'una manera més fàcil.';
  @override
  String get nearbyDevices => 'Dispositius propers';
  @override
  String get thisDevice => 'Aquest dispositiu';
  @override
  String get scan => 'Cerca dispositius';
  @override
  String get manualSending => 'Enviament manual';
  @override
  String get sendMode => 'Mode d\'enviament';
  @override
  late final _Translations$sendTab$sendModes$ca sendModes = _Translations$sendTab$sendModes$ca._(_root);
  @override
  String get sendModeHelp => 'Explicació';
  @override
  String get help => 'Comproveu que el destinatari està en la mateixa xarxa Wi-Fi.';
  @override
  String get placeItems => 'Col·loqueu els elements per compartir.';
  @override
  late final _Translations$sendTab$diagnosis$ca diagnosis = _Translations$sendTab$diagnosis$ca._(_root);
}

// Path: settingsTab
class _Translations$settingsTab$ca extends Translations$settingsTab$en {
  _Translations$settingsTab$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Configuració';
  @override
  late final _Translations$settingsTab$general$ca general = _Translations$settingsTab$general$ca._(_root);
  @override
  late final _Translations$settingsTab$receive$ca receive = _Translations$settingsTab$receive$ca._(_root);
  @override
  late final _Translations$settingsTab$send$ca send = _Translations$settingsTab$send$ca._(_root);
  @override
  late final _Translations$settingsTab$network$ca network = _Translations$settingsTab$network$ca._(_root);
  @override
  late final _Translations$settingsTab$other$ca other = _Translations$settingsTab$other$ca._(_root);
  @override
  String get advancedSettings => 'Configuració avançada';
}

// Path: troubleshootPage
class _Translations$troubleshootPage$ca extends Translations$troubleshootPage$en {
  _Translations$troubleshootPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Solució de problemes';
  @override
  String get subTitle => 'L\'aplicació no funciona com s\'espera? Aquí podeu trobar solucions als problemes més comuns.';
  @override
  String get solution => 'Solució:';
  @override
  String get fixButton => 'Corregeix de manera automàtica';
  @override
  late final _Translations$troubleshootPage$firewall$ca firewall = _Translations$troubleshootPage$firewall$ca._(_root);
  @override
  late final _Translations$troubleshootPage$noDiscovery$ca noDiscovery = _Translations$troubleshootPage$noDiscovery$ca._(_root);
  @override
  late final _Translations$troubleshootPage$noConnection$ca noConnection = _Translations$troubleshootPage$noConnection$ca._(_root);
}

// Path: networkInterfacesPage
class _Translations$networkInterfacesPage$ca extends Translations$networkInterfacesPage$en {
  _Translations$networkInterfacesPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Interfícies de xarxa';
  @override
  String get info =>
      'De manera predefinida, el LocalSend utilitza totes les interfícies de xarxa disponibles. Podeu excloure les xarxes no desitjades aquí. Cal que reinicieu el servidor per a aplicar els canvis.';
  @override
  String get preview => 'Previsualitza';
  @override
  String get whitelist => 'Llista de permeses';
  @override
  String get blacklist => 'Llista de denegades';
}

// Path: receiveHistoryPage
class _Translations$receiveHistoryPage$ca extends Translations$receiveHistoryPage$en {
  _Translations$receiveHistoryPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Historial';
  @override
  String get openFolder => 'Obre la carpeta';
  @override
  String get deleteHistory => 'Elimina l\'historial';
  @override
  String get empty => 'L\'historial està buit.';
  @override
  late final _Translations$receiveHistoryPage$entryActions$ca entryActions = _Translations$receiveHistoryPage$entryActions$ca._(_root);
}

// Path: apkPickerPage
class _Translations$apkPickerPage$ca extends Translations$apkPickerPage$en {
  _Translations$apkPickerPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Aplicacions (APK)';
  @override
  String get excludeSystemApps => 'Exclou les aplicacions del sistema';
  @override
  String get excludeAppsWithoutLaunchIntent => 'Exclou les aplicacions no executables';
  @override
  String apps({required Object n}) => '${n} Aplicacions';
}

// Path: selectedFilesPage
class _Translations$selectedFilesPage$ca extends Translations$selectedFilesPage$en {
  _Translations$selectedFilesPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get deleteAll => 'Elimina-ho tot';
}

// Path: deviceDetailsPage
class _Translations$deviceDetailsPage$ca extends Translations$deviceDetailsPage$en {
  _Translations$deviceDetailsPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Detalls del dispositiu';
  @override
  String get favorite => 'Preferit';
  @override
  String get verify => 'Verifica';
  @override
  late final _Translations$deviceDetailsPage$info$ca info = _Translations$deviceDetailsPage$info$ca._(_root);
  @override
  late final _Translations$deviceDetailsPage$logs$ca logs = _Translations$deviceDetailsPage$logs$ca._(_root);
}

// Path: verifyPage
class _Translations$verifyPage$ca extends Translations$verifyPage$en {
  _Translations$verifyPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Verifica';
  @override
  String get icons => 'Icones';
  @override
  String get text => 'Text';
  @override
  String get question => 'Es veu igual a l\'altre dispositiu?';
}

// Path: receivePage
class _Translations$receivePage$ca extends Translations$receivePage$en {
  _Translations$receivePage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String subTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ca'))(
    n,
    one: 'vol enviar-vos un fitxer',
    other: 'vol enviar-vos ${n} fitxers',
  );
  @override
  String get subTitleMessage => 'us ha enviat un missatge:';
  @override
  String get subTitleLink => 'us ha enviat un enllaç:';
  @override
  String get canceled => 'El remitent ha cancel·lat la petició.';
}

// Path: receiveOptionsPage
class _Translations$receiveOptionsPage$ca extends Translations$receiveOptionsPage$en {
  _Translations$receiveOptionsPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Opcions';
  @override
  String get destination => _root.settingsTab.receive.destination;
  @override
  String get appDirectory => '(Carpeta LocalSend)';
  @override
  String get saveToGallery => _root.settingsTab.receive.saveToGallery;
  @override
  String get saveToGalleryOff => 'S\'ha desactivat automàticament perquè hi ha carpetes.';
}

// Path: sendPage
class _Translations$sendPage$ca extends Translations$sendPage$en {
  _Translations$sendPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String calculatingChecksum({required Object curr, required Object n}) => 'S\'està calculant la suma de verificació (${curr} / ${n})';
  @override
  String get waiting => 'S\'està esperant una resposta…';
  @override
  String get rejected => 'El destinatari ha rebutjat la petició.';
  @override
  String get tooManyAttempts => _root.web.tooManyAttempts;
  @override
  String get busy => 'El destinatari està ocupat amb una altra petició.';
}

// Path: progressPage
class _Translations$progressPage$ca extends Translations$progressPage$en {
  _Translations$progressPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get titleSending => 'S\'estan enviant els fitxers';
  @override
  String get titleReceiving => 'S\'estan rebent els fitxers';
  @override
  String get savedToGallery => 'Desat a Fotos';
  @override
  late final _Translations$progressPage$checksum$ca checksum = _Translations$progressPage$checksum$ca._(_root);
  @override
  late final _Translations$progressPage$total$ca total = _Translations$progressPage$total$ca._(_root);
  @override
  late final _Translations$progressPage$remainingTime$ca remainingTime = _Translations$progressPage$remainingTime$ca._(_root);
}

// Path: webSharePage
class _Translations$webSharePage$ca extends Translations$webSharePage$en {
  _Translations$webSharePage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Comparteix via enllaç';
  @override
  String get loading => 'S\'està iniciant el servidor…';
  @override
  String get stopping => 'S\'està aturant el servidor…';
  @override
  String get error => 'Hi ha hagut un error en iniciar el servidor.';
  @override
  String openLink({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ca'))(
    n,
    one: 'Obre l\'enllaç al navegador:',
    other: 'Obre un d\'aquests enllaços al navegador:',
  );
  @override
  String get requests => 'Peticions';
  @override
  String get noRequests => 'Encara no hi ha peticions.';
  @override
  String get encryption => _root.settingsTab.network.encryption;
  @override
  String get autoAccept => 'Accepta les peticions automàticament';
  @override
  String get requirePin => 'Demana un PIN';
  @override
  String pinHint({required Object pin}) => 'El PIN és «${pin}»';
  @override
  String get encryptionHint => 'El LocalSend utilitza un certificat auto-signat. Cal que l\'accepteu al navegador.';
  @override
  String pendingRequests({required Object n}) => 'Peticions pendents: ${n}';
}

// Path: webReceivePage
class _Translations$webReceivePage$ca extends Translations$webReceivePage$en {
  _Translations$webReceivePage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Rebre mitjançant enllaç';
}

// Path: aboutPage
class _Translations$aboutPage$ca extends Translations$aboutPage$en {
  _Translations$aboutPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Quant al LocalSend';
  @override
  List<String> get description => [
    'El LocalSend és una aplicació gratuïta i de codi obert que us permet compartir fitxers i missatges de manera segura amb dispositius propers a la vostra xarxa local sense necessitat de connexió a Internet.',
    'Aquesta aplicació està disponible per a Android, iOS, macOS, Windows i Linux. Podeu trobar totes les opcions de baixada a la pàgina d\'inici oficial.',
  ];
  @override
  String get author => 'Autor';
  @override
  String get contributors => 'Col·laboradors';
  @override
  String get packagers => 'Empaquetadors';
  @override
  String get translators => 'Traductors';
}

// Path: donationPage
class _Translations$donationPage$ca extends Translations$donationPage$en {
  _Translations$donationPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Donació';
  @override
  String get info =>
      'El LocalSend és gratuït, de codi obert i sense anuncis. Si us agrada l\'aplicació, podeu donar suport al desenvolupament amb una donació.';
  @override
  String donate({required Object amount}) => 'Donació: ${amount}';
  @override
  String get thanks => 'Moltes gràcies!';
  @override
  String get restore => 'Restaura la compra';
}

// Path: changelogPage
class _Translations$changelogPage$ca extends Translations$changelogPage$en {
  _Translations$changelogPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Registre de canvis';
}

// Path: whatsNewPage
class _Translations$whatsNewPage$ca extends Translations$whatsNewPage$en {
  _Translations$whatsNewPage$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String title({required Object version}) => 'Novetats de la versió ${version}';
  @override
  late final _Translations$whatsNewPage$changes$ca changes = _Translations$whatsNewPage$changes$ca._(_root);
}

// Path: aliasGenerator
class _Translations$aliasGenerator$ca extends Translations$aliasGenerator$en {
  _Translations$aliasGenerator$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  List<String> get adjectives => [
    'Adorable',
    'Bonic',
    'Gran',
    'Brillant',
    'Neteja',
    'Intel·ligent',
    'Guai',
    'Bonic',
    'Astúcia',
    'Determinat',
    'Energètic',
    'Eficient',
    'Fantàstic',
    'Ràpid',
    'Bé',
    'Fresca',
    'Bo',
    'Preciós',
    'Genial',
    'Guapo',
    'Calent',
    'Amable',
    'Encantador',
    'Místic',
    'Producte',
    'Bonic',
    'Pacient',
    'Bonic',
    'Potent',
    'Ric',
    'Secret',
    'Intel·ligent',
    'Sòlid',
    'Especial',
    'Estratègic',
    'Fort',
    'Endreçat',
    'Savi',
  ];
  @override
  List<String> get fruits => [
    'Poma',
    'Alvocat',
    'Plàtan',
    'Blackberry',
    'Nabiu',
    'Bròquil',
    'Pastanaga',
    'Cirera',
    'Coco',
    'Raïm',
    'Llimona',
    'Enciam',
    'Mango',
    'Meló',
    'Bolet',
    'Ceba',
    'Taronja',
    'Papaia',
    'Préssec',
    'Pera',
    'Pinya',
    'Patata',
    'Carbassa',
    'Gerd',
    'Maduixa',
    'Tomàquet',
  ];

  /// In some languages, the adjective must be last.
  @override
  String combination({required Object fruit, required Object adjective}) => '${fruit} ${adjective}';
}

// Path: dialogs
class _Translations$dialogs$ca extends Translations$dialogs$en {
  _Translations$dialogs$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$dialogs$addFile$ca addFile = _Translations$dialogs$addFile$ca._(_root);
  @override
  late final _Translations$dialogs$openFile$ca openFile = _Translations$dialogs$openFile$ca._(_root);
  @override
  late final _Translations$dialogs$addressInput$ca addressInput = _Translations$dialogs$addressInput$ca._(_root);
  @override
  late final _Translations$dialogs$cancelSession$ca cancelSession = _Translations$dialogs$cancelSession$ca._(_root);
  @override
  late final _Translations$dialogs$connectionError$ca connectionError = _Translations$dialogs$connectionError$ca._(_root);
  @override
  late final _Translations$dialogs$deleteSourceAfterSendDialog$ca deleteSourceAfterSendDialog =
      _Translations$dialogs$deleteSourceAfterSendDialog$ca._(_root);
  @override
  late final _Translations$dialogs$cannotOpenFile$ca cannotOpenFile = _Translations$dialogs$cannotOpenFile$ca._(_root);
  @override
  late final _Translations$dialogs$encryptionDisabledNotice$ca encryptionDisabledNotice = _Translations$dialogs$encryptionDisabledNotice$ca._(_root);
  @override
  late final _Translations$dialogs$errorDialog$ca errorDialog = _Translations$dialogs$errorDialog$ca._(_root);
  @override
  late final _Translations$dialogs$favoriteDialog$ca favoriteDialog = _Translations$dialogs$favoriteDialog$ca._(_root);
  @override
  late final _Translations$dialogs$favoriteDeleteDialog$ca favoriteDeleteDialog = _Translations$dialogs$favoriteDeleteDialog$ca._(_root);
  @override
  late final _Translations$dialogs$favoriteEditDialog$ca favoriteEditDialog = _Translations$dialogs$favoriteEditDialog$ca._(_root);
  @override
  late final _Translations$dialogs$fileInfo$ca fileInfo = _Translations$dialogs$fileInfo$ca._(_root);
  @override
  late final _Translations$dialogs$fileNameInput$ca fileNameInput = _Translations$dialogs$fileNameInput$ca._(_root);
  @override
  late final _Translations$dialogs$historyClearDialog$ca historyClearDialog = _Translations$dialogs$historyClearDialog$ca._(_root);
  @override
  late final _Translations$dialogs$localNetworkUnauthorized$ca localNetworkUnauthorized = _Translations$dialogs$localNetworkUnauthorized$ca._(_root);
  @override
  late final _Translations$dialogs$messageInput$ca messageInput = _Translations$dialogs$messageInput$ca._(_root);
  @override
  late final _Translations$dialogs$noFiles$ca noFiles = _Translations$dialogs$noFiles$ca._(_root);
  @override
  late final _Translations$dialogs$noPermission$ca noPermission = _Translations$dialogs$noPermission$ca._(_root);
  @override
  late final _Translations$dialogs$notAvailableOnPlatform$ca notAvailableOnPlatform = _Translations$dialogs$notAvailableOnPlatform$ca._(_root);
  @override
  late final _Translations$dialogs$qr$ca qr = _Translations$dialogs$qr$ca._(_root);
  @override
  late final _Translations$dialogs$quickActions$ca quickActions = _Translations$dialogs$quickActions$ca._(_root);
  @override
  late final _Translations$dialogs$quickSaveNotice$ca quickSaveNotice = _Translations$dialogs$quickSaveNotice$ca._(_root);
  @override
  late final _Translations$dialogs$quickSaveFromFavoritesNotice$ca quickSaveFromFavoritesNotice =
      _Translations$dialogs$quickSaveFromFavoritesNotice$ca._(_root);
  @override
  late final _Translations$dialogs$pin$ca pin = _Translations$dialogs$pin$ca._(_root);
  @override
  late final _Translations$dialogs$sendModeHelp$ca sendModeHelp = _Translations$dialogs$sendModeHelp$ca._(_root);
  @override
  late final _Translations$dialogs$startupError$ca startupError = _Translations$dialogs$startupError$ca._(_root);
  @override
  late final _Translations$dialogs$zoom$ca zoom = _Translations$dialogs$zoom$ca._(_root);
}

// Path: sanitization
class _Translations$sanitization$ca extends Translations$sanitization$en {
  _Translations$sanitization$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get empty => 'El nom del fitxer no pot estar buit';
  @override
  String get invalid => 'El nom del fitxer conté caràcters no vàlids';
}

// Path: tray
class _Translations$tray$ca extends Translations$tray$en {
  _Translations$tray$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get open => _root.general.open;
  @override
  String get close => 'Surt del LocalSend';
  @override
  String get closeWindows => 'Surt';
}

// Path: web
class _Translations$web$ca extends Translations$web$en {
  _Translations$web$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get waiting => _root.sendPage.waiting;
  @override
  String get enterPin => 'Introduïu el PIN';
  @override
  String get invalidPin => 'PIN no vàlid';
  @override
  String get tooManyAttempts => 'Massa intents';
  @override
  String get rejected => 'Rebutjat';
  @override
  String get files => 'Fitxers';
  @override
  String get fileName => 'Nom del fitxer';
  @override
  String get size => 'Mida';
}

// Path: assetPicker
class _Translations$assetPicker$ca extends Translations$assetPicker$en {
  _Translations$assetPicker$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get confirm => 'Confirma';
  @override
  String get cancel => 'Cancel·la';
  @override
  String get edit => 'Edita';
  @override
  String get gifIndicator => 'GIF';
  @override
  String get loadFailed => 'Càrrega fallida';
  @override
  String get original => 'Origen';
  @override
  String get preview => 'Previsualitza';
  @override
  String get select => 'Seleccioneu';
  @override
  String get emptyList => 'Llista buida';
  @override
  String get unSupportedAssetType => 'Tipus de fitxer no compatible.';
  @override
  String get unableToAccessAll => 'No es pot accedir a tots els fitxers del dispositiu';
  @override
  String get viewingLimitedAssetsTip => 'Visualitza només fitxers i àlbums accessibles per l\'aplicació.';
  @override
  String get changeAccessibleLimitedAssets => 'Feu clic per a actualitzar els fitxers accessibles';
  @override
  String get accessAllTip =>
      'L\'aplicació només pot accedir a alguns fitxers del dispositiu. Aneu a la configuració del sistema i permeteu que l\'aplicació accedeixi a tots els mitjans del dispositiu.';
  @override
  String get goToSystemSettings => 'Vés a la configuració del sistema';
  @override
  String get accessLimitedAssets => 'Continua amb accés limitat';
  @override
  String get accessiblePathName => 'Fitxers accessibles';
  @override
  String get sTypeAudioLabel => 'Àudio';
  @override
  String get sTypeImageLabel => 'Imatge';
  @override
  String get sTypeVideoLabel => 'Vídeo';
  @override
  String get sTypeOtherLabel => 'Altres fitxers';
  @override
  String get sActionPlayHint => 'reprodueix';
  @override
  String get sActionPreviewHint => 'previsualitza';
  @override
  String get sActionSelectHint => 'selecccioneu';
  @override
  String get sActionSwitchPathLabel => 'canvia la ruta';
  @override
  String get sActionUseCameraHint => 'utilitza la càmera';
  @override
  String get sNameDurationLabel => 'duració';
  @override
  String get sUnitAssetCountLabel => 'compte';
}

// Path: receiveTab.infoBox
class _Translations$receiveTab$infoBox$ca extends Translations$receiveTab$infoBox$en {
  _Translations$receiveTab$infoBox$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get ip => 'IP:';
  @override
  String get port => 'Port:';
  @override
  String get alias => 'Nom del dispositiu:';
}

// Path: receiveTab.quickSave
class _Translations$receiveTab$quickSave$ca extends Translations$receiveTab$quickSave$en {
  _Translations$receiveTab$quickSave$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get off => _root.general.off;
  @override
  String get favorites => 'Preferits';
  @override
  String get on => _root.general.on;
}

// Path: sendTab.selection
class _Translations$sendTab$selection$ca extends Translations$sendTab$selection$en {
  _Translations$sendTab$selection$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Selecció';
  @override
  String files({required Object files}) => 'Fitxers: ${files}';
  @override
  String size({required Object size}) => 'Mida: ${size}';
}

// Path: sendTab.picker
class _Translations$sendTab$picker$ca extends Translations$sendTab$picker$en {
  _Translations$sendTab$picker$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get file => 'Fitxer';
  @override
  String get folder => 'Carpeta';
  @override
  String get media => 'Multimèdia';
  @override
  String get text => 'Text';
  @override
  String get app => 'Aplicació';
  @override
  String get clipboard => 'Enganxa';
}

// Path: sendTab.sendModes
class _Translations$sendTab$sendModes$ca extends Translations$sendTab$sendModes$en {
  _Translations$sendTab$sendModes$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get single => 'Destinatari únic';
  @override
  String get multiple => 'Múltiples destinataris';
  @override
  String get link => 'Comparteix via enllaç';
}

// Path: sendTab.diagnosis
class _Translations$sendTab$diagnosis$ca extends Translations$sendTab$diagnosis$en {
  _Translations$sendTab$diagnosis$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get scanning => 'S\'estan cercant dispositius propers…';
  @override
  late final _Translations$sendTab$diagnosis$noInterface$ca noInterface = _Translations$sendTab$diagnosis$noInterface$ca._(_root);
  @override
  late final _Translations$sendTab$diagnosis$multicastUnavailable$ca multicastUnavailable = _Translations$sendTab$diagnosis$multicastUnavailable$ca._(
    _root,
  );
  @override
  late final _Translations$sendTab$diagnosis$scanNoResult$ca scanNoResult = _Translations$sendTab$diagnosis$scanNoResult$ca._(_root);
  @override
  String get rescan => 'Torneu a cercar';
  @override
  String get bleHint =>
      'La descoberta per BLE és activa: els dispositius es troben per Bluetooth només si també executen aquest fork amb l\'opció activada; la transferència en si continua fent-se per la xarxa.';
  @override
  late final _Translations$sendTab$diagnosis$manualFallback$ca manualFallback = _Translations$sendTab$diagnosis$manualFallback$ca._(_root);
}

// Path: settingsTab.general
class _Translations$settingsTab$general$ca extends Translations$settingsTab$general$en {
  _Translations$settingsTab$general$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'General';
  @override
  String get brightness => 'Tema';
  @override
  late final _Translations$settingsTab$general$brightnessOptions$ca brightnessOptions = _Translations$settingsTab$general$brightnessOptions$ca._(
    _root,
  );
  @override
  String get color => 'Color';
  @override
  late final _Translations$settingsTab$general$colorOptions$ca colorOptions = _Translations$settingsTab$general$colorOptions$ca._(_root);
  @override
  String get language => 'Llengua';
  @override
  late final _Translations$settingsTab$general$languageOptions$ca languageOptions = _Translations$settingsTab$general$languageOptions$ca._(_root);
  @override
  String get saveWindowPlacement => 'Desa la posició de la finestra en sortir';
  @override
  String get saveWindowPlacementWindows => 'Desa la posició de la finestra després de sortir';
  @override
  String get minimizeToTray => 'Minimitza a la safata del sistema/barra de menú en tancar';
  @override
  String get launchAtStartup => 'Inici automàtic en iniciar la sessió';
  @override
  String get launchMinimized => 'Inici automàtic: Inici minimitzat';
  @override
  String get showInContextMenu => 'Mostra el LocalSend al menú contextual';
  @override
  String get animations => 'Animacions';
}

// Path: settingsTab.receive
class _Translations$settingsTab$receive$ca extends Translations$settingsTab$receive$en {
  _Translations$settingsTab$receive$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Recepció';
  @override
  String get quickSave => _root.general.quickSave;
  @override
  String get quickSaveFromFavorites => _root.general.quickSaveFromFavorites;
  @override
  String get requirePin => _root.webSharePage.requirePin;
  @override
  String get autoFinish => 'Finalització automàtica';
  @override
  String get destination => 'Desa en la carpeta';
  @override
  String get downloads => '(Baixades)';
  @override
  String get saveToGallery => 'Desa els fitxers multimèdia a la galeria';
  @override
  String get saveToHistory => 'Desa a l\'historial';
  @override
  String get verifyChecksums => 'Verifica les sumes de verificació en rebre fitxers';
}

// Path: settingsTab.send
class _Translations$settingsTab$send$ca extends Translations$settingsTab$send$en {
  _Translations$settingsTab$send$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Enviament';
  @override
  String get shareViaLinkAutoAccept => 'Accepta peticions de manera automàtica en el mode «Comparteix via enllaç»';
  @override
  String get createChecksums => 'Crea sumes de verificació en enviar fitxers';
  @override
  String get deleteSourceAfterSend => 'Elimina els fitxers d\'origen després d\'un enviament correcte';
}

// Path: settingsTab.network
class _Translations$settingsTab$network$ca extends Translations$settingsTab$network$en {
  _Translations$settingsTab$network$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Xarxa';
  @override
  String get needRestart => 'Reinicieu el servidor per a aplicar la configuració.';
  @override
  String get server => 'Servidor';
  @override
  String get alias => 'Nom del dispositiu';
  @override
  String get deviceType => 'Tipus de dispositiu';
  @override
  String get deviceModel => 'Model del dispositiu';
  @override
  String get port => 'Port';
  @override
  String get network => 'Xarxa';
  @override
  late final _Translations$settingsTab$network$networkOptions$ca networkOptions = _Translations$settingsTab$network$networkOptions$ca._(_root);
  @override
  String get discoveryTimeout => 'Temps d\'espera de descobriment';
  @override
  String get maxInterfaces => 'Màxim d\'interfícies (Escaneig intel·ligent)';
  @override
  String get vpnInterfaces => 'Inclou interfícies VPN (Escaneig intel·ligent)';
  @override
  String get vpnInterfacesHint =>
      'També escaneja les subxarxes de les interfícies de túnel VPN (Tailscale, WireGuard, ...). Les VPN normalment no admeten multicast, per la qual cosa les seves subxarxes es comproven amb l\'escaneig alternatiu per HTTP.';
  @override
  String get useSystemName => 'Utilitza el nom del sistema';
  @override
  String get generateRandomAlias => 'Genera un àlies aleatori';
  @override
  String portWarning({required Object defaultPort}) =>
      'Altres dispositius podrien no detectar-vos perquè utilitzeu un port personalitzat. (predefinit: ${defaultPort})';
  @override
  String get encryption => 'Xifratge';
  @override
  String get multicastGroup => 'Adreça del Multicast';
  @override
  String multicastGroupWarning({required Object defaultMulticast}) =>
      'Altres dispositius podrien no detectar-vos perquè utilitzeu una adreça multicast personalitzada. (predefinida: ${defaultMulticast})';
  @override
  String get bleDiscovery => 'Descoberta per BLE (experimental)';
  @override
  String get bleDiscoveryHint =>
      'Descobreix dispositius propers mitjançant Bluetooth fins i tot quan la xarxa bloqueja el multicast (aïllament del punt d\'accés, AP). Funciona a Android, iOS, macOS i Windows; a Linux aquest dispositiu en pot trobar d\'altres però no pot ser trobat. Tots dos dispositius necessiten aquest fork amb l\'opció activada; la transferència de fitxers en si continua utilitzant la xarxa.';
  @override
  String get bleStatusActive =>
      'Actiu: s\'està escanejant i emetent anuncis. Els dispositius propers només apareixen si també executen aquest fork amb l\'opció activada.';
  @override
  String get bleStatusScanOnly =>
      'Actiu: només escaneja. Aquest dispositiu no es pot descobrir per Bluetooth ara mateix (la plataforma no admet l\'emissió d\'anuncis BLE, o encara no hi ha cap adreça de xarxa utilitzable).';
  @override
  String get bleStatusPaused => 'En pausa. Es reprendrà quan l\'aplicació torni al primer pla.';
  @override
  String get bleStatusPermissionDenied =>
      'S\'han denegat els permisos de Bluetooth. Concediu el permís «Dispositius propers» (o «Ubicació» a Android 11 i anteriors) a la configuració del sistema i, després, desactiveu i torneu a activar aquesta opció.';
  @override
  String get bleStatusAdapterOff =>
      'El Bluetooth està desactivat o no està disponible. La descoberta es reiniciarà tota sola quan el Bluetooth torni a estar disponible.';
  @override
  String get bleStatusUnsupported =>
      'No és compatible amb aquest dispositiu: la descoberta per BLE necessita Android 7 o posterior i una ràdio Bluetooth LE.';
  @override
  String get bleStatusLegacyLocation =>
      'En aquesta versió d\'Android, per a trobar altres dispositius també cal que els serveis d\'ubicació del sistema estiguin activats (el permís es demana automàticament; aquest dispositiu ja pot ser trobat per altres).';
  @override
  String get bleStatusError => 'No s\'ha pogut iniciar la descoberta per BLE. Vegeu Solució de problemes > Registres per a més detalls.';
  @override
  String get bleOpenSystemSettings => 'Obre la configuració del sistema';
}

// Path: settingsTab.other
class _Translations$settingsTab$other$ca extends Translations$settingsTab$other$en {
  _Translations$settingsTab$other$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Altres';
  @override
  String get support => 'Doneu suport al LocalSend';
  @override
  String get donate => 'Donació';
  @override
  String get privacyPolicy => 'Política de privadesa';
  @override
  String get termsOfUse => 'Condicions d\'ús';
}

// Path: troubleshootPage.firewall
class _Translations$troubleshootPage$firewall$ca extends Translations$troubleshootPage$firewall$en {
  _Translations$troubleshootPage$firewall$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Aquest dispositiu pot enviar fitxers a d\'altres, però altres dispositius no poden enviar fitxers a aquest.';
  @override
  String solution({required Object port}) =>
      'El més probable és que sigui un problema del tallafocs. Podeu solucionar-ho permetent les connexiions entrants (UDP i TCP) al port ${port}.';
  @override
  String get openFirewall => 'Obre el tallafocs';
}

// Path: troubleshootPage.noDiscovery
class _Translations$troubleshootPage$noDiscovery$ca extends Translations$troubleshootPage$noDiscovery$en {
  _Translations$troubleshootPage$noDiscovery$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Aquest dispositiu no pot descobrir altres dispositius.';
  @override
  String get solution =>
      'Comproveu que tots els dispositius estan a la mateixa xarxa Wi-Fi i tenen la mateixa configuració (port, adreça multicast i xifratge). Podeu provar d\'escriure l\'adreça IP del dispositiu de destí de manera manual. Si això funciona, considereu afegir aquest dispositiu als preferits perquè pugui ser descobert automàticament en un futur.';
}

// Path: troubleshootPage.noConnection
class _Translations$troubleshootPage$noConnection$ca extends Translations$troubleshootPage$noConnection$en {
  _Translations$troubleshootPage$noConnection$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Cap dels dos dispositius no poden trobar-se ni compartir fitxers.';
  @override
  String get solution =>
      'Existeix el problema als dos costats? Si és així, cal que comproveu que els dispositius estan a la mateixa xarxa Wi-Fi i comparteixen la mateixa configuració (port, adreça multicast i xifratge). La Wi-Fi podria no permetre la comunicació entre els participants a causa de l\'aïllament del punt d\'accés (Access Point, AP). En aquest cas, cal que desactiveu aquesta opció a l\'encaminador.';
}

// Path: receiveHistoryPage.entryActions
class _Translations$receiveHistoryPage$entryActions$ca extends Translations$receiveHistoryPage$entryActions$en {
  _Translations$receiveHistoryPage$entryActions$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get open => 'Obre el fitxer';
  @override
  String get showInFolder => 'Mostra a la carpeta';
  @override
  String get info => 'Informació';
  @override
  String get deleteFromHistory => 'Elimina de l\'historial';
}

// Path: deviceDetailsPage.info
class _Translations$deviceDetailsPage$info$ca extends Translations$deviceDetailsPage$info$en {
  _Translations$deviceDetailsPage$info$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get name => 'Nom';
  @override
  String get address => 'Adreça';
  @override
  String get version => 'Versió';
  @override
  String protocol({required Object version}) => 'Protocol v${version}';
}

// Path: deviceDetailsPage.logs
class _Translations$deviceDetailsPage$logs$ca extends Translations$deviceDetailsPage$logs$en {
  _Translations$deviceDetailsPage$logs$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Registres';
  @override
  String get empty => 'No hi ha registres disponibles.';
  @override
  String discovered({required Object protocol, required Object host}) => 'Descobert mitjançant ${protocol} (${host})';
  @override
  String updated({required Object protocol, required Object host}) => 'Actualitzat mitjançant ${protocol} (${host})';
}

// Path: progressPage.checksum
class _Translations$progressPage$checksum$ca extends Translations$progressPage$checksum$en {
  _Translations$progressPage$checksum$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get verified => 'Sumes de verificació verificades';
  @override
  String partiallyVerified({required Object curr, required Object n}) => 'Sumes de verificació verificades per a ${curr} / ${n} fitxers';
  @override
  String get notVerifiable => 'El remitent no ha proporcionat sumes de verificació';
  @override
  String get disabled => 'La verificació de sumes de verificació està desactivada';
  @override
  String attached({required Object curr, required Object n}) => 'Sumes de verificació adjuntes (${curr} / ${n} fitxers)';
}

// Path: progressPage.total
class _Translations$progressPage$total$ca extends Translations$progressPage$total$en {
  _Translations$progressPage$total$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$progressPage$total$title$ca title = _Translations$progressPage$total$title$ca._(_root);
  @override
  String count({required Object curr, required Object n}) => 'Fitxers: ${curr} / ${n}';
  @override
  String size({required Object curr, required Object n}) => 'Mida: ${curr} / ${n}';
  @override
  String speed({required Object speed}) => 'Velocitat: ${speed}/s';
}

// Path: progressPage.remainingTime
class _Translations$progressPage$remainingTime$ca extends Translations$progressPage$remainingTime$en {
  _Translations$progressPage$remainingTime$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String minutesUnit({required num m}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ca'))(
    m,
    other: '${m}min',
  );
  @override
  String hoursUnit({required num h}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ca'))(
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
class _Translations$whatsNewPage$changes$ca extends Translations$whatsNewPage$changes$en {
  _Translations$whatsNewPage$changes$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$whatsNewPage$changes$v1_18_0$ca v1_18_0 = _Translations$whatsNewPage$changes$v1_18_0$ca._(_root);
}

// Path: dialogs.addFile
class _Translations$dialogs$addFile$ca extends Translations$dialogs$addFile$en {
  _Translations$dialogs$addFile$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Afegeix-ho a la selecció';
  @override
  String get content => 'Què voleu afegir?';
}

// Path: dialogs.openFile
class _Translations$dialogs$openFile$ca extends Translations$dialogs$openFile$en {
  _Translations$dialogs$openFile$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Obre el fitxer';
  @override
  String get content => 'Voleu obrir el fitxer rebut?';
}

// Path: dialogs.addressInput
class _Translations$dialogs$addressInput$ca extends Translations$dialogs$addressInput$en {
  _Translations$dialogs$addressInput$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Introduïu l\'adreça';
  @override
  String get hashtag => 'Etiqueta';
  @override
  String get ip => 'Adreça IP';
  @override
  String get recentlyUsed => 'Utilitzades recentment: ';
  @override
  String get noHashtagCandidates =>
      'La xarxa actual no té cap adreça IPv4, per la qual cosa l\'etiqueta no es pot ampliar a una adreça candidata. Introduïu l\'adreça completa en el seu lloc (p. ex. 192.168.1.5 o fe80::1).';
  @override
  late final _Translations$dialogs$addressInput$validation$ca validation = _Translations$dialogs$addressInput$validation$ca._(_root);
}

// Path: dialogs.cancelSession
class _Translations$dialogs$cancelSession$ca extends Translations$dialogs$cancelSession$en {
  _Translations$dialogs$cancelSession$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Cancel·la la transferència de fitxers';
  @override
  String get content => 'Segur que voleu cancel·lar la transferència dels fitxers?';
}

// Path: dialogs.connectionError
class _Translations$dialogs$connectionError$ca extends Translations$dialogs$connectionError$en {
  _Translations$dialogs$connectionError$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Ha fallat la connexió';
  @override
  late final _Translations$dialogs$connectionError$timeout$ca timeout = _Translations$dialogs$connectionError$timeout$ca._(_root);
  @override
  late final _Translations$dialogs$connectionError$refused$ca refused = _Translations$dialogs$connectionError$refused$ca._(_root);
  @override
  late final _Translations$dialogs$connectionError$forbidden$ca forbidden = _Translations$dialogs$connectionError$forbidden$ca._(_root);
  @override
  late final _Translations$dialogs$connectionError$other$ca other = _Translations$dialogs$connectionError$other$ca._(_root);
  @override
  String get retry => 'Torna-ho a provar';
  @override
  String get details => 'Detalls de l\'error:';
}

// Path: dialogs.deleteSourceAfterSendDialog
class _Translations$dialogs$deleteSourceAfterSendDialog$ca extends Translations$dialogs$deleteSourceAfterSendDialog$en {
  _Translations$dialogs$deleteSourceAfterSendDialog$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Elimina els fitxers d\'origen';
  @override
  String get content => 'Quan els fitxers s\'hagin enviat correctament, se suprimiran d\'aquest dispositiu. Això no es pot desfer.';
}

// Path: dialogs.cannotOpenFile
class _Translations$dialogs$cannotOpenFile$ca extends Translations$dialogs$cannotOpenFile$en {
  _Translations$dialogs$cannotOpenFile$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'No es pot obrir el fitxer';
  @override
  String content({required Object file}) => 'No s\'ha pogut obrir «${file}». S\'ha mogut, reanomenat o eliminat?';
}

// Path: dialogs.encryptionDisabledNotice
class _Translations$dialogs$encryptionDisabledNotice$ca extends Translations$dialogs$encryptionDisabledNotice$en {
  _Translations$dialogs$encryptionDisabledNotice$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Xifratge desactivat';
  @override
  String get content => 'La comunicació ara es fa mitjançant el protocol HTTP no xifrat. Per a utilitzar HTTPS, torneu a activar el xifratge.';
}

// Path: dialogs.errorDialog
class _Translations$dialogs$errorDialog$ca extends Translations$dialogs$errorDialog$en {
  _Translations$dialogs$errorDialog$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.error;
}

// Path: dialogs.favoriteDialog
class _Translations$dialogs$favoriteDialog$ca extends Translations$dialogs$favoriteDialog$en {
  _Translations$dialogs$favoriteDialog$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Preferits';
  @override
  String get noFavorites => 'Encara no hi ha cap dispositiu preferit.';
  @override
  String get addFavorite => 'Afegeix';
}

// Path: dialogs.favoriteDeleteDialog
class _Translations$dialogs$favoriteDeleteDialog$ca extends Translations$dialogs$favoriteDeleteDialog$en {
  _Translations$dialogs$favoriteDeleteDialog$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Elimina dels preferits';
  @override
  String content({required Object name}) => 'Voleu eliminar «${name}» dels preferits?';
}

// Path: dialogs.favoriteEditDialog
class _Translations$dialogs$favoriteEditDialog$ca extends Translations$dialogs$favoriteEditDialog$en {
  _Translations$dialogs$favoriteEditDialog$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get titleAdd => 'Afegeix als preferits';
  @override
  String get titleEdit => 'Configuració';
  @override
  String get name => 'Nom del dispositiu';
  @override
  String get auto => '(auto)';
  @override
  String get ip => 'Adreça IP';
  @override
  String get port => 'Port';
}

// Path: dialogs.fileInfo
class _Translations$dialogs$fileInfo$ca extends Translations$dialogs$fileInfo$en {
  _Translations$dialogs$fileInfo$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Informació del fitxer';
  @override
  String get fileName => 'Nom del fitxer:';
  @override
  String get path => 'Ruta:';
  @override
  String get size => 'Mida:';
  @override
  String get sender => 'Remitent:';
  @override
  String get time => 'Temps:';
}

// Path: dialogs.fileNameInput
class _Translations$dialogs$fileNameInput$ca extends Translations$dialogs$fileNameInput$en {
  _Translations$dialogs$fileNameInput$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Introduïu el nom del fitxer';
  @override
  String original({required Object original}) => 'Original: ${original}';
}

// Path: dialogs.historyClearDialog
class _Translations$dialogs$historyClearDialog$ca extends Translations$dialogs$historyClearDialog$en {
  _Translations$dialogs$historyClearDialog$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Esborra l\'historial';
  @override
  String get content => 'Segur que voleu eliminar tot l\'historial?';
}

// Path: dialogs.localNetworkUnauthorized
class _Translations$dialogs$localNetworkUnauthorized$ca extends Translations$dialogs$localNetworkUnauthorized$en {
  _Translations$dialogs$localNetworkUnauthorized$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.dialogs.noPermission.title;
  @override
  String get description =>
      'El LocalSend no pot trobar altres dispositius sense tenir permís per a escanejar la xarxa local. Concediu aquest permís a la configuració.';
  @override
  String get gotoSettings => 'Configuració';
}

// Path: dialogs.messageInput
class _Translations$dialogs$messageInput$ca extends Translations$dialogs$messageInput$en {
  _Translations$dialogs$messageInput$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tipus de missatge';
  @override
  String get multiline => 'Multilínia';
}

// Path: dialogs.noFiles
class _Translations$dialogs$noFiles$ca extends Translations$dialogs$noFiles$en {
  _Translations$dialogs$noFiles$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'No s\'ha seleccionat cap fitxer';
  @override
  String get content => 'Seleccioneu com a mínim un fitxer.';
}

// Path: dialogs.noPermission
class _Translations$dialogs$noPermission$ca extends Translations$dialogs$noPermission$en {
  _Translations$dialogs$noPermission$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Sense permisos';
  @override
  String get content => 'No heu concedit els permisos necessaris. Concediu-los a la configuració.';
}

// Path: dialogs.notAvailableOnPlatform
class _Translations$dialogs$notAvailableOnPlatform$ca extends Translations$dialogs$notAvailableOnPlatform$en {
  _Translations$dialogs$notAvailableOnPlatform$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'No disponible';
  @override
  String get content => 'Aquesta característica només està disponible a:';
}

// Path: dialogs.qr
class _Translations$dialogs$qr$ca extends Translations$dialogs$qr$en {
  _Translations$dialogs$qr$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Codi QR';
}

// Path: dialogs.quickActions
class _Translations$dialogs$quickActions$ca extends Translations$dialogs$quickActions$en {
  _Translations$dialogs$quickActions$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Accions ràpides';
  @override
  String get counter => 'Comptador';
  @override
  String get prefix => 'Prefix';
  @override
  String get padZero => 'Reomple amb zeros';
  @override
  String get sortBeforeCount => 'Ordena abans alfabèticament';
  @override
  String get random => 'Aleatori';
}

// Path: dialogs.quickSaveNotice
class _Translations$dialogs$quickSaveNotice$ca extends Translations$dialogs$quickSaveNotice$en {
  _Translations$dialogs$quickSaveNotice$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSave;
  @override
  String get content =>
      'Les sol·licituds de fitxers s\'accepten automàticament. Tingueu en compte que tothom a la xarxa local us pot enviar fitxers.';
}

// Path: dialogs.quickSaveFromFavoritesNotice
class _Translations$dialogs$quickSaveFromFavoritesNotice$ca extends Translations$dialogs$quickSaveFromFavoritesNotice$en {
  _Translations$dialogs$quickSaveFromFavoritesNotice$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSaveFromFavorites;
  @override
  List<String> get content => [
    'Les sol·licituds de fitxers s\'accepten automàticament dels dispositius de la llista de preferits.',
  ];
}

// Path: dialogs.pin
class _Translations$dialogs$pin$ca extends Translations$dialogs$pin$en {
  _Translations$dialogs$pin$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Introduïu el PIN';
}

// Path: dialogs.sendModeHelp
class _Translations$dialogs$sendModeHelp$ca extends Translations$dialogs$sendModeHelp$en {
  _Translations$dialogs$sendModeHelp$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Modes d\'enviament';
  @override
  String get single => 'Envia fitxers a un destinatari. La selecció s\'esborrarà un cop finalitzada la transferència de fitxers.';
  @override
  String get multiple => 'Envia fitxers a diversos destinataris. La selecció no s\'esborrarà en finalitzar la trasferència.';
  @override
  String get link =>
      'Els destinataris que no tinguin el LocalSend instal·lat poden baixar els fitxers seleccionats obrint l\'enllaç al seu navegador.';
}

// Path: dialogs.startupError
class _Translations$dialogs$startupError$ca extends Translations$dialogs$startupError$en {
  _Translations$dialogs$startupError$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'No s\'ha pogut iniciar el servidor';
  @override
  String port({required Object port}) => 'Port: ${port}';
  @override
  late final _Translations$dialogs$startupError$windowsAccessDenied$ca windowsAccessDenied =
      _Translations$dialogs$startupError$windowsAccessDenied$ca._(_root);
  @override
  late final _Translations$dialogs$startupError$addressInUse$ca addressInUse = _Translations$dialogs$startupError$addressInUse$ca._(_root);
  @override
  late final _Translations$dialogs$startupError$generic$ca generic = _Translations$dialogs$startupError$generic$ca._(_root);
  @override
  String get details => 'Detalls de l\'error:';
  @override
  String get copyDetails => 'Copia els detalls';
  @override
  String get openSettings => 'Obre la configuració';
}

// Path: dialogs.zoom
class _Translations$dialogs$zoom$ca extends Translations$dialogs$zoom$en {
  _Translations$dialogs$zoom$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'URL';
}

// Path: sendTab.diagnosis.noInterface
class _Translations$sendTab$diagnosis$noInterface$ca extends Translations$sendTab$diagnosis$noInterface$en {
  _Translations$sendTab$diagnosis$noInterface$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Sense connexió de xarxa';
  @override
  String get advice => 'Aquest dispositiu no està connectat a cap xarxa. Comproveu la connexió Wi-Fi o per cable d\'aquest dispositiu.';
}

// Path: sendTab.diagnosis.multicastUnavailable
class _Translations$sendTab$diagnosis$multicastUnavailable$ca extends Translations$sendTab$diagnosis$multicastUnavailable$en {
  _Translations$sendTab$diagnosis$multicastUnavailable$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Multicast no disponible';
  @override
  String advice({required Object port}) =>
      'El LocalSend no pot utilitzar el multicast per a descobrir dispositius en aquesta xarxa. Assegureu-vos que tots dos dispositius són a la mateixa xarxa i que l\'aïllament del punt d\'accés (AP) o un tallafocs no bloquegen el port UDP ${port}.';
  @override
  String reason({required Object reason}) => 'Motiu: ${reason}';
}

// Path: sendTab.diagnosis.scanNoResult
class _Translations$sendTab$diagnosis$scanNoResult$ca extends Translations$sendTab$diagnosis$scanNoResult$en {
  _Translations$sendTab$diagnosis$scanNoResult$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'No s\'han trobat dispositius';
  @override
  String get advice =>
      'La descoberta funciona, però cap dispositiu ha contestat als anuncis ni a l\'escaneig de xarxa. L\'altre dispositiu pot estar desconnectat, en repòs o bloquejat per un tallafocs. Assegureu-vos que el LocalSend s\'està executant a l\'altre dispositiu.';
  @override
  String detail({required Object announcements, required Object scans}) =>
      'S\'han enviat ${announcements} anuncis i ${scans} escanejos de xarxa sense resposta.';
}

// Path: sendTab.diagnosis.manualFallback
class _Translations$sendTab$diagnosis$manualFallback$ca extends Translations$sendTab$diagnosis$manualFallback$en {
  _Translations$sendTab$diagnosis$manualFallback$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get message =>
      'Les adreces IP canvien sovint. Tot i així, podeu accedir a un dispositiu que no surt a la llista: afegiu-lo als preferits o introduïu la seva adreça manualment.';
  @override
  String get openFavorites => 'Obre els preferits';
  @override
  String get manualInput => 'Introduïu l\'adreça manualment';
}

// Path: settingsTab.general.brightnessOptions
class _Translations$settingsTab$general$brightnessOptions$ca extends Translations$settingsTab$general$brightnessOptions$en {
  _Translations$settingsTab$general$brightnessOptions$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Sistema';
  @override
  String get dark => 'Fosc';
  @override
  String get light => 'Clar';
}

// Path: settingsTab.general.colorOptions
class _Translations$settingsTab$general$colorOptions$ca extends Translations$settingsTab$general$colorOptions$en {
  _Translations$settingsTab$general$colorOptions$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Sistema';
  @override
  String get oled => 'OLED';
  @override
  String get custom => 'Personalitzat';
}

// Path: settingsTab.general.languageOptions
class _Translations$settingsTab$general$languageOptions$ca extends Translations$settingsTab$general$languageOptions$en {
  _Translations$settingsTab$general$languageOptions$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Sistema';
}

// Path: settingsTab.network.networkOptions
class _Translations$settingsTab$network$networkOptions$ca extends Translations$settingsTab$network$networkOptions$en {
  _Translations$settingsTab$network$networkOptions$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'Totes';
  @override
  String get filtered => 'Filtrades';
}

// Path: progressPage.total.title
class _Translations$progressPage$total$title$ca extends Translations$progressPage$total$title$en {
  _Translations$progressPage$total$title$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String sending({required Object time}) => 'Progrés total (${time})';
  @override
  String get finishedError => 'Finalitzat amb error';
  @override
  String get canceledSender => 'Cancel·lat pel remitent';
  @override
  String get canceledReceiver => 'Cancel·lat pel destinatari';
}

// Path: whatsNewPage.changes.v1_18_0
class _Translations$whatsNewPage$changes$v1_18_0$ca extends Translations$whatsNewPage$changes$v1_18_0$en with WhatsNewStrings {
  _Translations$whatsNewPage$changes$v1_18_0$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  List<String> get changes => [
    'El xifratge ja no alenteix les transferències. S\'ha tornat a activar en aquest dispositiu si abans l\'havíeu desactivat.',
    'Les sol·licituds dels preferits ara s\'accepten automàticament. Aquesta opció està activada per defecte i es pot desactivar a la configuració.',
    'A Android, les transferències continuen mentre l\'aplicació és en segon pla o la pantalla està apagada. A iOS, l\'aplicació encara ha de romandre en primer pla.',
  ];
}

// Path: dialogs.addressInput.validation
class _Translations$dialogs$addressInput$validation$ca extends Translations$dialogs$addressInput$validation$en {
  _Translations$dialogs$addressInput$validation$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get invalid => 'Introduïu una adreça IPv4, una adreça IPv6 o un nom de host vàlid.';
  @override
  String get scheme => 'Introduïu només l\'adreça, sense «http://» ni «https://».';
  @override
  String get port => 'Introduïu només l\'adreça. El port s\'agafa de la configuració.';
}

// Path: dialogs.connectionError.timeout
class _Translations$dialogs$connectionError$timeout$ca extends Translations$dialogs$connectionError$timeout$en {
  _Translations$dialogs$connectionError$timeout$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'El dispositiu no ha respost a temps.';
  @override
  String get advice =>
      'Probablement està desconnectat, en repòs o un tallafocs està bloquejant la connexió. Assegureu-vos que el LocalSend s\'està executant a l\'altre dispositiu i que tots dos dispositius són a la mateixa xarxa.';
}

// Path: dialogs.connectionError.refused
class _Translations$dialogs$connectionError$refused$ca extends Translations$dialogs$connectionError$refused$en {
  _Translations$dialogs$connectionError$refused$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'El dispositiu ha rebutjat la connexió.';
  @override
  String get advice =>
      'Sembla que el LocalSend no s\'està executant al dispositiu de destí, o que escolta en un port diferent. Inicieu el LocalSend a l\'altre dispositiu o comproveu el port.';
}

// Path: dialogs.connectionError.forbidden
class _Translations$dialogs$connectionError$forbidden$ca extends Translations$dialogs$connectionError$forbidden$en {
  _Translations$dialogs$connectionError$forbidden$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'El dispositiu ha rebutjat la sol·licitud.';
  @override
  String get advice =>
      'Pot ser que calgui un PIN o que l\'aparellament amb el dispositiu hagi canviat. Comproveu el PIN i la configuració del desat ràpid al dispositiu de destí.';
}

// Path: dialogs.connectionError.other
class _Translations$dialogs$connectionError$other$ca extends Translations$dialogs$connectionError$other$en {
  _Translations$dialogs$connectionError$other$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'No s\'ha pogut establir la connexió.';
  @override
  String get advice =>
      'Comproveu l\'adreça i el port, assegureu-vos que el LocalSend s\'està executant al dispositiu de destí i que cap tallafocs ni VPN bloqueja la connexió.';
}

// Path: dialogs.startupError.windowsAccessDenied
class _Translations$dialogs$startupError$windowsAccessDenied$ca extends Translations$dialogs$startupError$windowsAccessDenied$en {
  _Translations$dialogs$startupError$windowsAccessDenied$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'El Windows ha denegat l\'accés al port (error de sòcol 10013).';
  @override
  String get advice =>
      'Això sol estar causat per un interval de ports reservat per Hyper-V, WSL o Docker, o per un catàleg Winsock malmès:\n• Canvieu el port a la configuració (Xarxa)\n• Comproveu els intervals reservats amb: netsh interface ipv4 show excludedportrange protocol=tcp\n• Repareu el Winsock com a administrador amb: netsh winsock reset (reinicieu després)';
}

// Path: dialogs.startupError.addressInUse
class _Translations$dialogs$startupError$addressInUse$ca extends Translations$dialogs$startupError$addressInUse$en {
  _Translations$dialogs$startupError$addressInUse$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'El port ja l\'utilitza una altra aplicació.';
  @override
  String get advice =>
      'Un altre programa (o una segona instància del LocalSend) escolta en aquest port:\n• Tanqueu l\'altra aplicació, o\n• Canvieu el port a la configuració (Xarxa)';
}

// Path: dialogs.startupError.generic
class _Translations$dialogs$startupError$generic$ca extends Translations$dialogs$startupError$generic$en {
  _Translations$dialogs$startupError$generic$ca._(TranslationsCa root) : this._root = root, super.internal(root);

  final TranslationsCa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'No s\'ha pogut iniciar el servidor.';
  @override
  String get advice => '• Comproveu la configuració del tallafocs i de la xarxa\n• Proveu de canviar el port a la configuració (Xarxa)';
}
