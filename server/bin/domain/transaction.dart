enum TransactionType { credit, debit }

abstract class Transaction {
  /// In cents
  int value;
  String description;
  DateTime realizedAt;
  TransactionType type;

  Transaction(this.value, this.description, this.realizedAt, this.type);

  fromJson(Map<String, dynamic> json) {
    value = json['value'];
    description = json['description'];
    realizedAt = DateTime.now();
    type = json['type'] == 'c' ? TransactionType.credit : TransactionType.debit;
  }
}
