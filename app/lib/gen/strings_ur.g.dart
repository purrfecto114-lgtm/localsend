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
class TranslationsUr extends Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsUr({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ur,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <ur>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  late final TranslationsUr _root = this; // ignore: unused_field

  @override
  TranslationsUr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsUr(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'LocalSend';
  @override
  late final _Translations$general$ur general = _Translations$general$ur._(_root);
  @override
  late final _Translations$receiveTab$ur receiveTab = _Translations$receiveTab$ur._(_root);
  @override
  late final _Translations$sendTab$ur sendTab = _Translations$sendTab$ur._(_root);
  @override
  late final _Translations$settingsTab$ur settingsTab = _Translations$settingsTab$ur._(_root);
  @override
  late final _Translations$troubleshootPage$ur troubleshootPage = _Translations$troubleshootPage$ur._(_root);
  @override
  late final _Translations$networkInterfacesPage$ur networkInterfacesPage = _Translations$networkInterfacesPage$ur._(_root);
  @override
  late final _Translations$receiveHistoryPage$ur receiveHistoryPage = _Translations$receiveHistoryPage$ur._(_root);
  @override
  late final _Translations$apkPickerPage$ur apkPickerPage = _Translations$apkPickerPage$ur._(_root);
  @override
  late final _Translations$selectedFilesPage$ur selectedFilesPage = _Translations$selectedFilesPage$ur._(_root);
  @override
  late final _Translations$deviceDetailsPage$ur deviceDetailsPage = _Translations$deviceDetailsPage$ur._(_root);
  @override
  late final _Translations$verifyPage$ur verifyPage = _Translations$verifyPage$ur._(_root);
  @override
  late final _Translations$receivePage$ur receivePage = _Translations$receivePage$ur._(_root);
  @override
  late final _Translations$receiveOptionsPage$ur receiveOptionsPage = _Translations$receiveOptionsPage$ur._(_root);
  @override
  late final _Translations$sendPage$ur sendPage = _Translations$sendPage$ur._(_root);
  @override
  late final _Translations$progressPage$ur progressPage = _Translations$progressPage$ur._(_root);
  @override
  late final _Translations$webSharePage$ur webSharePage = _Translations$webSharePage$ur._(_root);
  @override
  late final _Translations$webReceivePage$ur webReceivePage = _Translations$webReceivePage$ur._(_root);
  @override
  late final _Translations$aboutPage$ur aboutPage = _Translations$aboutPage$ur._(_root);
  @override
  late final _Translations$donationPage$ur donationPage = _Translations$donationPage$ur._(_root);
  @override
  late final _Translations$changelogPage$ur changelogPage = _Translations$changelogPage$ur._(_root);
  @override
  late final _Translations$whatsNewPage$ur whatsNewPage = _Translations$whatsNewPage$ur._(_root);
  @override
  late final _Translations$dialogs$ur dialogs = _Translations$dialogs$ur._(_root);
  @override
  late final _Translations$sanitization$ur sanitization = _Translations$sanitization$ur._(_root);
  @override
  late final _Translations$tray$ur tray = _Translations$tray$ur._(_root);
  @override
  late final _Translations$web$ur web = _Translations$web$ur._(_root);
  @override
  late final _Translations$assetPicker$ur assetPicker = _Translations$assetPicker$ur._(_root);
}

// Path: general
class _Translations$general$ur extends Translations$general$en {
  _Translations$general$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get accept => 'قبول کریں';
  @override
  String get accepted => 'قبول کر لیا';
  @override
  String get add => 'شامل کریں';
  @override
  String get advanced => 'اعلی درجے کی';
  @override
  String get cancel => 'منسوخ کریں';
  @override
  String get close => 'بند کریں';
  @override
  String get confirm => 'تصدیق کریں';
  @override
  String get continueStr => 'جاری رہے';
  @override
  String get copy => 'کاپی کریں';
  @override
  String get copiedToClipboard => 'کلپ بورڈ پر کاپی کیا گیا';
  @override
  String get decline => 'رد کرنا';
  @override
  String get done => 'ہو گیا';
  @override
  String get delete => 'حذف کریں';
  @override
  String get edit => 'ترمیم';
  @override
  String get error => 'خرابی';
  @override
  String get example => 'مثال';
  @override
  String get files => 'فائلوں';
  @override
  String get finished => 'ختم';
  @override
  String get hide => 'چھپائیں';
  @override
  String get off => 'بند';
  @override
  String get offline => 'آف لائن';
  @override
  String get on => 'آن';
  @override
  String get online => 'آن لائن';
  @override
  String get open => 'کھولیں';
  @override
  String get queue => 'قطار';
  @override
  String get quickSave => 'فوری محفوظ کریں';
  @override
  String get quickSaveFromFavorites => 'پسندیدہ کے لیے فوری محفوظ کریں';
  @override
  String get renamed => 'نام تبدیل کر دیا گیا';
  @override
  String get reset => 'دوبارہ ترتیب دیں';
  @override
  String get restart => 'دوبارہ شروع کریں';
  @override
  String get settings => 'ترتیبات';
  @override
  String get skipped => 'چھوڑ دیا';
  @override
  String get start => 'شروع کریں';
  @override
  String get stop => 'رک جاؤ';
  @override
  String get save => 'محفوظ کریں';
  @override
  String get unchanged => 'غیر تبدیل شدہ';
  @override
  String get unknown => 'نامعلوم';
  @override
  String get noItemInClipboard => 'کلپ بورڈ میں کوئی چیز نہیں ہے۔';
}

// Path: receiveTab
class _Translations$receiveTab$ur extends Translations$receiveTab$en {
  _Translations$receiveTab$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'وصول کریں';
  @override
  late final _Translations$receiveTab$infoBox$ur infoBox = _Translations$receiveTab$infoBox$ur._(_root);
  @override
  late final _Translations$receiveTab$quickSave$ur quickSave = _Translations$receiveTab$quickSave$ur._(_root);
  @override
  String get link => 'لنک کے ذریعے وصول کریں';
}

// Path: sendTab
class _Translations$sendTab$ur extends Translations$sendTab$en {
  _Translations$sendTab$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'بھیجیں';
  @override
  late final _Translations$sendTab$selection$ur selection = _Translations$sendTab$selection$ur._(_root);
  @override
  late final _Translations$sendTab$picker$ur picker = _Translations$sendTab$picker$ur._(_root);
  @override
  String get shareIntentInfo => 'آپ اپنے موبائل ڈیوائس کی "شیئر کریں" فیچر کو بھی آسانی سے فائلوں کو منتخب کرنے کے لیے استعمال کرسکتے ہیں۔';
  @override
  String get nearbyDevices => 'قریبی ڈیوائس';
  @override
  String get thisDevice => 'یہ ڈیوائس';
  @override
  String get scan => 'ڈیوائس تلاش کریں';
  @override
  String get manualSending => 'خود بھیجنا';
  @override
  String get sendMode => 'سینڈ موڈ';
  @override
  late final _Translations$sendTab$sendModes$ur sendModes = _Translations$sendTab$sendModes$ur._(_root);
  @override
  String get sendModeHelp => 'وضاحت';
  @override
  String get help => 'براہ کرم یقینی بنائیں کہ مطلوبہ ہدف بھی اسی وائی فائی نیٹ ورک میں ہے۔';
  @override
  String get placeItems => 'شئیر کرنے کے لیے اشیاء رکھیں۔';
  @override
  late final _Translations$sendTab$diagnosis$ur diagnosis = _Translations$sendTab$diagnosis$ur._(_root);
}

// Path: settingsTab
class _Translations$settingsTab$ur extends Translations$settingsTab$en {
  _Translations$settingsTab$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ترتیبات';
  @override
  late final _Translations$settingsTab$general$ur general = _Translations$settingsTab$general$ur._(_root);
  @override
  late final _Translations$settingsTab$receive$ur receive = _Translations$settingsTab$receive$ur._(_root);
  @override
  late final _Translations$settingsTab$send$ur send = _Translations$settingsTab$send$ur._(_root);
  @override
  late final _Translations$settingsTab$network$ur network = _Translations$settingsTab$network$ur._(_root);
  @override
  late final _Translations$settingsTab$other$ur other = _Translations$settingsTab$other$ur._(_root);
  @override
  String get advancedSettings => 'تجاویز شھر کی ترتیبات';
}

// Path: troubleshootPage
class _Translations$troubleshootPage$ur extends Translations$troubleshootPage$en {
  _Translations$troubleshootPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'خرابی کا سراغ لگانا';
  @override
  String get subTitle => 'کیا یہ ایپ توقع کے مطابق کام نہیں کرتی؟ یہاں آپ عام حل تلاش کر سکتے ہیں۔';
  @override
  String get solution => 'حل:';
  @override
  String get fixButton => 'خود بخود درست کریں';
  @override
  late final _Translations$troubleshootPage$firewall$ur firewall = _Translations$troubleshootPage$firewall$ur._(_root);
  @override
  late final _Translations$troubleshootPage$noDiscovery$ur noDiscovery = _Translations$troubleshootPage$noDiscovery$ur._(_root);
  @override
  late final _Translations$troubleshootPage$noConnection$ur noConnection = _Translations$troubleshootPage$noConnection$ur._(_root);
}

// Path: networkInterfacesPage
class _Translations$networkInterfacesPage$ur extends Translations$networkInterfacesPage$en {
  _Translations$networkInterfacesPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'نیٹ ورک انٹرفیسز';
  @override
  String get info =>
      'پہلے سے طے شدہ طور پر، لوکل سینڈ تمام دستیاب نیٹ ورک انٹرفیس استعمال کرتا ہے۔ آپ یہاں ناپسندیدہ نیٹ ورکس کو خارج کر سکتے ہیں۔ تبدیلیاں لاگو کرنے کے لیے آپ کو سرور کو دوبارہ شروع کرنے کی ضرورت ہے۔';
  @override
  String get preview => 'پیش نظارہ';
  @override
  String get whitelist => 'وائٹ لسٹ';
  @override
  String get blacklist => 'بلیک لسٹ';
}

// Path: receiveHistoryPage
class _Translations$receiveHistoryPage$ur extends Translations$receiveHistoryPage$en {
  _Translations$receiveHistoryPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'تاریخ';
  @override
  String get openFolder => 'فولڈر کھولیں';
  @override
  String get deleteHistory => 'تاریخ کو حذف کریں';
  @override
  String get empty => 'تاریخ خالی ہے۔';
  @override
  late final _Translations$receiveHistoryPage$entryActions$ur entryActions = _Translations$receiveHistoryPage$entryActions$ur._(_root);
}

// Path: apkPickerPage
class _Translations$apkPickerPage$ur extends Translations$apkPickerPage$en {
  _Translations$apkPickerPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'اپلیکیشنز (APK)';
  @override
  String get excludeSystemApps => 'سسٹم ایپس کو ختم کریں';
  @override
  String get excludeAppsWithoutLaunchIntent => 'غیر لانچ ہونے والے ایپس کو ختم کریں';
  @override
  String apps({required Object n}) => '${n} ایپس';
}

// Path: selectedFilesPage
class _Translations$selectedFilesPage$ur extends Translations$selectedFilesPage$en {
  _Translations$selectedFilesPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get deleteAll => 'تمام حذف کریں';
}

// Path: deviceDetailsPage
class _Translations$deviceDetailsPage$ur extends Translations$deviceDetailsPage$en {
  _Translations$deviceDetailsPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'آلے کی تفصیلات';
  @override
  String get favorite => 'پسندیدہ';
  @override
  String get verify => 'تصدیق کریں';
  @override
  late final _Translations$deviceDetailsPage$info$ur info = _Translations$deviceDetailsPage$info$ur._(_root);
  @override
  late final _Translations$deviceDetailsPage$logs$ur logs = _Translations$deviceDetailsPage$logs$ur._(_root);
}

// Path: verifyPage
class _Translations$verifyPage$ur extends Translations$verifyPage$en {
  _Translations$verifyPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'تصدیق کریں';
  @override
  String get icons => 'آئیکنز';
  @override
  String get text => 'متن';
  @override
  String get question => 'کیا یہ دوسرے آلے پر ویسا ہی نظر آتا ہے؟';
}

// Path: receivePage
class _Translations$receivePage$ur extends Translations$receivePage$en {
  _Translations$receivePage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String subTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ur'))(
    n,
    one: 'آپ کو ایک فائل بھیجنا چاہتا ہے',
    other: 'آپ کو ${n} فائلیں بھیجنا چاہتا ہے',
  );
  @override
  String get subTitleMessage => 'آپ کو ایک پیغام بھیجا:';
  @override
  String get subTitleLink => 'آپ کو ایک لنک بھیجا:';
  @override
  String get canceled => 'بھیجنے والے نے درخواست منسوخ کر دی ہے۔';
}

// Path: receiveOptionsPage
class _Translations$receiveOptionsPage$ur extends Translations$receiveOptionsPage$en {
  _Translations$receiveOptionsPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'اختیارات';
  @override
  String get destination => _root.settingsTab.receive.destination;
  @override
  String get appDirectory => '(لوکل سینڈ فولڈر)';
  @override
  String get saveToGallery => _root.settingsTab.receive.saveToGallery;
  @override
  String get saveToGalleryOff => 'خود کار طور پر منقطع ہوگیا ہے کیونکہ ڈائریکٹریاں ہیں۔';
}

// Path: sendPage
class _Translations$sendPage$ur extends Translations$sendPage$en {
  _Translations$sendPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String calculatingChecksum({required Object curr, required Object n}) => 'چیک سم کا حساب لگایا جا رہا ہے (${curr} / ${n})';
  @override
  String get waiting => 'جواب کا منتظر...';
  @override
  String get rejected => 'وصول کنندہ نے درخواست مسترد کر دی ہے۔';
  @override
  String get tooManyAttempts => _root.web.tooManyAttempts;
  @override
  String get busy => 'وصول کنندہ دوسری درخواست میں مصروف ہے۔';
}

// Path: progressPage
class _Translations$progressPage$ur extends Translations$progressPage$en {
  _Translations$progressPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get titleSending => 'فائلیں بھیج رہا ہے';
  @override
  String get titleReceiving => 'فائلیں موصول ہو رہی ہیں';
  @override
  String get savedToGallery => 'تصاویر میں محفوظ کیا گیا';
  @override
  late final _Translations$progressPage$checksum$ur checksum = _Translations$progressPage$checksum$ur._(_root);
  @override
  late final _Translations$progressPage$total$ur total = _Translations$progressPage$total$ur._(_root);
  @override
  late final _Translations$progressPage$remainingTime$ur remainingTime = _Translations$progressPage$remainingTime$ur._(_root);
}

// Path: webSharePage
class _Translations$webSharePage$ur extends Translations$webSharePage$en {
  _Translations$webSharePage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'لنک کے ذریعے شئیر کریں';
  @override
  String get loading => 'سرور کو چالو کررہا ہے...';
  @override
  String get stopping => 'سرور بند ہو رہا ہے...';
  @override
  String get error => 'سرور چالو کرتے وقت خامی پیش آئی ہے۔';
  @override
  String openLink({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ur'))(
    n,
    one: 'اس لنک کو براوزر میں کھولیں:',
    other: 'ان میں سے کسی ایک لنک کو براوزر میں کھولیں:',
  );
  @override
  String get requests => 'درخواستیں';
  @override
  String get noRequests => 'ابھی تک کوئی درخواست نہیں۔';
  @override
  String get encryption => _root.settingsTab.network.encryption;
  @override
  String get autoAccept => 'درخواستیں خود بخود قبول کریں';
  @override
  String get requirePin => 'PIN درکار ہے';
  @override
  String pinHint({required Object pin}) => 'PIN ہے "${pin}"';
  @override
  String get encryptionHint => 'LocalSend براؤزر میں استعمال کرنے کیلئے آپ کوخود سائن کردہ سرٹیفکیٹ قبول کرنا ہوگا۔';
  @override
  String pendingRequests({required Object n}) => 'زیر التواء درخواستیں: ${n}';
}

// Path: webReceivePage
class _Translations$webReceivePage$ur extends Translations$webReceivePage$en {
  _Translations$webReceivePage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'لنک کے ذریعے وصول کریں';
}

// Path: aboutPage
class _Translations$aboutPage$ur extends Translations$aboutPage$en {
  _Translations$aboutPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'کے بارے میں LocalSend';
  @override
  List<String> get description => [
    'LocalSend ایک مفت، اوپن سورس ایپ ہے جو آپ کو انٹرنیٹ کنکشن کی ضرورت کے بغیر اپنے مقامی نیٹ ورک کے ذریعے قریبی آلات کے ساتھ فائلیں اور پیغامات محفوظ طریقے سے شیئر کرنے کی اجازت دیتی ہے۔',
    'یہ ایپ اینڈرائیڈ، iOS، macOS، ونڈوز، اور لینکس پر دستیاب ہے۔ آپ تمام ڈاؤن لوڈ کے اختیارات سرکاری ویب سائٹ پر تلاش کر سکتے ہیں۔',
  ];
  @override
  String get author => 'مصنف';
  @override
  String get contributors => 'تعاون کنندگان';
  @override
  String get packagers => 'پیکجرز';
  @override
  String get translators => 'مترجمین';
}

// Path: donationPage
class _Translations$donationPage$ur extends Translations$donationPage$en {
  _Translations$donationPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'عطیہ کریں';
  @override
  String get info =>
      'LocalSend مفت، اوپن سورس ہے اور اس میں کوئی اشتہارات نہیں ہیں۔ اگر آپ کو ایپ پسند ہے، تو آپ عطیہ کے ذریعے ترقی کی حمایت کر سکتے ہیں۔';
  @override
  String donate({required Object amount}) => 'عطیہ کریں ${amount}';
  @override
  String get thanks => 'آپ کا بہت بہت شکریہ!';
  @override
  String get restore => 'خریداری بحال کریں';
}

// Path: changelogPage
class _Translations$changelogPage$ur extends Translations$changelogPage$en {
  _Translations$changelogPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'چینج لاگ';
}

// Path: whatsNewPage
class _Translations$whatsNewPage$ur extends Translations$whatsNewPage$en {
  _Translations$whatsNewPage$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String title({required Object version}) => '${version} میں نیا کیا ہے';
  @override
  late final _Translations$whatsNewPage$changes$ur changes = _Translations$whatsNewPage$changes$ur._(_root);
}

// Path: dialogs
class _Translations$dialogs$ur extends Translations$dialogs$en {
  _Translations$dialogs$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$dialogs$addFile$ur addFile = _Translations$dialogs$addFile$ur._(_root);
  @override
  late final _Translations$dialogs$openFile$ur openFile = _Translations$dialogs$openFile$ur._(_root);
  @override
  late final _Translations$dialogs$addressInput$ur addressInput = _Translations$dialogs$addressInput$ur._(_root);
  @override
  late final _Translations$dialogs$cancelSession$ur cancelSession = _Translations$dialogs$cancelSession$ur._(_root);
  @override
  late final _Translations$dialogs$connectionError$ur connectionError = _Translations$dialogs$connectionError$ur._(_root);
  @override
  late final _Translations$dialogs$deleteSourceAfterSendDialog$ur deleteSourceAfterSendDialog =
      _Translations$dialogs$deleteSourceAfterSendDialog$ur._(_root);
  @override
  late final _Translations$dialogs$cannotOpenFile$ur cannotOpenFile = _Translations$dialogs$cannotOpenFile$ur._(_root);
  @override
  late final _Translations$dialogs$encryptionDisabledNotice$ur encryptionDisabledNotice = _Translations$dialogs$encryptionDisabledNotice$ur._(_root);
  @override
  late final _Translations$dialogs$errorDialog$ur errorDialog = _Translations$dialogs$errorDialog$ur._(_root);
  @override
  late final _Translations$dialogs$favoriteDialog$ur favoriteDialog = _Translations$dialogs$favoriteDialog$ur._(_root);
  @override
  late final _Translations$dialogs$favoriteDeleteDialog$ur favoriteDeleteDialog = _Translations$dialogs$favoriteDeleteDialog$ur._(_root);
  @override
  late final _Translations$dialogs$favoriteEditDialog$ur favoriteEditDialog = _Translations$dialogs$favoriteEditDialog$ur._(_root);
  @override
  late final _Translations$dialogs$fileInfo$ur fileInfo = _Translations$dialogs$fileInfo$ur._(_root);
  @override
  late final _Translations$dialogs$fileNameInput$ur fileNameInput = _Translations$dialogs$fileNameInput$ur._(_root);
  @override
  late final _Translations$dialogs$historyClearDialog$ur historyClearDialog = _Translations$dialogs$historyClearDialog$ur._(_root);
  @override
  late final _Translations$dialogs$localNetworkUnauthorized$ur localNetworkUnauthorized = _Translations$dialogs$localNetworkUnauthorized$ur._(_root);
  @override
  late final _Translations$dialogs$messageInput$ur messageInput = _Translations$dialogs$messageInput$ur._(_root);
  @override
  late final _Translations$dialogs$noFiles$ur noFiles = _Translations$dialogs$noFiles$ur._(_root);
  @override
  late final _Translations$dialogs$noPermission$ur noPermission = _Translations$dialogs$noPermission$ur._(_root);
  @override
  late final _Translations$dialogs$notAvailableOnPlatform$ur notAvailableOnPlatform = _Translations$dialogs$notAvailableOnPlatform$ur._(_root);
  @override
  late final _Translations$dialogs$qr$ur qr = _Translations$dialogs$qr$ur._(_root);
  @override
  late final _Translations$dialogs$quickActions$ur quickActions = _Translations$dialogs$quickActions$ur._(_root);
  @override
  late final _Translations$dialogs$quickSaveNotice$ur quickSaveNotice = _Translations$dialogs$quickSaveNotice$ur._(_root);
  @override
  late final _Translations$dialogs$quickSaveFromFavoritesNotice$ur quickSaveFromFavoritesNotice =
      _Translations$dialogs$quickSaveFromFavoritesNotice$ur._(_root);
  @override
  late final _Translations$dialogs$pin$ur pin = _Translations$dialogs$pin$ur._(_root);
  @override
  late final _Translations$dialogs$sendModeHelp$ur sendModeHelp = _Translations$dialogs$sendModeHelp$ur._(_root);
  @override
  late final _Translations$dialogs$startupError$ur startupError = _Translations$dialogs$startupError$ur._(_root);
  @override
  late final _Translations$dialogs$zoom$ur zoom = _Translations$dialogs$zoom$ur._(_root);
}

// Path: sanitization
class _Translations$sanitization$ur extends Translations$sanitization$en {
  _Translations$sanitization$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get empty => 'فائل کا نام خالی نہیں ہو سکتا';
  @override
  String get invalid => 'فائل کے نام میں غلط حروف ہیں';
}

// Path: tray
class _Translations$tray$ur extends Translations$tray$en {
  _Translations$tray$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get open => _root.general.open;
  @override
  String get close => 'چھوڑو LocalSend';
  @override
  String get closeWindows => 'بند کریں';
}

// Path: web
class _Translations$web$ur extends Translations$web$en {
  _Translations$web$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get waiting => _root.sendPage.waiting;
  @override
  String get enterPin => 'PIN درج کریں';
  @override
  String get invalidPin => 'غلط PIN';
  @override
  String get tooManyAttempts => 'بہت زیادہ کوششیں';
  @override
  String get rejected => 'منسوخ کردیا';
  @override
  String get files => 'فائلیں';
  @override
  String get fileName => 'فائل کا نام';
  @override
  String get size => 'سائز';
}

// Path: assetPicker
class _Translations$assetPicker$ur extends Translations$assetPicker$en {
  _Translations$assetPicker$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get confirm => 'تصدیق کریں';
  @override
  String get cancel => 'منسوخ کریں';
  @override
  String get edit => 'ترمیم کریں';
  @override
  String get gifIndicator => 'جی آئی ایف';
  @override
  String get loadFailed => 'لوڈ نہیں ہوسکی';
  @override
  String get original => 'اصل ';
  @override
  String get preview => 'پیش نظارہ';
  @override
  String get select => 'منتخب کریں';
  @override
  String get emptyList => 'خالی فہرست';
  @override
  String get unSupportedAssetType => 'غیر معتبر فائل کی قسم۔';
  @override
  String get unableToAccessAll => 'یہ ڈیوائس پر تمام فائلوں تک رسائی نہیں ہوسکتی ہے۔';
  @override
  String get viewingLimitedAssetsTip => 'صرف ایپ تک رسائی پذیر فائلوں اور البم کونسیس ہوسکتی ہیں۔';
  @override
  String get changeAccessibleLimitedAssets => 'رسائی پذیر فائلوں کو اپ ڈیٹ کرنے کے لئے کلک کریں';
  @override
  String get accessAllTip =>
      'ایپ صرف چند فائلوں تک رسائی حاصل کرسکتی ہے ڈیوائس پر۔ سسٹم کی ترتیبات میں جائیں اور ایپ کو ڈیوائس پر تمام میڈیا تک رسائی کی اجازت دیں۔';
  @override
  String get goToSystemSettings => 'سسٹم ترتیبات پر جائیں';
  @override
  String get accessLimitedAssets => 'محدود رسائی کے ساتھ جاری رکھیں';
  @override
  String get accessiblePathName => 'رسائی پذیر فائلیں';
  @override
  String get sTypeAudioLabel => 'آڈیو';
  @override
  String get sTypeImageLabel => 'تصویر';
  @override
  String get sTypeVideoLabel => 'ویڈیو';
  @override
  String get sTypeOtherLabel => 'دیگر میڈیا';
  @override
  String get sActionPlayHint => 'چلائیں';
  @override
  String get sActionPreviewHint => 'پیش نظارہ کریں';
  @override
  String get sActionSelectHint => 'منتخب کریں';
  @override
  String get sActionSwitchPathLabel => 'راستہ تبدیل کریں';
  @override
  String get sActionUseCameraHint => 'کیمرہ استعمال کریں';
  @override
  String get sNameDurationLabel => 'مدت';
  @override
  String get sUnitAssetCountLabel => 'کاؤنٹ';
}

// Path: receiveTab.infoBox
class _Translations$receiveTab$infoBox$ur extends Translations$receiveTab$infoBox$en {
  _Translations$receiveTab$infoBox$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get ip => 'آئی پی:';
  @override
  String get port => 'پورٹ:';
  @override
  String get alias => 'عرف:';
}

// Path: receiveTab.quickSave
class _Translations$receiveTab$quickSave$ur extends Translations$receiveTab$quickSave$en {
  _Translations$receiveTab$quickSave$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get off => 'آف';
  @override
  String get favorites => 'پسندیدہ';
  @override
  String get on => 'آن';
}

// Path: sendTab.selection
class _Translations$sendTab$selection$ur extends Translations$sendTab$selection$en {
  _Translations$sendTab$selection$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'انتخاب';
  @override
  String files({required Object files}) => 'فائلیں: ${files}';
  @override
  String size({required Object size}) => 'سائز: ${size}';
}

// Path: sendTab.picker
class _Translations$sendTab$picker$ur extends Translations$sendTab$picker$en {
  _Translations$sendTab$picker$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get file => 'فائل';
  @override
  String get folder => 'فولڈر';
  @override
  String get media => 'میڈیا';
  @override
  String get text => 'ٹیکسٹ';
  @override
  String get app => 'ایپ';
  @override
  String get clipboard => 'چسپاں کریں';
}

// Path: sendTab.sendModes
class _Translations$sendTab$sendModes$ur extends Translations$sendTab$sendModes$en {
  _Translations$sendTab$sendModes$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get single => 'سنگل رسپٹ';
  @override
  String get multiple => 'ملٹیپل رسپٹ';
  @override
  String get link => 'لنک کے ذریعے شیئر کریں';
}

// Path: sendTab.diagnosis
class _Translations$sendTab$diagnosis$ur extends Translations$sendTab$diagnosis$en {
  _Translations$sendTab$diagnosis$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get scanning => 'قریبی ڈیوائسز کی تلاش جاری ہے…';
  @override
  late final _Translations$sendTab$diagnosis$noInterface$ur noInterface = _Translations$sendTab$diagnosis$noInterface$ur._(_root);
  @override
  late final _Translations$sendTab$diagnosis$multicastUnavailable$ur multicastUnavailable = _Translations$sendTab$diagnosis$multicastUnavailable$ur._(
    _root,
  );
  @override
  late final _Translations$sendTab$diagnosis$scanNoResult$ur scanNoResult = _Translations$sendTab$diagnosis$scanNoResult$ur._(_root);
  @override
  String get rescan => 'دوبارہ تلاش کریں';
  @override
  String get bleHint =>
      'BLE دریافت فعال ہے: ڈیوائسز صرف اسی صورت بلوٹوتھ کے ذریعے ملتی ہیں جب وہ بھی فعال آپشن کے ساتھ یہی فورک (fork) چلا رہی ہوں؛ منتقلی خود اب بھی نیٹ ورک کے ذریعے ہوتی ہے۔';
  @override
  late final _Translations$sendTab$diagnosis$manualFallback$ur manualFallback = _Translations$sendTab$diagnosis$manualFallback$ur._(_root);
}

// Path: settingsTab.general
class _Translations$settingsTab$general$ur extends Translations$settingsTab$general$en {
  _Translations$settingsTab$general$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'جنرل';
  @override
  String get brightness => 'تھیم';
  @override
  late final _Translations$settingsTab$general$brightnessOptions$ur brightnessOptions = _Translations$settingsTab$general$brightnessOptions$ur._(
    _root,
  );
  @override
  String get color => 'رنگ';
  @override
  late final _Translations$settingsTab$general$colorOptions$ur colorOptions = _Translations$settingsTab$general$colorOptions$ur._(_root);
  @override
  String get language => 'زبان';
  @override
  late final _Translations$settingsTab$general$languageOptions$ur languageOptions = _Translations$settingsTab$general$languageOptions$ur._(_root);
  @override
  String get saveWindowPlacement => 'چھوڑیں: ونڈو کی جگہ کو محفوظ کریں';
  @override
  String get saveWindowPlacementWindows => 'بند ہونے پر ونڈو کی پوزیشن محفوظ کریں';
  @override
  String get minimizeToTray => 'چھوڑیں: ٹرے میں چھوٹا کریں';
  @override
  String get launchAtStartup => 'لاگ ان کے بعد آٹو اسٹارٹ';
  @override
  String get launchMinimized => 'آٹو سٹارٹ: سٹارٹ پوشیدہ';
  @override
  String get showInContextMenu => 'سیاق و سباق کے مینو میں LocalSend دکھائیں';
  @override
  String get animations => 'تحریکات';
}

// Path: settingsTab.receive
class _Translations$settingsTab$receive$ur extends Translations$settingsTab$receive$en {
  _Translations$settingsTab$receive$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'وصول کریں';
  @override
  String get quickSave => _root.general.quickSave;
  @override
  String get quickSaveFromFavorites => _root.general.quickSaveFromFavorites;
  @override
  String get requirePin => _root.webSharePage.requirePin;
  @override
  String get autoFinish => 'خودکار تکمیل';
  @override
  String get destination => 'منزل';
  @override
  String get downloads => '(ڈاؤن لوڈ)';
  @override
  String get saveToGallery => 'میڈیا کو گیلری میں محفوظ کریں';
  @override
  String get saveToHistory => 'تاریخچہ میں محفوظ کریں';
  @override
  String get verifyChecksums => 'فائلیں وصول کرتے وقت چیک سم کی تصدیق کریں';
}

// Path: settingsTab.send
class _Translations$settingsTab$send$ur extends Translations$settingsTab$send$en {
  _Translations$settingsTab$send$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'بھیجیں';
  @override
  String get shareViaLinkAutoAccept => '"لنک کے ذریعے شیئر کریں" موڈ میں درخواستیں خود بخود قبول کریں';
  @override
  String get createChecksums => 'فائلیں بھیجتے وقت چیک سم بنائیں';
  @override
  String get deleteSourceAfterSend => 'کامیاب بھیجنے کے بعد سورس فائلیں حذف کریں';
}

// Path: settingsTab.network
class _Translations$settingsTab$network$ur extends Translations$settingsTab$network$en {
  _Translations$settingsTab$network$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'نیٹ ورک';
  @override
  String get needRestart => 'ترتیبات کو لاگو کرنے کے لیے سرور کو دوبارہ شروع کریں!';
  @override
  String get server => 'سرور';
  @override
  String get alias => 'عرف';
  @override
  String get deviceType => 'آلہ کی قسم';
  @override
  String get deviceModel => 'آلہ کا ماڈل';
  @override
  String get port => 'پورٹ';
  @override
  String get network => 'نیٹ ورک';
  @override
  late final _Translations$settingsTab$network$networkOptions$ur networkOptions = _Translations$settingsTab$network$networkOptions$ur._(_root);
  @override
  String get discoveryTimeout => 'نیٹورک پرڈھونڈنے کی مدت ختم ہوگئ ہے';
  @override
  String get maxInterfaces => 'زیادہ سے زیادہ انٹرفیس (اسمارٹ سکین)';
  @override
  String get vpnInterfaces => 'VPN انٹرفیسز شامل کریں (اسمارٹ سکین)';
  @override
  String get vpnInterfacesHint =>
      'VPN ٹنل انٹرفیسز (Tailscale، WireGuard وغیرہ) کے سب نیٹ ورکس بھی سکین ہوتے ہیں۔ VPN عموماً ملٹی کاسٹ کی حمایت نہیں کرتے، اس لیے ان کے سب نیٹ ورکس بجائے اس کے HTTP فال بیک سکین سے جانچے جاتے ہیں۔';
  @override
  String get useSystemName => 'سسٹم کا نام استعمال کریں';
  @override
  String get generateRandomAlias => 'بے ترتیب عرف پیدا کریں';
  @override
  String portWarning({required Object defaultPort}) =>
      'ہو سکتا ہے آپ کو دوسرے آلات سے پتہ نہ چل سکے کیونکہ آپ حسب ضرورت پورٹ استعمال کر رہے ہیں۔ (پہلے سے طے شدہ: ${defaultPort})';
  @override
  String get encryption => 'خفیہ کاری';
  @override
  String get multicastGroup => 'ملٹی کاسٹ';
  @override
  String multicastGroupWarning({required Object defaultMulticast}) =>
      'ہو سکتا ہے آپ کو دوسرے آلات سے پتہ نہ لگے کیونکہ آپ حسب ضرورت ملٹی کاسٹ ایڈریس استعمال کر رہے ہیں۔ (پہلے سے طے شدہ: ${defaultMulticast})';
  @override
  String get bleDiscovery => 'BLE دریافت (تجرباتی)';
  @override
  String get bleDiscoveryHint =>
      'نیٹ ورک کے ملٹی کاسٹ مسدود کرنے کے باوجود (AP آئسولیشن) بلوٹوتھ کے ذریعے قریبی ڈیوائسز تلاش کرتا ہے۔ اینڈرائیڈ، iOS، macOS اور ونڈوز پر کام کرتا ہے؛ لینکس پر یہ ڈیوائس دوسروں کو تلاش کر سکتی ہے لیکن خود دریافت نہیں ہو سکتی۔ دونوں ڈیوائسز کو فعال آپشن کے ساتھ یہی فورک (fork) درکار ہے؛ فائل کی منتقلی خود اب بھی نیٹ ورک سے ہوتی ہے۔';
  @override
  String get bleStatusActive =>
      'فعال: سکیننگ اور advertising جاری ہے۔ قریبی ڈیوائسز صرف اس صورت نظر آتی ہیں جب وہ بھی فعال آپشن کے ساتھ یہی فورک (fork) چلا رہی ہوں۔';
  @override
  String get bleStatusScanOnly =>
      'فعال: صرف سکیننگ۔ اس وقت اس ڈیوائس کو بلوٹوتھ کے ذریعے دریافت نہیں کیا جا سکتا (اس پلیٹ فارم پر BLE advertising کی حمایت نہیں، یا ابھی کوئی قابلِ استعمال نیٹ ورک ایڈریس موجود نہیں)۔';
  @override
  String get bleStatusPaused => 'موقوف۔ ایپ کے پیش منظر میں واپس آنے پر دوبارہ شروع ہو جاتی ہے۔';
  @override
  String get bleStatusPermissionDenied =>
      'بلوٹوتھ کی اجازتیں مسترد کر دی گئی ہیں۔ سسٹم ترتیبات میں "قریبی آلات" (یا اینڈرائیڈ 11 اور پرانے ورژن پر "مقام") کی اجازت دیں، پھر یہ آپشن بند کر کے دوبارہ چالو کریں۔';
  @override
  String get bleStatusAdapterOff => 'بلوٹوتھ بند ہے یا دستیاب نہیں۔ بلوٹوتھ کے دوبارہ دستیاب ہوتے ہی دریافت خود بخود دوبارہ شروع ہو جاتی ہے۔';
  @override
  String get bleStatusUnsupported => 'اس ڈیوائس پر معاون نہیں: BLE دریافت کے لیے اینڈرائیڈ 7 یا نیا ورژن اور Bluetooth LE ریڈیو درکار ہے۔';
  @override
  String get bleStatusLegacyLocation =>
      'اینڈرائیڈ کے اس ورژن پر دیگر ڈیوائسز کی تلاش کے لیے سسٹم کی لوکیشن سروسز کا چالو ہونا بھی ضروری ہے (اجازت خودکار طلب ہوتی ہے؛ اس ڈیوائس کو دیگر پہلے ہی تلاش کر سکتے ہیں)۔';
  @override
  String get bleStatusError => 'BLE دریافت شروع نہیں ہو سکی۔ تفصیلات کے لیے خرابی کا سراغ لگانا > لاگز دیکھیں۔';
  @override
  String get bleOpenSystemSettings => 'سسٹم ترتیبات کھولیں';
}

// Path: settingsTab.other
class _Translations$settingsTab$other$ur extends Translations$settingsTab$other$en {
  _Translations$settingsTab$other$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'دیگر';
  @override
  String get support => 'LocalSend کی حمایت کریں';
  @override
  String get donate => 'عطیہ کریں';
  @override
  String get privacyPolicy => 'رازداری کی پالیسی';
  @override
  String get termsOfUse => 'استعمال کی شرائط';
}

// Path: troubleshootPage.firewall
class _Translations$troubleshootPage$firewall$ur extends Translations$troubleshootPage$firewall$en {
  _Translations$troubleshootPage$firewall$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'یہ ایپ دیگر آلات پر فائلیں بھیج سکتی ہے لیکن دیگر آلات اس ڈیوائس پر فائلیں نہیں بھیج سکتے۔';
  @override
  String solution({required Object port}) =>
      'یہ ممکنہ طور پر فائر وال کا مسئلہ ہے۔ آپ اسے پورٹ ${port} پر آنے والے کنکشنز (UDP اور TCP) کی اجازت دے کر حل کر سکتے ہیں۔';
  @override
  String get openFirewall => 'فائر وال کھولیں';
}

// Path: troubleshootPage.noDiscovery
class _Translations$troubleshootPage$noDiscovery$ur extends Translations$troubleshootPage$noDiscovery$en {
  _Translations$troubleshootPage$noDiscovery$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'یہ آلہ دوسرے آلات کو دریافت نہیں کر سکتا۔';
  @override
  String get solution =>
      'براہ کرم یقینی بنائیں کہ تمام آلات ایک ہی وائی فائی نیٹ ورک پر ہیں اور ایک ہی ترتیب (پورٹ، ملٹی کاسٹ ایڈریس، انکرپشن) شیئر کرتے ہیں۔ آپ ہدف والے آلے کا IP پتہ دستی طور پر ٹائپ کرنے کی کوشش کر سکتے ہیں۔ اگر یہ کام کرتا ہے، تو اس آلے کو پسندیدہ میں شامل کرنے پر غور کریں تاکہ مستقبل میں اسے خود بخود دریافت کیا جا سکے۔';
}

// Path: troubleshootPage.noConnection
class _Translations$troubleshootPage$noConnection$ur extends Translations$troubleshootPage$noConnection$en {
  _Translations$troubleshootPage$noConnection$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'دونوں آلات ایک دوسرے کو دریافت نہیں کرسکتے ہیں اور نہ ہی وہ فائلوں کا اشتراک کرسکتے ہیں۔';
  @override
  String get solution =>
      'مسئلہ دونوں طرف موجود ہے؟ پھر آپ کو یہ یقینی بنانا ہوگا کہ دونوں ڈیوائسز ایک ہی وائی فائی نیٹ ورک میں ہیں اور ایک ہی کنفیگریشن (پورٹ، ملٹی کاسٹ ایڈریس، انکرپشن) کا اشتراک کرتے ہیں۔ وائی فائی شرکاء کے درمیان مواصلت کی اجازت نہیں دے سکتا ہے۔ اس صورت میں، یہ اختیار روٹر پر فعال ہونا ضروری ہے.';
}

// Path: receiveHistoryPage.entryActions
class _Translations$receiveHistoryPage$entryActions$ur extends Translations$receiveHistoryPage$entryActions$en {
  _Translations$receiveHistoryPage$entryActions$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get open => 'فائل کھولو';
  @override
  String get showInFolder => 'فولڈر میں دکھائیں';
  @override
  String get info => 'معلومات';
  @override
  String get deleteFromHistory => 'تاریخ سے حذف کریں';
}

// Path: deviceDetailsPage.info
class _Translations$deviceDetailsPage$info$ur extends Translations$deviceDetailsPage$info$en {
  _Translations$deviceDetailsPage$info$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get name => 'نام';
  @override
  String get address => 'پتہ';
  @override
  String get version => 'ورژن';
  @override
  String protocol({required Object version}) => 'پروٹوکول v${version}';
}

// Path: deviceDetailsPage.logs
class _Translations$deviceDetailsPage$logs$ur extends Translations$deviceDetailsPage$logs$en {
  _Translations$deviceDetailsPage$logs$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'لاگز';
  @override
  String get empty => 'کوئی لاگ دستیاب نہیں۔';
  @override
  String discovered({required Object protocol, required Object host}) => '${protocol} کے ذریعے دریافت ہوا (${host})';
  @override
  String updated({required Object protocol, required Object host}) => '${protocol} کے ذریعے اپ ڈیٹ ہوا (${host})';
}

// Path: progressPage.checksum
class _Translations$progressPage$checksum$ur extends Translations$progressPage$checksum$en {
  _Translations$progressPage$checksum$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get verified => 'چیک سمز کی تصدیق ہو گئی';
  @override
  String partiallyVerified({required Object curr, required Object n}) => '${curr} / ${n} فائلوں کی چیک سم کی تصدیق ہو گئی';
  @override
  String get notVerifiable => 'بھیجنے والے نے چیک سم فراہم نہیں کیے';
  @override
  String get disabled => 'چیک سم کی تصدیق بند ہے';
  @override
  String attached({required Object curr, required Object n}) => 'چیک سم منسلک کر دیے گئے (${curr} / ${n} فائلیں)';
}

// Path: progressPage.total
class _Translations$progressPage$total$ur extends Translations$progressPage$total$en {
  _Translations$progressPage$total$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$progressPage$total$title$ur title = _Translations$progressPage$total$title$ur._(_root);
  @override
  String count({required Object curr, required Object n}) => 'فائلوں: ${curr} / ${n}';
  @override
  String size({required Object curr, required Object n}) => 'سائز: ${curr} / ${n}';
  @override
  String speed({required Object speed}) => 'رفتار: ${speed}/s';
}

// Path: progressPage.remainingTime
class _Translations$progressPage$remainingTime$ur extends Translations$progressPage$remainingTime$en {
  _Translations$progressPage$remainingTime$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String minutesUnit({required num m}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ur'))(
    m,
    other: '${m}م',
  );
  @override
  String hoursUnit({required num h}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ur'))(
    h,
    other: '${h}گھ',
  );
  @override
  String minutes({required Object m, required Object ss}) => '${m}:${ss}';
  @override
  String hours({required num h, required num m}) =>
      '${_root.progressPage.remainingTime.hoursUnit(h: h)} ${_root.progressPage.remainingTime.minutesUnit(m: m)}';
}

// Path: whatsNewPage.changes
class _Translations$whatsNewPage$changes$ur extends Translations$whatsNewPage$changes$en {
  _Translations$whatsNewPage$changes$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$whatsNewPage$changes$v1_18_0$ur v1_18_0 = _Translations$whatsNewPage$changes$v1_18_0$ur._(_root);
}

// Path: dialogs.addFile
class _Translations$dialogs$addFile$ur extends Translations$dialogs$addFile$en {
  _Translations$dialogs$addFile$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'انتخاب میں شامل کریں';
  @override
  String get content => 'آپ کیا شامل کرنا چاہتے ہیں؟';
}

// Path: dialogs.openFile
class _Translations$dialogs$openFile$ur extends Translations$dialogs$openFile$en {
  _Translations$dialogs$openFile$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'فائل کھولیں';
  @override
  String get content => 'کیا آپ موصولہ فائل کھولنا چاہتے ہیں؟';
}

// Path: dialogs.addressInput
class _Translations$dialogs$addressInput$ur extends Translations$dialogs$addressInput$en {
  _Translations$dialogs$addressInput$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'پتہ درج کریں۔';
  @override
  String get hashtag => 'Hashtag';
  @override
  String get ip => 'اپ ایڈریس';
  @override
  String get recentlyUsed => 'حال ہی میں استعمال ہوا:';
  @override
  String get noHashtagCandidates =>
      'موجودہ نیٹ ورک کا کوئی IPv4 ایڈریس نہیں ہے، اس لیے ہیش ٹیگ کو امیدوار ایڈریس میں نہیں بدلا جا سکتا۔ براہ کرم مکمل ایڈریس درج کریں (مثلاً 192.168.1.5 یا fe80::1)۔';
  @override
  late final _Translations$dialogs$addressInput$validation$ur validation = _Translations$dialogs$addressInput$validation$ur._(_root);
}

// Path: dialogs.cancelSession
class _Translations$dialogs$cancelSession$ur extends Translations$dialogs$cancelSession$en {
  _Translations$dialogs$cancelSession$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'فائل ٹرانسفر منسوخ کریں۔';
  @override
  String get content => 'کیا آپ واقعی فائل ٹرانسفر کو منسوخ کرنا چاہتے ہیں؟';
}

// Path: dialogs.connectionError
class _Translations$dialogs$connectionError$ur extends Translations$dialogs$connectionError$en {
  _Translations$dialogs$connectionError$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'کنکشن ناکام ہوا';
  @override
  late final _Translations$dialogs$connectionError$timeout$ur timeout = _Translations$dialogs$connectionError$timeout$ur._(_root);
  @override
  late final _Translations$dialogs$connectionError$refused$ur refused = _Translations$dialogs$connectionError$refused$ur._(_root);
  @override
  late final _Translations$dialogs$connectionError$forbidden$ur forbidden = _Translations$dialogs$connectionError$forbidden$ur._(_root);
  @override
  late final _Translations$dialogs$connectionError$other$ur other = _Translations$dialogs$connectionError$other$ur._(_root);
  @override
  String get retry => 'دوبارہ کوشش کریں';
  @override
  String get details => 'خرابی کی تفصیلات:';
}

// Path: dialogs.deleteSourceAfterSendDialog
class _Translations$dialogs$deleteSourceAfterSendDialog$ur extends Translations$dialogs$deleteSourceAfterSendDialog$en {
  _Translations$dialogs$deleteSourceAfterSendDialog$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'سورس فائلیں حذف کریں';
  @override
  String get content => 'فائلوں کے کامیابی سے بھیجے جانے کے بعد وہ اس ڈیوائس سے حذف کر دی جائیں گی۔ یہ عمل واپس نہیں کیا جا سکتا۔';
}

// Path: dialogs.cannotOpenFile
class _Translations$dialogs$cannotOpenFile$ur extends Translations$dialogs$cannotOpenFile$en {
  _Translations$dialogs$cannotOpenFile$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'فائل نہیں کھل سکی';
  @override
  String content({required Object file}) => '"${file}" کھول نہیں سکتا۔ کیا یہ فائل منتقل ہوگئی ہے، نام تبدیل ہوگیا ہے یا حذف ہوگئی ہے؟';
}

// Path: dialogs.encryptionDisabledNotice
class _Translations$dialogs$encryptionDisabledNotice$ur extends Translations$dialogs$encryptionDisabledNotice$en {
  _Translations$dialogs$encryptionDisabledNotice$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Encryption disabled';
  @override
  String get content => 'Communication now takes place via the unencrypted HTTP protocol. To use HTTPS, enable encryption again.';
}

// Path: dialogs.errorDialog
class _Translations$dialogs$errorDialog$ur extends Translations$dialogs$errorDialog$en {
  _Translations$dialogs$errorDialog$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.error;
}

// Path: dialogs.favoriteDialog
class _Translations$dialogs$favoriteDialog$ur extends Translations$dialogs$favoriteDialog$en {
  _Translations$dialogs$favoriteDialog$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'پسندیدہ';
  @override
  String get noFavorites => 'ابھی تک کوئی پسندیدہ آلات نہیں ہیں۔';
  @override
  String get addFavorite => 'شامل کریں';
}

// Path: dialogs.favoriteDeleteDialog
class _Translations$dialogs$favoriteDeleteDialog$ur extends Translations$dialogs$favoriteDeleteDialog$en {
  _Translations$dialogs$favoriteDeleteDialog$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'پسندیدہ سے حذف کریں';
  @override
  String content({required Object name}) => 'کیا آپ واقعی "${name}" کو پسندیدہ سے حذف کرنا چاہتے ہیں؟';
}

// Path: dialogs.favoriteEditDialog
class _Translations$dialogs$favoriteEditDialog$ur extends Translations$dialogs$favoriteEditDialog$en {
  _Translations$dialogs$favoriteEditDialog$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get titleAdd => 'پسندیدہ میں شامل کریں';
  @override
  String get titleEdit => 'ترتیبات';
  @override
  String get name => 'آلے کا نام';
  @override
  String get auto => '(خودکار)';
  @override
  String get ip => 'IP پتہ';
  @override
  String get port => 'پورٹ';
}

// Path: dialogs.fileInfo
class _Translations$dialogs$fileInfo$ur extends Translations$dialogs$fileInfo$en {
  _Translations$dialogs$fileInfo$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'فائل کی معلومات';
  @override
  String get fileName => 'فائل کا نام:';
  @override
  String get path => 'راستہ:';
  @override
  String get size => 'سائز:';
  @override
  String get sender => 'بھیجنے والا:';
  @override
  String get time => 'وقت:';
}

// Path: dialogs.fileNameInput
class _Translations$dialogs$fileNameInput$ur extends Translations$dialogs$fileNameInput$en {
  _Translations$dialogs$fileNameInput$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'فائل کا نام درج کریں۔';
  @override
  String original({required Object original}) => 'اصل: ${original}';
}

// Path: dialogs.historyClearDialog
class _Translations$dialogs$historyClearDialog$ur extends Translations$dialogs$historyClearDialog$en {
  _Translations$dialogs$historyClearDialog$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'تاریخ صاف کریں';
  @override
  String get content => 'کیا آپ واقعی پوری تاریخ حذف کرنا چاہتے ہیں؟';
}

// Path: dialogs.localNetworkUnauthorized
class _Translations$dialogs$localNetworkUnauthorized$ur extends Translations$dialogs$localNetworkUnauthorized$en {
  _Translations$dialogs$localNetworkUnauthorized$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.dialogs.noPermission.title;
  @override
  String get description =>
      'لوکل نیٹ ورک کا سکین کرنے کی اجازت کے بغیر LocalSend، دیگر ڈیوائسز تلاش نہیں کرسکتا ہے۔ براہ کرم ترتیبات میں اس اجازت کو منظور کریں۔';
  @override
  String get gotoSettings => 'ترتیبات';
}

// Path: dialogs.messageInput
class _Translations$dialogs$messageInput$ur extends Translations$dialogs$messageInput$en {
  _Translations$dialogs$messageInput$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'پیغام ٹائپ کریں۔';
  @override
  String get multiline => 'ملٹی لائن';
}

// Path: dialogs.noFiles
class _Translations$dialogs$noFiles$ur extends Translations$dialogs$noFiles$en {
  _Translations$dialogs$noFiles$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'کوئی فائل منتخب نہیں کی گئی';
  @override
  String get content => 'براہ کرم کم از کم ایک فائل منتخب کریں۔';
}

// Path: dialogs.noPermission
class _Translations$dialogs$noPermission$ur extends Translations$dialogs$noPermission$en {
  _Translations$dialogs$noPermission$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'اجازت نہیں';
  @override
  String get content => 'آپ نے ضروری اجازتیں فراہم نہیں کی ہیں۔ براہ کرم انہیں ترتیبات میں فراہم کریں۔';
}

// Path: dialogs.notAvailableOnPlatform
class _Translations$dialogs$notAvailableOnPlatform$ur extends Translations$dialogs$notAvailableOnPlatform$en {
  _Translations$dialogs$notAvailableOnPlatform$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'دستیاب نہیں';
  @override
  String get content => 'یہ خصوصیت صرف یہاں دستیاب ہے:';
}

// Path: dialogs.qr
class _Translations$dialogs$qr$ur extends Translations$dialogs$qr$en {
  _Translations$dialogs$qr$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'QR کوڈ';
}

// Path: dialogs.quickActions
class _Translations$dialogs$quickActions$ur extends Translations$dialogs$quickActions$en {
  _Translations$dialogs$quickActions$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'فوری اقدامات';
  @override
  String get counter => 'کاؤنٹر';
  @override
  String get prefix => 'سابقہ';
  @override
  String get padZero => 'زیرو کے ساتھ پیڈ';
  @override
  String get sortBeforeCount => 'پہلے سے حروف تہجی کے مطابق ترتیب دیں۔';
  @override
  String get random => 'بے ترتیب';
}

// Path: dialogs.quickSaveNotice
class _Translations$dialogs$quickSaveNotice$ur extends Translations$dialogs$quickSaveNotice$en {
  _Translations$dialogs$quickSaveNotice$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSave;
  @override
  String get content => 'فائل کی درخواستیں خود بخود قبول ہو جاتی ہیں۔ آگاہ رہیں کہ مقامی نیٹ ورک میں موجود ہر کوئی آپ کو فائلیں بھیج سکتا ہے۔';
}

// Path: dialogs.quickSaveFromFavoritesNotice
class _Translations$dialogs$quickSaveFromFavoritesNotice$ur extends Translations$dialogs$quickSaveFromFavoritesNotice$en {
  _Translations$dialogs$quickSaveFromFavoritesNotice$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSaveFromFavorites;
  @override
  List<String> get content => [
    'آپ کی پسندیدہ فہرست میں شامل آلات کی فائل درخواستیں اب خودکار طور پر قبول کی جاتی ہیں۔',
  ];
}

// Path: dialogs.pin
class _Translations$dialogs$pin$ur extends Translations$dialogs$pin$en {
  _Translations$dialogs$pin$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'PIN درج کریں';
}

// Path: dialogs.sendModeHelp
class _Translations$dialogs$sendModeHelp$ur extends Translations$dialogs$sendModeHelp$en {
  _Translations$dialogs$sendModeHelp$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'بھیجنے کے انداز';
  @override
  String get single => 'ایک ریسیور کو فائل بھیجتا ہے۔ بھیجتے وقت سلیکشن ختم ہوجائیگا۔';
  @override
  String get multiple => 'اکثر متعدد ریسیورز کو فائل بھیجتا ہے۔ سلیکشن ختم نہیں ہوگا۔';
  @override
  String get link => 'LocalSend نصب نہیں ہونے والے رسیورز منتخب شدہ فائلز کو لنک اپنے براؤزر میں کھولنے سے ڈاؤن لوڈ کر سکتے ہیں۔';
}

// Path: dialogs.startupError
class _Translations$dialogs$startupError$ur extends Translations$dialogs$startupError$en {
  _Translations$dialogs$startupError$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'سرور شروع نہیں ہو سکا';
  @override
  String port({required Object port}) => 'پورٹ: ${port}';
  @override
  late final _Translations$dialogs$startupError$windowsAccessDenied$ur windowsAccessDenied =
      _Translations$dialogs$startupError$windowsAccessDenied$ur._(_root);
  @override
  late final _Translations$dialogs$startupError$addressInUse$ur addressInUse = _Translations$dialogs$startupError$addressInUse$ur._(_root);
  @override
  late final _Translations$dialogs$startupError$generic$ur generic = _Translations$dialogs$startupError$generic$ur._(_root);
  @override
  String get details => 'خرابی کی تفصیلات:';
  @override
  String get copyDetails => 'تفصیلات کاپی کریں';
  @override
  String get openSettings => 'ترتیبات کھولیں';
}

// Path: dialogs.zoom
class _Translations$dialogs$zoom$ur extends Translations$dialogs$zoom$en {
  _Translations$dialogs$zoom$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'URL';
}

// Path: sendTab.diagnosis.noInterface
class _Translations$sendTab$diagnosis$noInterface$ur extends Translations$sendTab$diagnosis$noInterface$en {
  _Translations$sendTab$diagnosis$noInterface$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'نیٹ ورک کنکشن نہیں ہے';
  @override
  String get advice => 'یہ ڈیوائس کسی نیٹ ورک سے منسلک نہیں ہے۔ اس ڈیوائس کا وائی فائی یا کیبل کنکشن چیک کریں۔';
}

// Path: sendTab.diagnosis.multicastUnavailable
class _Translations$sendTab$diagnosis$multicastUnavailable$ur extends Translations$sendTab$diagnosis$multicastUnavailable$en {
  _Translations$sendTab$diagnosis$multicastUnavailable$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ملٹی کاسٹ دستیاب نہیں ہے';
  @override
  String advice({required Object port}) =>
      'LocalSend اس نیٹ ورک پر ملٹی کاسٹ دریافت استعمال نہیں کر سکتا۔ یقینی بنائیں کہ دونوں ڈیوائسز ایک ہی نیٹ ورک پر ہیں اور AP آئسولیشن یا فائر وال UDP پورٹ ${port} کو مسدود نہیں کر رہا۔';
  @override
  String reason({required Object reason}) => 'وجہ: ${reason}';
}

// Path: sendTab.diagnosis.scanNoResult
class _Translations$sendTab$diagnosis$scanNoResult$ur extends Translations$sendTab$diagnosis$scanNoResult$en {
  _Translations$sendTab$diagnosis$scanNoResult$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'کوئی ڈیوائس نہیں ملی';
  @override
  String get advice =>
      'دریافت کام کر رہی ہے، لیکن کسی ڈیوائس نے اعلانات یا نیٹ ورک سکین کا جواب نہیں دیا۔ ہو سکتا ہے دوسری ڈیوائس آف لائن ہو، سلیپ موڈ میں ہو یا فائر وال کی وجہ سے مسدود ہو۔ یقینی بنائیں کہ LocalSend دوسری ڈیوائس پر چل رہا ہے۔';
  @override
  String detail({required Object announcements, required Object scans}) =>
      '${announcements} اعلانات اور ${scans} نیٹ ورک سکین جواب ملے بغیر بھیجے گئے۔';
}

// Path: sendTab.diagnosis.manualFallback
class _Translations$sendTab$diagnosis$manualFallback$ur extends Translations$sendTab$diagnosis$manualFallback$en {
  _Translations$sendTab$diagnosis$manualFallback$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get message =>
      'IP ایڈریسز اکثر تبدیل ہوتے رہتے ہیں۔ فہرست میں شامل نہ ہونے والی ڈیوائس تک آپ پھر بھی پہنچ سکتے ہیں: اسے پسندیدہ میں شامل کریں یا اس کا پتہ دستی طور پر درج کریں۔';
  @override
  String get openFavorites => 'پسندیدہ کھولیں';
  @override
  String get manualInput => 'پتہ دستی طور پر درج کریں';
}

// Path: settingsTab.general.brightnessOptions
class _Translations$settingsTab$general$brightnessOptions$ur extends Translations$settingsTab$general$brightnessOptions$en {
  _Translations$settingsTab$general$brightnessOptions$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'سسٹم';
  @override
  String get dark => 'اندھیرا';
  @override
  String get light => 'روشنی';
}

// Path: settingsTab.general.colorOptions
class _Translations$settingsTab$general$colorOptions$ur extends Translations$settingsTab$general$colorOptions$en {
  _Translations$settingsTab$general$colorOptions$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'نظام';
  @override
  String get oled => 'OLED';
  @override
  String get custom => 'حسب ضرورت';
}

// Path: settingsTab.general.languageOptions
class _Translations$settingsTab$general$languageOptions$ur extends Translations$settingsTab$general$languageOptions$en {
  _Translations$settingsTab$general$languageOptions$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'سسٹم';
}

// Path: settingsTab.network.networkOptions
class _Translations$settingsTab$network$networkOptions$ur extends Translations$settingsTab$network$networkOptions$en {
  _Translations$settingsTab$network$networkOptions$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'تمام';
  @override
  String get filtered => 'فلٹر کیا گیا';
}

// Path: progressPage.total.title
class _Translations$progressPage$total$title$ur extends Translations$progressPage$total$title$en {
  _Translations$progressPage$total$title$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String sending({required Object time}) => 'کل پیش رفت (${time})';
  @override
  String get finishedError => 'غلطی کے ساتھ ختم';
  @override
  String get canceledSender => 'بھیجنے والے کے ذریعے منسوخ کر دیا گیا';
  @override
  String get canceledReceiver => 'وصول کنندہ کے ذریعے منسوخ کر دیا گیا';
}

// Path: whatsNewPage.changes.v1_18_0
class _Translations$whatsNewPage$changes$v1_18_0$ur extends Translations$whatsNewPage$changes$v1_18_0$en with WhatsNewStrings {
  _Translations$whatsNewPage$changes$v1_18_0$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  List<String> get changes => [
    'خفیہ کاری اب منتقلی کو سست نہیں کرتی۔ اگر آپ نے اسے پہلے بند کیا تھا تو اس آلے پر اسے دوبارہ فعال کر دیا گیا ہے۔',
    'پسندیدہ آلات کی درخواستیں اب خودکار طور پر قبول کی جاتی ہیں۔ یہ طے شدہ طور پر فعال ہے اور ترتیبات میں غیر فعال کیا جا سکتا ہے۔',
    'Android پر، منتقلی جاری رہتی ہے جب ایپ پس منظر میں ہو یا اسکرین بند ہو۔ iOS پر، ایپ کو اب بھی پیش منظر میں رہنا ہوگا۔',
  ];
}

// Path: dialogs.addressInput.validation
class _Translations$dialogs$addressInput$validation$ur extends Translations$dialogs$addressInput$validation$en {
  _Translations$dialogs$addressInput$validation$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get invalid => 'درست IPv4 ایڈریس، IPv6 ایڈریس یا ہوسٹ نام درج کریں۔';
  @override
  String get scheme => 'صرف ایڈریس درج کریں، "http://" یا "https://" کے بغیر۔';
  @override
  String get port => 'صرف ایڈریس درج کریں۔ پورٹ ترتیبات سے لی جاتی ہے۔';
}

// Path: dialogs.connectionError.timeout
class _Translations$dialogs$connectionError$timeout$ur extends Translations$dialogs$connectionError$timeout$en {
  _Translations$dialogs$connectionError$timeout$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'ڈیوائس نے وقت میں جواب نہیں دیا۔';
  @override
  String get advice =>
      'غالباً وہ آف لائن ہے، سلیپ موڈ میں ہے، یا فائر وال کنکشن روک رہا ہے۔ یقینی بنائیں کہ LocalSend دوسری ڈیوائس پر چل رہا ہے اور دونوں ڈیوائسز ایک ہی نیٹ ورک پر ہیں۔';
}

// Path: dialogs.connectionError.refused
class _Translations$dialogs$connectionError$refused$ur extends Translations$dialogs$connectionError$refused$en {
  _Translations$dialogs$connectionError$refused$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'ڈیوائس نے کنکشن مسترد کر دیا۔';
  @override
  String get advice =>
      'معلوم ہوتا ہے LocalSend ہدف ڈیوائس پر چل نہیں رہا، یا وہ کسی اور پورٹ پر سن رہا ہے۔ LocalSend کو دوسری ڈیوائس پر چالو کریں یا پورٹ چیک کریں۔';
}

// Path: dialogs.connectionError.forbidden
class _Translations$dialogs$connectionError$forbidden$ur extends Translations$dialogs$connectionError$forbidden$en {
  _Translations$dialogs$connectionError$forbidden$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'ڈیوائس نے درخواست مسترد کر دی۔';
  @override
  String get advice => 'ہو سکتا ہے PIN درکار ہو، یا ڈیوائس کے ساتھ پیرنگ بدل گئی ہو۔ ہدف ڈیوائس پر PIN اور فوری محفوظ کرنے کی ترتیبات چیک کریں۔';
}

// Path: dialogs.connectionError.other
class _Translations$dialogs$connectionError$other$ur extends Translations$dialogs$connectionError$other$en {
  _Translations$dialogs$connectionError$other$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'کنکشن قائم نہیں ہو سکا۔';
  @override
  String get advice => 'ایڈریس اور پورٹ چیک کریں، یقینی بنائیں کہ LocalSend ہدف ڈیوائس پر چل رہا ہے، اور کوئی فائر وال یا VPN کنکشن روک نہیں رہا۔';
}

// Path: dialogs.startupError.windowsAccessDenied
class _Translations$dialogs$startupError$windowsAccessDenied$ur extends Translations$dialogs$startupError$windowsAccessDenied$en {
  _Translations$dialogs$startupError$windowsAccessDenied$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'ونڈوز نے پورٹ تک رسائی سے انکار کر دیا (ساکٹ خرابی 10013)۔';
  @override
  String get advice =>
      'یہ عموماً Hyper-V، WSL یا Docker کے ریزرو کردہ پورٹ رینج، یا خراب Winsock کیٹلاگ کی وجہ سے ہوتا ہے:\n• ترتیبات (نیٹ ورک) میں پورٹ تبدیل کریں\n• ریزرو شدہ رینجز اس کمانڈ سے چیک کریں: netsh interface ipv4 show excludedportrange protocol=tcp\n• بطور ایڈمنسٹریٹر Winsock اس کمانڈ سے مرمت کریں: netsh winsock reset (بعد میں کمپیوٹر دوبارہ چالو کریں)';
}

// Path: dialogs.startupError.addressInUse
class _Translations$dialogs$startupError$addressInUse$ur extends Translations$dialogs$startupError$addressInUse$en {
  _Translations$dialogs$startupError$addressInUse$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'یہ پورٹ پہلے ہی کسی اور ایپلیکیشن کے زیرِ استعمال ہے۔';
  @override
  String get advice =>
      'کوئی اور پروگرام (یا LocalSend کی دوسری کاپی) اس پورٹ پر سن رہا ہے:\n• دوسری ایپلیکیشن بند کریں، یا\n• ترتیبات (نیٹ ورک) میں پورٹ تبدیل کریں';
}

// Path: dialogs.startupError.generic
class _Translations$dialogs$startupError$generic$ur extends Translations$dialogs$startupError$generic$en {
  _Translations$dialogs$startupError$generic$ur._(TranslationsUr root) : this._root = root, super.internal(root);

  final TranslationsUr _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'سرور شروع نہیں ہو سکا۔';
  @override
  String get advice => '• اپنے فائر وال اور نیٹ ورک کی ترتیبات چیک کریں\n• ترتیبات (نیٹ ورک) میں پورٹ تبدیل کرنے کی کوشش کریں';
}
