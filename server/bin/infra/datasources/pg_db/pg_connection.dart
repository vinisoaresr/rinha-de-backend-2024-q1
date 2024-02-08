import 'dart:ffi';
import 'dart:io';

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
    try {
      conn = await Connection.open(
        Endpoint(
          host: Platform.environment['DB_HOST'] ?? 'localhost',
          database: 'rinha',
          username: 'admin',
          password: '123',
          port: int.parse(Platform.environment['DB_PORT'] ?? '5444'),
        ),
        settings: ConnectionSettings(
          sslMode: SslMode.disable,
        ),
      );
    } on SocketException catch (e) {
      sleep(Duration(seconds: 5));
      openConnection();
    } catch (e) {
      throw Exception('Failed when trying to connect to database: $e');
    }

    await testConnection();
  }

  testConnection() async {
    final result = await conn!.execute('SELECT 1');

    if (result.isEmpty) {
      throw Exception('Failed when trying to connect to database');
    }
  }
}