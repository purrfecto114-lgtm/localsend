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
class TranslationsZhCn extends Translations with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsZhCn({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.zhCn,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <zh-CN>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  late final TranslationsZhCn _root = this; // ignore: unused_field

  @override
  TranslationsZhCn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsZhCn(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'LocalSend';
  @override
  late final Translations$general$zh_CN general = Translations$general$zh_CN.internal(_root);
  @override
  late final Translations$receiveTab$zh_CN receiveTab = Translations$receiveTab$zh_CN.internal(_root);
  @override
  late final Translations$sendTab$zh_CN sendTab = Translations$sendTab$zh_CN.internal(_root);
  @override
  late final Translations$settingsTab$zh_CN settingsTab = Translations$settingsTab$zh_CN.internal(_root);
  @override
  late final Translations$troubleshootPage$zh_CN troubleshootPage = Translations$troubleshootPage$zh_CN.internal(_root);
  @override
  late final Translations$networkInterfacesPage$zh_CN networkInterfacesPage = Translations$networkInterfacesPage$zh_CN.internal(_root);
  @override
  late final Translations$receiveHistoryPage$zh_CN receiveHistoryPage = Translations$receiveHistoryPage$zh_CN.internal(_root);
  @override
  late final Translations$apkPickerPage$zh_CN apkPickerPage = Translations$apkPickerPage$zh_CN.internal(_root);
  @override
  late final Translations$selectedFilesPage$zh_CN selectedFilesPage = Translations$selectedFilesPage$zh_CN.internal(_root);
  @override
  late final Translations$deviceDetailsPage$zh_CN deviceDetailsPage = Translations$deviceDetailsPage$zh_CN.internal(_root);
  @override
  late final Translations$verifyPage$zh_CN verifyPage = Translations$verifyPage$zh_CN.internal(_root);
  @override
  late final Translations$receivePage$zh_CN receivePage = Translations$receivePage$zh_CN.internal(_root);
  @override
  late final Translations$receiveOptionsPage$zh_CN receiveOptionsPage = Translations$receiveOptionsPage$zh_CN.internal(_root);
  @override
  late final Translations$sendPage$zh_CN sendPage = Translations$sendPage$zh_CN.internal(_root);
  @override
  late final Translations$progressPage$zh_CN progressPage = Translations$progressPage$zh_CN.internal(_root);
  @override
  late final Translations$webSharePage$zh_CN webSharePage = Translations$webSharePage$zh_CN.internal(_root);
  @override
  late final Translations$webReceivePage$zh_CN webReceivePage = Translations$webReceivePage$zh_CN.internal(_root);
  @override
  late final Translations$aboutPage$zh_CN aboutPage = Translations$aboutPage$zh_CN.internal(_root);
  @override
  late final Translations$donationPage$zh_CN donationPage = Translations$donationPage$zh_CN.internal(_root);
  @override
  late final Translations$changelogPage$zh_CN changelogPage = Translations$changelogPage$zh_CN.internal(_root);
  @override
  late final Translations$whatsNewPage$zh_CN whatsNewPage = Translations$whatsNewPage$zh_CN.internal(_root);
  @override
  late final Translations$aliasGenerator$zh_CN aliasGenerator = Translations$aliasGenerator$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$zh_CN dialogs = Translations$dialogs$zh_CN.internal(_root);
  @override
  late final Translations$sanitization$zh_CN sanitization = Translations$sanitization$zh_CN.internal(_root);
  @override
  late final Translations$tray$zh_CN tray = Translations$tray$zh_CN.internal(_root);
  @override
  late final Translations$web$zh_CN web = Translations$web$zh_CN.internal(_root);
  @override
  late final Translations$assetPicker$zh_CN assetPicker = Translations$assetPicker$zh_CN.internal(_root);
}

// Path: general
class Translations$general$zh_CN extends Translations$general$en {
  Translations$general$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get accept => '接受';
  @override
  String get accepted => '已接受';
  @override
  String get add => '添加';
  @override
  String get advanced => '高级';
  @override
  String get cancel => '取消';
  @override
  String get close => '关闭';
  @override
  String get confirm => '确认';
  @override
  String get continueStr => '继续';
  @override
  String get copy => '复制';
  @override
  String get copiedToClipboard => '已复制到剪贴板';
  @override
  String get decline => '拒绝';
  @override
  String get done => '完成';
  @override
  String get delete => '删除';
  @override
  String get edit => '编辑';
  @override
  String get error => '错误';
  @override
  String get example => '示例';
  @override
  String get files => '文件';
  @override
  String get finished => '已完成';
  @override
  String get hide => '隐藏';
  @override
  String get off => '关';
  @override
  String get offline => '离线';
  @override
  String get on => '开';
  @override
  String get online => '在线';
  @override
  String get open => '打开';
  @override
  String get queue => '队列';
  @override
  String get quickSave => '自动保存';
  @override
  String get quickSaveFromFavorites => '自动保存来自“收藏夹(白名单)”设备的文件';
  @override
  String get renamed => '重命名成功';
  @override
  String get reset => '重置';
  @override
  String get restart => '重启';
  @override
  String get settings => '设置';
  @override
  String get skipped => '已跳过';
  @override
  String get start => '开始';
  @override
  String get stop => '停止';
  @override
  String get save => '保存';
  @override
  String get unchanged => '未更改';
  @override
  String get unknown => '未知';
  @override
  String get noItemInClipboard => '剪贴板为空';
}

// Path: receiveTab
class Translations$receiveTab$zh_CN extends Translations$receiveTab$en {
  Translations$receiveTab$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '接收';
  @override
  late final Translations$receiveTab$infoBox$zh_CN infoBox = Translations$receiveTab$infoBox$zh_CN.internal(_root);
  @override
  late final Translations$receiveTab$quickSave$zh_CN quickSave = Translations$receiveTab$quickSave$zh_CN.internal(_root);
  @override
  String get link => '通过链接接收';
}

// Path: sendTab
class Translations$sendTab$zh_CN extends Translations$sendTab$en {
  Translations$sendTab$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '发送';
  @override
  late final Translations$sendTab$selection$zh_CN selection = Translations$sendTab$selection$zh_CN.internal(_root);
  @override
  late final Translations$sendTab$picker$zh_CN picker = Translations$sendTab$picker$zh_CN.internal(_root);
  @override
  String get shareIntentInfo => '你也可以通过移动设备中的“分享”功能更简单地发送文件。';
  @override
  String get nearbyDevices => '附近的设备';
  @override
  String get thisDevice => '这台设备';
  @override
  String get scan => '扫描设备';
  @override
  String get manualSending => '手动发送';
  @override
  String get sendMode => '发送模式';
  @override
  late final Translations$sendTab$sendModes$zh_CN sendModes = Translations$sendTab$sendModes$zh_CN.internal(_root);
  @override
  String get sendModeHelp => '提示';
  @override
  String get help => '请确保目标连接到同一个 Wi‑Fi 网络。';
  @override
  String get placeItems => '列出要分享的项目。';
  @override
  late final Translations$sendTab$diagnosis$zh_CN diagnosis = Translations$sendTab$diagnosis$zh_CN.internal(_root);
}

// Path: settingsTab
class Translations$settingsTab$zh_CN extends Translations$settingsTab$en {
  Translations$settingsTab$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '设置';
  @override
  late final Translations$settingsTab$general$zh_CN general = Translations$settingsTab$general$zh_CN.internal(_root);
  @override
  late final Translations$settingsTab$receive$zh_CN receive = Translations$settingsTab$receive$zh_CN.internal(_root);
  @override
  late final Translations$settingsTab$send$zh_CN send = Translations$settingsTab$send$zh_CN.internal(_root);
  @override
  late final Translations$settingsTab$network$zh_CN network = Translations$settingsTab$network$zh_CN.internal(_root);
  @override
  late final Translations$settingsTab$other$zh_CN other = Translations$settingsTab$other$zh_CN.internal(_root);
  @override
  String get advancedSettings => '高级设置';
}

// Path: troubleshootPage
class Translations$troubleshootPage$zh_CN extends Translations$troubleshootPage$en {
  Translations$troubleshootPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '故障排除';
  @override
  String get subTitle => '应用没有按预期工作？您可以在这里找到常用解决方案。';
  @override
  String get solution => '解决方案：';
  @override
  String get fixButton => '自动修复';
  @override
  late final Translations$troubleshootPage$firewall$zh_CN firewall = Translations$troubleshootPage$firewall$zh_CN.internal(_root);
  @override
  late final Translations$troubleshootPage$noDiscovery$zh_CN noDiscovery = Translations$troubleshootPage$noDiscovery$zh_CN.internal(_root);
  @override
  late final Translations$troubleshootPage$noConnection$zh_CN noConnection = Translations$troubleshootPage$noConnection$zh_CN.internal(_root);
}

// Path: networkInterfacesPage
class Translations$networkInterfacesPage$zh_CN extends Translations$networkInterfacesPage$en {
  Translations$networkInterfacesPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '网络接口';
  @override
  String get info => '默认情况下，LocalSend 使用所有可用的网络接口。您可以在此处排除不需要的网络接口。您需要重新启动服务器以应用更改。';
  @override
  String get preview => '预览';
  @override
  String get whitelist => '白名单';
  @override
  String get blacklist => '黑名单';
}

// Path: receiveHistoryPage
class Translations$receiveHistoryPage$zh_CN extends Translations$receiveHistoryPage$en {
  Translations$receiveHistoryPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '历史';
  @override
  String get openFolder => '打开目录';
  @override
  String get deleteHistory => '删除历史记录';
  @override
  String get empty => '无历史记录。';
  @override
  late final Translations$receiveHistoryPage$entryActions$zh_CN entryActions = Translations$receiveHistoryPage$entryActions$zh_CN.internal(_root);
}

// Path: apkPickerPage
class Translations$apkPickerPage$zh_CN extends Translations$apkPickerPage$en {
  Translations$apkPickerPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '应用（APK）';
  @override
  String get excludeSystemApps => '排除系统应用';
  @override
  String get excludeAppsWithoutLaunchIntent => '排除无法启动的应用';
  @override
  String apps({required Object n}) => '${n} 个应用';
}

// Path: selectedFilesPage
class Translations$selectedFilesPage$zh_CN extends Translations$selectedFilesPage$en {
  Translations$selectedFilesPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get deleteAll => '全部删除';
}

// Path: deviceDetailsPage
class Translations$deviceDetailsPage$zh_CN extends Translations$deviceDetailsPage$en {
  Translations$deviceDetailsPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '设备详情';
  @override
  String get favorite => '收藏';
  @override
  String get verify => '验证';
  @override
  late final Translations$deviceDetailsPage$info$zh_CN info = Translations$deviceDetailsPage$info$zh_CN.internal(_root);
  @override
  late final Translations$deviceDetailsPage$logs$zh_CN logs = Translations$deviceDetailsPage$logs$zh_CN.internal(_root);
}

// Path: verifyPage
class Translations$verifyPage$zh_CN extends Translations$verifyPage$en {
  Translations$verifyPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '验证';
  @override
  String get icons => '图标';
  @override
  String get text => '文本';
  @override
  String get question => '在另一台设备上显示的内容相同吗？';
}

// Path: receivePage
class Translations$receivePage$zh_CN extends Translations$receivePage$en {
  Translations$receivePage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String subTitle({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(
    n,
    one: '想要发送给你一个文件',
    other: '想要发送给你 ${n} 个文件',
  );
  @override
  String get subTitleMessage => '发送给你了一条消息：';
  @override
  String get subTitleLink => '发送给你了一个链接：';
  @override
  String get canceled => '发送者取消了请求。';
}

// Path: receiveOptionsPage
class Translations$receiveOptionsPage$zh_CN extends Translations$receiveOptionsPage$en {
  Translations$receiveOptionsPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '设置';
  @override
  String get destination => _root.settingsTab.receive.destination;
  @override
  String get appDirectory => '(LocalSend 文件夹)';
  @override
  String get saveToGallery => _root.settingsTab.receive.saveToGallery;
  @override
  String get saveToGalleryOff => '由于分享内容中存在文件夹，已自动关闭。';
}

// Path: sendPage
class Translations$sendPage$zh_CN extends Translations$sendPage$en {
  Translations$sendPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String calculatingChecksum({required Object curr, required Object n}) => '正在计算校验和（${curr} / ${n}）';
  @override
  String get waiting => '等待响应中……';
  @override
  String get rejected => '对方拒绝了请求。';
  @override
  String get tooManyAttempts => _root.web.tooManyAttempts;
  @override
  String get busy => '对方正在处理另一个请求。';
}

// Path: progressPage
class Translations$progressPage$zh_CN extends Translations$progressPage$en {
  Translations$progressPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get titleSending => '正在发送文件';
  @override
  String get titleReceiving => '正在接收文件';
  @override
  String get savedToGallery => '已保存到相册';
  @override
  late final Translations$progressPage$checksum$zh_CN checksum = Translations$progressPage$checksum$zh_CN.internal(_root);
  @override
  late final Translations$progressPage$total$zh_CN total = Translations$progressPage$total$zh_CN.internal(_root);
  @override
  late final Translations$progressPage$remainingTime$zh_CN remainingTime = Translations$progressPage$remainingTime$zh_CN.internal(_root);
}

// Path: webSharePage
class Translations$webSharePage$zh_CN extends Translations$webSharePage$en {
  Translations$webSharePage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '分享为链接';
  @override
  String get loading => '正在启动服务器……';
  @override
  String get stopping => '正在停止服务器……';
  @override
  String get error => '在启动服务器过程中发生了错误。';
  @override
  String openLink({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(
    n,
    one: '在浏览器中打开链接：',
    other: '在浏览器中打开其中一个链接：',
  );
  @override
  String get requests => '请求';
  @override
  String get noRequests => '尚无请求。';
  @override
  String get encryption => _root.settingsTab.network.encryption;
  @override
  String get autoAccept => '自动接受请求';
  @override
  String get requirePin => '启用 PIN 密码';
  @override
  String pinHint({required Object pin}) => 'PIN 为 “${pin}”';
  @override
  String get encryptionHint => 'LocalSend 使用自签名证书。您需要在浏览器中允许它。';
  @override
  String pendingRequests({required Object n}) => '待处理请求：${n}';
}

// Path: webReceivePage
class Translations$webReceivePage$zh_CN extends Translations$webReceivePage$en {
  Translations$webReceivePage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '通过链接接收';
}

// Path: aboutPage
class Translations$aboutPage$zh_CN extends Translations$aboutPage$en {
  Translations$aboutPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '关于 LocalSend';
  @override
  List<String> get description => [
    'LocalSend 是一款免费的开源应用程序，可让您通过本地网络与附近的设备安全地分享文件和信息，而无需互联网连接。',
    '本程序可在 Android、iOS、macOS、Windows 和 Linux 上使用。您可以在官方主页找到所有下载选项。',
  ];
  @override
  String get author => '作者';
  @override
  String get contributors => '贡献者';
  @override
  String get packagers => '打包者';
  @override
  String get translators => '翻译者';
}

// Path: donationPage
class Translations$donationPage$zh_CN extends Translations$donationPage$en {
  Translations$donationPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '捐赠';
  @override
  String get info => 'LocalSend 免费、开源、无广告。如果您喜欢这款应用程序，可以捐款支持开发。';
  @override
  String donate({required Object amount}) => '捐款 ${amount}';
  @override
  String get thanks => '非常感谢您的支持！';
  @override
  String get restore => '恢复购买';
}

// Path: changelogPage
class Translations$changelogPage$zh_CN extends Translations$changelogPage$en {
  Translations$changelogPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '更新日志';
}

// Path: whatsNewPage
class Translations$whatsNewPage$zh_CN extends Translations$whatsNewPage$en {
  Translations$whatsNewPage$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String title({required Object version}) => '${version} 中的新增功能';
  @override
  late final Translations$whatsNewPage$changes$zh_CN changes = Translations$whatsNewPage$changes$zh_CN.internal(_root);
}

// Path: aliasGenerator
class Translations$aliasGenerator$zh_CN extends Translations$aliasGenerator$en {
  Translations$aliasGenerator$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  List<String> get adjectives => [
    '迷人',
    '美丽',
    '巨大',
    '明亮',
    '干净',
    '聪明',
    '帅气',
    '可爱',
    '狡猾',
    '坚定',
    '有活力',
    '高效',
    '极好',
    '快速',
    '不错',
    '新鲜',
    '好',
    '华丽',
    '伟大',
    '英俊',
    '炽热',
    '善良',
    '诚实',
    '神秘',
    '整洁',
    '开心',
    '耐心',
    '漂亮',
    '强大',
    '富有',
    '秘密',
    '聪明',
    '稳固',
    '特别',
    '战略性',
    '强大',
    '整洁',
    '智慧',
  ];
  @override
  List<String> get fruits => [
    '苹果',
    '鳄梨',
    '香蕉',
    '黑莓',
    '蓝莓',
    '西兰花',
    '胡萝卜',
    '樱桃',
    '椰子',
    '葡萄',
    '柠檬',
    '莴苣',
    '芒果',
    '甜瓜',
    '蘑菇',
    '洋葱',
    '橙子',
    '木瓜',
    '桃子',
    '梨',
    '菠萝',
    '土豆',
    '南瓜',
    '覆盆子',
    '草莓',
    '番茄',
  ];
  @override
  String combination({required Object adjective, required Object fruit}) => '${adjective}的${fruit}';
}

// Path: dialogs
class Translations$dialogs$zh_CN extends Translations$dialogs$en {
  Translations$dialogs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  late final Translations$dialogs$addFile$zh_CN addFile = Translations$dialogs$addFile$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$openFile$zh_CN openFile = Translations$dialogs$openFile$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$addressInput$zh_CN addressInput = Translations$dialogs$addressInput$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$cancelSession$zh_CN cancelSession = Translations$dialogs$cancelSession$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$connectionError$zh_CN connectionError = Translations$dialogs$connectionError$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$deleteSourceAfterSendDialog$zh_CN deleteSourceAfterSendDialog =
      Translations$dialogs$deleteSourceAfterSendDialog$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$cannotOpenFile$zh_CN cannotOpenFile = Translations$dialogs$cannotOpenFile$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$encryptionDisabledNotice$zh_CN encryptionDisabledNotice =
      Translations$dialogs$encryptionDisabledNotice$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$errorDialog$zh_CN errorDialog = Translations$dialogs$errorDialog$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$favoriteDialog$zh_CN favoriteDialog = Translations$dialogs$favoriteDialog$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$favoriteDeleteDialog$zh_CN favoriteDeleteDialog = Translations$dialogs$favoriteDeleteDialog$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$favoriteEditDialog$zh_CN favoriteEditDialog = Translations$dialogs$favoriteEditDialog$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$fileInfo$zh_CN fileInfo = Translations$dialogs$fileInfo$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$fileNameInput$zh_CN fileNameInput = Translations$dialogs$fileNameInput$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$historyClearDialog$zh_CN historyClearDialog = Translations$dialogs$historyClearDialog$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$localNetworkUnauthorized$zh_CN localNetworkUnauthorized =
      Translations$dialogs$localNetworkUnauthorized$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$messageInput$zh_CN messageInput = Translations$dialogs$messageInput$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$noFiles$zh_CN noFiles = Translations$dialogs$noFiles$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$noPermission$zh_CN noPermission = Translations$dialogs$noPermission$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$notAvailableOnPlatform$zh_CN notAvailableOnPlatform = Translations$dialogs$notAvailableOnPlatform$zh_CN.internal(
    _root,
  );
  @override
  late final Translations$dialogs$qr$zh_CN qr = Translations$dialogs$qr$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$quickActions$zh_CN quickActions = Translations$dialogs$quickActions$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$quickSaveNotice$zh_CN quickSaveNotice = Translations$dialogs$quickSaveNotice$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$quickSaveFromFavoritesNotice$zh_CN quickSaveFromFavoritesNotice =
      Translations$dialogs$quickSaveFromFavoritesNotice$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$pin$zh_CN pin = Translations$dialogs$pin$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$sendModeHelp$zh_CN sendModeHelp = Translations$dialogs$sendModeHelp$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$startupError$zh_CN startupError = Translations$dialogs$startupError$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$zoom$zh_CN zoom = Translations$dialogs$zoom$zh_CN.internal(_root);
}

// Path: sanitization
class Translations$sanitization$zh_CN extends Translations$sanitization$en {
  Translations$sanitization$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get empty => '文件名不能为空';
  @override
  String get invalid => '文件名包含无效字符';
}

// Path: tray
class Translations$tray$zh_CN extends Translations$tray$en {
  Translations$tray$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get open => _root.general.open;
  @override
  String get close => '退出 LocalSend';
  @override
  String get closeWindows => '退出';
}

// Path: web
class Translations$web$zh_CN extends Translations$web$en {
  Translations$web$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get waiting => _root.sendPage.waiting;
  @override
  String get enterPin => '输入 PIN';
  @override
  String get invalidPin => 'PIN 无效';
  @override
  String get tooManyAttempts => '尝试次数过多';
  @override
  String get rejected => '已拒绝';
  @override
  String get files => '文件';
  @override
  String get fileName => '文件名';
  @override
  String get size => '大小';
}

// Path: assetPicker
class Translations$assetPicker$zh_CN extends Translations$assetPicker$en {
  Translations$assetPicker$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get confirm => '确认';
  @override
  String get cancel => '取消';
  @override
  String get edit => '编辑';
  @override
  String get gifIndicator => 'GIF';
  @override
  String get loadFailed => '加载失败';
  @override
  String get original => '原文件';
  @override
  String get preview => '预览';
  @override
  String get select => '选择';
  @override
  String get emptyList => '清空列表';
  @override
  String get unSupportedAssetType => '不支持该文件格式';
  @override
  String get unableToAccessAll => '无法访问设备上的所有文件';
  @override
  String get viewingLimitedAssetsTip => '应用程序仅能查看您允许的文件和相册。';
  @override
  String get changeAccessibleLimitedAssets => '点击以更改可访问文件范围';
  @override
  String get accessAllTip => '应用程序只能访问设备上的部分文件，请转到系统设置并允许该应用访问设备上的所有媒体文件。';
  @override
  String get goToSystemSettings => '转到系统设置';
  @override
  String get accessLimitedAssets => '继续受限访问';
  @override
  String get accessiblePathName => '可访问的文件';
  @override
  String get sTypeAudioLabel => '音频';
  @override
  String get sTypeImageLabel => '图片';
  @override
  String get sTypeVideoLabel => '视频';
  @override
  String get sTypeOtherLabel => '其他媒体文件';
  @override
  String get sActionPlayHint => '播放';
  @override
  String get sActionPreviewHint => '预览';
  @override
  String get sActionSelectHint => '选择';
  @override
  String get sActionSwitchPathLabel => '更改路径';
  @override
  String get sActionUseCameraHint => '使用摄像头';
  @override
  String get sNameDurationLabel => '时长';
  @override
  String get sUnitAssetCountLabel => '计数';
}

// Path: receiveTab.infoBox
class Translations$receiveTab$infoBox$zh_CN extends Translations$receiveTab$infoBox$en {
  Translations$receiveTab$infoBox$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get ip => 'IP：';
  @override
  String get port => '端口：';
  @override
  String get alias => '设备名称：';
}

// Path: receiveTab.quickSave
class Translations$receiveTab$quickSave$zh_CN extends Translations$receiveTab$quickSave$en {
  Translations$receiveTab$quickSave$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get off => _root.general.off;
  @override
  String get favorites => '收藏夹';
  @override
  String get on => _root.general.on;
}

// Path: sendTab.selection
class Translations$sendTab$selection$zh_CN extends Translations$sendTab$selection$en {
  Translations$sendTab$selection$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '选择';
  @override
  String files({required Object files}) => '文件：${files}';
  @override
  String size({required Object size}) => '大小：${size}';
}

// Path: sendTab.picker
class Translations$sendTab$picker$zh_CN extends Translations$sendTab$picker$en {
  Translations$sendTab$picker$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get file => '文件';
  @override
  String get folder => '文件夹';
  @override
  String get media => '媒体';
  @override
  String get text => '文本';
  @override
  String get app => '应用';
  @override
  String get clipboard => '剪贴板';
}

// Path: sendTab.sendModes
class Translations$sendTab$sendModes$zh_CN extends Translations$sendTab$sendModes$en {
  Translations$sendTab$sendModes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get single => '一个接收者';
  @override
  String get multiple => '多个接收者';
  @override
  String get link => '通过链接分享';
}

// Path: sendTab.diagnosis
class Translations$sendTab$diagnosis$zh_CN extends Translations$sendTab$diagnosis$en {
  Translations$sendTab$diagnosis$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get scanning => '正在搜索附近的设备……';
  @override
  late final Translations$sendTab$diagnosis$noInterface$zh_CN noInterface = Translations$sendTab$diagnosis$noInterface$zh_CN.internal(_root);
  @override
  late final Translations$sendTab$diagnosis$multicastUnavailable$zh_CN multicastUnavailable =
      Translations$sendTab$diagnosis$multicastUnavailable$zh_CN.internal(_root);
  @override
  late final Translations$sendTab$diagnosis$scanNoResult$zh_CN scanNoResult = Translations$sendTab$diagnosis$scanNoResult$zh_CN.internal(_root);
  @override
  String get rescan => '重新搜索';
  @override
  String get bleHint => 'BLE 发现已启用：只有对方设备也运行此修改版并启用了该选项，才能通过蓝牙发现设备；传输本身仍通过网络进行。';
  @override
  late final Translations$sendTab$diagnosis$manualFallback$zh_CN manualFallback = Translations$sendTab$diagnosis$manualFallback$zh_CN.internal(_root);
}

// Path: settingsTab.general
class Translations$settingsTab$general$zh_CN extends Translations$settingsTab$general$en {
  Translations$settingsTab$general$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '通用';
  @override
  String get brightness => '主题';
  @override
  late final Translations$settingsTab$general$brightnessOptions$zh_CN brightnessOptions =
      Translations$settingsTab$general$brightnessOptions$zh_CN.internal(_root);
  @override
  String get color => '颜色';
  @override
  late final Translations$settingsTab$general$colorOptions$zh_CN colorOptions = Translations$settingsTab$general$colorOptions$zh_CN.internal(_root);
  @override
  String get language => '语言';
  @override
  late final Translations$settingsTab$general$languageOptions$zh_CN languageOptions = Translations$settingsTab$general$languageOptions$zh_CN.internal(
    _root,
  );
  @override
  String get saveWindowPlacement => '退出时保存窗口位置';
  @override
  String get saveWindowPlacementWindows => '退出时保存窗口位置';
  @override
  String get minimizeToTray => '关闭时最小化到系统托盘';
  @override
  String get launchAtStartup => '登录系统后自动启动程序';
  @override
  String get launchMinimized => '启动时最小化到任务栏';
  @override
  String get showInContextMenu => '在“发送到...”文件菜单中显示 LocalSend';
  @override
  String get animations => '动画效果';
}

// Path: settingsTab.receive
class Translations$settingsTab$receive$zh_CN extends Translations$settingsTab$receive$en {
  Translations$settingsTab$receive$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '接收';
  @override
  String get quickSave => _root.general.quickSave;
  @override
  String get quickSaveFromFavorites => _root.general.quickSaveFromFavorites;
  @override
  String get requirePin => _root.webSharePage.requirePin;
  @override
  String get autoFinish => '自动完成传输任务';
  @override
  String get destination => '保存目录';
  @override
  String get downloads => '(下载)';
  @override
  String get saveToGallery => '保存到相册';
  @override
  String get saveToHistory => '保存到历史记录';
  @override
  String get verifyChecksums => '接收文件时验证校验和';
}

// Path: settingsTab.send
class Translations$settingsTab$send$zh_CN extends Translations$settingsTab$send$en {
  Translations$settingsTab$send$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '发送';
  @override
  String get shareViaLinkAutoAccept => '通过链接分享：自动同意接收请求';
  @override
  String get createChecksums => '发送文件时创建校验和';
  @override
  String get deleteSourceAfterSend => '发送成功后删除源文件';
}

// Path: settingsTab.network
class Translations$settingsTab$network$zh_CN extends Translations$settingsTab$network$en {
  Translations$settingsTab$network$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '网络';
  @override
  String get needRestart => '重启服务器后生效！';
  @override
  String get server => '服务器';
  @override
  String get alias => '设备名称';
  @override
  String get deviceType => '设备类型';
  @override
  String get deviceModel => '设备型号';
  @override
  String get port => '端口';
  @override
  String get network => '网络';
  @override
  late final Translations$settingsTab$network$networkOptions$zh_CN networkOptions = Translations$settingsTab$network$networkOptions$zh_CN.internal(
    _root,
  );
  @override
  String get discoveryTimeout => '搜索设备超时';
  @override
  String get maxInterfaces => '最大接口数（智能扫描）';
  @override
  String get vpnInterfaces => '包含 VPN 接口（智能扫描）';
  @override
  String get vpnInterfacesHint => '同时扫描 VPN 隧道接口的子网（Tailscale、WireGuard 等）。VPN 通常不支持多播，因此其子网会改用 HTTP 回退扫描来探测。';
  @override
  String get useSystemName => '使用系统名称';
  @override
  String get generateRandomAlias => '生成随机昵称';
  @override
  String portWarning({required Object defaultPort}) => '由于正在使用自定义端口，你可能不会被其他设备检测到。（默认端口：${defaultPort}）';
  @override
  String get encryption => '加密';
  @override
  String get multicastGroup => '多播';
  @override
  String multicastGroupWarning({required Object defaultMulticast}) => '由于正在使用自定义多播地址，你可能不会被其他设备检测到。（默认地址：${defaultMulticast}）';
  @override
  String get bleDiscovery => 'BLE 发现（实验性）';
  @override
  String get bleDiscoveryHint =>
      '即使网络阻止多播（接入点(AP)隔离），也能通过蓝牙发现附近设备。支持 Android、iOS、macOS 和 Windows；在 Linux 上此设备可以找到其他设备，但无法被其他设备找到。双方设备都需要运行此修改版并启用该选项；文件传输本身仍使用网络。';
  @override
  String get bleStatusActive => '已启用：正在扫描和广播。只有对方设备也运行此修改版并启用该选项，附近设备才会显示。';
  @override
  String get bleStatusScanOnly => '已启用：仅扫描。此设备目前无法通过蓝牙被发现（此平台不支持 BLE 广播，或尚无可用的网络地址）。';
  @override
  String get bleStatusPaused => '已暂停。应用返回前台时会自动恢复。';
  @override
  String get bleStatusPermissionDenied => '蓝牙权限被拒绝。请在系统设置中授予“附近设备”权限（Android 11 及以下版本为“位置”权限），然后将此选项关闭后再重新打开。';
  @override
  String get bleStatusAdapterOff => '蓝牙已关闭或不可用。蓝牙恢复可用后，设备发现会自动重新启动。';
  @override
  String get bleStatusUnsupported => '此设备不支持：BLE 发现需要 Android 7 或更新版本以及蓝牙 LE 无线电。';
  @override
  String get bleStatusLegacyLocation => '在此 Android 版本上，发现其他设备还需要开启系统定位服务（权限会自动请求；此设备已可以被其他设备找到）。';
  @override
  String get bleStatusError => 'BLE 发现无法启动。详情请查看 故障排除 > 日志。';
  @override
  String get bleOpenSystemSettings => '打开系统设置';
}

// Path: settingsTab.other
class Translations$settingsTab$other$zh_CN extends Translations$settingsTab$other$en {
  Translations$settingsTab$other$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '其他';
  @override
  String get support => '支持 LocalSend';
  @override
  String get donate => '捐赠';
  @override
  String get privacyPolicy => '隐私政策';
  @override
  String get termsOfUse => '使用条款';
}

// Path: troubleshootPage.firewall
class Translations$troubleshootPage$firewall$zh_CN extends Translations$troubleshootPage$firewall$en {
  Translations$troubleshootPage$firewall$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => '此设备可以发送文件至其他设备，但其它设备无法发送文件到此设备。';
  @override
  String solution({required Object port}) => '这最可能是由防火墙规则设定引起的。你可以通过在端口 ${port} 上允许（UDP 和 TCP 的）传入请求来解决这个问题。';
  @override
  String get openFirewall => '打开防火墙';
}

// Path: troubleshootPage.noDiscovery
class Translations$troubleshootPage$noDiscovery$zh_CN extends Translations$troubleshootPage$noDiscovery$en {
  Translations$troubleshootPage$noDiscovery$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => '此设备未能发现其他设备。';
  @override
  String get solution => '确保所有设备都处于同一个 Wi‑Fi 网络上，且共享相同的网络配置（端口、多播地址、加密选项）。您可以尝试手动输入目标设备的 IP 地址。如果起到了效果，请考虑将此设备添加到收藏夹中，以便将来可以自动发现。';
}

// Path: troubleshootPage.noConnection
class Translations$troubleshootPage$noConnection$zh_CN extends Translations$troubleshootPage$noConnection$en {
  Translations$troubleshootPage$noConnection$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get symptom => '双方设备均无法发现对方或者分享文件。';
  @override
  String get solution => '当问题发生在双方设备上时，请先确认双方设备处于同一个 Wi‑Fi 网络上，且共享相同的网络配置（端口、多播地址、加密选项）。若因 Wi‑Fi 不允许参与者间通信，那么请在路由器中关闭“接入点(AP)隔离”选项。';
}

// Path: receiveHistoryPage.entryActions
class Translations$receiveHistoryPage$entryActions$zh_CN extends Translations$receiveHistoryPage$entryActions$en {
  Translations$receiveHistoryPage$entryActions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get open => '打开文件';
  @override
  String get showInFolder => '在文件管理器中显示';
  @override
  String get info => '信息';
  @override
  String get deleteFromHistory => '从历史记录中删除';
}

// Path: deviceDetailsPage.info
class Translations$deviceDetailsPage$info$zh_CN extends Translations$deviceDetailsPage$info$en {
  Translations$deviceDetailsPage$info$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get name => '名称';
  @override
  String get address => '地址';
  @override
  String get version => '版本';
  @override
  String protocol({required Object version}) => '协议 v${version}';
}

// Path: deviceDetailsPage.logs
class Translations$deviceDetailsPage$logs$zh_CN extends Translations$deviceDetailsPage$logs$en {
  Translations$deviceDetailsPage$logs$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '日志';
  @override
  String get empty => '没有可用的日志。';
  @override
  String discovered({required Object protocol, required Object host}) => '通过 ${protocol} 发现 (${host})';
  @override
  String updated({required Object protocol, required Object host}) => '通过 ${protocol} 更新 (${host})';
}

// Path: progressPage.checksum
class Translations$progressPage$checksum$zh_CN extends Translations$progressPage$checksum$en {
  Translations$progressPage$checksum$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get verified => '校验和已验证';
  @override
  String partiallyVerified({required Object curr, required Object n}) => '已验证 ${curr} / ${n} 个文件的校验和';
  @override
  String get notVerifiable => '发送方未提供校验和';
  @override
  String get disabled => '校验和验证已禁用';
  @override
  String attached({required Object curr, required Object n}) => '已附加校验和（${curr} / ${n} 个文件）';
}

// Path: progressPage.total
class Translations$progressPage$total$zh_CN extends Translations$progressPage$total$en {
  Translations$progressPage$total$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  late final Translations$progressPage$total$title$zh_CN title = Translations$progressPage$total$title$zh_CN.internal(_root);
  @override
  String count({required Object curr, required Object n}) => '文件：${curr} / ${n}';
  @override
  String size({required Object curr, required Object n}) => '大小：${curr} / ${n}';
  @override
  String speed({required Object speed}) => '速度：${speed}/s';
}

// Path: progressPage.remainingTime
class Translations$progressPage$remainingTime$zh_CN extends Translations$progressPage$remainingTime$en {
  Translations$progressPage$remainingTime$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String minutesUnit({required num m}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(
    m,
    other: '${m}分钟',
  );
  @override
  String hoursUnit({required num h}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('zh'))(
    h,
    other: '${h}小时',
  );
  @override
  String minutes({required Object m, required Object ss}) => '${m}:${ss}';
  @override
  String hours({required num h, required num m}) =>
      '${_root.progressPage.remainingTime.hoursUnit(h: h)} ${_root.progressPage.remainingTime.minutesUnit(m: m)}';
}

// Path: whatsNewPage.changes
class Translations$whatsNewPage$changes$zh_CN extends Translations$whatsNewPage$changes$en {
  Translations$whatsNewPage$changes$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  late final Translations$whatsNewPage$changes$v1_18_0$zh_CN v1_18_0 = Translations$whatsNewPage$changes$v1_18_0$zh_CN.internal(_root);
}

// Path: dialogs.addFile
class Translations$dialogs$addFile$zh_CN extends Translations$dialogs$addFile$en {
  Translations$dialogs$addFile$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '添加文件';
  @override
  String get content => '你想添加什么文件？';
}

// Path: dialogs.openFile
class Translations$dialogs$openFile$zh_CN extends Translations$dialogs$openFile$en {
  Translations$dialogs$openFile$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '打开文件';
  @override
  String get content => '您是否要打开接收的文件？';
}

// Path: dialogs.addressInput
class Translations$dialogs$addressInput$zh_CN extends Translations$dialogs$addressInput$en {
  Translations$dialogs$addressInput$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '输入地址';
  @override
  String get hashtag => '标签';
  @override
  String get ip => 'IP 地址';
  @override
  String get recentlyUsed => '最近使用： ';
  @override
  String get noHashtagCandidates => '当前网络没有 IPv4 地址，因此无法将标签展开为候选地址。请改为输入完整地址（例如 192.168.1.5 或 fe80::1）。';
  @override
  late final Translations$dialogs$addressInput$validation$zh_CN validation = Translations$dialogs$addressInput$validation$zh_CN.internal(_root);
}

// Path: dialogs.cancelSession
class Translations$dialogs$cancelSession$zh_CN extends Translations$dialogs$cancelSession$en {
  Translations$dialogs$cancelSession$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '取消文件传输';
  @override
  String get content => '要取消文件传输吗？';
}

// Path: dialogs.connectionError
class Translations$dialogs$connectionError$zh_CN extends Translations$dialogs$connectionError$en {
  Translations$dialogs$connectionError$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '连接失败';
  @override
  late final Translations$dialogs$connectionError$timeout$zh_CN timeout = Translations$dialogs$connectionError$timeout$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$connectionError$refused$zh_CN refused = Translations$dialogs$connectionError$refused$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$connectionError$forbidden$zh_CN forbidden = Translations$dialogs$connectionError$forbidden$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$connectionError$other$zh_CN other = Translations$dialogs$connectionError$other$zh_CN.internal(_root);
  @override
  String get retry => '重试';
  @override
  String get details => '错误详情：';
}

// Path: dialogs.deleteSourceAfterSendDialog
class Translations$dialogs$deleteSourceAfterSendDialog$zh_CN extends Translations$dialogs$deleteSourceAfterSendDialog$en {
  Translations$dialogs$deleteSourceAfterSendDialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '删除源文件';
  @override
  String get content => '文件发送成功后，将从本设备中删除这些文件。此操作无法撤消。';
}

// Path: dialogs.cannotOpenFile
class Translations$dialogs$cannotOpenFile$zh_CN extends Translations$dialogs$cannotOpenFile$en {
  Translations$dialogs$cannotOpenFile$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '无法打开文件';
  @override
  String content({required Object file}) => '无法打开 “${file}”。这个文件是否已被移动、重命名或删除？';
}

// Path: dialogs.encryptionDisabledNotice
class Translations$dialogs$encryptionDisabledNotice$zh_CN extends Translations$dialogs$encryptionDisabledNotice$en {
  Translations$dialogs$encryptionDisabledNotice$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '加密已关闭';
  @override
  String get content => '正在通过未加密的 HTTP 协议连接。要使用 HTTPS 协议，请开启加密选项。';
}

// Path: dialogs.errorDialog
class Translations$dialogs$errorDialog$zh_CN extends Translations$dialogs$errorDialog$en {
  Translations$dialogs$errorDialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.error;
}

// Path: dialogs.favoriteDialog
class Translations$dialogs$favoriteDialog$zh_CN extends Translations$dialogs$favoriteDialog$en {
  Translations$dialogs$favoriteDialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '收藏夹';
  @override
  String get noFavorites => '还没有收藏的设备。';
  @override
  String get addFavorite => '新建';
}

// Path: dialogs.favoriteDeleteDialog
class Translations$dialogs$favoriteDeleteDialog$zh_CN extends Translations$dialogs$favoriteDeleteDialog$en {
  Translations$dialogs$favoriteDeleteDialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '删除收藏';
  @override
  String content({required Object name}) => '确定要取消收藏 “${name}” 吗?';
}

// Path: dialogs.favoriteEditDialog
class Translations$dialogs$favoriteEditDialog$zh_CN extends Translations$dialogs$favoriteEditDialog$en {
  Translations$dialogs$favoriteEditDialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get titleAdd => '添加到收藏夹';
  @override
  String get titleEdit => '设置';
  @override
  String get name => '名称';
  @override
  String get auto => '(自动)';
  @override
  String get ip => 'IP 地址';
  @override
  String get port => '端口';
}

// Path: dialogs.fileInfo
class Translations$dialogs$fileInfo$zh_CN extends Translations$dialogs$fileInfo$en {
  Translations$dialogs$fileInfo$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '文件信息';
  @override
  String get fileName => '文件名：';
  @override
  String get path => '路径：';
  @override
  String get size => '大小：';
  @override
  String get sender => '发送者：';
  @override
  String get time => '时间：';
}

// Path: dialogs.fileNameInput
class Translations$dialogs$fileNameInput$zh_CN extends Translations$dialogs$fileNameInput$en {
  Translations$dialogs$fileNameInput$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '输入文件名';
  @override
  String original({required Object original}) => '原名：${original}';
}

// Path: dialogs.historyClearDialog
class Translations$dialogs$historyClearDialog$zh_CN extends Translations$dialogs$historyClearDialog$en {
  Translations$dialogs$historyClearDialog$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '清空历史记录';
  @override
  String get content => '确定要清空全部历史记录吗？';
}

// Path: dialogs.localNetworkUnauthorized
class Translations$dialogs$localNetworkUnauthorized$zh_CN extends Translations$dialogs$localNetworkUnauthorized$en {
  Translations$dialogs$localNetworkUnauthorized$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.dialogs.noPermission.title;
  @override
  String get description => 'LocalSend 在没有扫描本地网络的权限的情况下无法找到其他设备。请在设置中授予此权限。';
  @override
  String get gotoSettings => '设置';
}

// Path: dialogs.messageInput
class Translations$dialogs$messageInput$zh_CN extends Translations$dialogs$messageInput$en {
  Translations$dialogs$messageInput$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '输入消息';
  @override
  String get multiline => '多行';
}

// Path: dialogs.noFiles
class Translations$dialogs$noFiles$zh_CN extends Translations$dialogs$noFiles$en {
  Translations$dialogs$noFiles$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '未选择文件';
  @override
  String get content => '请至少选择一个文件。';
}

// Path: dialogs.noPermission
class Translations$dialogs$noPermission$zh_CN extends Translations$dialogs$noPermission$en {
  Translations$dialogs$noPermission$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '没有权限';
  @override
  String get content => '您尚未授予必要的权限。请在设置中授予权限。';
}

// Path: dialogs.notAvailableOnPlatform
class Translations$dialogs$notAvailableOnPlatform$zh_CN extends Translations$dialogs$notAvailableOnPlatform$en {
  Translations$dialogs$notAvailableOnPlatform$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '不可用';
  @override
  String get content => '此功能只在以下平台可用：';
}

// Path: dialogs.qr
class Translations$dialogs$qr$zh_CN extends Translations$dialogs$qr$en {
  Translations$dialogs$qr$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '二维码';
}

// Path: dialogs.quickActions
class Translations$dialogs$quickActions$zh_CN extends Translations$dialogs$quickActions$en {
  Translations$dialogs$quickActions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '快速操作';
  @override
  String get counter => '计数器';
  @override
  String get prefix => '前缀';
  @override
  String get padZero => '以零填充';
  @override
  String get sortBeforeCount => '事先以字母顺序排序';
  @override
  String get random => '随机';
}

// Path: dialogs.quickSaveNotice
class Translations$dialogs$quickSaveNotice$zh_CN extends Translations$dialogs$quickSaveNotice$en {
  Translations$dialogs$quickSaveNotice$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSave;
  @override
  String get content => '自动接受所有文件传输请求。请注意，这会让此网络中的所有人都可以向你发送文件。';
}

// Path: dialogs.quickSaveFromFavoritesNotice
class Translations$dialogs$quickSaveFromFavoritesNotice$zh_CN extends Translations$dialogs$quickSaveFromFavoritesNotice$en {
  Translations$dialogs$quickSaveFromFavoritesNotice$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => _root.general.quickSaveFromFavorites;
  @override
  List<String> get content => [
    '当前会自动接受收藏夹中设备的文件请求。',
  ];
}

// Path: dialogs.pin
class Translations$dialogs$pin$zh_CN extends Translations$dialogs$pin$en {
  Translations$dialogs$pin$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '输入 PIN';
}

// Path: dialogs.sendModeHelp
class Translations$dialogs$sendModeHelp$zh_CN extends Translations$dialogs$sendModeHelp$en {
  Translations$dialogs$sendModeHelp$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '发送模式';
  @override
  String get single => '发送文件给一个接收者。已选择的文件在发送后会取消选择。';
  @override
  String get multiple => '发送文件给多个接收者。已选择的文件在发送后不会取消选择。';
  @override
  String get link => '未安装 LocalSend 的接收者可以在浏览器中打开链接以下载选中的文件。';
}

// Path: dialogs.startupError
class Translations$dialogs$startupError$zh_CN extends Translations$dialogs$startupError$en {
  Translations$dialogs$startupError$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '无法启动服务器';
  @override
  String port({required Object port}) => '端口：${port}';
  @override
  late final Translations$dialogs$startupError$windowsAccessDenied$zh_CN windowsAccessDenied =
      Translations$dialogs$startupError$windowsAccessDenied$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$startupError$addressInUse$zh_CN addressInUse = Translations$dialogs$startupError$addressInUse$zh_CN.internal(_root);
  @override
  late final Translations$dialogs$startupError$generic$zh_CN generic = Translations$dialogs$startupError$generic$zh_CN.internal(_root);
  @override
  String get details => '错误详情：';
  @override
  String get copyDetails => '复制详情';
  @override
  String get openSettings => '打开设置';
}

// Path: dialogs.zoom
class Translations$dialogs$zoom$zh_CN extends Translations$dialogs$zoom$en {
  Translations$dialogs$zoom$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'URL';
}

// Path: sendTab.diagnosis.noInterface
class Translations$sendTab$diagnosis$noInterface$zh_CN extends Translations$sendTab$diagnosis$noInterface$en {
  Translations$sendTab$diagnosis$noInterface$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '未连接到网络';
  @override
  String get advice => '此设备未连接到任何网络。请检查此设备的 Wi‑Fi 或网线连接。';
}

// Path: sendTab.diagnosis.multicastUnavailable
class Translations$sendTab$diagnosis$multicastUnavailable$zh_CN extends Translations$sendTab$diagnosis$multicastUnavailable$en {
  Translations$sendTab$diagnosis$multicastUnavailable$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '多播不可用';
  @override
  String advice({required Object port}) => 'LocalSend 无法在此网络中使用多播发现设备。请确保两台设备处于同一网络，并且接入点(AP)隔离或防火墙没有阻止 UDP 端口 ${port}。';
  @override
  String reason({required Object reason}) => '原因：${reason}';
}

// Path: sendTab.diagnosis.scanNoResult
class Translations$sendTab$diagnosis$scanNoResult$zh_CN extends Translations$sendTab$diagnosis$scanNoResult$en {
  Translations$sendTab$diagnosis$scanNoResult$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get title => '未找到设备';
  @override
  String get advice => '设备发现功能正常，但没有设备响应通告或网络扫描。对方设备可能已离线、休眠，或被防火墙拦截。请确保对方设备正在运行 LocalSend。';
  @override
  String detail({required Object announcements, required Object scans}) => '已发送 ${announcements} 次通告和 ${scans} 次网络扫描，均未收到响应。';
}

// Path: sendTab.diagnosis.manualFallback
class Translations$sendTab$diagnosis$manualFallback$zh_CN extends Translations$sendTab$diagnosis$manualFallback$en {
  Translations$sendTab$diagnosis$manualFallback$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get message => 'IP 地址经常变化。你仍可以连接未显示在列表中的设备：将其添加到收藏夹，或手动输入其地址。';
  @override
  String get openFavorites => '打开收藏夹';
  @override
  String get manualInput => '手动输入地址';
}

// Path: settingsTab.general.brightnessOptions
class Translations$settingsTab$general$brightnessOptions$zh_CN extends Translations$settingsTab$general$brightnessOptions$en {
  Translations$settingsTab$general$brightnessOptions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get system => '跟随系统';
  @override
  String get dark => '深色';
  @override
  String get light => '浅色';
}

// Path: settingsTab.general.colorOptions
class Translations$settingsTab$general$colorOptions$zh_CN extends Translations$settingsTab$general$colorOptions$en {
  Translations$settingsTab$general$colorOptions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get system => '跟随系统';
  @override
  String get oled => 'OLED';
  @override
  String get custom => '自定义';
}

// Path: settingsTab.general.languageOptions
class Translations$settingsTab$general$languageOptions$zh_CN extends Translations$settingsTab$general$languageOptions$en {
  Translations$settingsTab$general$languageOptions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get system => '跟随系统';
}

// Path: settingsTab.network.networkOptions
class Translations$settingsTab$network$networkOptions$zh_CN extends Translations$settingsTab$network$networkOptions$en {
  Translations$settingsTab$network$networkOptions$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get all => '所有';
  @override
  String get filtered => '已过滤';
}

// Path: progressPage.total.title
class Translations$progressPage$total$title$zh_CN extends Translations$progressPage$total$title$en {
  Translations$progressPage$total$title$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String sending({required Object time}) => '总进度 (${time})';
  @override
  String get finishedError => '已完成，但发生错误';
  @override
  String get canceledSender => '发送者已取消';
  @override
  String get canceledReceiver => '接收者已取消';
}

// Path: whatsNewPage.changes.v1_18_0
class Translations$whatsNewPage$changes$v1_18_0$zh_CN extends Translations$whatsNewPage$changes$v1_18_0$en with WhatsNewStrings {
  Translations$whatsNewPage$changes$v1_18_0$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  List<String> get changes => [
    '加密不再减缓传输速度。如果您之前将其关闭，则现在已在此设备上重新启用。',
    '来自收藏夹的请求现在会被自动接受。这项功能是默认打开的，可以在设置中禁用。',
    '在Android上，当应用处于后台或屏幕关闭时，传输仍会继续。在iOS上，应用仍必须保持在前台。',
  ];
}

// Path: dialogs.addressInput.validation
class Translations$dialogs$addressInput$validation$zh_CN extends Translations$dialogs$addressInput$validation$en {
  Translations$dialogs$addressInput$validation$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get invalid => '请输入有效的 IPv4 地址、IPv6 地址或主机名。';
  @override
  String get scheme => '请只输入地址，无需包含“http://”或“https://”。';
  @override
  String get port => '请只输入地址。端口将使用设置中的值。';
}

// Path: dialogs.connectionError.timeout
class Translations$dialogs$connectionError$timeout$zh_CN extends Translations$dialogs$connectionError$timeout$en {
  Translations$dialogs$connectionError$timeout$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get message => '设备未及时响应。';
  @override
  String get advice => '对方设备可能已离线、休眠，或被防火墙阻止连接。请确保对方设备正在运行 LocalSend，且两台设备处于同一网络。';
}

// Path: dialogs.connectionError.refused
class Translations$dialogs$connectionError$refused$zh_CN extends Translations$dialogs$connectionError$refused$en {
  Translations$dialogs$connectionError$refused$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get message => '设备拒绝了连接。';
  @override
  String get advice => '目标设备上似乎没有运行 LocalSend，或其正在使用其他端口。请在对方设备上启动 LocalSend，或检查端口。';
}

// Path: dialogs.connectionError.forbidden
class Translations$dialogs$connectionError$forbidden$zh_CN extends Translations$dialogs$connectionError$forbidden$en {
  Translations$dialogs$connectionError$forbidden$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get message => '设备拒绝了请求。';
  @override
  String get advice => '可能需要输入 PIN，或与该设备的配对已发生变化。请检查目标设备上的 PIN 和自动保存设置。';
}

// Path: dialogs.connectionError.other
class Translations$dialogs$connectionError$other$zh_CN extends Translations$dialogs$connectionError$other$en {
  Translations$dialogs$connectionError$other$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get message => '无法建立连接。';
  @override
  String get advice => '请检查地址和端口，确保目标设备正在运行 LocalSend，并确认没有防火墙或 VPN 阻止连接。';
}

// Path: dialogs.startupError.windowsAccessDenied
class Translations$dialogs$startupError$windowsAccessDenied$zh_CN extends Translations$dialogs$startupError$windowsAccessDenied$en {
  Translations$dialogs$startupError$windowsAccessDenied$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get hint => 'Windows 拒绝访问该端口（套接字错误 10013）。';
  @override
  String get advice =>
      '这通常是由 Hyper-V、WSL 或 Docker 保留的端口范围，或损坏的 Winsock 目录引起的：\n• 在设置（网络）中更改端口\n• 使用以下命令检查保留范围：netsh interface ipv4 show excludedportrange protocol=tcp\n• 以管理员身份修复 Winsock：netsh winsock reset（之后重启电脑）';
}

// Path: dialogs.startupError.addressInUse
class Translations$dialogs$startupError$addressInUse$zh_CN extends Translations$dialogs$startupError$addressInUse$en {
  Translations$dialogs$startupError$addressInUse$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get hint => '该端口已被其他应用程序占用。';
  @override
  String get advice => '另一个程序（或第二个 LocalSend 实例）正在监听此端口：\n• 关闭该应用程序，或\n• 在设置（网络）中更改端口';
}

// Path: dialogs.startupError.generic
class Translations$dialogs$startupError$generic$zh_CN extends Translations$dialogs$startupError$generic$en {
  Translations$dialogs$startupError$generic$zh_CN.internal(TranslationsZhCn root) : this._root = root, super.internal(root);

  final TranslationsZhCn _root; // ignore: unused_field

  // Translations
  @override
  String get hint => '服务器无法启动。';
  @override
  String get advice => '• 检查防火墙和网络设置\n• 尝试在设置（网络）中更改端口';
}
