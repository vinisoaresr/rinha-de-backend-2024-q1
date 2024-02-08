class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException(this.message);
}

class InsufficientBalanceException implements Exception {
  final String message;

  InsufficientBalanceException(this.message);
}
