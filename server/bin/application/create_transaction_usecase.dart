import 'dart:math';

import '../domain/transaction.dart';
import '../infra/datasources/transaction_repository.dart';

class CreateTransactionUseCase {
  final TransactionRepository repository;

  CreateTransactionUseCase({
    required this.repository,
  });

  Future<Output> execute(Input input) async {
    final transaction = Transaction(
      id: -(Random.secure().nextInt(1000)),
      userId: input.userId,
      value: input.value,
      realizedAt: DateTime.now(),
      description: input.description,
      type: input.type == 'c' ? TransactionType.credit : TransactionType.debit,
    );

    final createdTransaction = await repository.save(transaction);

    if (createdTransaction != null) {
      return Output(message: 'Transação realizada com sucesso');
    } else {
      return Output(message: 'Erro ao realizar transação', error: '500');
    }
  }
}

class Input {
  final int value;
  final int userId;
  final String type;
  final String description;

  Input({
    required this.userId,
    required this.value,
    required this.type,
    required this.description,
  });
}

class Output {
  final String message;
  final String? error;

  Output({
    required this.message,
    this.error,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'error': error,
    };
  }
}
