import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../application/create_transaction_usecase.dart';

class TransactionController {
  final CreateTransactionUseCase createTransaction;

  TransactionController({
    required this.createTransaction,
  });

  Future<Response> createTransactionHandler(Request req, String id) async {
    final body = jsonDecode(await req.readAsString());

    final input = Input(
      userId: int.parse(id),
      value: body['value'],
      type: body['type'],
      description: body['description'],
    );

    final output = await createTransaction.execute(input);

    return Response.ok(jsonEncode(output));
  }
}
