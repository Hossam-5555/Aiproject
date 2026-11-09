class ChatRoom {
  final String id;
  final String name;
  final bool isPrivate;
  final String? password;

  ChatRoom({
    required this.id,
    required this.name,
    required this.isPrivate,
    this.password,
  });

  factory ChatRoom.fromJson(json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      isPrivate: json['isPrivate'],
      password: json['password']
    );
  }
}