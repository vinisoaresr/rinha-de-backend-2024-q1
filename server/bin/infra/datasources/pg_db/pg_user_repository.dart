import '../../../application/repository/repository.dart';
import '../../../domain/user.dart';
import './pg_connection.dart';

class PgUserRepository implements UserRepository {
  final PgConnection conn;

  PgUserRepository({required this.conn});

  @override
  Future<User?> findById(int id) async {
    var users = await conn.conn!.execute('SELECT * FROM users WHERE id = $id');

    if (users.isEmpty) {
      return null;
    }

    return User(
      id: users[0][0] as int,
      balance: users[0][1] as int,
      limit: users[0][2] as int,
    );
  }

  @override
  Future updateBalance(int id, int nextBalance) async {
    return Future.value(() async {
      var users = await conn.conn!.execute("""UPDATE users 
                                              SET balance = $nextBalance 
                                              WHERE id = $id 
                                              RETURNING *
                                          """);

      if (users.isEmpty) {
        return null;
      }

      return User(
        id: users[0][0] as int,
        balance: users[0][1] as int,
        limit: users[0][2] as int,
      );
    });
  }
}
