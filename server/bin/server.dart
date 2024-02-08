import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'application/create_transaction_usecase.dart';
import 'application/find_bank_statement_use_case.dart';
import 'controllers/bank_statement_controller.dart';
import 'controllers/transaction_controller.dart';
import 'infra/datasources/transaction_repository.dart';
import 'infra/datasources/user_repository.dart';
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
  var transactionRepository = TransactionRepository();
  var userRepository = UserRepository();
  var createTransactionUseCase = CreateTransactionUseCase(
    repository: transactionRepository,
    userRepository: userRepository,
  );
  var transactionController = TransactionController(
    createTransaction: createTransactionUseCase,
  );
  var findBankStatementByUserUseCase = FindBankStatementByUserUseCase(
    repository: transactionRepository,
    userRepository: userRepository,
  );
  var bankStatementController = BankStatementController(
    findBankStatementByUserUseCase: findBankStatementByUserUseCase,
  );

  Registry().register<TransactionRepository>(transactionRepository);
  Registry().register<UserRepository>(userRepository);
  Registry().register<CreateTransactionUseCase>(createTransactionUseCase);
  Registry().register<TransactionController>(transactionController);
  Registry()
      .register<FindBankStatementByUserUseCase>(findBankStatementByUserUseCase);
  Registry().register<BankStatementController>(bankStatementController);
}
