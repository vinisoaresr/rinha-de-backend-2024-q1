import 'dart:convert';

import 'package:shelf/shelf.dart';

class TransactionController {
  Response createTransaction(Request req, String id) {
    req.readAsString().then((jsonString) {
      final json = jsonDecode(jsonString);
    });

    return Response.ok('');
  }
}
