export './insufficient_balance_exception.dart';
export './user_not_found_exception.dart';

class BusinessException implements Exception {
  final String message;

  BusinessException({required this.message});
}
