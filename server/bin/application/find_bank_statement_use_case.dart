import '../domain/transaction.dart';
import './repository/repository.dart';
import 'exceptions/user_not_found_exception.dart';

class FindBankStatementByUserUseCase {
  final TransactionRepository repository;
  final UserRepository userRepository;

  FindBankStatementByUserUseCase({
    required this.repository,
    required this.userRepository,
  });

  Future<Output> execute(Input input) async {
    final user = await userRepository.findById(input.userId);

    if (user == null) {
      throw UserNotFoundException('Usuário não encontrado');
    }

    final transactions = await repository.findByUser(input.userId);

    if (transactions.isEmpty) {
      return Output(
        balance: OutputBalance(
          total: 0,
          statementDate: DateTime.now().toIso8601String(),
          limit: user.limit,
        ),
        transactions: [],
      );
    }

    return Output(
      balance: OutputBalance(
        total: transactions
            .map((transaction) => transaction.value)
            .reduce((value, element) => value + element),
        statementDate: DateTime.now().toIso8601String(),
        limit: user.limit,
      ),
      transactions: transactions
          .map(
            (transaction) => OutputTransaction(
              value: transaction.value,
              type: transaction.type == TransactionType.debit ? "d" : "c",
              description: transaction.description,
              realizedAt: transaction.realizedAt.toIso8601String(),
            ),
          )
          .toList(),
    );
  }
}

class Input {
  final int userId;

  Input({
    required this.userId,
  });
}

class Output {
  final OutputBalance balance;
  final List<OutputTransaction>? transactions;

  Output({
    required this.balance,
    this.transactions,
  });

  Map<String, dynamic> toJson() {
    return {
      'saldo': balance.toJson(),
      'ultimas_transacoes': transactions?.map((e) => e.toJson()).toList(),
    };
  }
}

class OutputBalance {
  final int total;
  final String statementDate;
  final int limit;

  OutputBalance({
    required this.total,
    required this.statementDate,
    required this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      "total": total,
      "data_extrato": statementDate,
      "limite": limit,
    };
  }
}

class OutputTransaction {
  final int value;
  final String type;
  final String description;
  final String realizedAt;

  OutputTransaction({
    required this.value,
    required this.type,
    required this.description,
    required this.realizedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "valor": value,
      "tipo": type,
      "descricao": description,
      "realizada_em": realizedAt,
    };
  }
}
