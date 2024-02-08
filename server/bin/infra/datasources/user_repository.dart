import '../../domain/user.dart';

class UserRepository {
  final Map<int, User> _table = {
    1: User(id: 1, limit: 100000, balance: 0),
    2: User(id: 2, limit: 80000, balance: 0),
    3: User(id: 3, limit: 1000000, balance: 0),
    4: User(id: 4, limit: 10000000, balance: 0),
    5: User(id: 5, limit: 500000, balance: 0),
  };

  Future<User?> findById(int id) async {
    return _table[id];
  }

  Future updateBalance(int id, int nextBalance) async {
    if (!_table.containsKey(id)) {
      throw Exception('Usuário não encontrado');
    }

    final user = _table[id]!;

    _table[id] = user.copyWith(balance: nextBalance);
  }
}
