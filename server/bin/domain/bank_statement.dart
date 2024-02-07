import 'transaction.dart';

abstract class BankStatement {
  int total;
  DateTime realizedAt;
  int limit;
  List<Transaction> lastTransactions;

  BankStatement(this.total, this.realizedAt, this.limit, this.lastTransactions);

  int getBalance() {
    int balance = 0;

    for (var transaction in lastTransactions) {
      if (transaction.type == TransactionType.credit) {
        balance += transaction.value;
      } else {
        balance -= transaction.value;
      }
    }

    return balance;
  }
}
