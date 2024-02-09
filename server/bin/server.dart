import 'dart:io';
import 'dart:isolate';

import 'package:shelf/shelf.dart';
import 'package:shelf_serve_isolates/shelf_serve_isolates.dart';

import 'application/create_transaction_usecase.dart';
import 'application/find_bank_statement_use_case.dart';
import 'application/repository/repository.dart';
import 'controllers/bank_statement_controller.dart';
import 'controllers/transaction_controller.dart';
import 'infra/datasources/pg_db/pg_connection.dart';
import 'infra/datasources/pg_db/pg_data_sources.dart';
import 'infra/utils/registry.dart';
import 'infra/utils/routes.dart';

// Tive que criar um pool de conexões para cada isolate usando o hash do isolate como chave (não é uma boa prática, but it works)
Map<int, PgConnection> connectionsPool = {};

void main(List<String> args) async {
  init();

  final handler = getHandler();
  final port = int.parse(Platform.environment['PORT'] ?? '9999');

  await ServeWithMultiIsolates(
    handler: handler,
    address: 'localhost',
    port: port,
    onStart: (server) {
      connectionsPool[Isolate.current.hashCode] = PgConnection();
      print(
        'Serving at http://${server.address.host}:${server.port} ${Isolate.current.debugName}-${Isolate.current.hashCode}',
      );
    },
    onClose: (server) {
      print('server shutdown');
    },
  ).serve();

  // final server = await serve(
  //   handler,
  //   ip,
  //   port,
  //   shared: true,
  // );

  // print('Server listening on ${ip.address}:${server.port}');
}

getHandler() {
  final handler = Pipeline().addMiddleware(
    logRequests(
      logger: (String msg, bool isError) {
        msg =
            'Thread: ${Isolate.current.debugName}-${Isolate.current.hashCode} - $msg';

        if (isError) {
          print('ERROR: $msg');
        } else {
          print(msg);
        }
      },
    ),
  ).addHandler(
    Routes().router,
  );

  return handler;
}

init() {
  // infra
  var pgConnection = PgConnection();

  // repositories
  var transactionRepository = PgTransactionRepository(conn: pgConnection);
  var userRepository = PgUserRepository();

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
  Registry().register<PgConnection>(
    pgConnection,
  );
}
