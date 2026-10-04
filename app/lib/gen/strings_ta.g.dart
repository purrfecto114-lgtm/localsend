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
class TranslationsTa extends Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsTa({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ta,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <ta>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  late final TranslationsTa _root = this; // ignore: unused_field

  @override
  TranslationsTa $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTa(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'உள்ளக';
  @override
  late final _Translations$general$ta general = _Translations$general$ta._(_root);
  @override
  late final _Translations$receiveTab$ta receiveTab = _Translations$receiveTab$ta._(_root);
  @override
  late final _Translations$sendTab$ta sendTab = _Translations$sendTab$ta._(_root);
  @override
  late final _Translations$settingsTab$ta settingsTab = _Translations$settingsTab$ta._(_root);
  @override
  late final _Translations$troubleshootPage$ta troubleshootPage = _Translations$troubleshootPage$ta._(_root);
  @override
  late final _Translations$networkInterfacesPage$ta networkInterfacesPage = _Translations$networkInterfacesPage$ta._(_root);
  @override
  late final _Translations$receiveHistoryPage$ta receiveHistoryPage = _Translations$receiveHistoryPage$ta._(_root);
  @override
  late final _Translations$apkPickerPage$ta apkPickerPage = _Translations$apkPickerPage$ta._(_root);
  @override
  late final _Translations$selectedFilesPage$ta selectedFilesPage = _Translations$selectedFilesPage$ta._(_root);
  @override
  late final _Translations$deviceDetailsPage$ta deviceDetailsPage = _Translations$deviceDetailsPage$ta._(_root);
  @override
  late final _Translations$verifyPage$ta verifyPage = _Translations$verifyPage$ta._(_root);
  @override
  late final _Translations$receivePage$ta receivePage = _Translations$receivePage$ta._(_root);
  @override
  late final _Translations$receiveOptionsPage$ta receiveOptionsPage = _Translations$receiveOptionsPage$ta._(_root);
  @override
  late final _Translations$sendPage$ta sendPage = _Translations$sendPage$ta._(_root);
  @override
  late final _Translations$progressPage$ta progressPage = _Translations$progressPage$ta._(_root);
  @override
  late final _Translations$webSharePage$ta webSharePage = _Translations$webSharePage$ta._(_root);
  @override
  late final _Translations$webReceivePage$ta webReceivePage = _Translations$webReceivePage$ta._(_root);
  @override
  late final _Translations$aboutPage$ta aboutPage = _Translations$aboutPage$ta._(_root);
  @override
  late final _Translations$donationPage$ta donationPage = _Translations$donationPage$ta._(_root);
  @override
  late final _Translations$changelogPage$ta changelogPage = _Translations$changelogPage$ta._(_root);
  @override
  late final _Translations$whatsNewPage$ta whatsNewPage = _Translations$whatsNewPage$ta._(_root);
  @override
  late final _Translations$aliasGenerator$ta aliasGenerator = _Translations$aliasGenerator$ta._(_root);
  @override
  late final _Translations$dialogs$ta dialogs = _Translations$dialogs$ta._(_root);
  @override
  late final _Translations$sanitization$ta sanitization = _Translations$sanitization$ta._(_root);
  @override
  late final _Translations$tray$ta tray = _Translations$tray$ta._(_root);
  @override
  late final _Translations$web$ta web = _Translations$web$ta._(_root);
  @override
  late final _Translations$assetPicker$ta assetPicker = _Translations$assetPicker$ta._(_root);
}

// Path: general
class _Translations$general$ta extends Translations$general$en {
  _Translations$general$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get accept => 'ஏற்றுக்கொள்';
  @override
  String get accepted => 'ஏற்றுக்கொள்ளப்பட்டது';
  @override
  String get add => 'சேர்க்க';
  @override
  String get advanced => 'மேம்பட்ட';
  @override
  String get cancel => 'ரத்து செய்';
  @override
  String get close => 'மூடு';
  @override
  String get confirm => 'உறுதி';
  @override
  String get continueStr => 'தொடரவும்';
  @override
  String get copy => 'நகல் எடு';
  @override
  String get copiedToClipboard => 'கிளிப்போர்டுக்கு நகலெடுக்கப்பட்டது';
  @override
  String get decline => 'மறு';
  @override
  String get done => 'முடிந்தது';
  @override
  String get delete => 'நீக்கு';
  @override
  String get edit => 'தொகுத்து அமை (திருத்து)';
  @override
  String get error => 'பிழை / தவறு';
  @override
  String get example => 'உதாரணம்';
  @override
  String get files => 'கோப்புகள்';
  @override
  String get finished => 'முடிந்தது';
  @override
  String get hide => 'மறை';
  @override
  String get off => 'ஆஃப் (Off)';
  @override
  String get offline => 'ஆஃப்லைன் (Offline)';
  @override
  String get on => 'ஆன் (On)';
  @override
  String get online => 'ஆன்லைன் (Online)';
  @override
  String get open => 'திறக்கவும்';
  @override
  String get queue => 'வரிசை';
  @override
  String get quickSave => 'விரைவில் சேமி';
  @override
  String get quickSaveFromFavorites => 'விருப்பங்களுக்கு விரைவாகச் சேமி';
  @override
  String get renamed => 'மறுபெயரிடப்பட்டது';
  @override
  String get reset => 'மாற்றங்களைச் செயல்தவிர்';
  @override
  String get restart => 'மறுதொடக்கம்';
  @override
  String get settings => 'அமைப்புகள்';
  @override
  String get skipped => 'தவிர்க்கப்பட்டது';
  @override
  String get start => 'தொடங்கு';
  @override
  String get stop => 'நிறுத்து';
  @override
  String get save => 'சேமி';
  @override
  String get unchanged => 'மாறாது';
  @override
  String get unknown => 'தெரியவில்லை';
  @override
  String get noItemInClipboard => 'கிளிப்போர்டில் உருப்படிகள் இல்லை.';
}

// Path: receiveTab
class _Translations$receiveTab$ta extends Translations$receiveTab$en {
  _Translations$receiveTab$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'பெறு';
  @override
  late final _Translations$receiveTab$infoBox$ta infoBox = _Translations$receiveTab$infoBox$ta._(_root);
  @override
  late final _Translations$receiveTab$quickSave$ta quickSave = _Translations$receiveTab$quickSave$ta._(_root);
  @override
  String get link => 'இணைப்பு வழியாகப் பெறுக';
}

// Path: sendTab
class _Translations$sendTab$ta extends Translations$sendTab$en {
  _Translations$sendTab$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'அனுப்பு';
  @override
  late final _Translations$sendTab$selection$ta selection = _Translations$sendTab$selection$ta._(_root);
  @override
  late final _Translations$sendTab$picker$ta picker = _Translations$sendTab$picker$ta._(_root);
  @override
  String get shareIntentInfo => 'கோப்புகளை மிக எளிதாக தேர்ந்தெடுக்க உங்கள் மொபைல் சாதனத்தின் பகிர் அம்சத்தையும் பயன்படுத்தலாம்.';
  @override
  String get nearbyDevices => 'அருகிலுள்ள சாதனங்கள்';
  @override
  String get thisDevice => 'இந்த சாதனம்';
  @override
  String get scan => 'சாதனங்களைத் தேடு';
  @override
  String get manualSending => 'கைமுறையாக அனுப்புதல்';
  @override
  String get sendMode => 'அனுப்பும் முறை';
  @override
  late final _Translations$sendTab$sendModes$ta sendModes = _Translations$sendTab$sendModes$ta._(_root);
  @override
  String get sendModeHelp => 'விளக்கம்';
  @override
  String get help => 'விரும்பிய இலக்கும் அதே வைஃபை நெட்வொர்க்கில் இருப்பதை உறுதிசெய்யவும்.';
  @override
  String get placeItems => 'பகிர்ந்து கொள்ள பொருட்களை வைக்கவும்.';
  @override
  late final _Translations$sendTab$diagnosis$ta diagnosis = _Translations$sendTab$diagnosis$ta._(_root);
}

// Path: settingsTab
class _Translations$settingsTab$ta extends Translations$settingsTab$en {
  _Translations$settingsTab$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'அமைப்புகள்';
  @override
  late final _Translations$settingsTab$general$ta general = _Translations$settingsTab$general$ta._(_root);
  @override
  late final _Translations$settingsTab$receive$ta receive = _Translations$settingsTab$receive$ta._(_root);
  @override
  late final _Translations$settingsTab$send$ta send = _Translations$settingsTab$send$ta._(_root);
  @override
  late final _Translations$settingsTab$network$ta network = _Translations$settingsTab$network$ta._(_root);
  @override
  late final _Translations$settingsTab$other$ta other = _Translations$settingsTab$other$ta._(_root);
  @override
  String get advancedSettings => 'மேம்பட்ட அமைப்புகள்';
}

// Path: troubleshootPage
class _Translations$troubleshootPage$ta extends Translations$troubleshootPage$en {
  _Translations$troubleshootPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'பிரச்சனைகளை தீர்க்கவும்';
  @override
  String get subTitle => 'ஆப் எதிர்பார்த்தது போல வேலை செய்யவில்லையா? இங்கே சில பொதுவான தீர்வுகளை நீங்கள் காணலாம்.';
  @override
  String get solution => 'தீர்வு:';
  @override
  String get fixButton => 'தானாக சரி செய்யவும்';
  @override
  late final _Translations$troubleshootPage$firewall$ta firewall = _Translations$troubleshootPage$firewall$ta._(_root);
  @override
  late final _Translations$troubleshootPage$noDiscovery$ta noDiscovery = _Translations$troubleshootPage$noDiscovery$ta._(_root);
  @override
  late final _Translations$troubleshootPage$noConnection$ta noConnection = _Translations$troubleshootPage$noConnection$ta._(_root);
}

// Path: networkInterfacesPage
class _Translations$networkInterfacesPage$ta extends Translations$networkInterfacesPage$en {
  _Translations$networkInterfacesPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'பிணைய இடைமுகங்கள்';
  @override
  String get info =>
      'இயல்பாக, லோக்கல்சென்ட் கிடைக்கக்கூடிய அனைத்து பிணைய இடைமுகங்களையும் பயன்படுத்துகிறது. தேவையற்ற நெட்வொர்க்குகளை இங்கே விலக்கலாம். மாற்றங்களைப் பயன்படுத்த நீங்கள் சேவையகத்தை மறுதொடக்கம் செய்ய வேண்டும்.';
  @override
  String get preview => 'முன்னோட்டம்';
  @override
  String get whitelist => 'அனுமதிப்பட்டியலாளர்';
  @override
  String get blacklist => 'தடுப்புப்பட்டியல்';
}

// Path: receiveHistoryPage
class _Translations$receiveHistoryPage$ta extends Translations$receiveHistoryPage$en {
  _Translations$receiveHistoryPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'வரலாறு';
  @override
  String get openFolder => 'கோப்புறையை திறக்கவும்';
  @override
  String get deleteHistory => 'வரலாற்றை நீக்கவும்';
  @override
  String get empty => 'வரலாறு காலியாக உள்ளது.';
  @override
  late final _Translations$receiveHistoryPage$entryActions$ta entryActions = _Translations$receiveHistoryPage$entryActions$ta._(_root);
}

// Path: apkPickerPage
class _Translations$apkPickerPage$ta extends Translations$apkPickerPage$en {
  _Translations$apkPickerPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'செயலிகள் (APK)';
  @override
  String get excludeSystemApps => 'கணினி செயலிகளைக் கணக்கில் எடுத்துக்கொள்ளாமல் விடவும்';
  @override
  String get excludeAppsWithoutLaunchIntent => 'திறக்க முடியாத செயலிகளை தவிர்க்கவும்';
  @override
  String apps({required Object n}) => '${n} செயலிகள்';
}

// Path: selectedFilesPage
class _Translations$selectedFilesPage$ta extends Translations$selectedFilesPage$en {
  _Translations$selectedFilesPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get deleteAll => 'அனைத்தையும் நீக்கவும்';
}

// Path: deviceDetailsPage
class _Translations$deviceDetailsPage$ta extends Translations$deviceDetailsPage$en {
  _Translations$deviceDetailsPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'சாதன விவரங்கள்';
  @override
  String get favorite => 'பிடித்தவை';
  @override
  String get verify => 'சரிபார்';
  @override
  late final _Translations$deviceDetailsPage$info$ta info = _Translations$deviceDetailsPage$info$ta._(_root);
  @override
  late final _Translations$deviceDetailsPage$logs$ta logs = _Translations$deviceDetailsPage$logs$ta._(_root);
}

// Path: verifyPage
class _Translations$verifyPage$ta extends Translations$verifyPage$en {
  _Translations$verifyPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'சரிபார்';
  @override
  String get icons => 'ஐகான்கள்';
  @override
  String get text => 'உரை';
  @override
  String get question => 'மற்ற சாதனத்தில் இது ஒரே மாதிரி தெரிகிறதா?';
}

// Path: receivePage
class _Translations$receivePage$ta extends Translations$receivePage$en {
  _Translations$receivePage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String subTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ta'))(
    n,
    one: 'உங்களுக்கு ஒரு கோப்பை அனுப்ப விரும்புகிறார்',
    other: 'உங்களுக்கு ${n} கோப்புகளை அனுப்ப விரும்புகிறார்',
  );
  @override
  String get subTitleMessage => 'உங்களுக்கு ஒரு செய்தியை அனுப்பினார்:';
  @override
  String get subTitleLink => 'உங்களுக்கு ஒரு இணைப்பை அனுப்பினார்:';
  @override
  String get canceled => 'அனுப்புபவர் கோரிக்கையை ரத்து செய்துள்ளார்.';
}

// Path: receiveOptionsPage
class _Translations$receiveOptionsPage$ta extends Translations$receiveOptionsPage$en {
  _Translations$receiveOptionsPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'விருப்பங்கள்';
  @override
  String get destination => '@: setsionStab.receive.destination';
  @override
  String get appDirectory => '(LocalSend கோப்புறை)';
  @override
  String get saveToGallery => '@: settionstab.receive.savetogallery';
  @override
  String get saveToGalleryOff => 'கோப்புறைகள் இருப்பதால் தானாகவே முடக்கப்பட்டது.';
}

// Path: sendPage
class _Translations$sendPage$ta extends Translations$sendPage$en {
  _Translations$sendPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String calculatingChecksum({required Object curr, required Object n}) => 'checksum கணக்கிடப்படுகிறது (${curr} / ${n})';
  @override
  String get waiting => 'பதில் வரும் வரை காத்திருக்கிறது…';
  @override
  String get rejected => 'பெறுநர் கோரிக்கையை நிராகரித்துள்ளார்.';
  @override
  String get tooManyAttempts => '@: web.doomanyattempts';
  @override
  String get busy => 'பெறுநர் மற்றொரு கோரிக்கையுடன் ব্যস্তமாக உள்ளார்.';
}

// Path: progressPage
class _Translations$progressPage$ta extends Translations$progressPage$en {
  _Translations$progressPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get titleSending => 'கோப்புகளை அனுப்புகிறது';
  @override
  String get titleReceiving => 'கோப்புகளை பெறுகிறது';
  @override
  String get savedToGallery => 'புகைப்படங்களில் சேமிக்கப்பட்டது';
  @override
  late final _Translations$progressPage$checksum$ta checksum = _Translations$progressPage$checksum$ta._(_root);
  @override
  late final _Translations$progressPage$total$ta total = _Translations$progressPage$total$ta._(_root);
  @override
  late final _Translations$progressPage$remainingTime$ta remainingTime = _Translations$progressPage$remainingTime$ta._(_root);
}

// Path: webSharePage
class _Translations$webSharePage$ta extends Translations$webSharePage$en {
  _Translations$webSharePage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'இணைப்பின் மூலம் பகிரவும்';
  @override
  String get loading => 'சேவையை தொடங்குகிறது…';
  @override
  String get stopping => 'சேவையை நிறுத்துகிறது…';
  @override
  String get error => 'சேவையை தொடங்கும்போது பிழை ஏற்பட்டது.';
  @override
  String openLink({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ta'))(
    n,
    one: 'உங்கள் உலாவியில் இந்த இணைப்பை திறக்கவும்:',
    other: 'உங்கள் உலாவியில் இந்த இணைப்புகளில் ஒன்றை திறக்கவும்:',
  );
  @override
  String get requests => 'கோரிக்கைகள்';
  @override
  String get noRequests => 'இன்னும் கோரிக்கைகள் இல்லை.';
  @override
  String get encryption => '@: settionstab.network.encryption';
  @override
  String get autoAccept => 'கோரிக்கைகளை தானாகவே ஏற்கவும்';
  @override
  String get requirePin => 'PIN தேவை';
  @override
  String pinHint({required Object pin}) => 'PIN "${pin}" ஆகும்';
  @override
  String get encryptionHint => 'LocalSend ஒரு சுய கையொப்பம் செய்யப்பட்ட சான்றிதழைப் பயன்படுத்துகிறது. உங்களின் உலாவியில் அதை ஏற்க வேண்டும்.';
  @override
  String pendingRequests({required Object n}) => 'நிலுவை கோரிக்கைகள்: ${n}';
}

// Path: webReceivePage
class _Translations$webReceivePage$ta extends Translations$webReceivePage$en {
  _Translations$webReceivePage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'இணைப்பு வழியாகப் பெறுக';
}

// Path: aboutPage
class _Translations$aboutPage$ta extends Translations$aboutPage$en {
  _Translations$aboutPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'LocalSend பற்றி';
  @override
  List<String> get description => [
    'LocalSend என்பது ஒரு இலவச, திறந்த மூல செயலி ஆகும், இது உங்களுக்கு உங்களின் உள்ளூர் நெட்வொர்க்கின் மூலம் அருகிலுள்ள சாதனங்களுடன் இணையம் தேவையின்றி பாதுகாப்பாக கோப்புகள் மற்றும் செய்திகளை பகிர அனுமதிக்கிறது.',
    'இந்த செயலி Android, iOS, macOS, Windows மற்றும் Linux-ல் கிடைக்கிறது. அனைத்து பதிவிறக்கம் விருப்பங்களையும் உத்தியோகபூர்வ இணையதளத்தில் காணலாம்.',
  ];
  @override
  String get author => 'ஆசிரியர்';
  @override
  String get contributors => 'பங்களிப்பாளர்கள்';
  @override
  String get packagers => 'பேக்கேஜர்கள்';
  @override
  String get translators => 'மொழிபெயர்ப்பாளர்கள்';
}

// Path: donationPage
class _Translations$donationPage$ta extends Translations$donationPage$en {
  _Translations$donationPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'தானம்';
  @override
  String get info =>
      'LocalSend இலவசம், திறந்த மூலமாக உள்ளது மற்றும் விளம்பரங்களின்றி உள்ளது. செயலியை நீங்கள் விரும்பினால், ஒரு தானம் மூலம் வளர்ச்சியை ஆதரிக்கலாம்.';
  @override
  String donate({required Object amount}) => '${amount} தானம் செய்யவும்';
  @override
  String get thanks => 'மிகவும் நன்றி!';
  @override
  String get restore => 'கொள்முதல் மீட்டமை';
}

// Path: changelogPage
class _Translations$changelogPage$ta extends Translations$changelogPage$en {
  _Translations$changelogPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'மாற்றம் பதிவு';
}

// Path: whatsNewPage
class _Translations$whatsNewPage$ta extends Translations$whatsNewPage$en {
  _Translations$whatsNewPage$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String title({required Object version}) => '${version} இல் புதியது என்ன';
  @override
  late final _Translations$whatsNewPage$changes$ta changes = _Translations$whatsNewPage$changes$ta._(_root);
}

// Path: aliasGenerator
class _Translations$aliasGenerator$ta extends Translations$aliasGenerator$en {
  _Translations$aliasGenerator$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  List<String> get adjectives => [
    'அருமையான',
    'அழகான',
    'பெரிய',
    'பிரகாசமான',
    'சுத்தமான',
    'திறமையான',
    'குளிர்ச்சி',
    'அழகான',
    'வில்லங்கமான',
    'உறுதியான',
    'ஆற்றல் மிக்க',
    'திறமையான',
    'அபாரமான',
    'வேகமான',
    'நன்றாக',
    'புதிய',
    'நல்ல',
    'கண்கவர்',
    'சிறந்த',
    'அழகான',
    'சூடான',
    'கருணைமிக்க',
    'செல்வாக்கான',
    'மர்மமான',
    'ஒழுங்கான',
    'நன்றான',
    'பொறுமையான',
    'அழகான',
    'சக்திவாய்ந்த',
    'செல்வந்தர்',
    'ரகசியமான',
    'சாமர்த்தியமான',
    'உறுதியான',
    'சிறப்பான',
    'உத்தேசமான',
    'வலுவான',
    'சுத்தமாக',
    'புத்திசாலி',
  ];
  @override
  List<String> get fruits => [
    'ஆப்பிள்',
    'அவகேடோ',
    'வாழை',
    'கருப்பு திராட்சை',
    'நீல திராட்சை',
    'ப்ரோக்கோலி',
    'கேரட்',
    'செர்ரி',
    'தேங்காய்',
    'திராட்சை',
    'எலுமிச்சை',
    'லெட்டுஸ்',
    'மாம்பழம்',
    'மெலன்',
    'மஷ்ரூம்',
    'வெங்காயம்',
    'ஆரஞ்சு',
    'பப்பாளி',
    'பீச்',
    'பேரிக்காய்',
    'அன்னாசி',
    'உருளைக்கிழங்கு',
    'மடிக்கோயா',
    'ராஸ்பெர்ரி',
    'ஸ்ட்ராபெர்ரி',
    'தக்காளி',
  ];

  /// சில மொழிகளில், பெயர்ச்சொல் இறுதியில் வர வேண்டும்.
  @override
  String combination({required Object adjective, required Object fruit}) => '${adjective} ${fruit}';
}

// Path: dialogs
class _Translations$dialogs$ta extends Translations$dialogs$en {
  _Translations$dialogs$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$dialogs$addFile$ta addFile = _Translations$dialogs$addFile$ta._(_root);
  @override
  late final _Translations$dialogs$openFile$ta openFile = _Translations$dialogs$openFile$ta._(_root);
  @override
  late final _Translations$dialogs$addressInput$ta addressInput = _Translations$dialogs$addressInput$ta._(_root);
  @override
  late final _Translations$dialogs$cancelSession$ta cancelSession = _Translations$dialogs$cancelSession$ta._(_root);
  @override
  late final _Translations$dialogs$connectionError$ta connectionError = _Translations$dialogs$connectionError$ta._(_root);
  @override
  late final _Translations$dialogs$deleteSourceAfterSendDialog$ta deleteSourceAfterSendDialog =
      _Translations$dialogs$deleteSourceAfterSendDialog$ta._(_root);
  @override
  late final _Translations$dialogs$cannotOpenFile$ta cannotOpenFile = _Translations$dialogs$cannotOpenFile$ta._(_root);
  @override
  late final _Translations$dialogs$encryptionDisabledNotice$ta encryptionDisabledNotice = _Translations$dialogs$encryptionDisabledNotice$ta._(_root);
  @override
  late final _Translations$dialogs$errorDialog$ta errorDialog = _Translations$dialogs$errorDialog$ta._(_root);
  @override
  late final _Translations$dialogs$favoriteDialog$ta favoriteDialog = _Translations$dialogs$favoriteDialog$ta._(_root);
  @override
  late final _Translations$dialogs$favoriteDeleteDialog$ta favoriteDeleteDialog = _Translations$dialogs$favoriteDeleteDialog$ta._(_root);
  @override
  late final _Translations$dialogs$favoriteEditDialog$ta favoriteEditDialog = _Translations$dialogs$favoriteEditDialog$ta._(_root);
  @override
  late final _Translations$dialogs$fileInfo$ta fileInfo = _Translations$dialogs$fileInfo$ta._(_root);
  @override
  late final _Translations$dialogs$fileNameInput$ta fileNameInput = _Translations$dialogs$fileNameInput$ta._(_root);
  @override
  late final _Translations$dialogs$historyClearDialog$ta historyClearDialog = _Translations$dialogs$historyClearDialog$ta._(_root);
  @override
  late final _Translations$dialogs$localNetworkUnauthorized$ta localNetworkUnauthorized = _Translations$dialogs$localNetworkUnauthorized$ta._(_root);
  @override
  late final _Translations$dialogs$messageInput$ta messageInput = _Translations$dialogs$messageInput$ta._(_root);
  @override
  late final _Translations$dialogs$noFiles$ta noFiles = _Translations$dialogs$noFiles$ta._(_root);
  @override
  late final _Translations$dialogs$noPermission$ta noPermission = _Translations$dialogs$noPermission$ta._(_root);
  @override
  late final _Translations$dialogs$notAvailableOnPlatform$ta notAvailableOnPlatform = _Translations$dialogs$notAvailableOnPlatform$ta._(_root);
  @override
  late final _Translations$dialogs$qr$ta qr = _Translations$dialogs$qr$ta._(_root);
  @override
  late final _Translations$dialogs$quickActions$ta quickActions = _Translations$dialogs$quickActions$ta._(_root);
  @override
  late final _Translations$dialogs$quickSaveNotice$ta quickSaveNotice = _Translations$dialogs$quickSaveNotice$ta._(_root);
  @override
  late final _Translations$dialogs$quickSaveFromFavoritesNotice$ta quickSaveFromFavoritesNotice =
      _Translations$dialogs$quickSaveFromFavoritesNotice$ta._(_root);
  @override
  late final _Translations$dialogs$pin$ta pin = _Translations$dialogs$pin$ta._(_root);
  @override
  late final _Translations$dialogs$sendModeHelp$ta sendModeHelp = _Translations$dialogs$sendModeHelp$ta._(_root);
  @override
  late final _Translations$dialogs$startupError$ta startupError = _Translations$dialogs$startupError$ta._(_root);
  @override
  late final _Translations$dialogs$zoom$ta zoom = _Translations$dialogs$zoom$ta._(_root);
}

// Path: sanitization
class _Translations$sanitization$ta extends Translations$sanitization$en {
  _Translations$sanitization$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get empty => 'கோப்பின் பெயர் காலியாக இருக்க முடியாது';
  @override
  String get invalid => 'கோப்பின் பெயரில் தவறான எழுத்துக்கள் உள்ளன';
}

// Path: tray
class _Translations$tray$ta extends Translations$tray$en {
  _Translations$tray$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get open => '@: general.open';
  @override
  String get close => 'LocalSend-ஐ நிறுத்து';
  @override
  String get closeWindows => 'வெளியேறு';
}

// Path: web
class _Translations$web$ta extends Translations$web$en {
  _Translations$web$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get waiting => '@: sendPage.wainging';
  @override
  String get enterPin => 'PIN-ஐ உள்ளிடவும்';
  @override
  String get invalidPin => 'தவறான PIN';
  @override
  String get tooManyAttempts => 'மிக அதிகமான முயற்சிகள்';
  @override
  String get rejected => 'நிராகரிக்கப்பட்டது';
  @override
  String get files => 'கோப்புகள்';
  @override
  String get fileName => 'கோப்பின் பெயர்';
  @override
  String get size => 'அளவு';
}

// Path: assetPicker
class _Translations$assetPicker$ta extends Translations$assetPicker$en {
  _Translations$assetPicker$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get confirm => 'உறுதிசெய்';
  @override
  String get cancel => 'ரத்து செய்';
  @override
  String get edit => 'தொகு';
  @override
  String get gifIndicator => 'Gif';
  @override
  String get loadFailed => 'ஏற்றுதல் தோல்வியடைந்தது';
  @override
  String get original => 'மூல';
  @override
  String get preview => 'முன்னோட்டம்';
  @override
  String get select => 'தேர்வு செய்';
  @override
  String get emptyList => 'காலி பட்டியல்';
  @override
  String get unSupportedAssetType => 'ஆதரிக்கப்படாத கோப்பு வகை.';
  @override
  String get unableToAccessAll => 'சாதனத்தின் அனைத்து கோப்புகளுக்கும் அணுக முடியவில்லை';
  @override
  String get viewingLimitedAssetsTip => 'பயன்பாட்டால் அணுகக்கூடிய கோப்புகள் மற்றும் ஆல்பங்களை மட்டுமே பார்க்கவும்.';
  @override
  String get changeAccessibleLimitedAssets => 'அணுகக்கூடிய கோப்புகளை புதுப்பிக்க கிளிக் செய்யவும்';
  @override
  String get accessAllTip =>
      'பயன்பாடு சாதனத்தின் சில கோப்புகளுக்கே அணுக முடியும். முறைமை அமைப்புகள் செல்லவும் மற்றும் பயன்பாட்டுக்கு அனைத்து ஊடகத்திற்கும் அணுகலை அனுமதிக்கவும்.';
  @override
  String get goToSystemSettings => 'முறைமை அமைப்புகள் செல்லவும்';
  @override
  String get accessLimitedAssets => 'வரையறுக்கப்பட்ட அணுகலுடன் தொடரவும்';
  @override
  String get accessiblePathName => 'அணுகக்கூடிய கோப்புகள்';
  @override
  String get sTypeAudioLabel => 'ஒலி';
  @override
  String get sTypeImageLabel => 'படம்';
  @override
  String get sTypeVideoLabel => 'வீடியோ';
  @override
  String get sTypeOtherLabel => 'மற்ற ஊடகம்';
  @override
  String get sActionPlayHint => 'விளையாட';
  @override
  String get sActionPreviewHint => 'முன்னோட்டம்';
  @override
  String get sActionSelectHint => 'தேர்வு செய்';
  @override
  String get sActionSwitchPathLabel => 'பாதையை மாற்றவும்';
  @override
  String get sActionUseCameraHint => 'கேமராவை பயன்படுத்தவும்';
  @override
  String get sNameDurationLabel => 'நேர அளவு';
  @override
  String get sUnitAssetCountLabel => 'எண்ணிக்கை';
}

// Path: receiveTab.infoBox
class _Translations$receiveTab$infoBox$ta extends Translations$receiveTab$infoBox$en {
  _Translations$receiveTab$infoBox$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get ip => 'இணைய முகவரி:';
  @override
  String get port => 'போர்ட்:';
  @override
  String get alias => 'சாதனத்தின் பெயர்:';
}

// Path: receiveTab.quickSave
class _Translations$receiveTab$quickSave$ta extends Translations$receiveTab$quickSave$en {
  _Translations$receiveTab$quickSave$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get off => '@: செனரல்';
  @override
  String get favorites => 'பிடித்தவை';
  @override
  String get on => '@: செனரல்';
}

// Path: sendTab.selection
class _Translations$sendTab$selection$ta extends Translations$sendTab$selection$en {
  _Translations$sendTab$selection$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'தேர்வு';
  @override
  String files({required Object files}) => 'கோப்புகள்: ${files}';
  @override
  String size({required Object size}) => 'அளவு: ${size}';
}

// Path: sendTab.picker
class _Translations$sendTab$picker$ta extends Translations$sendTab$picker$en {
  _Translations$sendTab$picker$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get file => 'கோப்பு';
  @override
  String get folder => 'கோப்புறை';
  @override
  String get media => 'மீடியா';
  @override
  String get text => 'தட்டச்சு';
  @override
  String get app => 'செயலி';
  @override
  String get clipboard => 'ஒட்டவும்';
}

// Path: sendTab.sendModes
class _Translations$sendTab$sendModes$ta extends Translations$sendTab$sendModes$en {
  _Translations$sendTab$sendModes$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get single => 'ஒற்றை பெறுநர்';
  @override
  String get multiple => 'பல பெறுநர்கள்';
  @override
  String get link => 'இணைப்பு மூலம் பகிரவும்';
}

// Path: sendTab.diagnosis
class _Translations$sendTab$diagnosis$ta extends Translations$sendTab$diagnosis$en {
  _Translations$sendTab$diagnosis$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get scanning => 'அருகிலுள்ள சாதனங்களைத் தேடுகிறது…';
  @override
  late final _Translations$sendTab$diagnosis$noInterface$ta noInterface = _Translations$sendTab$diagnosis$noInterface$ta._(_root);
  @override
  late final _Translations$sendTab$diagnosis$multicastUnavailable$ta multicastUnavailable = _Translations$sendTab$diagnosis$multicastUnavailable$ta._(
    _root,
  );
  @override
  late final _Translations$sendTab$diagnosis$scanNoResult$ta scanNoResult = _Translations$sendTab$diagnosis$scanNoResult$ta._(_root);
  @override
  String get rescan => 'மீண்டும் தேடுங்கள்';
  @override
  String get bleHint =>
      'BLE கண்டறிதல் செயலில் உள்ளது: மற்ற சாதனமும் இந்த ஃபோர்க்கை (விருப்பம் இயக்கத்துடன்) இயக்கும்போது மட்டுமே சாதனங்கள் Bluetooth வழியாகக் கண்டறியப்படும்; கோப்பு பரிமாற்றம் இன்னும் நெட்வொர்க் வழியாகவே நடைபெறும்.';
  @override
  late final _Translations$sendTab$diagnosis$manualFallback$ta manualFallback = _Translations$sendTab$diagnosis$manualFallback$ta._(_root);
}

// Path: settingsTab.general
class _Translations$settingsTab$general$ta extends Translations$settingsTab$general$en {
  _Translations$settingsTab$general$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'பொது';
  @override
  String get brightness => 'தீம்';
  @override
  late final _Translations$settingsTab$general$brightnessOptions$ta brightnessOptions = _Translations$settingsTab$general$brightnessOptions$ta._(
    _root,
  );
  @override
  String get color => 'நிறம்';
  @override
  late final _Translations$settingsTab$general$colorOptions$ta colorOptions = _Translations$settingsTab$general$colorOptions$ta._(_root);
  @override
  String get language => 'மொழி';
  @override
  late final _Translations$settingsTab$general$languageOptions$ta languageOptions = _Translations$settingsTab$general$languageOptions$ta._(_root);
  @override
  String get saveWindowPlacement => 'வெளியேறிய பிறகு சாளர நிலையை சேமிக்கவும்';
  @override
  String get saveWindowPlacementWindows => 'வெளியேறிய பிறகு சாளர நிலையை சேமிக்கவும்';
  @override
  String get minimizeToTray => 'மூடும் போது சிஸ்டம் ட்ரே/மெனு பட்டியில் குறைக்கவும்';
  @override
  String get launchAtStartup => 'உள்நுழைந்த பிறகு தானாக துவக்கவும்';
  @override
  String get launchMinimized => 'ஆட்டோஸ்டார்ட்: மறைக்கப்பட்ட தொடக்கம்';
  @override
  String get showInContextMenu => 'சூழல் மெனுவில் LocalSend ஐக் காட்டு';
  @override
  String get animations => 'அனிமேஷன்கள்';
}

// Path: settingsTab.receive
class _Translations$settingsTab$receive$ta extends Translations$settingsTab$receive$en {
  _Translations$settingsTab$receive$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'பெறு';
  @override
  String get quickSave => '@: general.quicksave';
  @override
  String get quickSaveFromFavorites => '@: general.quick பிடித்தவைகளிலிருந்து சேமிக்கவும்';
  @override
  String get requirePin => '@: websharepage.requirepin';
  @override
  String get autoFinish => 'ஆட்டோ பினிஷ்';
  @override
  String get destination => 'கோப்புறையில் சேமிக்கவும்';
  @override
  String get downloads => '(பதிவிறக்கங்கள்)';
  @override
  String get saveToGallery => 'மீடியாவை கேலரியில் சேமிக்கவும்';
  @override
  String get saveToHistory => 'வரலாற்றில் சேமிக்கவும்';
  @override
  String get verifyChecksums => 'கோப்புகளைப் பெறும்போது checksum சரிபார்க்கவும்';
}

// Path: settingsTab.send
class _Translations$settingsTab$send$ta extends Translations$settingsTab$send$en {
  _Translations$settingsTab$send$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'அனுப்பு';
  @override
  String get shareViaLinkAutoAccept => '"இணைப்பு வழியாக பகிர்" பயன்முறையில் கோரிக்கைகளை தானாக ஏற்கவும்';
  @override
  String get createChecksums => 'கோப்புகளை அனுப்பும்போது checksum உருவாக்கவும்';
  @override
  String get deleteSourceAfterSend => 'வெற்றிகரமான அனுப்புதலுக்குப் பிறகு மூல கோப்புகளை நீக்கு';
}

// Path: settingsTab.network
class _Translations$settingsTab$network$ta extends Translations$settingsTab$network$en {
  _Translations$settingsTab$network$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'நெட்வொர்க்';
  @override
  String get needRestart => 'அமைப்புகளைப் பயன்படுத்த, சேவையகத்தை மறுதொடக்கம் செய்யுங்கள்!';
  @override
  String get server => 'சர்வர்';
  @override
  String get alias => 'சாதனத்தின் பெயர்';
  @override
  String get deviceType => 'சாதன வகை';
  @override
  String get deviceModel => 'சாதன மாதிரி';
  @override
  String get port => 'போர்ட்';
  @override
  String get network => 'பிணையம்';
  @override
  late final _Translations$settingsTab$network$networkOptions$ta networkOptions = _Translations$settingsTab$network$networkOptions$ta._(_root);
  @override
  String get discoveryTimeout => 'கண்டுபிடிப்பு நேரம் முடிந்தது';
  @override
  String get maxInterfaces => 'அதிகபட்ச இடைமுகங்கள் (ஸ்மார்ட் ஸ்கேன்)';
  @override
  String get vpnInterfaces => 'VPN இடைமுகங்களைச் சேர்க்கவும் (ஸ்மார்ட் ஸ்கேன்)';
  @override
  String get vpnInterfacesHint =>
      'VPN டன்னல் இடைமுகங்களின் சப்நெட்களையும் (Tailscale, WireGuard, ...) ஸ்கேன் செய்யுங்கள். VPNகள் பொதுவாக மல்டிகாஸ்ட்டை கொண்டு செல்லாது, எனவே அவற்றின் சப்நெட்கள் HTTP ஃபால்பேக் ஸ்கேன் மூலம் சோதிக்கப்படும்.';
  @override
  String get useSystemName => 'அமைப்பின் பெயரைப் பயன்படுத்தவும்';
  @override
  String get generateRandomAlias => 'சீரற்ற மாற்றுப்பெயரை உருவாக்கவும்';
  @override
  String portWarning({required Object defaultPort}) =>
      'நீங்கள் தனிப்பயன் போர்ட்டைப் பயன்படுத்துவதால், பிற சாதனங்களால் உங்களைக் கண்டறிய முடியாமல் போகலாம். (இயல்புநிலை: ${defaultPort})';
  @override
  String get encryption => 'மறையாக்கம்';
  @override
  String get multicastGroup => 'மல்டிகாஸ்ட் முகவரி';
  @override
  String multicastGroupWarning({required Object defaultMulticast}) =>
      'நீங்கள் தனிப்பயன் மல்டிகாஸ்ட் முகவரியைப் பயன்படுத்துவதால் பிற சாதனங்களால் உங்களைக் கண்டறிய முடியாமல் போகலாம். (இயல்புநிலை: ${defaultMulticast})';
  @override
  String get bleDiscovery => 'BLE கண்டறிதல் (சோதனைமுறை)';
  @override
  String get bleDiscoveryHint =>
      'நெட்வொர்க் மல்டிகாஸ்ட்டைத் தடுக்கும்போதும் (Access Point (AP) Isolation) அருகிலுள்ள சாதனங்களை Bluetooth வழியாகக் கண்டறியும். Android, iOS, macOS மற்றும் Windows-ல் வேலை செய்யும்; Linux-ல் இந்தச் சாதனம் மற்றவற்றைக் கண்டறியும், ஆனால் இது தானாகக் கண்டறியப்பட முடியாது. இரண்டு சாதனங்களுக்கும் இந்த ஃபோர்க் (விருப்பம் இயக்கத்துடன்) தேவை; கோப்பு பரிமாற்றம் இன்னும் நெட்வொர்க்கையே பயன்படுத்தும்.';
  @override
  String get bleStatusActive =>
      'செயலில்: ஸ்கேன் செய்தல் மற்றும் அறிவிப்பு வெளியிடுதல். மற்ற சாதனங்களும் இந்த ஃபோர்க்கை (விருப்பம் இயக்கத்துடன்) இயக்கும்போது மட்டுமே அருகிலுள்ள சாதனங்கள் தோன்றும்.';
  @override
  String get bleStatusScanOnly =>
      'செயலில்: ஸ்கேன் மட்டும். இந்தச் சாதனத்தை இப்போது Bluetooth வழியாகக் கண்டறிய முடியாது (இந்த தளத்தில் BLE அறிவிப்பு வெளியீட்டுக்கு ஆதரவு இல்லை, அல்லது இன்னும் பயன்படுத்தக்கூடிய நெட்வொர்க் முகவரி இல்லை).';
  @override
  String get bleStatusPaused => 'இடைநிறுத்தப்பட்டது. ஆப் முன்னணிக்குத் திரும்பும்போது மீண்டும் தொடங்கும்.';
  @override
  String get bleStatusPermissionDenied =>
      'Bluetooth அனுமதிகள் மறுக்கப்பட்டுள்ளன. கணினி அமைப்புகளில் "அருகிலுள்ள சாதனங்கள்" (அல்லது Android 11 மற்றும் அதற்குக் கீழ் உள்ள பதிப்புகளில் "இருப்பிடம்") அனுமதியை வழங்கி, இந்த விருப்பத்தை முடக்கி மீண்டும் இயக்கவும்.';
  @override
  String get bleStatusAdapterOff =>
      'Bluetooth முடக்கப்பட்டுள்ளது அல்லது கிடைக்கவில்லை. Bluetooth மீண்டும் கிடைக்கும்போது கண்டறிதல் தானாகவே மீண்டும் தொடங்கும்.';
  @override
  String get bleStatusUnsupported =>
      'இந்தச் சாதனத்தில் ஆதரவு இல்லை: BLE கண்டறிதலுக்கு Android 7 அல்லது அதற்குப் பிந்தைய பதிப்பும் Bluetooth LE ரேடியோவும் தேவை.';
  @override
  String get bleStatusLegacyLocation =>
      'இந்த Android பதிப்பில், மற்ற சாதனங்களைக் கண்டறிய கணினியின் இருப்பிட சேவைகளும் இயக்கத்தில் இருக்க வேண்டும் (அனுமதி தானாகக் கோரப்படும்; இந்தச் சாதனத்தை மற்றவர்கள் ஏற்கனவே கண்டறியலாம்).';
  @override
  String get bleStatusError => 'BLE கண்டறிதலைத் தொடங்க முடியவில்லை. விவரங்களுக்கு பிரச்சனைகளை தீர்க்கவும் > பதிவுகள் பார்க்கவும்.';
  @override
  String get bleOpenSystemSettings => 'கணினி அமைப்புகளைத் திறக்கவும்';
}

// Path: settingsTab.other
class _Translations$settingsTab$other$ta extends Translations$settingsTab$other$en {
  _Translations$settingsTab$other$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'மற்றவை';
  @override
  String get support => 'LocalSend ஐ ஆதரிக்க';
  @override
  String get donate => 'நன்கொடை';
  @override
  String get privacyPolicy => 'தனியுரிமைக் கொள்கை';
  @override
  String get termsOfUse => 'பயன்பாட்டு விதிமுறைகள்';
}

// Path: troubleshootPage.firewall
class _Translations$troubleshootPage$firewall$ta extends Translations$troubleshootPage$firewall$en {
  _Translations$troubleshootPage$firewall$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'இந்த சாதனம் மற்ற சாதனங்களுக்கு கோப்புகளை அனுப்ப முடிகிறது ஆனால் மற்ற சாதனங்கள் இந்த சாதனத்திற்கு கோப்புகளை அனுப்ப முடியாது.';
  @override
  String solution({required Object port}) =>
      'இது பொதுவாக ஒரு ஃபயர்வால் பிரச்சனை ஆகும். ${port} போர்ட் மீது உள்வரும் இணைப்புகளை (UDP மற்றும் TCP) அனுமதிப்பதன் மூலம் இதை சரி செய்யலாம்.';
  @override
  String get openFirewall => 'ஃபயர்வால் திறக்கவும்';
}

// Path: troubleshootPage.noDiscovery
class _Translations$troubleshootPage$noDiscovery$ta extends Translations$troubleshootPage$noDiscovery$en {
  _Translations$troubleshootPage$noDiscovery$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'இந்த சாதனம் மற்ற சாதனங்களை கண்டறிய முடியவில்லை.';
  @override
  String get solution =>
      'அனைத்து சாதனங்களும் ஒரே Wi-Fi நெட்வொர்க்கில் உள்ளன மற்றும் ஒரே அமைப்பைப் பகிர்ந்து கொள்கின்றன என்பதை உறுதிசெய்யவும் (போர்ட், மல்டிகாஸ்ட் முகவரி, குறியாக்கம்). இலக்கு சாதனத்தின் IP முகவரியை கையால் টাইப் செய்ய முயற்சிக்கவும். இது வேலை செய்தால், இந்த சாதனத்தை விருப்பங்களில் சேர்க்க பரிந்துரை செய்யப்படுகிறது, எனவே எதிர்காலத்தில் இது தானாகவே கண்டறியப்படும்.';
}

// Path: troubleshootPage.noConnection
class _Translations$troubleshootPage$noConnection$ta extends Translations$troubleshootPage$noConnection$en {
  _Translations$troubleshootPage$noConnection$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'இரண்டு சாதனங்களும் ஒருவருக்கொருவர் கண்டறிய முடியவில்லை அல்லது கோப்புகளை பகிர முடியவில்லை.';
  @override
  String get solution =>
      'பிரச்சனை இரு பக்கங்களிலும் உள்ளதா? அவ்வாறெனில், இரு சாதனங்களும் ஒரே Wi-Fi நெட்வொர்க்கில் உள்ளன மற்றும் ஒரே அமைப்பைப் பகிர்ந்து கொள்கின்றன என்பதை உறுதிசெய்ய வேண்டும் (போர்ட், மல்டிகாஸ்ட் முகவரி, குறியாக்கம்). Access Point (AP) Isolation காரணமாக Wi-Fi நெட்வொர்க்கில் பங்கேற்பாளர்கள் ஒருவருடன் ஒருவர் தொடர்பு கொள்ள முடியாமல் இருக்கலாம். இந்த விருப்பத்தை ரௌட்டரில் முடக்க வேண்டும்.';
}

// Path: receiveHistoryPage.entryActions
class _Translations$receiveHistoryPage$entryActions$ta extends Translations$receiveHistoryPage$entryActions$en {
  _Translations$receiveHistoryPage$entryActions$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get open => 'கோப்பை திறக்கவும்';
  @override
  String get showInFolder => 'கோப்புறையில் காண்பிக்கவும்';
  @override
  String get info => 'தகவல்';
  @override
  String get deleteFromHistory => 'வரலாற்றில் இருந்து நீக்கவும்';
}

// Path: deviceDetailsPage.info
class _Translations$deviceDetailsPage$info$ta extends Translations$deviceDetailsPage$info$en {
  _Translations$deviceDetailsPage$info$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get name => 'பெயர்';
  @override
  String get address => 'முகவரி';
  @override
  String get version => 'பதிப்பு';
  @override
  String protocol({required Object version}) => 'நெறிமுறை v${version}';
}

// Path: deviceDetailsPage.logs
class _Translations$deviceDetailsPage$logs$ta extends Translations$deviceDetailsPage$logs$en {
  _Translations$deviceDetailsPage$logs$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'பதிவுகள்';
  @override
  String get empty => 'பதிவுகள் எதுவும் இல்லை.';
  @override
  String discovered({required Object protocol, required Object host}) => '${protocol} வழியாகக் கண்டறியப்பட்டது (${host})';
  @override
  String updated({required Object protocol, required Object host}) => '${protocol} வழியாக புதுப்பிக்கப்பட்டது (${host})';
}

// Path: progressPage.checksum
class _Translations$progressPage$checksum$ta extends Translations$progressPage$checksum$en {
  _Translations$progressPage$checksum$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get verified => 'அனைத்து checksumகளும் சரிபார்க்கப்பட்டன';
  @override
  String partiallyVerified({required Object curr, required Object n}) => '${curr} / ${n} கோப்புகளுக்கு checksumகள் சரிபார்க்கப்பட்டன';
  @override
  String get notVerifiable => 'அனுப்புநர் checksumகளை வழங்கவில்லை';
  @override
  String get disabled => 'Checksum சரிபார்ப்பு முடக்கப்பட்டுள்ளது';
  @override
  String attached({required Object curr, required Object n}) => 'Checksumகள் இணைக்கப்பட்டன (கோப்புகள் ${curr} / ${n})';
}

// Path: progressPage.total
class _Translations$progressPage$total$ta extends Translations$progressPage$total$en {
  _Translations$progressPage$total$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$progressPage$total$title$ta title = _Translations$progressPage$total$title$ta._(_root);
  @override
  String count({required Object curr, required Object n}) => 'கோப்புகள்: ${curr} / ${n}';
  @override
  String size({required Object curr, required Object n}) => 'அளவு: ${curr} / ${n}';
  @override
  String speed({required Object speed}) => 'வேகம்: ${speed}/s';
}

// Path: progressPage.remainingTime
class _Translations$progressPage$remainingTime$ta extends Translations$progressPage$remainingTime$en {
  _Translations$progressPage$remainingTime$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String minutesUnit({required num m}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ta'))(
    m,
    other: '${m}நி',
  );
  @override
  String hoursUnit({required num h}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ta'))(
    h,
    other: '${h}மணி',
  );
  @override
  String minutes({required Object m, required Object ss}) => '${m}:${ss}';
  @override
  String hours({required num h, required num m}) =>
      '${_root.progressPage.remainingTime.hoursUnit(h: h)} ${_root.progressPage.remainingTime.minutesUnit(m: m)}';
}

// Path: whatsNewPage.changes
class _Translations$whatsNewPage$changes$ta extends Translations$whatsNewPage$changes$en {
  _Translations$whatsNewPage$changes$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$whatsNewPage$changes$v1_18_0$ta v1_18_0 = _Translations$whatsNewPage$changes$v1_18_0$ta._(_root);
}

// Path: dialogs.addFile
class _Translations$dialogs$addFile$ta extends Translations$dialogs$addFile$en {
  _Translations$dialogs$addFile$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'தேர்வுக்கு சேர்';
  @override
  String get content => 'நீங்கள் என்ன சேர்க்க விரும்புகிறீர்கள்?';
}

// Path: dialogs.openFile
class _Translations$dialogs$openFile$ta extends Translations$dialogs$openFile$en {
  _Translations$dialogs$openFile$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'கோப்பை திறக்கவும்';
  @override
  String get content => 'பெறப்பட்ட கோப்பை திறக்க விரும்புகிறீர்களா?';
}

// Path: dialogs.addressInput
class _Translations$dialogs$addressInput$ta extends Translations$dialogs$addressInput$en {
  _Translations$dialogs$addressInput$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'முகவரியை உள்ளிடவும்';
  @override
  String get hashtag => 'ஹாஷ்டேக்';
  @override
  String get ip => 'IP முகவரி';
  @override
  String get recentlyUsed => 'சமீபத்தில் பயன்படுத்தப்பட்டது: ';
  @override
  String get noHashtagCandidates =>
      'தற்போதைய நெட்வொர்க்கில் IPv4 முகவரி இல்லாததால், ஹாஷ்டேக்கை வேட்பாளர் முகவரியாக விரிவாக்க முடியாது. முழு முகவரியை உள்ளிடவும் (உதா. 192.168.1.5 அல்லது fe80::1).';
  @override
  late final _Translations$dialogs$addressInput$validation$ta validation = _Translations$dialogs$addressInput$validation$ta._(_root);
}

// Path: dialogs.cancelSession
class _Translations$dialogs$cancelSession$ta extends Translations$dialogs$cancelSession$en {
  _Translations$dialogs$cancelSession$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'கோப்புகள் பரிமாற்றத்தை ரத்து செய்யவும்';
  @override
  String get content => 'நீங்கள் உண்மையிலேயே கோப்புகள் பரிமாற்றத்தை ரத்து செய்ய விரும்புகிறீர்களா?';
}

// Path: dialogs.connectionError
class _Translations$dialogs$connectionError$ta extends Translations$dialogs$connectionError$en {
  _Translations$dialogs$connectionError$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'இணைப்பு தோல்வியடைந்தது';
  @override
  late final _Translations$dialogs$connectionError$timeout$ta timeout = _Translations$dialogs$connectionError$timeout$ta._(_root);
  @override
  late final _Translations$dialogs$connectionError$refused$ta refused = _Translations$dialogs$connectionError$refused$ta._(_root);
  @override
  late final _Translations$dialogs$connectionError$forbidden$ta forbidden = _Translations$dialogs$connectionError$forbidden$ta._(_root);
  @override
  late final _Translations$dialogs$connectionError$other$ta other = _Translations$dialogs$connectionError$other$ta._(_root);
  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';
  @override
  String get details => 'பிழை விவரங்கள்:';
}

// Path: dialogs.deleteSourceAfterSendDialog
class _Translations$dialogs$deleteSourceAfterSendDialog$ta extends Translations$dialogs$deleteSourceAfterSendDialog$en {
  _Translations$dialogs$deleteSourceAfterSendDialog$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'மூல கோப்புகளை நீக்கு';
  @override
  String get content => 'கோப்புகள் வெற்றிகரமாக அனுப்பப்பட்ட பிறகு, அவை இந்தச் சாதனத்திலிருந்து நீக்கப்படும். இதை மீட்டெடுக்க முடியாது.';
}

// Path: dialogs.cannotOpenFile
class _Translations$dialogs$cannotOpenFile$ta extends Translations$dialogs$cannotOpenFile$en {
  _Translations$dialogs$cannotOpenFile$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'கோப்பை திறக்க முடியவில்லை';
  @override
  String content({required Object file}) => '"${file}"-ஐ திறக்க முடியவில்லை. இந்த கோப்பு நகர்த்தப்பட்டதா, மறுபெயரிடப்பட்டதா அல்லது நீக்கப்பட்டதா?';
}

// Path: dialogs.encryptionDisabledNotice
class _Translations$dialogs$encryptionDisabledNotice$ta extends Translations$dialogs$encryptionDisabledNotice$en {
  _Translations$dialogs$encryptionDisabledNotice$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'குறியாக்கம் முடக்கப்பட்டது';
  @override
  String get content =>
      'இப்போது தகவல்தொடர்பு குறியாக்கமில்லாத HTTP நெறிமுறையின் மூலம் நடக்கிறது. HTTPS நெறிமுறையை பயன்படுத்த, குறியாக்கத்தை மீண்டும் இயக்கவும்.';
}

// Path: dialogs.errorDialog
class _Translations$dialogs$errorDialog$ta extends Translations$dialogs$errorDialog$en {
  _Translations$dialogs$errorDialog$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '@: general.error';
}

// Path: dialogs.favoriteDialog
class _Translations$dialogs$favoriteDialog$ta extends Translations$dialogs$favoriteDialog$en {
  _Translations$dialogs$favoriteDialog$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'பிடித்தவை';
  @override
  String get noFavorites => 'இன்னும் பிடித்த சாதனங்கள் இல்லை.';
  @override
  String get addFavorite => 'சேர்';
}

// Path: dialogs.favoriteDeleteDialog
class _Translations$dialogs$favoriteDeleteDialog$ta extends Translations$dialogs$favoriteDeleteDialog$en {
  _Translations$dialogs$favoriteDeleteDialog$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'பிடித்தவையிலிருந்து நீக்கவும்';
  @override
  String content({required Object name}) => '"${name}"-ஐ பிடித்தவையிலிருந்து உண்மையிலேயே நீக்க விரும்புகிறீர்களா?';
}

// Path: dialogs.favoriteEditDialog
class _Translations$dialogs$favoriteEditDialog$ta extends Translations$dialogs$favoriteEditDialog$en {
  _Translations$dialogs$favoriteEditDialog$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get titleAdd => 'பிடித்தவைகளில் சேர்க்கவும்';
  @override
  String get titleEdit => 'அமைப்புகள்';
  @override
  String get name => 'சாதனத்தின் பெயர்';
  @override
  String get auto => '(தானாக)';
  @override
  String get ip => 'IP முகவரி';
  @override
  String get port => 'போர்ட்';
}

// Path: dialogs.fileInfo
class _Translations$dialogs$fileInfo$ta extends Translations$dialogs$fileInfo$en {
  _Translations$dialogs$fileInfo$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'கோப்பு தகவல்';
  @override
  String get fileName => 'கோப்பின் பெயர்:';
  @override
  String get path => 'பாதை:';
  @override
  String get size => 'அளவு:';
  @override
  String get sender => 'அனுப்புநர்:';
  @override
  String get time => 'நேரம்:';
}

// Path: dialogs.fileNameInput
class _Translations$dialogs$fileNameInput$ta extends Translations$dialogs$fileNameInput$en {
  _Translations$dialogs$fileNameInput$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'கோப்பின் பெயரை உள்ளிடவும்';
  @override
  String original({required Object original}) => 'மூல: ${original}';
}

// Path: dialogs.historyClearDialog
class _Translations$dialogs$historyClearDialog$ta extends Translations$dialogs$historyClearDialog$en {
  _Translations$dialogs$historyClearDialog$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'வரலாற்றை அழிக்கவும்';
  @override
  String get content => 'மொத்த வரலாற்றையும் உண்மையிலேயே நீக்க விரும்புகிறீர்களா?';
}

// Path: dialogs.localNetworkUnauthorized
class _Translations$dialogs$localNetworkUnauthorized$ta extends Translations$dialogs$localNetworkUnauthorized$en {
  _Translations$dialogs$localNetworkUnauthorized$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '@: உரையாடல்.நோபர்மிசன்.டிடில்';
  @override
  String get description =>
      'LocalSend உள்நாட்டு நெட்வொர்க்கை ஸ்கேன் செய்ய அனுமதியின்றி சாதனங்களை கண்டறிய முடியாது. தயவுசெய்து அமைப்புகளில் இந்த அனுமதியை வழங்கவும்.';
  @override
  String get gotoSettings => 'அமைப்புகள்';
}

// Path: dialogs.messageInput
class _Translations$dialogs$messageInput$ta extends Translations$dialogs$messageInput$en {
  _Translations$dialogs$messageInput$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'செய்தியை தட்டச்சு செய்யவும்';
  @override
  String get multiline => 'பல வரிகள்';
}

// Path: dialogs.noFiles
class _Translations$dialogs$noFiles$ta extends Translations$dialogs$noFiles$en {
  _Translations$dialogs$noFiles$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'கோப்புகள் தேர்ந்தெடுக்கப்படவில்லை';
  @override
  String get content => 'குறைந்தது ஒரு கோப்பை தேர்ந்தெடுக்கவும்.';
}

// Path: dialogs.noPermission
class _Translations$dialogs$noPermission$ta extends Translations$dialogs$noPermission$en {
  _Translations$dialogs$noPermission$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'அனுமதி இல்லை';
  @override
  String get content => 'தேவையான அனுமதிகளை நீங்கள் வழங்கவில்லை. தயவுசெய்து அமைப்புகளில் அவற்றை வழங்கவும்.';
}

// Path: dialogs.notAvailableOnPlatform
class _Translations$dialogs$notAvailableOnPlatform$ta extends Translations$dialogs$notAvailableOnPlatform$en {
  _Translations$dialogs$notAvailableOnPlatform$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'கிடைக்கவில்லை';
  @override
  String get content => 'இந்த அம்சம் மட்டுமே கிடைக்கிறது:';
}

// Path: dialogs.qr
class _Translations$dialogs$qr$ta extends Translations$dialogs$qr$en {
  _Translations$dialogs$qr$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'QR குறியீடு';
}

// Path: dialogs.quickActions
class _Translations$dialogs$quickActions$ta extends Translations$dialogs$quickActions$en {
  _Translations$dialogs$quickActions$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'விரைவு செயல்கள்';
  @override
  String get counter => 'கணக்கிடுபவர்';
  @override
  String get prefix => 'முன்னொட்டு';
  @override
  String get padZero => 'பூஜ்யங்களால் நிரப்பவும்';
  @override
  String get sortBeforeCount => 'முன்னதாக வரிசைப்படுத்தவும் (A-Z)';
  @override
  String get random => 'சீரற்ற';
}

// Path: dialogs.quickSaveNotice
class _Translations$dialogs$quickSaveNotice$ta extends Translations$dialogs$quickSaveNotice$en {
  _Translations$dialogs$quickSaveNotice$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '@: general.quicksave';
  @override
  String get content =>
      'கோப்பு கோரிக்கைகள் இப்போது தானாகவே ஏற்கப்படும். உள்ளூர் நெட்வொர்க்கில் உள்ள அனைவரும் உங்களுக்கு கோப்புகளை அனுப்ப முடியும் என்பதை கவனிக்கவும்.';
}

// Path: dialogs.quickSaveFromFavoritesNotice
class _Translations$dialogs$quickSaveFromFavoritesNotice$ta extends Translations$dialogs$quickSaveFromFavoritesNotice$en {
  _Translations$dialogs$quickSaveFromFavoritesNotice$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '@: general.quick பிடித்தவைகளிலிருந்து சேமிக்கவும்';
  @override
  List<String> get content => [
    'உங்கள் பிடிக்க பட்டியலில் உள்ள சாதனங்களில் இருந்து கோப்பு கோரிக்கைகள் இப்போது தானாகவே ஏற்கப்படும்.',
  ];
}

// Path: dialogs.pin
class _Translations$dialogs$pin$ta extends Translations$dialogs$pin$en {
  _Translations$dialogs$pin$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'PIN-ஐ உள்ளிடவும்';
}

// Path: dialogs.sendModeHelp
class _Translations$dialogs$sendModeHelp$ta extends Translations$dialogs$sendModeHelp$en {
  _Translations$dialogs$sendModeHelp$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'அனுப்பும் முறைகள்';
  @override
  String get single => 'கோப்புகளை ஒரு பெறுநருக்கு அனுப்புகிறது. கோப்புகள் பரிமாற்றம் முடிந்த பிறகு தேர்வு அழிக்கப்படும்.';
  @override
  String get multiple => 'கோப்புகளை பல பெறுநர்களுக்கு அனுப்புகிறது. கோப்புகள் பரிமாற்றம் முடிந்த பிறகு தேர்வு அழிக்கப்படாது.';
  @override
  String get link =>
      'LocalSend நிறுவப்படாத பெறுநர்கள் தங்கள் உலாவியில் இணைப்பைத் திறக்க மூலம் தேர்ந்தெடுக்கப்பட்ட கோப்புகளை பதிவிறக்கம் செய்ய முடியும்.';
}

// Path: dialogs.startupError
class _Translations$dialogs$startupError$ta extends Translations$dialogs$startupError$en {
  _Translations$dialogs$startupError$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'சேவையகத்தைத் தொடங்க முடியவில்லை';
  @override
  String port({required Object port}) => 'போர்ட்: ${port}';
  @override
  late final _Translations$dialogs$startupError$windowsAccessDenied$ta windowsAccessDenied =
      _Translations$dialogs$startupError$windowsAccessDenied$ta._(_root);
  @override
  late final _Translations$dialogs$startupError$addressInUse$ta addressInUse = _Translations$dialogs$startupError$addressInUse$ta._(_root);
  @override
  late final _Translations$dialogs$startupError$generic$ta generic = _Translations$dialogs$startupError$generic$ta._(_root);
  @override
  String get details => 'பிழை விவரங்கள்:';
  @override
  String get copyDetails => 'விவரங்களை நகலெடுக்கவும்';
  @override
  String get openSettings => 'அமைப்புகளைத் திறக்கவும்';
}

// Path: dialogs.zoom
class _Translations$dialogs$zoom$ta extends Translations$dialogs$zoom$en {
  _Translations$dialogs$zoom$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'முகவரி';
}

// Path: sendTab.diagnosis.noInterface
class _Translations$sendTab$diagnosis$noInterface$ta extends Translations$sendTab$diagnosis$noInterface$en {
  _Translations$sendTab$diagnosis$noInterface$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'நெட்வொர்க் இணைப்பு இல்லை';
  @override
  String get advice => 'இந்தச் சாதனம் எந்த நெட்வொர்க்கிலும் இணைக்கப்படவில்லை. இந்தச் சாதனத்தின் Wi-Fi அல்லது கேபிள் இணைப்பைச் சரிபார்க்கவும்.';
}

// Path: sendTab.diagnosis.multicastUnavailable
class _Translations$sendTab$diagnosis$multicastUnavailable$ta extends Translations$sendTab$diagnosis$multicastUnavailable$en {
  _Translations$sendTab$diagnosis$multicastUnavailable$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'மல்டிகாஸ்ட் கிடைக்கவில்லை';
  @override
  String advice({required Object port}) =>
      'இந்த நெட்வொர்க்கில் LocalSend மல்டிகாஸ்ட் கண்டறிதலைப் பயன்படுத்த முடியவில்லை. இரண்டு சாதனங்களும் ஒரே நெட்வொர்க்கில் இருப்பதையும், Access Point (AP) Isolation அல்லது ஃபயர்வால் UDP ${port} போர்ட்டைத் தடுக்கவில்லை என்பதையும் உறுதிசெய்யவும்.';
  @override
  String reason({required Object reason}) => 'காரணம்: ${reason}';
}

// Path: sendTab.diagnosis.scanNoResult
class _Translations$sendTab$diagnosis$scanNoResult$ta extends Translations$sendTab$diagnosis$scanNoResult$en {
  _Translations$sendTab$diagnosis$scanNoResult$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'சாதனங்கள் எதுவும் கிடைக்கவில்லை';
  @override
  String get advice =>
      'கண்டறிதல் வேலை செய்கிறது, ஆனால் அறிவிப்புகளுக்கோ நெட்வொர்க் ஸ்கேனுக்கோ எந்தச் சாதனமும் பதிலளிக்கவில்லை. மற்ற சாதனம் ஆஃப்லைனில் இருக்கலாம், தூங்கிக் கொண்டிருக்கலாம், அல்லது ஃபயர்வாலால் தடுக்கப்பட்டிருக்கலாம். மற்ற சாதனத்தில் LocalSend இயங்குவதை உறுதிசெய்யவும்.';
  @override
  String detail({required Object announcements, required Object scans}) =>
      'பதில் இன்றி ${announcements} அறிவிப்புகள் மற்றும் ${scans} நெட்வொர்க் ஸ்கேன்கள் அனுப்பப்பட்டன.';
}

// Path: sendTab.diagnosis.manualFallback
class _Translations$sendTab$diagnosis$manualFallback$ta extends Translations$sendTab$diagnosis$manualFallback$en {
  _Translations$sendTab$diagnosis$manualFallback$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get message =>
      'IP முகவரிகள் அடிக்கடி மாறும். பட்டியலில் இல்லாத சாதனத்தையும் அணுகலாம்: அதை பிடித்தவையில் சேர்க்கவும் அல்லது அதன் முகவரியை கைமுறையாக உள்ளிடவும்.';
  @override
  String get openFavorites => 'பிடித்தவையைத் திறக்கவும்';
  @override
  String get manualInput => 'முகவரியை கைமுறையாக உள்ளிடவும்';
}

// Path: settingsTab.general.brightnessOptions
class _Translations$settingsTab$general$brightnessOptions$ta extends Translations$settingsTab$general$brightnessOptions$en {
  _Translations$settingsTab$general$brightnessOptions$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'கணினி தீம்';
  @override
  String get dark => 'இருண்ட தீம்';
  @override
  String get light => 'ஒளி தீம்';
}

// Path: settingsTab.general.colorOptions
class _Translations$settingsTab$general$colorOptions$ta extends Translations$settingsTab$general$colorOptions$en {
  _Translations$settingsTab$general$colorOptions$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'கணினி நிறம்';
  @override
  String get oled => 'ஓஎல்இடி';
  @override
  String get custom => 'தனிப்பயன்';
}

// Path: settingsTab.general.languageOptions
class _Translations$settingsTab$general$languageOptions$ta extends Translations$settingsTab$general$languageOptions$en {
  _Translations$settingsTab$general$languageOptions$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'கணினி மொழி';
}

// Path: settingsTab.network.networkOptions
class _Translations$settingsTab$network$networkOptions$ta extends Translations$settingsTab$network$networkOptions$en {
  _Translations$settingsTab$network$networkOptions$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'அனைத்தும்';
  @override
  String get filtered => 'வடிகட்டப்பட்டது';
}

// Path: progressPage.total.title
class _Translations$progressPage$total$title$ta extends Translations$progressPage$total$title$en {
  _Translations$progressPage$total$title$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String sending({required Object time}) => 'மொத்த முன்னேற்றம் (${time})';
  @override
  String get finishedError => 'பிழையுடன் முடிந்தது';
  @override
  String get canceledSender => 'அனுப்புநரால் ரத்து செய்யப்பட்டது';
  @override
  String get canceledReceiver => 'பெறுநரால் ரத்து செய்யப்பட்டது';
}

// Path: whatsNewPage.changes.v1_18_0
class _Translations$whatsNewPage$changes$v1_18_0$ta extends Translations$whatsNewPage$changes$v1_18_0$en with WhatsNewStrings {
  _Translations$whatsNewPage$changes$v1_18_0$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  List<String> get changes => [
    'மறைகுறியாக்கம் இனி பரிமாற்றங்களை மெதுவாக்காது. நீங்கள் முன்பு அதை அணைத்திருந்தால், இந்தச் சாதனத்தில் அது மீண்டும் இயக்கப்பட்டுள்ளது.',
    'பிடித்தவைகளில் இருந்து வரும் கோரிக்கைகள் இப்போது தானாகவே ஏற்கப்படுகின்றன. இது இயல்பாக இயக்கத்தில் உள்ளது; அமைப்புகளில் முடக்கலாம்.',
    'Android இல், செயலி பின்னணியில் இருந்தாலும் அல்லது திரை அணைந்திருந்தாலும் பரிமாற்றங்கள் தொடரும். iOS இல், செயலி இன்னும் முன்னணியில் இருக்க வேண்டும்.',
  ];
}

// Path: dialogs.addressInput.validation
class _Translations$dialogs$addressInput$validation$ta extends Translations$dialogs$addressInput$validation$en {
  _Translations$dialogs$addressInput$validation$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get invalid => 'சரியான IPv4 முகவரி, IPv6 முகவரி அல்லது ஹோஸ்ட் பெயரை உள்ளிடவும்.';
  @override
  String get scheme => 'முகவரியை மட்டும் உள்ளிடவும், "http://" அல்லது "https://" இல்லாமல்.';
  @override
  String get port => 'முகவரியை மட்டும் உள்ளிடவும். போர்ட் அமைப்புகளிலிருந்து எடுக்கப்படும்.';
}

// Path: dialogs.connectionError.timeout
class _Translations$dialogs$connectionError$timeout$ta extends Translations$dialogs$connectionError$timeout$en {
  _Translations$dialogs$connectionError$timeout$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'சாதனம் நேரத்திற்குள் பதிலளிக்கவில்லை.';
  @override
  String get advice =>
      'அது பெரும்பாலும் ஆஃப்லைனில் இருக்கலாம், தூங்கிக் கொண்டிருக்கலாம், அல்லது ஃபயர்வால் இணைப்பைத் தடுக்கிறது. மற்ற சாதனத்தில் LocalSend இயங்குவதையும், இரண்டு சாதனங்களும் ஒரே நெட்வொர்க்கில் இருப்பதையும் உறுதிசெய்யவும்.';
}

// Path: dialogs.connectionError.refused
class _Translations$dialogs$connectionError$refused$ta extends Translations$dialogs$connectionError$refused$en {
  _Translations$dialogs$connectionError$refused$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'சாதனம் இணைப்பை நிராகரித்தது.';
  @override
  String get advice =>
      'இலக்கு சாதனத்தில் LocalSend இயங்காததாகத் தெரிகிறது, அல்லது அது வேறு போர்ட்டில் கேட்கிறது. மற்ற சாதனத்தில் LocalSend-ஐத் தொடங்கவும் அல்லது போர்ட்டைச் சரிபார்க்கவும்.';
}

// Path: dialogs.connectionError.forbidden
class _Translations$dialogs$connectionError$forbidden$ta extends Translations$dialogs$connectionError$forbidden$en {
  _Translations$dialogs$connectionError$forbidden$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'சாதனம் கோரிக்கையை நிராகரித்தது.';
  @override
  String get advice =>
      'PIN தேவைப்படலாம், அல்லது சாதனத்துடனான இணைத்தல் (pairing) மாறியிருக்கலாம். இலக்கு சாதனத்தில் PIN மற்றும் விரைவு சேமிப்பு அமைப்புகளைச் சரிபார்க்கவும்.';
}

// Path: dialogs.connectionError.other
class _Translations$dialogs$connectionError$other$ta extends Translations$dialogs$connectionError$other$en {
  _Translations$dialogs$connectionError$other$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'இணைப்பை ஏற்படுத்த முடியவில்லை.';
  @override
  String get advice =>
      'முகவரி மற்றும் போர்ட்டைச் சரிபார்த்து, இலக்கு சாதனத்தில் LocalSend இயங்குவதையும், ஃபயர்வால் அல்லது VPN இணைப்பைத் தடுக்கவில்லை என்பதையும் உறுதிசெய்யவும்.';
}

// Path: dialogs.startupError.windowsAccessDenied
class _Translations$dialogs$startupError$windowsAccessDenied$ta extends Translations$dialogs$startupError$windowsAccessDenied$en {
  _Translations$dialogs$startupError$windowsAccessDenied$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Windows போர்ட்டுக்கான அணுகலை மறுத்தது (சாக்கெட் பிழை 10013).';
  @override
  String get advice =>
      'இது பொதுவாக Hyper-V, WSL அல்லது Docker ஒதுக்கியுள்ள போர்ட் வரம்பு அல்லது சேதமடைந்த Winsock கேடலாக் காரணமாக இருக்கலாம்:\n• அமைப்புகள் (நெட்வொர்க்) பகுதியில் போர்ட்டை மாற்றவும்\n• ஒதுக்கப்பட்ட வரம்புகளை இதனால் சரிபார்க்கவும்: netsh interface ipv4 show excludedportrange protocol=tcp\n• நிர்வாகியாக Winsock-ஐ பழுதுபார்க்கவும்: netsh winsock reset (பின்னர் மறுதொடக்கம் செய்யவும்)';
}

// Path: dialogs.startupError.addressInUse
class _Translations$dialogs$startupError$addressInUse$ta extends Translations$dialogs$startupError$addressInUse$en {
  _Translations$dialogs$startupError$addressInUse$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'இந்த போர்ட் ஏற்கனவே மற்றொரு செயலியால் பயன்படுத்தப்படுகிறது.';
  @override
  String get advice =>
      'மற்றொரு நிரல் (அல்லது இரண்டாவது LocalSend நிகழ்வு) இந்த போர்ட்டில் கேட்டுக்கொண்டிருக்கிறது:\n• மற்ற செயலியை மூடவும், அல்லது\n• அமைப்புகள் (நெட்வொர்க்) பகுதியில் போர்ட்டை மாற்றவும்';
}

// Path: dialogs.startupError.generic
class _Translations$dialogs$startupError$generic$ta extends Translations$dialogs$startupError$generic$en {
  _Translations$dialogs$startupError$generic$ta._(TranslationsTa root) : this._root = root, super.internal(root);

  final TranslationsTa _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'சேவையகத்தைத் தொடங்க முடியவில்லை.';
  @override
  String get advice =>
      '• ஃபயர்வால் மற்றும் நெட்வொர்க் அமைப்புகளைச் சரிபார்க்கவும்\n• அமைப்புகள் (நெட்வொர்க்) பகுதியில் போர்ட்டை மாற்றிப் பார்க்கவும்';
}
