import '../../domain/entities/like_info.dart';

class LikeInfoModel extends LikeInfo {
  const LikeInfoModel({
    required super.count,
    required super.userIds,
  });

  factory LikeInfoModel.fromJson(Map<String, dynamic> json) {
    return LikeInfoModel(
      count: json['count'] as int? ?? 0,
      userIds: List<String>.from(json['userIds'] as List? ?? [
        
      ]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'userIds': userIds,
    };
  }

  factory LikeInfoModel.empty() {
    return const LikeInfoModel(count: 0, userIds: []);
  }
}
