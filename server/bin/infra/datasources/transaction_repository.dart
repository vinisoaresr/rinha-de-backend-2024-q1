import '../../domain/transaction.dart';

class TransactionRepository {
  final Map<int, Transaction> _table = {};
  int _sequence = 0;

  Future<Transaction?> save(Transaction transaction) async {
    transaction.id = _generateId();
    _table[transaction.id] = transaction;
    return transaction;
  }

  Future<List<Transaction>> findByUser(int userId) async {
    return _table.values.where((element) => element.userId == userId).toList();
  }

  int _generateId() {
    return ++_sequence;
  }
}
