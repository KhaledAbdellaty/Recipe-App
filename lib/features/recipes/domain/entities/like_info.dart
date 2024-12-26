import 'package:equatable/equatable.dart';

class LikeInfo extends Equatable {
  final int count;
  final List<String> userIds;

  const LikeInfo({
    required this.count,
    required this.userIds,
  });

  @override
  List<Object> get props => [count, userIds];
}
