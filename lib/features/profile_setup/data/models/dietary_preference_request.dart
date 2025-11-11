import 'package:json_annotation/json_annotation.dart';

part 'dietary_preference_request.g.dart';

@JsonSerializable()
class DietaryPreferenceRequest {
  final int mealsPerDay;
  final String? cuisineType;
  final String? allergies;
  final String? avoidIngredients;
  final String? preferredIngredients;
  final String? notes;

  const DietaryPreferenceRequest({
    required this.mealsPerDay,
    this.cuisineType,
    this.allergies,
    this.avoidIngredients,
    this.preferredIngredients,
    this.notes,
  });

  /// Convert từ JSON → Object
  factory DietaryPreferenceRequest.fromJson(Map<String, dynamic> json) =>
      _$DietaryPreferenceRequestFromJson(json);

  /// Convert từ Object → JSON
  Map<String, dynamic> toJson() => _$DietaryPreferenceRequestToJson(this);
}
