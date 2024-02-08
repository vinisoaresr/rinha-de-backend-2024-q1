import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../application/find_bank_statement_use_case.dart';

class BankStatementController {
  final FindBankStatementByUserUseCase findBankStatementByUserUseCase;

  BankStatementController({
    required this.findBankStatementByUserUseCase,
  });

  Future<Response> getBankStatement(Request req, String id) async {
    final output = await findBankStatementByUserUseCase.execute(
      Input(userId: int.parse(id)),
    );

    return Response.ok(
      jsonEncode(output),
    );
  }
}
