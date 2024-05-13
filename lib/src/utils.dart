typedef JSONMap = Map<String, dynamic>;

Out? mapIfNotNull<In, Out>(In? dataIn, Out? Function(In) mapper) {
  if (dataIn != null) return mapper(dataIn);
  return null;
}

extension IterableUtils<E> on Iterable<E> {
  bool containsWhere(bool Function(E) check) {
    for (final e in this) {
      if (check(e)) return true;
    }
    return false;
  }

  bool containsType<T>() {
    for (final e in this) {
      if (e is T) return true;
    }
    return false;
  }

  E? firstWhereOrNull(bool Function(E) check) {
    for (final e in this) {
      if (check(e)) return e;
    }
    return null;
  }

  T? firstAsType<T>() {
    for (final e in this) {
      if (e is T) return e;
    }
    return null;
  }
}
