import '../../../application/repository/repository.dart';
import '../../../domain/transaction.dart';
import './pg_connection.dart';

class PgTransactionRepository implements TransactionRepository {
  final PgConnection conn;

  PgTransactionRepository({required this.conn});

  @override
  Future<Transaction?> save(Transaction transaction) async {
    var transactions = await conn.conn!.execute(
        """INSERT INTO transactions (user_id, value, created_at, type, description) VALUES (
              ${transaction.userId}, 
              ${transaction.value}, 
              ${transaction.realizedAt}, 
              ${transaction.type}, 
              ${transaction.description}) 
            RETURNING *""");

    if (transactions.isEmpty) {
      return null;
    }

    return Transaction(
      id: transactions[0][0] as int,
      userId: transactions[0][1] as int,
      value: transactions[0][2] as int,
      description: transactions[0][3] as String,
      realizedAt: transactions[0][4] as DateTime,
      type: transactions[0][5] as String == 'c'
          ? TransactionType.credit
          : TransactionType.debit,
    );
  }

  @override
  Future<List<Transaction>> findByUser(int userId) async {
    var transactions = await conn.conn!
        .execute('SELECT * FROM transactions WHERE user_id = $userId');

    return transactions
        .map((t) => Transaction(
              id: t[0] as int,
              userId: t[1] as int,
              value: t[2] as int,
              description: t[3] as String,
              realizedAt: t[4] as DateTime,
              type: t[5] as String == 'c'
                  ? TransactionType.credit
                  : TransactionType.debit,
            ))
        .toList();
  }
}
