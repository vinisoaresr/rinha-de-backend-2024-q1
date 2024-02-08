import '../../domain/user.dart';

abstract interface class UserRepository {
  Future<User?> findById(int id);

  Future updateBalance(int id, int nextBalance);
}
