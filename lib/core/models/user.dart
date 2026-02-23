class User {
  const User({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.status,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final String? status;

  User copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    bool clearAvatarUrl = false,
    String? status,
    bool clearStatus = false,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: clearAvatarUrl ? null : (avatarUrl ?? this.avatarUrl),
      status: clearStatus ? null : (status ?? this.status),
    );
  }
}
