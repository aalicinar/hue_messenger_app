class Chat {
  const Chat({
    required this.id,
    required this.memberIds,
    this.lastPreview,
    this.lastAt,
  });

  final String id;
  final List<String> memberIds;
  final String? lastPreview;
  final DateTime? lastAt;

  Chat copyWith({
    String? id,
    List<String>? memberIds,
    String? lastPreview,
    DateTime? lastAt,
  }) {
    return Chat(
      id: id ?? this.id,
      memberIds: memberIds ?? this.memberIds,
      lastPreview: lastPreview ?? this.lastPreview,
      lastAt: lastAt ?? this.lastAt,
    );
  }
}
