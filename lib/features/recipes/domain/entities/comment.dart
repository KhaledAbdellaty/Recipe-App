import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  Comment copyWith({String? content}) {
    return Comment(
        id: id,
        userId: userId,
        userName: userName,
        content: content ?? this.content,
        createdAt: createdAt);
  }

  @override
  List<Object> get props => [id, userId, userName, content, createdAt];
}
