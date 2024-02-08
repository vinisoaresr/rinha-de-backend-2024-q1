import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'application/create_transaction_usecase.dart';
import 'application/find_bank_statement_use_case.dart';
import 'application/repository/repository.dart';
import 'controllers/bank_statement_controller.dart';
import 'controllers/transaction_controller.dart';
import 'infra/datasources/in_memory/in_memory_data_sources.dart';
import 'infra/datasources/pg_db/pg_connection.dart';
import 'infra/utils/registry.dart';
import 'infra/utils/routes.dart';

void main(List<String> args) async {
  final handler = init();

  final port = int.parse(Platform.environment['PORT'] ?? '9999');

  final ip = InternetAddress.anyIPv4;

  final server = await serve(handler, ip, port);

  print('Server listening on ${ip.address}:${server.port}');
}

init() {
  initDependencies();

  final handler = Pipeline()
      .addMiddleware(
        logRequests(),
      )
      .addHandler(
        Routes().router,
      );

  return handler;
}

initDependencies() {
  // infra
  // var pgConnection = PgConnection();

  // repositories
  var transactionRepository = InMemoryTransactionRepository();
  var userRepository = InMemoryUserRepository();

  // use cases
  var createTransactionUseCase = CreateTransactionUseCase(
    repository: transactionRepository,
    userRepository: userRepository,
  );
  var findBankStatementByUserUseCase = FindBankStatementByUserUseCase(
    repository: transactionRepository,
    userRepository: userRepository,
  );

  // controllers
  var transactionController = TransactionController(
    createTransaction: createTransactionUseCase,
  );
  var bankStatementController = BankStatementController(
      findBankStatementByUserUseCase: findBankStatementByUserUseCase);

  Registry().register<TransactionRepository>(
    transactionRepository,
  );
  Registry().register<UserRepository>(
    userRepository,
  );
  Registry().register<CreateTransactionUseCase>(
    createTransactionUseCase,
  );
  Registry().register<TransactionController>(
    transactionController,
  );
  Registry().register<FindBankStatementByUserUseCase>(
    findBankStatementByUserUseCase,
  );
  Registry().register<BankStatementController>(
    bankStatementController,
  );
  // Registry().register<PgConnection>(
  //   pgConnection,
  // );
}
