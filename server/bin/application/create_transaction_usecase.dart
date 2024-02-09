import 'dart:math';

import '../domain/transaction.dart';
import './repository/repository.dart';
import 'exceptions/insufficient_balance_exception.dart';
import 'exceptions/user_not_found_exception.dart';

class CreateTransactionUseCase {
  final TransactionRepository repository;
  final UserRepository userRepository;

  CreateTransactionUseCase({
    required this.repository,
    required this.userRepository,
  });

  Future<Output> execute(Input input) async {
    input.validate();

    final user = await userRepository.findById(input.userId);

    if (user == null) {
      throw UserNotFoundException('Usuário não encontrado');
    }

    int nextBalance = input.type == 'c'
        ? user.balance + input.value
        : user.balance - input.value;

    if (input.type == 'd' && nextBalance < -(user.limit)) {
      throw InsufficientBalanceException('Saldo insuficiente');
    }

    final transaction = Transaction(
      id: -(Random.secure().nextInt(1000)),
      userId: user.id,
      value: input.value,
      realizedAt: DateTime.now(),
      description: input.description,
      type: input.type == 'c' ? TransactionType.credit : TransactionType.debit,
    );

    final createdTransaction = await repository.save(transaction);
    await userRepository.updateBalance(
      user.id,
      nextBalance,
    );

    if (createdTransaction == null) {
      throw Exception('Erro ao criar transação');
    }

    return Output(
      limit: user.limit,
      balance: nextBalance,
    );
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

  factory Input.fromJson(Map<String, dynamic> json, String userId) {
    int value;

    switch (json['valor'].runtimeType) {
      case int:
        value = json['valor'];
        break;
      case double:
        value = (json['valor'] as double).toInt();
        break;
      case String:
        int.tryParse(json['valor']) != null
            ? value = int.parse(json['valor'])
            : double.tryParse(json['valor']) != null
                ? value = double.parse(json['valor']).toInt()
                : value = -1;
        break;
      default:
        value = -1;
    }

    return Input(
      userId: int.parse(userId),
      value: value,
      type: json['tipo'] ?? '',
      description: json['descricao'] ?? '',
    );
  }

  void validate() {
    if (value <= 0) {
      throw Exception('Valor inválido');
    }

    if (type != 'c' && type != 'd') {
      throw Exception('Tipo inválido');
    }

    if (description.isEmpty || description.length > 10) {
      throw Exception('Descrição inválida');
    }
  }
}

class Output {
  final int limit;
  final int balance;

  Output({
    required this.limit,
    required this.balance,
  });

  Map<String, dynamic> toJson() {
    return {
      'limite': limit,
      'saldo': balance,
    };
  }
}
