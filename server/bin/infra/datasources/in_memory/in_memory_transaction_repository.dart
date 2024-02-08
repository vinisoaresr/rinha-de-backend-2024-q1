import '../../../application/repository/repository.dart';
import '../../../domain/transaction.dart';

class InMemoryTransactionRepository implements TransactionRepository {
  final Map<int, Transaction> _table = {};
  int _sequence = 0;

  @override
  Future<Transaction?> save(Transaction transaction) async {
    transaction.id = _generateId();
    _table[transaction.id] = transaction;
    return transaction;
  }

  @override
  Future<List<Transaction>> findByUser(int userId) async {
    return _table.values.where((element) => element.userId == userId).toList();
  }

  int _generateId() {
    return ++_sequence;
  }
}
