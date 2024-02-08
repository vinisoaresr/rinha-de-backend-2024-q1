import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../controllers/bank_statement_controller.dart';
import '../../controllers/transaction_controller.dart';
import 'registry.dart';

class Routes {
  static final Routes _instance = Routes._internal();
  Routes._internal();
  factory Routes() => _instance;

  final _router = Router();
  final _transactionController = Registry().inject<TransactionController>();
  final _bankStatementController = Registry().inject<BankStatementController>();

  Handler get router {
    _router.get(
      '/clientes/<id>/extrato',
      _bankStatementController.getBankStatement,
    );

    _router.post(
      '/clientes/<id>/transacoes',
      _transactionController.createTransactionHandler,
    );

    return _router.call;
  }
}
