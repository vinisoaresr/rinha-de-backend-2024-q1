import '../../domain/transaction.dart';

abstract interface class TransactionRepository {
  Future<Transaction?> save(Transaction transaction);

  Future<List<Transaction>> findByUser(int userId);

}
