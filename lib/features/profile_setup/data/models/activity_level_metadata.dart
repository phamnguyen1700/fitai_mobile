import 'package:json_annotation/json_annotation.dart';

part 'activity_level_metadata.g.dart';

@JsonSerializable()
class ActivityLevelMetadata {
  final int id;
  final String name;

  const ActivityLevelMetadata({required this.id, required this.name});

  factory ActivityLevelMetadata.fromJson(Map<String, dynamic> json) =>
      _$ActivityLevelMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityLevelMetadataToJson(this);

  /// Label hiển thị thân thiện hơn, bạn có thể custom thêm tiếng Việt
  String get displayLabel {
    switch (name) {
      case 'Sedentary':
        return 'Ít vận động';
      case 'LightlyActive':
        return 'Nhẹ (1–2 buổi/tuần)';
      case 'ModeratelyActive':
        return 'Vừa (3–4 buổi/tuần)';
      case 'VeryActive':
        return 'Năng động (5+ buổi/tuần)';
      case 'ExtraActive':
        return 'Rất năng động / vận động viên';
      default:
        return name;
    }
  }
}
