import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitai_mobile/features/payment/data/services/payment_service.dart';
import 'package:fitai_mobile/features/payment/data/repositories/payment_repository.dart';

/// Provider cho PaymentRepository – dùng trong ProcessingScreen / viewmodel
final paymentProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepository(PaymentService()),
);
