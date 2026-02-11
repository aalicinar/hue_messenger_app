import '../../core/models/hue_category.dart';
import '../../core/models/message.dart';

List<Message> sortHueBoxItems(Iterable<Message> messages) {
  final items = List<Message>.from(messages);
  items.sort(compareHueBoxItems);
  return items;
}

int compareHueBoxItems(Message a, Message b) {
  if (a.isUnacked != b.isUnacked) {
    return a.isUnacked ? -1 : 1;
  }

  if (a.isUnacked && b.isUnacked) {
    final categoryCompare = b.category!.priority.compareTo(
      a.category!.priority,
    );
    if (categoryCompare != 0) return categoryCompare;
  }

  return b.createdAt.compareTo(a.createdAt);
}
