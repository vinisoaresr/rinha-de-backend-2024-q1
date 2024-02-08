import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../application/find_bank_statement_use_case.dart';
import '../application/exceptions/bussines_exceptions.dart';

class BankStatementController {
  final FindBankStatementByUserUseCase findBankStatementByUserUseCase;

  BankStatementController({
    required this.findBankStatementByUserUseCase,
  });

  Future<Response> getBankStatement(Request req, String id) async {
    Output output;
    try {
      output = await findBankStatementByUserUseCase.execute(
        Input(userId: int.parse(id)),
      );
    } on UserNotFoundException catch (e) {
      return Response.notFound(jsonEncode({
        'message': e.message,
      }));
    }

    return Response.ok(
      jsonEncode(output),
    );
  }
}
