import 'package:json_annotation/json_annotation.dart';

part 'prepare_next_checkpoint_response.g.dart';

@JsonSerializable()
class PrepareNextCheckpointResponse {
  final String? data;
  final bool success;
  final String? message;

  PrepareNextCheckpointResponse({
    this.data,
    required this.success,
    this.message,
  });

  factory PrepareNextCheckpointResponse.fromJson(Map<String, dynamic> json) =>
      _$PrepareNextCheckpointResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PrepareNextCheckpointResponseToJson(this);
}
