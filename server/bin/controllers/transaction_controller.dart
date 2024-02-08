import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../application/create_transaction_usecase.dart';
import '../infra/exceptions/user_not_found_exception.dart';

class TransactionController {
  final CreateTransactionUseCase createTransaction;

  TransactionController({
    required this.createTransaction,
  });

  Future<Response> createTransactionHandler(Request req, String id) async {
    final body = jsonDecode(await req.readAsString());

    final input = Input.fromJson(body, id);

    Output output;

    try {
      output = await createTransaction.execute(input);
    } on UserNotFoundException catch (e) {
      return Response(404, body: jsonEncode({'message': e.message}));
    } on InsufficientBalanceException catch (e) {
      return Response(422, body: jsonEncode({'message': e.message}));
    } catch (e) {
      return Response.internalServerError(
        body: jsonEncode({'message': e.toString()}),
      );
    }

    return Response.ok(jsonEncode(output));
  }
}
