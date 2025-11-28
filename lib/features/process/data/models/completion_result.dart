import 'completion_models.dart';

class CompletionResult {
  final String status;
  final CompletionPercentData? data;

  const CompletionResult._(this.status, this.data);

  factory CompletionResult.hasPlan(CompletionPercentData data) =>
      CompletionResult._('has_plan', data);

  factory CompletionResult.noPlan(CompletionPercentData? data) =>
      CompletionResult._('no_plan', data);

  factory CompletionResult.error() => const CompletionResult._('error', null);
}
