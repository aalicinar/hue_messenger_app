import 'package:flutter/widgets.dart';

import 'locale_provider.dart';

/// All user-facing strings in the app, keyed by AppLanguage.
class S {
  const S._();

  static String of(BuildContext context, String key) {
    // This is a simple lookup; context is reserved for future InheritedWidget use.
    throw UnsupportedError('Use S.get(language, key) instead');
  }

  static String get(AppLanguage lang, String key) {
    return _strings[lang]?[key] ?? _strings[AppLanguage.english]?[key] ?? key;
  }

  static final Map<AppLanguage, Map<String, String>> _strings = {
    // ═══════════════════════════════════════════════════
    //  TURKISH
    // ═══════════════════════════════════════════════════
    AppLanguage.turkish: {
      // ── Tabs ──
      'tab_hue_box': 'Hue Box',
      'tab_chats': 'Sohbetler',
      'tab_settings': 'Ayarlar',

      // ── Chats screen ──
      'chats_title': 'Sohbetler',
      'chats_header': 'Konuşmalar',
      'chats_active_count': '{n} aktif sohbet',
      'chats_empty': 'Henüz sohbet yok.',
      'chats_new': 'Yeni Sohbet Başlat',
      'chats_new_title': 'Yeni Sohbet Başlat',
      'chats_unknown': 'Bilinmiyor',
      'chats_no_message': 'Henüz mesaj yok',
      'cancel': 'Vazgeç',

      // ── Hue Box screen ──
      'hue_box_title': 'Hue Box',
      'hue_box_header': 'Sakin Kutu',
      'hue_box_pending': '{n} bekleyen onay',
      'hue_box_empty_all': 'Hue Box şu an boş.',
      'hue_box_empty_filter': 'Bu filtrede öğe yok.',
      'hue_box_empty_hint': 'H mesajları buraya düşecek',
      'hue_box_quick_ack': 'Hızlı onay',
      'hue_box_reply': 'Yanıtla',
      'hue_box_reply_title': 'Hızlı Yanıt',
      'hue_box_reply_message': 'Onay için bir yanıt seç.',

      // ── Filter ──
      'filter_all': 'Tümü',

      // ── Settings screen ──
      'settings_title': 'Ayarlar',
      'settings_app_name': 'Hue Messenger',
      'settings_phase': 'Aşama A – Yerel Mock',
      'settings_theme': 'Tema Stili',
      'settings_templates': 'Şablonlar',
      'settings_templates_sub': 'H şablonlarını yönet',
      'settings_rate_limit': 'Gönderim Aralığı',
      'settings_rate_limit_sub': 'Kategori bekleme ayarları',
      'settings_ack_replies': 'Onay Yanıtları',
      'settings_ack_replies_sub': 'En fazla 3 hızlı yanıt',
      'settings_version': 'Sürüm',
      'settings_language': 'Dil',
      'settings_language_sub': 'Uygulama dilini değiştir',
      'settings_language_title': 'Dil Seçin',

      // ── Theme picker ──
      'theme_picker_title': 'Tema Stilini Seç',
      'theme_picker_message': 'Uygulamanın görsel yönünü seç.',

      // ── Chat detail ──
      'chat_empty': 'Henüz mesaj yok.',
      'chat_composer_placeholder': 'Mesaj yaz...',
      'chat_rate_limit_title': 'Gönderim Sınırı Aktif',
      'chat_rate_limit_body':
          'Seçili H kategorisinde geçici sınır var. {t} sonra tekrar dene.',

      // ── Hue bubble ──
      'hue_label': 'H Mesajı',

      // ── Hue sheet ──
      'hue_sheet_title': 'H Şablonu Seç',
      'hue_sheet_empty': 'Bu kategoride şablon yok.',

      // ── Categories ──
      'category_red': 'Kırmızı',
      'category_yellow': 'Sarı',
      'category_green': 'Yeşil',
      'category_blue': 'Mavi',
    },

    // ═══════════════════════════════════════════════════
    //  ENGLISH
    // ═══════════════════════════════════════════════════
    AppLanguage.english: {
      'tab_hue_box': 'Hue Box',
      'tab_chats': 'Chats',
      'tab_settings': 'Settings',

      'chats_title': 'Chats',
      'chats_header': 'Conversations',
      'chats_active_count': '{n} active chats',
      'chats_empty': 'No chats yet.',
      'chats_new': 'Start New Chat',
      'chats_new_title': 'Start New Chat',
      'chats_unknown': 'Unknown',
      'chats_no_message': 'No messages yet',
      'cancel': 'Cancel',

      'hue_box_title': 'Hue Box',
      'hue_box_header': 'Calm Box',
      'hue_box_pending': '{n} pending approval',
      'hue_box_empty_all': 'Hue Box is empty.',
      'hue_box_empty_filter': 'No items in this filter.',
      'hue_box_empty_hint': 'H messages will appear here',
      'hue_box_quick_ack': 'Quick acknowledge',
      'hue_box_reply': 'Reply',
      'hue_box_reply_title': 'Quick Reply',
      'hue_box_reply_message': 'Choose a reply to acknowledge.',

      'filter_all': 'All',

      'settings_title': 'Settings',
      'settings_app_name': 'Hue Messenger',
      'settings_phase': 'Phase A – Local Mock',
      'settings_theme': 'Theme Style',
      'settings_templates': 'Templates',
      'settings_templates_sub': 'Manage H templates',
      'settings_rate_limit': 'Send Interval',
      'settings_rate_limit_sub': 'Category cooldown settings',
      'settings_ack_replies': 'Ack Replies',
      'settings_ack_replies_sub': 'Up to 3 quick replies',
      'settings_version': 'Version',
      'settings_language': 'Language',
      'settings_language_sub': 'Change app language',
      'settings_language_title': 'Select Language',

      'theme_picker_title': 'Select Theme Style',
      'theme_picker_message': 'Choose the visual style of the app.',

      'chat_empty': 'No messages yet.',
      'chat_composer_placeholder': 'Type a message...',
      'chat_rate_limit_title': 'Send Limit Active',
      'chat_rate_limit_body':
          'There is a temporary limit on the selected H category. Try again after {t}.',

      'hue_label': 'H Message',

      'hue_sheet_title': 'Select H Template',
      'hue_sheet_empty': 'No templates in this category.',

      'category_red': 'Red',
      'category_yellow': 'Yellow',
      'category_green': 'Green',
      'category_blue': 'Blue',
    },

    // ═══════════════════════════════════════════════════
    //  RUSSIAN
    // ═══════════════════════════════════════════════════
    AppLanguage.russian: {
      'tab_hue_box': 'Hue Box',
      'tab_chats': 'Чаты',
      'tab_settings': 'Настройки',

      'chats_title': 'Чаты',
      'chats_header': 'Переписки',
      'chats_active_count': '{n} активных чатов',
      'chats_empty': 'Чатов пока нет.',
      'chats_new': 'Начать новый чат',
      'chats_new_title': 'Начать новый чат',
      'chats_unknown': 'Неизвестно',
      'chats_no_message': 'Сообщений пока нет',
      'cancel': 'Отмена',

      'hue_box_title': 'Hue Box',
      'hue_box_header': 'Спокойный ящик',
      'hue_box_pending': '{n} ожидает подтверждения',
      'hue_box_empty_all': 'Hue Box пуст.',
      'hue_box_empty_filter': 'Нет элементов в этом фильтре.',
      'hue_box_empty_hint': 'Сообщения H появятся здесь',
      'hue_box_quick_ack': 'Быстрое подтверждение',
      'hue_box_reply': 'Ответить',
      'hue_box_reply_title': 'Быстрый ответ',
      'hue_box_reply_message': 'Выберите ответ для подтверждения.',

      'filter_all': 'Все',

      'settings_title': 'Настройки',
      'settings_app_name': 'Hue Messenger',
      'settings_phase': 'Фаза A – Локальный мок',
      'settings_theme': 'Стиль темы',
      'settings_templates': 'Шаблоны',
      'settings_templates_sub': 'Управление шаблонами H',
      'settings_rate_limit': 'Интервал отправки',
      'settings_rate_limit_sub': 'Настройки ожидания по категориям',
      'settings_ack_replies': 'Ответы на подтверждение',
      'settings_ack_replies_sub': 'До 3 быстрых ответов',
      'settings_version': 'Версия',
      'settings_language': 'Язык',
      'settings_language_sub': 'Изменить язык приложения',
      'settings_language_title': 'Выберите язык',

      'theme_picker_title': 'Выберите стиль темы',
      'theme_picker_message': 'Выберите визуальный стиль приложения.',

      'chat_empty': 'Сообщений пока нет.',
      'chat_composer_placeholder': 'Напишите сообщение...',
      'chat_rate_limit_title': 'Лимит отправки',
      'chat_rate_limit_body':
          'Временное ограничение на выбранную категорию H. Попробуйте снова через {t}.',

      'hue_label': 'Сообщение H',

      'hue_sheet_title': 'Выберите шаблон H',
      'hue_sheet_empty': 'Нет шаблонов в этой категории.',

      'category_red': 'Красный',
      'category_yellow': 'Жёлтый',
      'category_green': 'Зелёный',
      'category_blue': 'Синий',
    },

    // ═══════════════════════════════════════════════════
    //  JAPANESE
    // ═══════════════════════════════════════════════════
    AppLanguage.japanese: {
      'tab_hue_box': 'Hue Box',
      'tab_chats': 'チャット',
      'tab_settings': '設定',

      'chats_title': 'チャット',
      'chats_header': '会話',
      'chats_active_count': '{n}のアクティブチャット',
      'chats_empty': 'チャットはまだありません。',
      'chats_new': '新しいチャットを開始',
      'chats_new_title': '新しいチャットを開始',
      'chats_unknown': '不明',
      'chats_no_message': 'メッセージはまだありません',
      'cancel': 'キャンセル',

      'hue_box_title': 'Hue Box',
      'hue_box_header': '静かな箱',
      'hue_box_pending': '{n}件の承認待ち',
      'hue_box_empty_all': 'Hue Boxは空です。',
      'hue_box_empty_filter': 'このフィルターにはアイテムがありません。',
      'hue_box_empty_hint': 'Hメッセージはここに表示されます',
      'hue_box_quick_ack': 'クイック承認',
      'hue_box_reply': '返信',
      'hue_box_reply_title': 'クイック返信',
      'hue_box_reply_message': '承認のための返信を選んでください。',

      'filter_all': 'すべて',

      'settings_title': '設定',
      'settings_app_name': 'Hue Messenger',
      'settings_phase': 'フェーズA – ローカルモック',
      'settings_theme': 'テーマスタイル',
      'settings_templates': 'テンプレート',
      'settings_templates_sub': 'Hテンプレートを管理',
      'settings_rate_limit': '送信間隔',
      'settings_rate_limit_sub': 'カテゴリの待機設定',
      'settings_ack_replies': '承認返信',
      'settings_ack_replies_sub': '最大3つのクイック返信',
      'settings_version': 'バージョン',
      'settings_language': '言語',
      'settings_language_sub': 'アプリの言語を変更',
      'settings_language_title': '言語を選択',

      'theme_picker_title': 'テーマスタイルを選択',
      'theme_picker_message': 'アプリのビジュアルスタイルを選んでください。',

      'chat_empty': 'メッセージはまだありません。',
      'chat_composer_placeholder': 'メッセージを入力...',
      'chat_rate_limit_title': '送信制限中',
      'chat_rate_limit_body': '選択したHカテゴリに一時的な制限があります。{t}後に再試行してください。',

      'hue_label': 'Hメッセージ',

      'hue_sheet_title': 'Hテンプレートを選択',
      'hue_sheet_empty': 'このカテゴリにはテンプレートがありません。',

      'category_red': '赤',
      'category_yellow': '黄',
      'category_green': '緑',
      'category_blue': '青',
    },

    // ═══════════════════════════════════════════════════
    //  CHINESE
    // ═══════════════════════════════════════════════════
    AppLanguage.chinese: {
      'tab_hue_box': 'Hue Box',
      'tab_chats': '聊天',
      'tab_settings': '设置',

      'chats_title': '聊天',
      'chats_header': '会话',
      'chats_active_count': '{n}个活跃聊天',
      'chats_empty': '暂无聊天。',
      'chats_new': '开始新聊天',
      'chats_new_title': '开始新聊天',
      'chats_unknown': '未知',
      'chats_no_message': '暂无消息',
      'cancel': '取消',

      'hue_box_title': 'Hue Box',
      'hue_box_header': '静音箱',
      'hue_box_pending': '{n}个待确认',
      'hue_box_empty_all': 'Hue Box 为空。',
      'hue_box_empty_filter': '此筛选下无项目。',
      'hue_box_empty_hint': 'H消息将在此显示',
      'hue_box_quick_ack': '快速确认',
      'hue_box_reply': '回复',
      'hue_box_reply_title': '快速回复',
      'hue_box_reply_message': '选择一个回复来确认。',

      'filter_all': '全部',

      'settings_title': '设置',
      'settings_app_name': 'Hue Messenger',
      'settings_phase': '阶段A – 本地模拟',
      'settings_theme': '主题样式',
      'settings_templates': '模板',
      'settings_templates_sub': '管理H模板',
      'settings_rate_limit': '发送间隔',
      'settings_rate_limit_sub': '分类冷却设置',
      'settings_ack_replies': '确认回复',
      'settings_ack_replies_sub': '最多3个快捷回复',
      'settings_version': '版本',
      'settings_language': '语言',
      'settings_language_sub': '更改应用语言',
      'settings_language_title': '选择语言',

      'theme_picker_title': '选择主题样式',
      'theme_picker_message': '选择应用的视觉样式。',

      'chat_empty': '暂无消息。',
      'chat_composer_placeholder': '输入消息...',
      'chat_rate_limit_title': '发送限制中',
      'chat_rate_limit_body': '所选H分类有临时限制。请在{t}后重试。',

      'hue_label': 'H消息',

      'hue_sheet_title': '选择H模板',
      'hue_sheet_empty': '此分类中无模板。',

      'category_red': '红色',
      'category_yellow': '黄色',
      'category_green': '绿色',
      'category_blue': '蓝色',
    },
  };
}
