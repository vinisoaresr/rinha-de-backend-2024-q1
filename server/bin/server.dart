import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import './infra/routes.dart';

void main(List<String> args) async {
  final handler = init();

  final port = int.parse(Platform.environment['PORT'] ?? '9999');

  final ip = InternetAddress.anyIPv4;

  final server = await serve(handler, ip, port);

  print('Server listening on ${ip.address}:${server.port}');
}

init() {
  final handler = Pipeline()
      .addMiddleware(
        logRequests(),
      )
      .addHandler(
    Routes.instance.router,
  );

  return handler;
}
