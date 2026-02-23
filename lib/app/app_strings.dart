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
      'chats_search': 'Sohbet veya kişi ara...',
      'cancel': 'Vazgeç',

      // ── Hue Box screen ──
      'hue_box_title': 'Hue Box',
      'hue_box_header': 'Hue Gelen',
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
      'chat_online': 'Çevrimiçi',
      'chat_today': 'Bugün',
      'chat_yesterday': 'Dün',
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

      // ── Login / Register ──
      'login_tab_login': 'Giriş Yap',
      'login_tab_register': 'Kayıt Ol',
      'login_phone_hint': 'Telefon numarası',
      'login_name_hint': 'Adınız',
      'login_login_btn': 'Giriş Yap',
      'login_register_btn': 'Kayıt Ol',

      // ── Common ──
      'common_ok': 'Tamam',
      'common_yes': 'Evet',
      'common_no': 'Hayır',
      'common_add': 'Ekle',
      'common_save': 'Kaydet',
      'common_delete': 'Sil',
      'common_other': 'Diğer',
      'common_send': 'Gönder',
      'common_could_not_save': 'Kaydedilemedi',

      // ── Chat detail extras ──
      'chat_wait_moment': 'birazdan',

      // ── Templates screen ──
      'templates_nav_title': 'Şablonlar',
      'templates_custom_count': 'Özel şablon: {n}/10',
      'templates_empty': 'Bu kategoride şablon yok.',
      'templates_add_button': 'Şablon Ekle',
      'templates_limit_error':
          'Bu kategoride en fazla 10 özel şablon olabilir.',
      'templates_new_title': 'Yeni Şablon',
      'templates_edit_title': 'Şablonu Düzenle',
      'templates_input_placeholder': 'Şablon metni',
      'templates_delete_title': 'Şablon silinsin mi?',
      'templates_delete_body': 'Bu işlem geri alınamaz.',
      'templates_default_label': 'Varsayılan',
      'templates_custom_label': 'Özel',

      // ── Ack replies screen ──
      'ack_replies_nav_title': 'Onay Yanıtları',
      'ack_replies_description':
          'H mesajı onaylarken kullanılan hızlı yanıtlar.',
      'ack_replies_count': '{n}/3 seçenek',
      'ack_replies_empty': 'Henüz yanıt seçeneği yok.',
      'ack_replies_add_button': 'Yanıt Seçeneği Ekle',
      'ack_replies_limit_error': 'En fazla 3 yanıt seçeneği tanımlayabilirsin.',
      'ack_replies_new_title': 'Yeni Yanıt Seçeneği',
      'ack_replies_edit_title': 'Yanıt Seçeneğini Düzenle',
      'ack_replies_input_placeholder': 'Yanıt metni',
      'ack_replies_delete_title': 'Yanıt seçeneği silinsin mi?',
      'ack_replies_delete_body': 'Bu işlem geri alınamaz.',

      // ── Ack reply sheet ──
      'ack_sheet_custom_placeholder': 'Kendi yanıtını yaz',
      'ack_sheet_use_quick': 'Hazırları kullan',
      'ack_sheet_reply_empty': 'Yanıt metni boş olamaz.',
      'ack_sheet_reply_too_long': 'Yanıt en fazla 24 karakter olabilir.',

      // ── Rate limits screen ──
      'rate_limits_nav_title': 'Gönderim Aralığı',
      'rate_limits_description':
          'Alıcı, her H kategorisi için en az gönderim aralığını belirler.',
      'rate_limits_sheet_title': 'H Aralığı',
      'rate_limits_unlimited': 'Sınırsız',
      'rate_limits_category_label': 'H Kategorisi',
      'rate_limits_unit_sec': 'sn',
      'rate_limits_unit_min': 'dk',
      'rate_limits_unit_hour': 'sa',
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
      'chats_search': 'Search chats or people...',
      'cancel': 'Cancel',

      'hue_box_title': 'Hue Box',
      'hue_box_header': 'Hue Inbox',
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
      'chat_online': 'Online',
      'chat_today': 'Today',
      'chat_yesterday': 'Yesterday',
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

      // ── Login / Register ──
      'login_tab_login': 'Log In',
      'login_tab_register': 'Sign Up',
      'login_phone_hint': 'Phone number',
      'login_name_hint': 'Your name',
      'login_login_btn': 'Log In',
      'login_register_btn': 'Sign Up',

      'common_ok': 'OK',
      'common_yes': 'Yes',
      'common_no': 'No',
      'common_add': 'Add',
      'common_save': 'Save',
      'common_delete': 'Delete',
      'common_other': 'Other',
      'common_send': 'Send',
      'common_could_not_save': 'Could not save',

      'chat_wait_moment': 'a moment',

      'templates_nav_title': 'Templates',
      'templates_custom_count': 'Custom templates: {n}/10',
      'templates_empty': 'No templates in this category.',
      'templates_add_button': 'Add Template',
      'templates_limit_error':
          'At most 10 custom templates are allowed in this category.',
      'templates_new_title': 'New Template',
      'templates_edit_title': 'Edit Template',
      'templates_input_placeholder': 'Template text',
      'templates_delete_title': 'Delete template?',
      'templates_delete_body': 'This action cannot be undone.',
      'templates_default_label': 'Default',
      'templates_custom_label': 'Custom',

      'ack_replies_nav_title': 'Ack Replies',
      'ack_replies_description': 'Quick replies used while acknowledging H.',
      'ack_replies_count': '{n}/3 options',
      'ack_replies_empty': 'No reply option yet.',
      'ack_replies_add_button': 'Add Reply Option',
      'ack_replies_limit_error': 'You can define up to 3 reply options.',
      'ack_replies_new_title': 'New Reply Option',
      'ack_replies_edit_title': 'Edit Reply Option',
      'ack_replies_input_placeholder': 'Reply text',
      'ack_replies_delete_title': 'Delete reply option?',
      'ack_replies_delete_body': 'This action cannot be undone.',

      'ack_sheet_custom_placeholder': 'Write your own reply',
      'ack_sheet_use_quick': 'Use quick replies',
      'ack_sheet_reply_empty': 'Reply text cannot be empty.',
      'ack_sheet_reply_too_long': 'Reply must be 24 characters or fewer.',

      'rate_limits_nav_title': 'Send Interval',
      'rate_limits_description':
          'Set the minimum send interval per H category for each recipient.',
      'rate_limits_sheet_title': 'H Interval',
      'rate_limits_unlimited': 'Unlimited',
      'rate_limits_category_label': 'H Category',
      'rate_limits_unit_sec': 's',
      'rate_limits_unit_min': 'm',
      'rate_limits_unit_hour': 'h',
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
      'chats_search': 'Поиск чатов и людей...',
      'cancel': 'Отмена',

      'hue_box_title': 'Hue Box',
      'hue_box_header': 'Hue Входящие',
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
      'chat_online': 'В сети',
      'chat_today': 'Сегодня',
      'chat_yesterday': 'Вчера',
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

      // ── Login / Register ──
      'login_tab_login': 'Войти',
      'login_tab_register': 'Регистрация',
      'login_phone_hint': 'Номер телефона',
      'login_name_hint': 'Ваше имя',
      'login_login_btn': 'Войти',
      'login_register_btn': 'Зарегистрироваться',

      // ── Common ──
      'common_ok': 'ОК',
      'common_yes': 'Да',
      'common_no': 'Нет',
      'common_add': 'Добавить',
      'common_save': 'Сохранить',
      'common_delete': 'Удалить',
      'common_other': 'Другое',
      'common_send': 'Отправить',
      'common_could_not_save': 'Не удалось сохранить',

      'chat_wait_moment': 'через мгновение',

      // ── Templates screen ──
      'templates_nav_title': 'Шаблоны',
      'templates_custom_count': 'Пользовательских шаблонов: {n}/10',
      'templates_empty': 'Нет шаблонов в этой категории.',
      'templates_add_button': 'Добавить шаблон',
      'templates_limit_error':
          'В этой категории допускается не более 10 пользовательских шаблонов.',
      'templates_new_title': 'Новый шаблон',
      'templates_edit_title': 'Редактировать шаблон',
      'templates_input_placeholder': 'Текст шаблона',
      'templates_delete_title': 'Удалить шаблон?',
      'templates_delete_body': 'Это действие нельзя отменить.',
      'templates_default_label': 'По умолчанию',
      'templates_custom_label': 'Пользовательские',

      // ── Ack replies screen ──
      'ack_replies_nav_title': 'Ответы для подтверждения',
      'ack_replies_description':
          'Быстрые ответы, используемые при подтверждении H.',
      'ack_replies_count': '{n}/3 вариантов',
      'ack_replies_empty': 'Нет вариантов ответов.',
      'ack_replies_add_button': 'Добавить ответ',
      'ack_replies_limit_error': 'Можно определить до 3 вариантов ответа.',
      'ack_replies_new_title': 'Новый вариант ответа',
      'ack_replies_edit_title': 'Редактировать ответ',
      'ack_replies_input_placeholder': 'Текст ответа',
      'ack_replies_delete_title': 'Удалить вариант ответа?',
      'ack_replies_delete_body': 'Это действие нельзя отменить.',

      // ── Ack reply sheet ──
      'ack_sheet_custom_placeholder': 'Напишите свой ответ',
      'ack_sheet_use_quick': 'Использовать быстрые ответы',
      'ack_sheet_reply_empty': 'Текст ответа не может быть пустым.',
      'ack_sheet_reply_too_long': 'Ответ не должен превышать 24 символа.',

      // ── Rate limits screen ──
      'rate_limits_nav_title': 'Интервал отправки',
      'rate_limits_description':
          'Установите минимальный интервал отправки для каждой категории H.',
      'rate_limits_sheet_title': 'Интервал H',
      'rate_limits_unlimited': 'Без ограничений',
      'rate_limits_category_label': 'Категория H',
      'rate_limits_unit_sec': 'с',
      'rate_limits_unit_min': 'м',
      'rate_limits_unit_hour': 'ч',
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
      'chats_search': 'チャットや人を検索...',
      'cancel': 'キャンセル',

      'hue_box_title': 'Hue Box',
      'hue_box_header': 'Hue 受信箱',
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
      'chat_online': 'オンライン',
      'chat_today': '今日',
      'chat_yesterday': '昨日',
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

      // ── Login / Register ──
      'login_tab_login': 'ログイン',
      'login_tab_register': 'サインアップ',
      'login_phone_hint': '電話番号',
      'login_name_hint': 'お名前',
      'login_login_btn': 'ログイン',
      'login_register_btn': 'サインアップ',

      // ── Common ──
      'common_ok': 'OK',
      'common_yes': 'はい',
      'common_no': 'いいえ',
      'common_add': '追加',
      'common_save': '保存',
      'common_delete': '削除',
      'common_other': 'その他',
      'common_send': '送信',
      'common_could_not_save': '保存できませんでした',

      'chat_wait_moment': 'まもなく',

      // ── Templates screen ──
      'templates_nav_title': 'テンプレート',
      'templates_custom_count': 'カスタムテンプレート: {n}/10',
      'templates_empty': 'このカテゴリにはテンプレートがありません。',
      'templates_add_button': 'テンプレートを追加',
      'templates_limit_error': 'このカテゴリでは最大10個のカスタムテンプレートが許可されています。',
      'templates_new_title': '新しいテンプレート',
      'templates_edit_title': 'テンプレートを編集',
      'templates_input_placeholder': 'テンプレートテキスト',
      'templates_delete_title': 'テンプレートを削除しますか？',
      'templates_delete_body': 'この操作は元に戻せません。',
      'templates_default_label': 'デフォルト',
      'templates_custom_label': 'カスタム',

      // ── Ack replies screen ──
      'ack_replies_nav_title': '承認返信',
      'ack_replies_description': 'Hを承認する際に使用するクイック返信。',
      'ack_replies_count': '{n}/3 オプション',
      'ack_replies_empty': 'まだ返信オプションがありません。',
      'ack_replies_add_button': '返信オプションを追加',
      'ack_replies_limit_error': '返信オプションは最大3つまで設定できます。',
      'ack_replies_new_title': '新しい返信オプション',
      'ack_replies_edit_title': '返信オプションを編集',
      'ack_replies_input_placeholder': '返信テキスト',
      'ack_replies_delete_title': '返信オプションを削除しますか？',
      'ack_replies_delete_body': 'この操作は元に戻せません。',

      // ── Ack reply sheet ──
      'ack_sheet_custom_placeholder': '自分で返信を書く',
      'ack_sheet_use_quick': 'クイック返信を使う',
      'ack_sheet_reply_empty': '返信テキストは空にできません。',
      'ack_sheet_reply_too_long': '返信は24文字以内にしてください。',

      // ── Rate limits screen ──
      'rate_limits_nav_title': '送信間隔',
      'rate_limits_description': '各H分類ごとに最小送信間隔を設定してください。',
      'rate_limits_sheet_title': 'Hの間隔',
      'rate_limits_unlimited': '無制限',
      'rate_limits_category_label': 'Hカテゴリ',
      'rate_limits_unit_sec': '秒',
      'rate_limits_unit_min': '分',
      'rate_limits_unit_hour': '時',
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
      'chats_search': '搜索聊天或联系人...',
      'cancel': '取消',

      'hue_box_title': 'Hue Box',
      'hue_box_header': 'Hue 收件箱',
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
      'chat_online': '在线',
      'chat_today': '今天',
      'chat_yesterday': '昨天',
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

      // ── Login / Register ──
      'login_tab_login': '登录',
      'login_tab_register': '注册',
      'login_phone_hint': '手机号码',
      'login_name_hint': '您的姓名',
      'login_login_btn': '登录',
      'login_register_btn': '注册',

      // ── Common ──
      'common_ok': '确定',
      'common_yes': '是',
      'common_no': '否',
      'common_add': '添加',
      'common_save': '保存',
      'common_delete': '删除',
      'common_other': '其他',
      'common_send': '发送',
      'common_could_not_save': '无法保存',

      'chat_wait_moment': '稍后',

      // ── Templates screen ──
      'templates_nav_title': '模板',
      'templates_custom_count': '自定义模板: {n}/10',
      'templates_empty': '此分类中无模板。',
      'templates_add_button': '添加模板',
      'templates_limit_error': '此分类最多允许10个自定义模板。',
      'templates_new_title': '新建模板',
      'templates_edit_title': '编辑模板',
      'templates_input_placeholder': '模板文本',
      'templates_delete_title': '删除模板？',
      'templates_delete_body': '此操作无法撤消。',
      'templates_default_label': '默认',
      'templates_custom_label': '自定义',

      // ── Ack replies screen ──
      'ack_replies_nav_title': '确认回复',
      'ack_replies_description': '确认H时使用的快捷回复。',
      'ack_replies_count': '{n}/3 选项',
      'ack_replies_empty': '暂无回复选项。',
      'ack_replies_add_button': '添加回复选项',
      'ack_replies_limit_error': '最多可定义3个回复选项。',
      'ack_replies_new_title': '新建回复选项',
      'ack_replies_edit_title': '编辑回复选项',
      'ack_replies_input_placeholder': '回复文本',
      'ack_replies_delete_title': '删除回复选项？',
      'ack_replies_delete_body': '此操作无法撤消。',

      // ── Ack reply sheet ──
      'ack_sheet_custom_placeholder': '输入自定义回复',
      'ack_sheet_use_quick': '使用快捷回复',
      'ack_sheet_reply_empty': '回复文本不能为空。',
      'ack_sheet_reply_too_long': '回复不能超过24个字符。',

      // ── Rate limits screen ──
      'rate_limits_nav_title': '发送间隔',
      'rate_limits_description': '为每个H分类设置最小发送间隔。',
      'rate_limits_sheet_title': 'H间隔',
      'rate_limits_unlimited': '无限制',
      'rate_limits_category_label': 'H分类',
      'rate_limits_unit_sec': '秒',
      'rate_limits_unit_min': '分',
      'rate_limits_unit_hour': '时',
    },
  };
}
