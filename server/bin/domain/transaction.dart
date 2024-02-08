enum TransactionType { credit, debit }

class Transaction {
  int id;

  /// In cents
  int value;
  String description;
  int userId;
  DateTime realizedAt;
  TransactionType type;

  Transaction({
    required this.id,
    required this.userId,
    required this.value,
    required this.description,
    required this.realizedAt,
    required this.type,
  });
}
