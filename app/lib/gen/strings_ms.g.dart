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
class TranslationsMs extends Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsMs({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.ms,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <ms>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  late final TranslationsMs _root = this; // ignore: unused_field

  @override
  TranslationsMs $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsMs(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'LocalSend';
  @override
  late final _Translations$general$ms general = _Translations$general$ms._(_root);
  @override
  late final _Translations$receiveTab$ms receiveTab = _Translations$receiveTab$ms._(_root);
  @override
  late final _Translations$sendTab$ms sendTab = _Translations$sendTab$ms._(_root);
  @override
  late final _Translations$settingsTab$ms settingsTab = _Translations$settingsTab$ms._(_root);
  @override
  late final _Translations$troubleshootPage$ms troubleshootPage = _Translations$troubleshootPage$ms._(_root);
  @override
  late final _Translations$networkInterfacesPage$ms networkInterfacesPage = _Translations$networkInterfacesPage$ms._(_root);
  @override
  late final _Translations$receiveHistoryPage$ms receiveHistoryPage = _Translations$receiveHistoryPage$ms._(_root);
  @override
  late final _Translations$apkPickerPage$ms apkPickerPage = _Translations$apkPickerPage$ms._(_root);
  @override
  late final _Translations$selectedFilesPage$ms selectedFilesPage = _Translations$selectedFilesPage$ms._(_root);
  @override
  late final _Translations$deviceDetailsPage$ms deviceDetailsPage = _Translations$deviceDetailsPage$ms._(_root);
  @override
  late final _Translations$verifyPage$ms verifyPage = _Translations$verifyPage$ms._(_root);
  @override
  late final _Translations$receivePage$ms receivePage = _Translations$receivePage$ms._(_root);
  @override
  late final _Translations$receiveOptionsPage$ms receiveOptionsPage = _Translations$receiveOptionsPage$ms._(_root);
  @override
  late final _Translations$sendPage$ms sendPage = _Translations$sendPage$ms._(_root);
  @override
  late final _Translations$progressPage$ms progressPage = _Translations$progressPage$ms._(_root);
  @override
  late final _Translations$webSharePage$ms webSharePage = _Translations$webSharePage$ms._(_root);
  @override
  late final _Translations$webReceivePage$ms webReceivePage = _Translations$webReceivePage$ms._(_root);
  @override
  late final _Translations$aboutPage$ms aboutPage = _Translations$aboutPage$ms._(_root);
  @override
  late final _Translations$donationPage$ms donationPage = _Translations$donationPage$ms._(_root);
  @override
  late final _Translations$changelogPage$ms changelogPage = _Translations$changelogPage$ms._(_root);
  @override
  late final _Translations$whatsNewPage$ms whatsNewPage = _Translations$whatsNewPage$ms._(_root);
  @override
  late final _Translations$aliasGenerator$ms aliasGenerator = _Translations$aliasGenerator$ms._(_root);
  @override
  late final _Translations$dialogs$ms dialogs = _Translations$dialogs$ms._(_root);
  @override
  late final _Translations$sanitization$ms sanitization = _Translations$sanitization$ms._(_root);
  @override
  late final _Translations$tray$ms tray = _Translations$tray$ms._(_root);
  @override
  late final _Translations$web$ms web = _Translations$web$ms._(_root);
  @override
  late final _Translations$assetPicker$ms assetPicker = _Translations$assetPicker$ms._(_root);
}

// Path: general
class _Translations$general$ms extends Translations$general$en {
  _Translations$general$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get accept => 'Terima';
  @override
  String get accepted => 'Diterima';
  @override
  String get add => 'Tambah';
  @override
  String get advanced => 'Lanjutan';
  @override
  String get cancel => 'Batal';
  @override
  String get close => 'Tutup';
  @override
  String get confirm => 'Sahkan';
  @override
  String get continueStr => 'Teruskan';
  @override
  String get copy => 'Salin';
  @override
  String get copiedToClipboard => 'Disalin ke Papan Keratan';
  @override
  String get decline => 'Tolak';
  @override
  String get done => 'Selesai';
  @override
  String get delete => 'Padam';
  @override
  String get edit => 'Sunting';
  @override
  String get error => 'Ralat';
  @override
  String get example => 'Contoh';
  @override
  String get files => 'Fail-fail';
  @override
  String get finished => 'Telah selesai';
  @override
  String get hide => 'Sembunyi';
  @override
  String get off => 'Tutup';
  @override
  String get offline => 'Luar talian';
  @override
  String get on => 'Buka';
  @override
  String get online => 'Dalam talian';
  @override
  String get open => 'Buka';
  @override
  String get queue => 'Baris gilir';
  @override
  String get quickSave => 'Simpan Pantas';
  @override
  String get quickSaveFromFavorites => 'Simpan Pantas untuk "Kegemaran"';
  @override
  String get renamed => 'Dinamakan semula';
  @override
  String get reset => 'Buat asal perubahan';
  @override
  String get restart => 'Mula semula';
  @override
  String get settings => 'Tetapan';
  @override
  String get skipped => 'Dilangkau';
  @override
  String get start => 'Mula';
  @override
  String get stop => 'Henti';
  @override
  String get save => 'Simpan';
  @override
  String get unchanged => 'Tidak berubah';
  @override
  String get unknown => 'Tidak diketahui';
  @override
  String get noItemInClipboard => 'Tiada item dalam papan keratan.';
}

// Path: receiveTab
class _Translations$receiveTab$ms extends Translations$receiveTab$en {
  _Translations$receiveTab$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Terima';
  @override
  late final _Translations$receiveTab$infoBox$ms infoBox = _Translations$receiveTab$infoBox$ms._(_root);
  @override
  late final _Translations$receiveTab$quickSave$ms quickSave = _Translations$receiveTab$quickSave$ms._(_root);
  @override
  String get link => 'Terima melalui pautan';
}

// Path: sendTab
class _Translations$sendTab$ms extends Translations$sendTab$en {
  _Translations$sendTab$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Hantar';
  @override
  late final _Translations$sendTab$selection$ms selection = _Translations$sendTab$selection$ms._(_root);
  @override
  late final _Translations$sendTab$picker$ms picker = _Translations$sendTab$picker$ms._(_root);
  @override
  String get shareIntentInfo => 'Anda juga boleh menggunakan ciri "Kongsi" peranti mudah alih anda untuk memilih fail dengan lebih mudah.';
  @override
  String get nearbyDevices => 'Peranti berdekatan';
  @override
  String get thisDevice => 'Peranti Ini';
  @override
  String get scan => 'Cari peranti';
  @override
  String get manualSending => 'Penghantaran manual';
  @override
  String get sendMode => 'Mod penghantaran';
  @override
  late final _Translations$sendTab$sendModes$ms sendModes = _Translations$sendTab$sendModes$ms._(_root);
  @override
  String get sendModeHelp => 'Penerangan';
  @override
  String get help => 'Sila pastikan sasaran yang diingini juga berada dalam rangkaian Wi-Fi yang sama.';
  @override
  String get placeItems => 'Letakkan item untuk dikongsi.';
  @override
  late final _Translations$sendTab$diagnosis$ms diagnosis = _Translations$sendTab$diagnosis$ms._(_root);
}

// Path: settingsTab
class _Translations$settingsTab$ms extends Translations$settingsTab$en {
  _Translations$settingsTab$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tetapan';
  @override
  late final _Translations$settingsTab$general$ms general = _Translations$settingsTab$general$ms._(_root);
  @override
  late final _Translations$settingsTab$receive$ms receive = _Translations$settingsTab$receive$ms._(_root);
  @override
  late final _Translations$settingsTab$send$ms send = _Translations$settingsTab$send$ms._(_root);
  @override
  late final _Translations$settingsTab$network$ms network = _Translations$settingsTab$network$ms._(_root);
  @override
  late final _Translations$settingsTab$other$ms other = _Translations$settingsTab$other$ms._(_root);
  @override
  String get advancedSettings => 'Tetapan lanjutan';
}

// Path: troubleshootPage
class _Translations$troubleshootPage$ms extends Translations$troubleshootPage$en {
  _Translations$troubleshootPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Penyelesaian masalah';
  @override
  String get subTitle => 'Aplikasi ini tidak berfungsi seperti yang diharapkan? Di sini anda boleh mencari penyelesaian umum.';
  @override
  String get solution => 'Penyelesaian:';
  @override
  String get fixButton => 'Baiki secara automatik';
  @override
  late final _Translations$troubleshootPage$firewall$ms firewall = _Translations$troubleshootPage$firewall$ms._(_root);
  @override
  late final _Translations$troubleshootPage$noDiscovery$ms noDiscovery = _Translations$troubleshootPage$noDiscovery$ms._(_root);
  @override
  late final _Translations$troubleshootPage$noConnection$ms noConnection = _Translations$troubleshootPage$noConnection$ms._(_root);
}

// Path: networkInterfacesPage
class _Translations$networkInterfacesPage$ms extends Translations$networkInterfacesPage$en {
  _Translations$networkInterfacesPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Antara Muka Rangkaian';
  @override
  String get info =>
      'Secara lalai, LocalSend menggunakan semua antara muka rangkaian tersedia. Anda boleh memulaukan rangkaian yang tidak diingini. Anda perlu mula semula pelayan untuk mengenakan perubahan.';
  @override
  String get preview => 'Pratonton';
  @override
  String get whitelist => 'Senarai Putih';
  @override
  String get blacklist => 'Senarai Hitam';
}

// Path: receiveHistoryPage
class _Translations$receiveHistoryPage$ms extends Translations$receiveHistoryPage$en {
  _Translations$receiveHistoryPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Sejarah';
  @override
  String get openFolder => 'Buka folder';
  @override
  String get deleteHistory => 'Padam sejarah';
  @override
  String get empty => 'Sejarah kosong.';
  @override
  late final _Translations$receiveHistoryPage$entryActions$ms entryActions = _Translations$receiveHistoryPage$entryActions$ms._(_root);
}

// Path: apkPickerPage
class _Translations$apkPickerPage$ms extends Translations$apkPickerPage$en {
  _Translations$apkPickerPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Aplikasi (APK)';
  @override
  String get excludeSystemApps => 'Kecualikan aplikasi sistem';
  @override
  String get excludeAppsWithoutLaunchIntent => 'Kecualikan aplikasi yang tidak boleh dilancarkan';
  @override
  String apps({required Object n}) => '${n} Aplikasi';
}

// Path: selectedFilesPage
class _Translations$selectedFilesPage$ms extends Translations$selectedFilesPage$en {
  _Translations$selectedFilesPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get deleteAll => 'Padam semua';
}

// Path: deviceDetailsPage
class _Translations$deviceDetailsPage$ms extends Translations$deviceDetailsPage$en {
  _Translations$deviceDetailsPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Butiran Peranti';
  @override
  String get favorite => 'Kegemaran';
  @override
  String get verify => 'Sahkan';
  @override
  late final _Translations$deviceDetailsPage$info$ms info = _Translations$deviceDetailsPage$info$ms._(_root);
  @override
  late final _Translations$deviceDetailsPage$logs$ms logs = _Translations$deviceDetailsPage$logs$ms._(_root);
}

// Path: verifyPage
class _Translations$verifyPage$ms extends Translations$verifyPage$en {
  _Translations$verifyPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Sahkan';
  @override
  String get icons => 'Ikon';
  @override
  String get text => 'Teks';
  @override
  String get question => 'Adakah ia kelihatan sama pada peranti yang satu lagi?';
}

// Path: receivePage
class _Translations$receivePage$ms extends Translations$receivePage$en {
  _Translations$receivePage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String subTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ms'))(
    n,
    one: 'ingin menghantar fail kepada anda',
    other: 'ingin menghantar ${n} fail kepada anda',
  );
  @override
  String get subTitleMessage => 'menghantar mesej kepada anda:';
  @override
  String get subTitleLink => 'menghantar pautan kepada anda:';
  @override
  String get canceled => 'Penghantar telah membatalkan permintaan.';
}

// Path: receiveOptionsPage
class _Translations$receiveOptionsPage$ms extends Translations$receiveOptionsPage$en {
  _Translations$receiveOptionsPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Pilihan';
  @override
  String get destination => _root.settingsTab.receive.destination;
  @override
  String get appDirectory => '(folder LocalSend)';
  @override
  String get saveToGallery => _root.settingsTab.receive.saveToGallery;
  @override
  String get saveToGalleryOff => 'Dimatikan secara automatik kerana terdapat folder.';
}

// Path: sendPage
class _Translations$sendPage$ms extends Translations$sendPage$en {
  _Translations$sendPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String calculatingChecksum({required Object curr, required Object n}) => 'Mengira checksum (${curr} / ${n})';
  @override
  String get waiting => 'Menunggu respons…';
  @override
  String get rejected => 'Penerima telah menolak permintaan.';
  @override
  String get tooManyAttempts => _root.web.tooManyAttempts;
  @override
  String get busy => 'Penerima sibuk dengan permintaan lain.';
}

// Path: progressPage
class _Translations$progressPage$ms extends Translations$progressPage$en {
  _Translations$progressPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get titleSending => 'Menghantar fail';
  @override
  String get titleReceiving => 'Menerima fail';
  @override
  String get savedToGallery => 'Disimpan dalam Foto';
  @override
  late final _Translations$progressPage$checksum$ms checksum = _Translations$progressPage$checksum$ms._(_root);
  @override
  late final _Translations$progressPage$total$ms total = _Translations$progressPage$total$ms._(_root);
  @override
  late final _Translations$progressPage$remainingTime$ms remainingTime = _Translations$progressPage$remainingTime$ms._(_root);
}

// Path: webSharePage
class _Translations$webSharePage$ms extends Translations$webSharePage$en {
  _Translations$webSharePage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Kongsi melalui pautan';
  @override
  String get loading => 'Memulakan pelayan…';
  @override
  String get stopping => 'Menghentikan pelayan…';
  @override
  String get error => 'Ralat telah berlaku ketika memulakan pelayan.';
  @override
  String openLink({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ms'))(
    n,
    one: 'Buka pautan ini dalam pelayar anda:',
    other: 'Buka salah satu daripada pautan ini dalam pelayar anda:',
  );
  @override
  String get requests => 'Permintaan';
  @override
  String get noRequests => 'Tiada permintaan lagi.';
  @override
  String get encryption => _root.settingsTab.network.encryption;
  @override
  String get autoAccept => 'Terima permintaan secara automatik';
  @override
  String get requirePin => 'Memerlukan PIN';
  @override
  String pinHint({required Object pin}) => 'PIN ialah "${pin}"';
  @override
  String get encryptionHint => 'LocalSend menggunakan sijil yang ditandatangani sendiri. Anda perlu menerimanya di pelayar anda.';
  @override
  String pendingRequests({required Object n}) => 'Permintaan yang masih belum selesai: ${n}';
}

// Path: webReceivePage
class _Translations$webReceivePage$ms extends Translations$webReceivePage$en {
  _Translations$webReceivePage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Terima melalui pautan';
}

// Path: aboutPage
class _Translations$aboutPage$ms extends Translations$aboutPage$en {
  _Translations$aboutPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tentang LocalSend';
  @override
  List<String> get description => [
    'LocalSend adalah aplikasi percuma dan sumber terbuka yang membolehkan anda berkongsi fail dan mesej secara selamat dan terjamin dengan peranti berdekatan yang berada dalam rangkaian tempatan anda tanpa memerlukan sebarang sambungan internet.',
    'Aplikasi ini tersedia di Android, iOS, macOS, Windows dan Linux. Anda boleh mencari semua pilihan untuk memuat turun di laman web rasmi.',
  ];
  @override
  String get author => 'Pengarang';
  @override
  String get contributors => 'Penyumbang';
  @override
  String get packagers => 'Pembungkus';
  @override
  String get translators => 'Penterjemah';
}

// Path: donationPage
class _Translations$donationPage$ms extends Translations$donationPage$en {
  _Translations$donationPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Derma';
  @override
  String get info =>
      'LocalSend adalah percuma, sumber terbuka dan tanpa iklan. Jika anda menyukai aplikasi ini, anda boleh menyokong pembangunannya dengan derma.';
  @override
  String donate({required Object amount}) => 'Derma ${amount}';
  @override
  String get thanks => 'Terima kasih banyak!';
  @override
  String get restore => 'Pulihkan pembelian';
}

// Path: changelogPage
class _Translations$changelogPage$ms extends Translations$changelogPage$en {
  _Translations$changelogPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Log perubahan';
}

// Path: whatsNewPage
class _Translations$whatsNewPage$ms extends Translations$whatsNewPage$en {
  _Translations$whatsNewPage$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String title({required Object version}) => 'Apa yang baharu dalam ${version}';
  @override
  late final _Translations$whatsNewPage$changes$ms changes = _Translations$whatsNewPage$changes$ms._(_root);
}

// Path: aliasGenerator
class _Translations$aliasGenerator$ms extends Translations$aliasGenerator$en {
  _Translations$aliasGenerator$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  List<String> get adjectives => [
    'Comel',
    'Cantik',
    'Besar',
    'Terang',
    'Bersih',
    'Bijak',
    'Keren',
    'Menarik',
    'Licik',
    'Bersemangat',
    'Cekap',
    'Hebat',
    'Pantas',
    'Baik',
    'Segar',
    'Bagus',
    'Menakjubkan',
    'Hebat',
    'Tampan',
    'Panas',
    'Baik hati',
    'Misteri',
    'Kemas',
    'Sabar',
    'Cantik',
    'Berkuasa',
    'Kaya',
    'Rahsia',
    'Pintar',
    'Kukuh',
    'Istimewa',
    'Strategik',
    'Kuat',
    'Kemas',
    'Bijaksana',
  ];
  @override
  List<String> get fruits => [
    'Epal',
    'Avokado',
    'Pisang',
    'Blackberi',
    'Bluberi',
    'Brokoli',
    'Lobak merah',
    'Ceri',
    'Kelapa',
    'Anggur',
    'Lemon',
    'Salad',
    'Mangga',
    'Tembikai',
    'Cendawan',
    'Bawang',
    'Oren',
    'Betik',
    'Pic',
    'Pir',
    'Nanas',
    'Kentang',
    'Labu',
    'Rasberi',
    'Strawberi',
    'Tomato',
  ];

  /// Dalam bahasa Melayu, kata sifat biasanya diletakkan selepas kata nama.
  @override
  String combination({required Object fruit, required Object adjective}) => '${fruit} yang ${adjective}';
}

// Path: dialogs
class _Translations$dialogs$ms extends Translations$dialogs$en {
  _Translations$dialogs$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$dialogs$addFile$ms addFile = _Translations$dialogs$addFile$ms._(_root);
  @override
  late final _Translations$dialogs$openFile$ms openFile = _Translations$dialogs$openFile$ms._(_root);
  @override
  late final _Translations$dialogs$addressInput$ms addressInput = _Translations$dialogs$addressInput$ms._(_root);
  @override
  late final _Translations$dialogs$cancelSession$ms cancelSession = _Translations$dialogs$cancelSession$ms._(_root);
  @override
  late final _Translations$dialogs$connectionError$ms connectionError = _Translations$dialogs$connectionError$ms._(_root);
  @override
  late final _Translations$dialogs$deleteSourceAfterSendDialog$ms deleteSourceAfterSendDialog =
      _Translations$dialogs$deleteSourceAfterSendDialog$ms._(_root);
  @override
  late final _Translations$dialogs$cannotOpenFile$ms cannotOpenFile = _Translations$dialogs$cannotOpenFile$ms._(_root);
  @override
  late final _Translations$dialogs$encryptionDisabledNotice$ms encryptionDisabledNotice = _Translations$dialogs$encryptionDisabledNotice$ms._(_root);
  @override
  late final _Translations$dialogs$errorDialog$ms errorDialog = _Translations$dialogs$errorDialog$ms._(_root);
  @override
  late final _Translations$dialogs$favoriteDialog$ms favoriteDialog = _Translations$dialogs$favoriteDialog$ms._(_root);
  @override
  late final _Translations$dialogs$favoriteDeleteDialog$ms favoriteDeleteDialog = _Translations$dialogs$favoriteDeleteDialog$ms._(_root);
  @override
  late final _Translations$dialogs$favoriteEditDialog$ms favoriteEditDialog = _Translations$dialogs$favoriteEditDialog$ms._(_root);
  @override
  late final _Translations$dialogs$fileInfo$ms fileInfo = _Translations$dialogs$fileInfo$ms._(_root);
  @override
  late final _Translations$dialogs$fileNameInput$ms fileNameInput = _Translations$dialogs$fileNameInput$ms._(_root);
  @override
  late final _Translations$dialogs$historyClearDialog$ms historyClearDialog = _Translations$dialogs$historyClearDialog$ms._(_root);
  @override
  late final _Translations$dialogs$localNetworkUnauthorized$ms localNetworkUnauthorized = _Translations$dialogs$localNetworkUnauthorized$ms._(_root);
  @override
  late final _Translations$dialogs$messageInput$ms messageInput = _Translations$dialogs$messageInput$ms._(_root);
  @override
  late final _Translations$dialogs$noFiles$ms noFiles = _Translations$dialogs$noFiles$ms._(_root);
  @override
  late final _Translations$dialogs$noPermission$ms noPermission = _Translations$dialogs$noPermission$ms._(_root);
  @override
  late final _Translations$dialogs$notAvailableOnPlatform$ms notAvailableOnPlatform = _Translations$dialogs$notAvailableOnPlatform$ms._(_root);
  @override
  late final _Translations$dialogs$qr$ms qr = _Translations$dialogs$qr$ms._(_root);
  @override
  late final _Translations$dialogs$quickActions$ms quickActions = _Translations$dialogs$quickActions$ms._(_root);
  @override
  late final _Translations$dialogs$quickSaveNotice$ms quickSaveNotice = _Translations$dialogs$quickSaveNotice$ms._(_root);
  @override
  late final _Translations$dialogs$quickSaveFromFavoritesNotice$ms quickSaveFromFavoritesNotice =
      _Translations$dialogs$quickSaveFromFavoritesNotice$ms._(_root);
  @override
  late final _Translations$dialogs$pin$ms pin = _Translations$dialogs$pin$ms._(_root);
  @override
  late final _Translations$dialogs$sendModeHelp$ms sendModeHelp = _Translations$dialogs$sendModeHelp$ms._(_root);
  @override
  late final _Translations$dialogs$startupError$ms startupError = _Translations$dialogs$startupError$ms._(_root);
  @override
  late final _Translations$dialogs$zoom$ms zoom = _Translations$dialogs$zoom$ms._(_root);
}

// Path: sanitization
class _Translations$sanitization$ms extends Translations$sanitization$en {
  _Translations$sanitization$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get empty => 'Nama fail tidak boleh kosong';
  @override
  String get invalid => 'Nama fail mengandungi aksara yang tidak sah';
}

// Path: tray
class _Translations$tray$ms extends Translations$tray$en {
  _Translations$tray$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get open => _root.general.open;
  @override
  String get close => 'Keluar LocalSend';
  @override
  String get closeWindows => 'Keluar';
}

// Path: web
class _Translations$web$ms extends Translations$web$en {
  _Translations$web$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get waiting => _root.sendPage.waiting;
  @override
  String get enterPin => 'Masukkan PIN';
  @override
  String get invalidPin => 'PIN Tidak Sah';
  @override
  String get tooManyAttempts => 'Terlalu banyak percubaan';
  @override
  String get rejected => 'Ditolak';
  @override
  String get files => 'Fail';
  @override
  String get fileName => 'Nama fail';
  @override
  String get size => 'Saiz';
}

// Path: assetPicker
class _Translations$assetPicker$ms extends Translations$assetPicker$en {
  _Translations$assetPicker$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get confirm => 'Sahkan';
  @override
  String get cancel => 'Batal';
  @override
  String get edit => 'Sunting';
  @override
  String get gifIndicator => 'GIF';
  @override
  String get loadFailed => 'Gagal dimuat';
  @override
  String get original => 'Asal';
  @override
  String get preview => 'Pratonton';
  @override
  String get select => 'Pilih';
  @override
  String get emptyList => 'Senarai kosong';
  @override
  String get unSupportedAssetType => 'Jenis fail tidak disokong.';
  @override
  String get unableToAccessAll => 'Tidak dapat mengakses semua fail pada peranti';
  @override
  String get viewingLimitedAssetsTip => 'Hanya lihat fail dan album yang boleh diakses oleh aplikasi.';
  @override
  String get changeAccessibleLimitedAssets => 'Klik untuk mengemas kini fail yang boleh diakses';
  @override
  String get accessAllTip =>
      'Aplikasi hanya dapat mengakses beberapa fail pada peranti. Pergi ke tetapan sistem dan benarkan aplikasi mengakses semua media pada peranti.';
  @override
  String get goToSystemSettings => 'Pergi ke tetapan sistem';
  @override
  String get accessLimitedAssets => 'Teruskan dengan akses terhad';
  @override
  String get accessiblePathName => 'Fail yang boleh diakses';
  @override
  String get sTypeAudioLabel => 'Audio';
  @override
  String get sTypeImageLabel => 'Imej';
  @override
  String get sTypeVideoLabel => 'Video';
  @override
  String get sTypeOtherLabel => 'Media lain';
  @override
  String get sActionPlayHint => 'main';
  @override
  String get sActionPreviewHint => 'pratonton';
  @override
  String get sActionSelectHint => 'pilih';
  @override
  String get sActionSwitchPathLabel => 'tukar laluan';
  @override
  String get sActionUseCameraHint => 'guna kamera';
  @override
  String get sNameDurationLabel => 'tempoh';
  @override
  String get sUnitAssetCountLabel => 'kiraan';
}

// Path: receiveTab.infoBox
class _Translations$receiveTab$infoBox$ms extends Translations$receiveTab$infoBox$en {
  _Translations$receiveTab$infoBox$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get ip => 'IP:';
  @override
  String get port => 'Port:';
  @override
  String get alias => 'Nama peranti:';
}

// Path: receiveTab.quickSave
class _Translations$receiveTab$quickSave$ms extends Translations$receiveTab$quickSave$en {
  _Translations$receiveTab$quickSave$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get off => _root.general.off;
  @override
  String get favorites => 'Kegemaran';
  @override
  String get on => _root.general.on;
}

// Path: sendTab.selection
class _Translations$sendTab$selection$ms extends Translations$sendTab$selection$en {
  _Translations$sendTab$selection$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Pilihan';
  @override
  String files({required Object files}) => 'Fail: ${files}';
  @override
  String size({required Object size}) => 'Saiz: ${size}';
}

// Path: sendTab.picker
class _Translations$sendTab$picker$ms extends Translations$sendTab$picker$en {
  _Translations$sendTab$picker$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get file => 'Fail';
  @override
  String get folder => 'Folder';
  @override
  String get media => 'Media';
  @override
  String get text => 'Teks';
  @override
  String get app => 'Aplikasi';
  @override
  String get clipboard => 'Tampal';
}

// Path: sendTab.sendModes
class _Translations$sendTab$sendModes$ms extends Translations$sendTab$sendModes$en {
  _Translations$sendTab$sendModes$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get single => 'Satu penerima';
  @override
  String get multiple => 'Pelbagai penerima';
  @override
  String get link => 'Kongsi melalui pautan';
}

// Path: sendTab.diagnosis
class _Translations$sendTab$diagnosis$ms extends Translations$sendTab$diagnosis$en {
  _Translations$sendTab$diagnosis$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get scanning => 'Mencari peranti berdekatan…';
  @override
  late final _Translations$sendTab$diagnosis$noInterface$ms noInterface = _Translations$sendTab$diagnosis$noInterface$ms._(_root);
  @override
  late final _Translations$sendTab$diagnosis$multicastUnavailable$ms multicastUnavailable = _Translations$sendTab$diagnosis$multicastUnavailable$ms._(
    _root,
  );
  @override
  late final _Translations$sendTab$diagnosis$scanNoResult$ms scanNoResult = _Translations$sendTab$diagnosis$scanNoResult$ms._(_root);
  @override
  String get rescan => 'Cari semula';
  @override
  String get bleHint =>
      'Penemuan BLE aktif: peranti hanya ditemui melalui Bluetooth jika peranti itu juga menjalankan versi terbitan ini (fork) dengan pilihan ini diaktifkan; pemindahan itu sendiri masih berjalan melalui rangkaian.';
  @override
  late final _Translations$sendTab$diagnosis$manualFallback$ms manualFallback = _Translations$sendTab$diagnosis$manualFallback$ms._(_root);
}

// Path: settingsTab.general
class _Translations$settingsTab$general$ms extends Translations$settingsTab$general$en {
  _Translations$settingsTab$general$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Umum';
  @override
  String get brightness => 'Tema';
  @override
  late final _Translations$settingsTab$general$brightnessOptions$ms brightnessOptions = _Translations$settingsTab$general$brightnessOptions$ms._(
    _root,
  );
  @override
  String get color => 'Warna';
  @override
  late final _Translations$settingsTab$general$colorOptions$ms colorOptions = _Translations$settingsTab$general$colorOptions$ms._(_root);
  @override
  String get language => 'Bahasa';
  @override
  late final _Translations$settingsTab$general$languageOptions$ms languageOptions = _Translations$settingsTab$general$languageOptions$ms._(_root);
  @override
  String get saveWindowPlacement => 'Simpan kedudukan tetingkap selepas keluar';
  @override
  String get saveWindowPlacementWindows => 'Simpan kedudukan tetingkap selepas keluar';
  @override
  String get minimizeToTray => 'Minimumkan ke dulang sistem/menu bar apabila menutup';
  @override
  String get launchAtStartup => 'Mula automatik selepas log masuk';
  @override
  String get launchMinimized => 'Mula automatik: Mula tersembunyi';
  @override
  String get showInContextMenu => 'Tunjukkan LocalSend dalam menu konteks';
  @override
  String get animations => 'Animasi';
}

// Path: settingsTab.receive
class _Translations$settingsTab$receive$ms extends Translations$settingsTab$receive$en {
  _Translations$settingsTab$receive$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Terima';
  @override
  String get quickSave => _root.general.quickSave;
  @override
  String get quickSaveFromFavorites => _root.general.quickSaveFromFavorites;
  @override
  String get requirePin => 'Memerlukan PIN';
  @override
  String get autoFinish => 'Selesai Automatik';
  @override
  String get destination => 'Simpan ke folder';
  @override
  String get downloads => '(Muat turun)';
  @override
  String get saveToGallery => 'Simpan media ke galeri';
  @override
  String get saveToHistory => 'Simpan ke sejarah';
  @override
  String get verifyChecksums => 'Sahkan checksum semasa menerima fail';
}

// Path: settingsTab.send
class _Translations$settingsTab$send$ms extends Translations$settingsTab$send$en {
  _Translations$settingsTab$send$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Hantar';
  @override
  String get shareViaLinkAutoAccept => 'Terima permintaan secara automatik dalam mod "Kongsi melalui pautan"';
  @override
  String get createChecksums => 'Cipta checksum semasa menghantar fail';
  @override
  String get deleteSourceAfterSend => 'Padam fail sumber selepas penghantaran berjaya';
}

// Path: settingsTab.network
class _Translations$settingsTab$network$ms extends Translations$settingsTab$network$en {
  _Translations$settingsTab$network$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Rangkaian';
  @override
  String get needRestart => 'Mulakan semula pelayan untuk menggunakan tetapan!';
  @override
  String get server => 'Pelayan';
  @override
  String get alias => 'Nama peranti';
  @override
  String get deviceType => 'Jenis peranti';
  @override
  String get deviceModel => 'Model peranti';
  @override
  String get port => 'Port';
  @override
  String get network => 'Rangkaian';
  @override
  late final _Translations$settingsTab$network$networkOptions$ms networkOptions = _Translations$settingsTab$network$networkOptions$ms._(_root);
  @override
  String get discoveryTimeout => 'Tamat Masa Penemuan';
  @override
  String get maxInterfaces => 'Antara Muka Maksimum (Imbasan Pintar)';
  @override
  String get vpnInterfaces => 'Sertakan antara muka VPN (Imbasan Pintar)';
  @override
  String get vpnInterfacesHint =>
      'Turut mengimbas subnet antara muka terowong VPN (Tailscale, WireGuard, ...). VPN biasanya tidak membawa multicast, jadi subnetnya diperiksa oleh imbasan sandaran HTTP sebagai gantinya.';
  @override
  String get useSystemName => 'Gunakan nama sistem';
  @override
  String get generateRandomAlias => 'Jana alias rawak';
  @override
  String portWarning({required Object defaultPort}) =>
      'Anda mungkin tidak dapat dikesan oleh peranti lain kerana anda menggunakan port tersuai. (lalai: ${defaultPort})';
  @override
  String get encryption => 'Penyulitan';
  @override
  String get multicastGroup => 'Multicast';
  @override
  String multicastGroupWarning({required Object defaultMulticast}) =>
      'Anda mungkin tidak dapat dikesan oleh peranti lain kerana anda menggunakan alamat multicast tersuai. (lalai: ${defaultMulticast})';
  @override
  String get bleDiscovery => 'Penemuan BLE (eksperimen)';
  @override
  String get bleDiscoveryHint =>
      'Menemui peranti berdekatan melalui Bluetooth walaupun rangkaian menyekat multicast (pengasingan AP). Berfungsi pada Android, iOS, macOS dan Windows; pada Linux peranti ini boleh menemui yang lain tetapi tidak boleh ditemui. Kedua-dua peranti memerlukan versi terbitan ini (fork) dengan pilihan ini diaktifkan; pemindahan fail itu sendiri masih menggunakan rangkaian.';
  @override
  String get bleStatusActive =>
      'Aktif: mengimbas dan mengiklankan. Peranti berdekatan hanya muncul jika ia juga menjalankan versi terbitan ini (fork) dengan pilihan ini diaktifkan.';
  @override
  String get bleStatusScanOnly =>
      'Aktif: imbasan sahaja. Peranti ini tidak dapat ditemui melalui Bluetooth buat masa ini (tiada sokongan pengiklanan BLE pada platform ini, atau belum ada alamat rangkaian yang boleh digunakan).';
  @override
  String get bleStatusPaused => 'Dijeda. Akan disambung semula apabila aplikasi kembali ke latar depan.';
  @override
  String get bleStatusPermissionDenied =>
      'Kebenaran Bluetooth ditolak. Berikan kebenaran "Peranti berdekatan" (atau "Lokasi" pada Android 11 dan ke bawah) dalam tetapan sistem, kemudian matikan dan hidupkan semula pilihan ini.';
  @override
  String get bleStatusAdapterOff =>
      'Bluetooth dimatikan atau tidak tersedia. Penemuan akan dimulakan semula secara automatik apabila Bluetooth tersedia semula.';
  @override
  String get bleStatusUnsupported => 'Tidak disokong pada peranti ini: penemuan BLE memerlukan Android 7 atau lebih baharu serta radio Bluetooth LE.';
  @override
  String get bleStatusLegacyLocation =>
      'Pada versi Android ini, mencari peranti lain juga memerlukan perkhidmatan lokasi sistem diaktifkan (kebenaran diminta secara automatik; peranti ini sudah boleh ditemui oleh orang lain).';
  @override
  String get bleStatusError => 'Penemuan BLE tidak dapat dimulakan. Sila lihat Penyelesaian masalah > Log untuk butiran.';
  @override
  String get bleOpenSystemSettings => 'Buka tetapan sistem';
}

// Path: settingsTab.other
class _Translations$settingsTab$other$ms extends Translations$settingsTab$other$en {
  _Translations$settingsTab$other$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Lain-lain';
  @override
  String get support => 'Sokong LocalSend';
  @override
  String get donate => 'Derma';
  @override
  String get privacyPolicy => 'Dasar Privasi';
  @override
  String get termsOfUse => 'Syarat Penggunaan';
}

// Path: troubleshootPage.firewall
class _Translations$troubleshootPage$firewall$ms extends Translations$troubleshootPage$firewall$en {
  _Translations$troubleshootPage$firewall$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Peranti ini boleh menghantar fail ke peranti lain tetapi peranti lain tidak boleh menghantar fail ke peranti ini.';
  @override
  String solution({required Object port}) =>
      'Ini kemungkinan besar adalah masalah firewall. Anda boleh menyelesaikannya dengan membenarkan sambungan masuk (UDP dan TCP) pada port ${port}.';
  @override
  String get openFirewall => 'Buka Firewall';
}

// Path: troubleshootPage.noDiscovery
class _Translations$troubleshootPage$noDiscovery$ms extends Translations$troubleshootPage$noDiscovery$en {
  _Translations$troubleshootPage$noDiscovery$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Peranti ini tidak dapat menemui peranti lain.';
  @override
  String get solution =>
      'Sila pastikan semua peranti berada dalam rangkaian Wi-Fi yang sama dan berkongsi konfigurasi yang sama (port, alamat multicast, penyulitan). Anda boleh cuba menaip alamat IP peranti sasaran secara manual. Jika ini berhasil, pertimbangkan untuk menambahkan peranti ini ke kegemaran agar ia dapat ditemui secara automatik pada masa hadapan.';
}

// Path: troubleshootPage.noConnection
class _Translations$troubleshootPage$noConnection$ms extends Translations$troubleshootPage$noConnection$en {
  _Translations$troubleshootPage$noConnection$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => 'Kedua-dua peranti tidak dapat menemui satu sama lain atau tidak dapat berkongsi fail.';
  @override
  String get solution =>
      'Adakah masalah wujud di kedua-dua belah pihak? Jika ya, anda perlu memastikan bahawa kedua-dua peranti berada dalam rangkaian Wi-Fi yang sama dan berkongsi konfigurasi yang sama (port, alamat multicast, penyulitan). Rangkaian Wi-Fi mungkin tidak membenarkan komunikasi antara peserta (pengasingan AP). Dalam kes ini, pilihan ini mesti diaktifkan pada penghala.';
}

// Path: receiveHistoryPage.entryActions
class _Translations$receiveHistoryPage$entryActions$ms extends Translations$receiveHistoryPage$entryActions$en {
  _Translations$receiveHistoryPage$entryActions$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get open => 'Buka fail';
  @override
  String get showInFolder => 'Tunjukkan dalam folder';
  @override
  String get info => 'Maklumat';
  @override
  String get deleteFromHistory => 'Padam dari sejarah';
}

// Path: deviceDetailsPage.info
class _Translations$deviceDetailsPage$info$ms extends Translations$deviceDetailsPage$info$en {
  _Translations$deviceDetailsPage$info$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get name => 'Nama';
  @override
  String get address => 'Alamat';
  @override
  String get version => 'Versi';
  @override
  String protocol({required Object version}) => 'Protokol v${version}';
}

// Path: deviceDetailsPage.logs
class _Translations$deviceDetailsPage$logs$ms extends Translations$deviceDetailsPage$logs$en {
  _Translations$deviceDetailsPage$logs$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Log';
  @override
  String get empty => 'Tiada log tersedia.';
  @override
  String discovered({required Object protocol, required Object host}) => 'Ditemui melalui ${protocol} (${host})';
  @override
  String updated({required Object protocol, required Object host}) => 'Dikemas kini melalui ${protocol} (${host})';
}

// Path: progressPage.checksum
class _Translations$progressPage$checksum$ms extends Translations$progressPage$checksum$en {
  _Translations$progressPage$checksum$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get verified => 'Checksum disahkan';
  @override
  String partiallyVerified({required Object curr, required Object n}) => 'Checksum disahkan untuk ${curr} / ${n} fail';
  @override
  String get notVerifiable => 'Penghantar tidak menyediakan checksum';
  @override
  String get disabled => 'Pengesahan checksum dilumpuhkan';
  @override
  String attached({required Object curr, required Object n}) => 'Checksum dilampirkan (${curr} / ${n} fail)';
}

// Path: progressPage.total
class _Translations$progressPage$total$ms extends Translations$progressPage$total$en {
  _Translations$progressPage$total$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$progressPage$total$title$ms title = _Translations$progressPage$total$title$ms._(_root);
  @override
  String count({required Object curr, required Object n}) => 'Fail: ${curr} / ${n}';
  @override
  String size({required Object curr, required Object n}) => 'Saiz: ${curr} / ${n}';
  @override
  String speed({required Object speed}) => 'Kelajuan: ${speed}/s';
}

// Path: progressPage.remainingTime
class _Translations$progressPage$remainingTime$ms extends Translations$progressPage$remainingTime$en {
  _Translations$progressPage$remainingTime$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String minutesUnit({required num m}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ms'))(
    m,
    other: '${m}m',
  );
  @override
  String hoursUnit({required num h}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ms'))(
    h,
    other: '${h}j',
  );
  @override
  String minutes({required Object m, required Object ss}) => '${m}:${ss}';
  @override
  String hours({required num h, required num m}) =>
      '${_root.progressPage.remainingTime.hoursUnit(h: h)} ${_root.progressPage.remainingTime.minutesUnit(m: m)}';
}

// Path: whatsNewPage.changes
class _Translations$whatsNewPage$changes$ms extends Translations$whatsNewPage$changes$en {
  _Translations$whatsNewPage$changes$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  late final _Translations$whatsNewPage$changes$v1_18_0$ms v1_18_0 = _Translations$whatsNewPage$changes$v1_18_0$ms._(_root);
}

// Path: dialogs.addFile
class _Translations$dialogs$addFile$ms extends Translations$dialogs$addFile$en {
  _Translations$dialogs$addFile$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tambah ke pilihan';
  @override
  String get content => 'Apa yang anda ingin tambah?';
}

// Path: dialogs.openFile
class _Translations$dialogs$openFile$ms extends Translations$dialogs$openFile$en {
  _Translations$dialogs$openFile$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Buka fail';
  @override
  String get content => 'Adakah anda mahu untuk membuka fail yang diterima?';
}

// Path: dialogs.addressInput
class _Translations$dialogs$addressInput$ms extends Translations$dialogs$addressInput$en {
  _Translations$dialogs$addressInput$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Masukkan alamat';
  @override
  String get hashtag => 'Tanda pagar';
  @override
  String get ip => 'Alamat IP';
  @override
  String get recentlyUsed => 'Digunakan baru-baru ini: ';
  @override
  String get noHashtagCandidates =>
      'Rangkaian semasa tiada alamat IPv4, jadi tanda pagar tidak dapat dikembangkan menjadi alamat calon. Sila masukkan alamat penuh sebaliknya (cth. 192.168.1.5 atau fe80::1).';
  @override
  late final _Translations$dialogs$addressInput$validation$ms validation = _Translations$dialogs$addressInput$validation$ms._(_root);
}

// Path: dialogs.cancelSession
class _Translations$dialogs$cancelSession$ms extends Translations$dialogs$cancelSession$en {
  _Translations$dialogs$cancelSession$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Batalkan pemindahan fail';
  @override
  String get content => 'Adakah anda benar-benar mahu membatalkan pemindahan fail?';
}

// Path: dialogs.connectionError
class _Translations$dialogs$connectionError$ms extends Translations$dialogs$connectionError$en {
  _Translations$dialogs$connectionError$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Sambungan gagal';
  @override
  late final _Translations$dialogs$connectionError$timeout$ms timeout = _Translations$dialogs$connectionError$timeout$ms._(_root);
  @override
  late final _Translations$dialogs$connectionError$refused$ms refused = _Translations$dialogs$connectionError$refused$ms._(_root);
  @override
  late final _Translations$dialogs$connectionError$forbidden$ms forbidden = _Translations$dialogs$connectionError$forbidden$ms._(_root);
  @override
  late final _Translations$dialogs$connectionError$other$ms other = _Translations$dialogs$connectionError$other$ms._(_root);
  @override
  String get retry => 'Cuba semula';
  @override
  String get details => 'Butiran ralat:';
}

// Path: dialogs.deleteSourceAfterSendDialog
class _Translations$dialogs$deleteSourceAfterSendDialog$ms extends Translations$dialogs$deleteSourceAfterSendDialog$en {
  _Translations$dialogs$deleteSourceAfterSendDialog$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Padam fail sumber';
  @override
  String get content => 'Selepas fail berjaya dihantar, fail tersebut akan dipadamkan daripada peranti ini. Tindakan ini tidak boleh dibuat asal.';
}

// Path: dialogs.cannotOpenFile
class _Translations$dialogs$cannotOpenFile$ms extends Translations$dialogs$cannotOpenFile$en {
  _Translations$dialogs$cannotOpenFile$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tidak dapat membuka fail';
  @override
  String content({required Object file}) => 'Tidak dapat membuka "${file}". Adakah fail ini telah dipindahkan, dinamakan semula atau dipadamkan?';
}

// Path: dialogs.encryptionDisabledNotice
class _Translations$dialogs$encryptionDisabledNotice$ms extends Translations$dialogs$encryptionDisabledNotice$en {
  _Translations$dialogs$encryptionDisabledNotice$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Penyulitan dimatikan';
  @override
  String get content =>
      'Komunikasi kini berlaku melalui protokol HTTP yang tidak disulitkan. Untuk menggunakan protokol HTTPS, aktifkan penyulitan semula.';
}

// Path: dialogs.errorDialog
class _Translations$dialogs$errorDialog$ms extends Translations$dialogs$errorDialog$en {
  _Translations$dialogs$errorDialog$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.error;
}

// Path: dialogs.favoriteDialog
class _Translations$dialogs$favoriteDialog$ms extends Translations$dialogs$favoriteDialog$en {
  _Translations$dialogs$favoriteDialog$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Kegemaran';
  @override
  String get noFavorites => 'Tiada peranti kegemaran lagi.';
  @override
  String get addFavorite => 'Tambah';
}

// Path: dialogs.favoriteDeleteDialog
class _Translations$dialogs$favoriteDeleteDialog$ms extends Translations$dialogs$favoriteDeleteDialog$en {
  _Translations$dialogs$favoriteDeleteDialog$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Padam dari kegemaran';
  @override
  String content({required Object name}) => 'Adakah anda benar-benar mahu memadam "${name}" dari kegemaran?';
}

// Path: dialogs.favoriteEditDialog
class _Translations$dialogs$favoriteEditDialog$ms extends Translations$dialogs$favoriteEditDialog$en {
  _Translations$dialogs$favoriteEditDialog$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get titleAdd => 'Tambah ke kegemaran';
  @override
  String get titleEdit => 'Tetapan';
  @override
  String get name => 'Nama peranti';
  @override
  String get auto => '(auto)';
  @override
  String get ip => 'Alamat IP';
  @override
  String get port => 'Port';
}

// Path: dialogs.fileInfo
class _Translations$dialogs$fileInfo$ms extends Translations$dialogs$fileInfo$en {
  _Translations$dialogs$fileInfo$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Maklumat fail';
  @override
  String get fileName => 'Nama fail:';
  @override
  String get path => 'Laluan:';
  @override
  String get size => 'Saiz:';
  @override
  String get sender => 'Penghantar:';
  @override
  String get time => 'Masa:';
}

// Path: dialogs.fileNameInput
class _Translations$dialogs$fileNameInput$ms extends Translations$dialogs$fileNameInput$en {
  _Translations$dialogs$fileNameInput$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Masukkan nama fail';
  @override
  String original({required Object original}) => 'Asal: ${original}';
}

// Path: dialogs.historyClearDialog
class _Translations$dialogs$historyClearDialog$ms extends Translations$dialogs$historyClearDialog$en {
  _Translations$dialogs$historyClearDialog$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Kosongkan sejarah';
  @override
  String get content => 'Adakah anda benar-benar mahu memadamkan keseluruhan sejarah?';
}

// Path: dialogs.localNetworkUnauthorized
class _Translations$dialogs$localNetworkUnauthorized$ms extends Translations$dialogs$localNetworkUnauthorized$en {
  _Translations$dialogs$localNetworkUnauthorized$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.dialogs.noPermission.title;
  @override
  String get description =>
      'LocalSend tidak dapat mencari peranti lain tanpa mempunyai kebenaran untuk mengimbas rangkaian tempatan. Sila berikan kebenaran ini dalam tetapan.';
  @override
  String get gotoSettings => 'Tetapan';
}

// Path: dialogs.messageInput
class _Translations$dialogs$messageInput$ms extends Translations$dialogs$messageInput$en {
  _Translations$dialogs$messageInput$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Taip mesej';
  @override
  String get multiline => 'Pelbagai baris';
}

// Path: dialogs.noFiles
class _Translations$dialogs$noFiles$ms extends Translations$dialogs$noFiles$en {
  _Translations$dialogs$noFiles$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tiada fail dipilih';
  @override
  String get content => 'Sila pilih sekurang-kurangnya satu fail.';
}

// Path: dialogs.noPermission
class _Translations$dialogs$noPermission$ms extends Translations$dialogs$noPermission$en {
  _Translations$dialogs$noPermission$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tiada kebenaran';
  @override
  String get content => 'Anda belum memberikan kebenaran yang diperlukan. Sila berikan kebenaran dalam tetapan.';
}

// Path: dialogs.notAvailableOnPlatform
class _Translations$dialogs$notAvailableOnPlatform$ms extends Translations$dialogs$notAvailableOnPlatform$en {
  _Translations$dialogs$notAvailableOnPlatform$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tidak tersedia';
  @override
  String get content => 'Ciri ini hanya tersedia di:';
}

// Path: dialogs.qr
class _Translations$dialogs$qr$ms extends Translations$dialogs$qr$en {
  _Translations$dialogs$qr$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Kod QR';
}

// Path: dialogs.quickActions
class _Translations$dialogs$quickActions$ms extends Translations$dialogs$quickActions$en {
  _Translations$dialogs$quickActions$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tindakan Pantas';
  @override
  String get counter => 'Kaunter';
  @override
  String get prefix => 'Awalan';
  @override
  String get padZero => 'Isi dengan sifar';
  @override
  String get sortBeforeCount => 'Susun mengikut abjad terlebih dahulu';
  @override
  String get random => 'Rawak';
}

// Path: dialogs.quickSaveNotice
class _Translations$dialogs$quickSaveNotice$ms extends Translations$dialogs$quickSaveNotice$en {
  _Translations$dialogs$quickSaveNotice$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSave;
  @override
  String get content =>
      'Permintaan fail kini diterima secara automatik. Sila ambil perhatian bahawa semua orang dalam rangkaian tempatan boleh menghantar fail kepada anda.';
}

// Path: dialogs.quickSaveFromFavoritesNotice
class _Translations$dialogs$quickSaveFromFavoritesNotice$ms extends Translations$dialogs$quickSaveFromFavoritesNotice$en {
  _Translations$dialogs$quickSaveFromFavoritesNotice$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSaveFromFavorites;
  @override
  List<String> get content => [
    'Permintaan fail kini diterima secara automatik daripada peranti-peranti yang dalam senarai kegemaran anda.',
  ];
}

// Path: dialogs.pin
class _Translations$dialogs$pin$ms extends Translations$dialogs$pin$en {
  _Translations$dialogs$pin$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Masukkan PIN';
}

// Path: dialogs.sendModeHelp
class _Translations$dialogs$sendModeHelp$ms extends Translations$dialogs$sendModeHelp$en {
  _Translations$dialogs$sendModeHelp$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Mod penghantaran';
  @override
  String get single => 'Menghantar fail kepada satu penerima. Pilihan akan dibersihkan selepas pemindahan fail selesai.';
  @override
  String get multiple => 'Menghantar fail kepada beberapa penerima. Pilihan tidak akan dibersihkan.';
  @override
  String get link =>
      'Penerima yang tidak mempunyai LocalSend dipasang boleh memuat turun fail yang dipilih dengan membuka pautan dalam pelayar mereka.';
}

// Path: dialogs.startupError
class _Translations$dialogs$startupError$ms extends Translations$dialogs$startupError$en {
  _Translations$dialogs$startupError$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Pelayan tidak dapat dimulakan';
  @override
  String port({required Object port}) => 'Port: ${port}';
  @override
  late final _Translations$dialogs$startupError$windowsAccessDenied$ms windowsAccessDenied =
      _Translations$dialogs$startupError$windowsAccessDenied$ms._(_root);
  @override
  late final _Translations$dialogs$startupError$addressInUse$ms addressInUse = _Translations$dialogs$startupError$addressInUse$ms._(_root);
  @override
  late final _Translations$dialogs$startupError$generic$ms generic = _Translations$dialogs$startupError$generic$ms._(_root);
  @override
  String get details => 'Butiran ralat:';
  @override
  String get copyDetails => 'Salin butiran';
  @override
  String get openSettings => 'Buka tetapan';
}

// Path: dialogs.zoom
class _Translations$dialogs$zoom$ms extends Translations$dialogs$zoom$en {
  _Translations$dialogs$zoom$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'URL';
}

// Path: sendTab.diagnosis.noInterface
class _Translations$sendTab$diagnosis$noInterface$ms extends Translations$sendTab$diagnosis$noInterface$en {
  _Translations$sendTab$diagnosis$noInterface$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tiada sambungan rangkaian';
  @override
  String get advice => 'Peranti ini tidak disambungkan ke sebarang rangkaian. Sila semak sambungan Wi-Fi atau kabel peranti ini.';
}

// Path: sendTab.diagnosis.multicastUnavailable
class _Translations$sendTab$diagnosis$multicastUnavailable$ms extends Translations$sendTab$diagnosis$multicastUnavailable$en {
  _Translations$sendTab$diagnosis$multicastUnavailable$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Multicast tidak tersedia';
  @override
  String advice({required Object port}) =>
      'LocalSend tidak dapat menggunakan penemuan multicast pada rangkaian ini. Sila pastikan kedua-dua peranti berada dalam rangkaian yang sama, dan pengasingan AP atau firewall tidak menyekat port UDP ${port}.';
  @override
  String reason({required Object reason}) => 'Sebab: ${reason}';
}

// Path: sendTab.diagnosis.scanNoResult
class _Translations$sendTab$diagnosis$scanNoResult$ms extends Translations$sendTab$diagnosis$scanNoResult$en {
  _Translations$sendTab$diagnosis$scanNoResult$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Tiada peranti ditemui';
  @override
  String get advice =>
      'Penemuan berfungsi dengan baik, tetapi tiada peranti yang membalas pengumuman atau imbasan rangkaian. Peranti yang satu lagi mungkin luar talian, dalam mod tidur, atau disekat oleh firewall. Sila pastikan LocalSend sedang berjalan pada peranti yang satu lagi.';
  @override
  String detail({required Object announcements, required Object scans}) =>
      'Telah menghantar ${announcements} pengumuman dan ${scans} imbasan rangkaian tanpa balasan.';
}

// Path: sendTab.diagnosis.manualFallback
class _Translations$sendTab$diagnosis$manualFallback$ms extends Translations$sendTab$diagnosis$manualFallback$en {
  _Translations$sendTab$diagnosis$manualFallback$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get message =>
      'Alamat IP sering berubah. Anda tetap boleh menghubungi peranti yang tidak disenaraikan: tambahkannya ke kegemaran atau masukkan alamatnya secara manual.';
  @override
  String get openFavorites => 'Buka kegemaran';
  @override
  String get manualInput => 'Masukkan alamat secara manual';
}

// Path: settingsTab.general.brightnessOptions
class _Translations$settingsTab$general$brightnessOptions$ms extends Translations$settingsTab$general$brightnessOptions$en {
  _Translations$settingsTab$general$brightnessOptions$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Sistem';
  @override
  String get dark => 'Gelap';
  @override
  String get light => 'Cerah';
}

// Path: settingsTab.general.colorOptions
class _Translations$settingsTab$general$colorOptions$ms extends Translations$settingsTab$general$colorOptions$en {
  _Translations$settingsTab$general$colorOptions$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Sistem';
  @override
  String get oled => 'OLED';
  @override
  String get custom => 'Tersuai';
}

// Path: settingsTab.general.languageOptions
class _Translations$settingsTab$general$languageOptions$ms extends Translations$settingsTab$general$languageOptions$en {
  _Translations$settingsTab$general$languageOptions$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get system => 'Sistem';
}

// Path: settingsTab.network.networkOptions
class _Translations$settingsTab$network$networkOptions$ms extends Translations$settingsTab$network$networkOptions$en {
  _Translations$settingsTab$network$networkOptions$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get all => 'Semua';
  @override
  String get filtered => 'Ditapis';
}

// Path: progressPage.total.title
class _Translations$progressPage$total$title$ms extends Translations$progressPage$total$title$en {
  _Translations$progressPage$total$title$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String sending({required Object time}) => 'Kemajuan keseluruhan (${time})';
  @override
  String get finishedError => 'Selesai dengan ralat';
  @override
  String get canceledSender => 'Dibatalkan oleh penghantar';
  @override
  String get canceledReceiver => 'Dibatalkan oleh penerima';
}

// Path: whatsNewPage.changes.v1_18_0
class _Translations$whatsNewPage$changes$v1_18_0$ms extends Translations$whatsNewPage$changes$v1_18_0$en with WhatsNewStrings {
  _Translations$whatsNewPage$changes$v1_18_0$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  List<String> get changes => [
    'Penyulitan tidak lagi memperlahankan pemindahan. Ia telah diaktifkan semula pada peranti ini jika anda mematikannya sebelum ini.',
    'Permintaan daripada kegemaran kini diterima secara automatik. Ini diaktifkan secara lalai dan boleh dimatikan dalam tetapan.',
    'Pada Android, pemindahan diteruskan semasa aplikasi berada di latar belakang atau skrin dimatikan. Pada iOS, aplikasi masih perlu kekal di latar depan.',
  ];
}

// Path: dialogs.addressInput.validation
class _Translations$dialogs$addressInput$validation$ms extends Translations$dialogs$addressInput$validation$en {
  _Translations$dialogs$addressInput$validation$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get invalid => 'Masukkan alamat IPv4, alamat IPv6 atau nama hos yang sah.';
  @override
  String get scheme => 'Masukkan alamat sahaja, tanpa "http://" atau "https://".';
  @override
  String get port => 'Masukkan alamat sahaja. Port diambil daripada tetapan.';
}

// Path: dialogs.connectionError.timeout
class _Translations$dialogs$connectionError$timeout$ms extends Translations$dialogs$connectionError$timeout$en {
  _Translations$dialogs$connectionError$timeout$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Peranti tidak membalas dalam masa yang ditetapkan.';
  @override
  String get advice =>
      'Ia berkemungkinan luar talian, dalam mod tidur, atau firewall menyekat sambungan. Sila pastikan LocalSend sedang berjalan pada peranti yang satu lagi dan kedua-dua peranti berada dalam rangkaian yang sama.';
}

// Path: dialogs.connectionError.refused
class _Translations$dialogs$connectionError$refused$ms extends Translations$dialogs$connectionError$refused$en {
  _Translations$dialogs$connectionError$refused$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Peranti menolak sambungan.';
  @override
  String get advice =>
      'LocalSend nampaknya tidak berjalan pada peranti sasaran, atau ia mendengar pada port yang berbeza. Mulakan LocalSend pada peranti yang satu lagi atau semak port.';
}

// Path: dialogs.connectionError.forbidden
class _Translations$dialogs$connectionError$forbidden$ms extends Translations$dialogs$connectionError$forbidden$en {
  _Translations$dialogs$connectionError$forbidden$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Peranti menolak permintaan.';
  @override
  String get advice =>
      'PIN mungkin diperlukan, atau penggandingan dengan peranti telah berubah. Semak PIN dan tetapan simpan pantas pada peranti sasaran.';
}

// Path: dialogs.connectionError.other
class _Translations$dialogs$connectionError$other$ms extends Translations$dialogs$connectionError$other$en {
  _Translations$dialogs$connectionError$other$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'Sambungan tidak dapat dibuat.';
  @override
  String get advice =>
      'Semak alamat dan port, pastikan LocalSend sedang berjalan pada peranti sasaran, dan tiada firewall atau VPN yang menyekat sambungan.';
}

// Path: dialogs.startupError.windowsAccessDenied
class _Translations$dialogs$startupError$windowsAccessDenied$ms extends Translations$dialogs$startupError$windowsAccessDenied$en {
  _Translations$dialogs$startupError$windowsAccessDenied$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Windows menafikan akses kepada port tersebut (ralat soket 10013).';
  @override
  String get advice =>
      'Ini biasanya disebabkan oleh julat port yang dikhaskan oleh Hyper-V, WSL atau Docker, atau katalog Winsock yang rosak:\n• Tukar port dalam Tetapan (Rangkaian)\n• Semak julat dikhaskan dengan: netsh interface ipv4 show excludedportrange protocol=tcp\n• Baiki Winsock sebagai pentadbir dengan: netsh winsock reset (but semula selepas itu)';
}

// Path: dialogs.startupError.addressInUse
class _Translations$dialogs$startupError$addressInUse$ms extends Translations$dialogs$startupError$addressInUse$en {
  _Translations$dialogs$startupError$addressInUse$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Port tersebut sudah digunakan oleh aplikasi lain.';
  @override
  String get advice =>
      'Program lain (atau contoh LocalSend kedua) sedang mendengar pada port ini:\n• Tutup aplikasi tersebut, atau\n• Tukar port dalam Tetapan (Rangkaian)';
}

// Path: dialogs.startupError.generic
class _Translations$dialogs$startupError$generic$ms extends Translations$dialogs$startupError$generic$en {
  _Translations$dialogs$startupError$generic$ms._(TranslationsMs root) : this._root = root, super.internal(root);

  final TranslationsMs _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Pelayan tidak dapat dimulakan.';
  @override
  String get advice => '• Semak tetapan firewall dan rangkaian anda\n• Cuba tukar port dalam Tetapan (Rangkaian)';
}
