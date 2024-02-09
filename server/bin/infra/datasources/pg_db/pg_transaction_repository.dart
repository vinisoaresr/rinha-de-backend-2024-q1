import '../../../application/repository/repository.dart';
import '../../../domain/transaction.dart';
import './pg_connection.dart';

class PgTransactionRepository implements TransactionRepository {
  final PgConnection conn;

  PgTransactionRepository({required this.conn});

  @override
  Future<Transaction?> save(Transaction transaction) async {
    var transactions = await conn.conn!.execute(
        """INSERT INTO transactions (user_id, value, realized_at, type, description) VALUES (
              ${transaction.userId}, 
              ${transaction.value}, 
              '${transaction.realizedAt.toString()}', 
              '${transaction.type == TransactionType.credit ? 'c' : 'd'}', 
              '${transaction.description}'
        ) RETURNING *""");

    if (transactions.isEmpty) {
      return null;
    }

    final createdTransaction = transactions[0];

    return Transaction(
      id: createdTransaction[0] as int,
      userId: createdTransaction[1] as int,
      value: createdTransaction[2] as int,
      description: createdTransaction[3] as String,
      realizedAt: DateTime.parse(createdTransaction[4] as String),
      type: createdTransaction[5] as String == 'c'
          ? TransactionType.credit
          : TransactionType.debit,
    );
  }

  @override
  Future<List<Transaction>> findByUser(int userId) async {
    var transactions = await conn.conn!.execute(
        'SELECT * FROM transactions WHERE user_id = $userId ORDER BY realized_at DESC');

    return transactions
        .map((t) => Transaction(
              id: t[0] as int,
              userId: t[1] as int,
              value: t[2] as int,
              description: t[3] as String,
              // realizedAt: DateTime.parse(t[4] as String),
              realizedAt: DateTime.now(),
              type: t[5] as String == 'c'
                  ? TransactionType.credit
                  : TransactionType.debit,
            ))
        .toList();
  }
}
