import 'dart:io';
import 'dart:isolate';

import 'package:postgres/postgres.dart';

class PgConnection {
  PgConnection._internal();

  static final PgConnection _instance = PgConnection._internal();

  factory PgConnection() {
    if (_instance.conn == null ||
        (_instance.conn != null && !_instance.conn!.isOpen)) {
      _instance.openConnection();
    }

    return _instance;
  }

  Connection? conn;

  void openConnection() async {
    final host = Platform.environment['DB_HOST'] ?? 'localhost';
    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
    final database = 'rinha';
    final username = 'admin';
    final password = '123';

    print('Connecting to database: $host:$port/$database');

    try {
      conn = await Connection.open(
        Endpoint(
          host: host,
          database: database,
          username: username,
          password: password,
          port: port,
        ),
        settings: ConnectionSettings(
          sslMode: SslMode.disable,
        ),
      );
    } on SocketException catch (_) {
      sleep(Duration(seconds: 5));
      openConnection();
    } catch (e) {
      throw Exception('Failed when trying to connect to database: $e');
    }

    await testConnection();
  }

  testConnection() async {
    final result = await conn!.execute('SELECT now()');

    if (result.isEmpty) {
      throw Exception('Failed when trying to connect to database');
    }

    print(
        'Thread: ${Isolate.current.debugName}-${Isolate.current.hashCode} Connected to database: ${DateTime.parse(result[0][0].toString())}');
  }
}
