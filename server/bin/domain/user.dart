class User {
  int id;
  int limit;
  int balance;

  User({
    required this.id,
    required this.limit,
    required this.balance,
  });

  User copyWith({
    int? id,
    int? limit,
    int? balance,
  }) {
    return User(
      id: id ?? this.id,
      limit: limit ?? this.limit,
      balance: balance ?? this.balance,
    );
  }
}
