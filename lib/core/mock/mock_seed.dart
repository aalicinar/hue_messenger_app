import '../models/chat.dart';
import '../models/hue_category.dart';
import '../models/message.dart';
import '../models/rate_limits.dart';
import '../models/template.dart';
import '../models/user.dart';

class MockSeed {
  const MockSeed._();

  static List<User> users() {
    return const [
      User(id: 'current', name: 'Me'),
      User(id: 'alice', name: 'Alice'),
      User(id: 'bob', name: 'Bob'),
      User(id: 'zoe', name: 'Zoe'),
    ];
  }

  static List<Chat> chats() {
    final now = DateTime.now();
    return [
      Chat(
        id: 'chat_alice',
        memberIds: const ['current', 'alice'],
        lastPreview: 'Acil: Müsait olduğunda dönebilir misin?',
        lastAt: now.subtract(const Duration(minutes: 11)),
      ),
      Chat(
        id: 'chat_bob',
        memberIds: const ['current', 'bob'],
        lastPreview: 'Akşam 8 gibi buluşalım mı?',
        lastAt: now.subtract(const Duration(hours: 2, minutes: 8)),
      ),
      Chat(
        id: 'chat_zoe',
        memberIds: const ['current', 'zoe'],
        lastPreview: 'Sunumu yarın paylaşıyorum.',
        lastAt: now.subtract(const Duration(hours: 5, minutes: 20)),
      ),
    ];
  }

  static List<Message> messages() {
    final now = DateTime.now();
    return [
      Message(
        id: 'm1',
        chatId: 'chat_alice',
        senderId: 'alice',
        recipientId: 'current',
        type: MessageType.normal,
        text: 'Toplantı dosyasını gönderdim.',
        createdAt: now.subtract(const Duration(hours: 7)),
      ),
      Message(
        id: 'm2',
        chatId: 'chat_alice',
        senderId: 'alice',
        recipientId: 'current',
        type: MessageType.hue,
        category: HueCategory.red,
        templateText: 'Acil: Müsait olduğunda dönebilir misin?',
        createdAt: now.subtract(const Duration(minutes: 11)),
      ),
      Message(
        id: 'm3',
        chatId: 'chat_alice',
        senderId: 'current',
        recipientId: 'alice',
        type: MessageType.normal,
        text: '15 dk sonra döneceğim.',
        createdAt: now.subtract(const Duration(minutes: 8)),
      ),
      Message(
        id: 'm4',
        chatId: 'chat_bob',
        senderId: 'bob',
        recipientId: 'current',
        type: MessageType.hue,
        category: HueCategory.yellow,
        templateText: 'Akşam 8 gibi buluşalım mı?',
        createdAt: now.subtract(const Duration(hours: 2, minutes: 8)),
      ),
      Message(
        id: 'm5',
        chatId: 'chat_bob',
        senderId: 'bob',
        recipientId: 'current',
        type: MessageType.hue,
        category: HueCategory.green,
        templateText: 'Eve geçtim, haberin olsun.',
        createdAt: now.subtract(const Duration(hours: 3)),
        acknowledgedAt: now.subtract(const Duration(hours: 2, minutes: 30)),
        acknowledgedText: 'Tamam',
      ),
      Message(
        id: 'm6',
        chatId: 'chat_zoe',
        senderId: 'zoe',
        recipientId: 'current',
        type: MessageType.normal,
        text: 'Takvimi güncelledim.',
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      Message(
        id: 'm7',
        chatId: 'chat_zoe',
        senderId: 'zoe',
        recipientId: 'current',
        type: MessageType.hue,
        category: HueCategory.blue,
        templateText: 'Sunumu yarın paylaşıyorum.',
        createdAt: now.subtract(const Duration(hours: 5, minutes: 20)),
      ),
      Message(
        id: 'm8',
        chatId: 'chat_zoe',
        senderId: 'zoe',
        recipientId: 'current',
        type: MessageType.hue,
        category: HueCategory.red,
        templateText: 'Acil: Beni arayabilir misin?',
        createdAt: now.subtract(const Duration(minutes: 44)),
      ),
      Message(
        id: 'm9',
        chatId: 'chat_bob',
        senderId: 'current',
        recipientId: 'bob',
        type: MessageType.normal,
        text: 'Tamam, ben de geleyim.',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      Message(
        id: 'm10',
        chatId: 'chat_alice',
        senderId: 'alice',
        recipientId: 'current',
        type: MessageType.hue,
        category: HueCategory.yellow,
        templateText: 'Mola verince kahveye inelim mi?',
        createdAt: now.subtract(const Duration(hours: 1, minutes: 32)),
      ),
      Message(
        id: 'm11',
        chatId: 'chat_bob',
        senderId: 'bob',
        recipientId: 'current',
        type: MessageType.hue,
        category: HueCategory.blue,
        templateText: 'Boş olduğunda şu linke bak.',
        createdAt: now.subtract(const Duration(minutes: 53)),
        acknowledgedAt: now.subtract(const Duration(minutes: 21)),
        acknowledgedText: 'Evet',
      ),
      Message(
        id: 'm12',
        chatId: 'chat_alice',
        senderId: 'alice',
        recipientId: 'current',
        type: MessageType.hue,
        category: HueCategory.green,
        templateText: 'Toplantı odasına geçtim.',
        createdAt: now.subtract(const Duration(minutes: 17)),
      ),
    ];
  }

  static List<Template> templates() {
    return const [
      Template(
        id: 't_red_1',
        category: HueCategory.red,
        text: 'Acil: Müsait olduğunda dönebilir misin?',
        isDefault: true,
        isHidden: false,
        order: 0,
      ),
      Template(
        id: 't_red_2',
        category: HueCategory.red,
        text: 'Acil: Beni arayabilir misin?',
        isDefault: true,
        isHidden: false,
        order: 1,
      ),
      Template(
        id: 't_yellow_1',
        category: HueCategory.yellow,
        text: 'Akşam 8 gibi buluşalım mı?',
        isDefault: true,
        isHidden: false,
        order: 0,
      ),
      Template(
        id: 't_green_1',
        category: HueCategory.green,
        text: 'Toplantı odasına geçtim.',
        isDefault: true,
        isHidden: false,
        order: 0,
      ),
      Template(
        id: 't_blue_1',
        category: HueCategory.blue,
        text: 'Boş olduğunda şu linke bak.',
        isDefault: true,
        isHidden: false,
        order: 0,
      ),
    ];
  }

  static RateLimits rateLimits() {
    return const RateLimits(
      redSeconds: 3600,
      yellowSeconds: 1800,
      greenSeconds: 300,
      blueSeconds: 0,
    );
  }

  static List<String> ackReplies() {
    return const ['Tamam', 'Evet', 'Hayır'];
  }
}
