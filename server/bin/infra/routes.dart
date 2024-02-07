import 'package:shelf_router/shelf_router.dart';

import '../controllers/bank_statement_controller.dart';
import '../controllers/transaction_controller.dart';

class Routes {
  Routes._();

  static final Routes _instance = Routes._();

  static Routes get instance => _instance;

  final _transactionController = TransactionController();
  final _bankStatementController = BankStatementController();
  final _router = Router();

  Router get router {
    _router.get(
        '/clientes/<id>/extrato', _bankStatementController.getBankStatement);

    _router.post(
        '/clientes/<id>/transacoes', _transactionController.createTransaction);

    return _router;
  }
}
