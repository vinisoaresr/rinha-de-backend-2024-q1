class Registry {
  Registry._internal();

  static final Registry _instance = Registry._internal();

  factory Registry() {
    return _instance;
  }

  final Map<Type, dynamic> _instances = {};

  T inject<T>() {
    return _instances[T];
  }

  void register<T>(T instance) {
    _instances[T] = instance;
  }
}
