typedef JSONMap = Map<String, dynamic>;

Out? mapIfNotNull<In, Out>(In? dataIn, Out Function(In) mapper) {
  if (dataIn != null) return mapper(dataIn);
  return null;
}

T? tryCast<T>(dynamic object) => object is T ? object : null;

extension IterableUtils<E> on Iterable<E> {
  Iterable<Out> mapIndexed<Out>(Out Function(int, E) mapper) {
    int i = 0;
    return map((e) => mapper(i++, e));
  }

  bool containsWhere(bool Function(E) check) {
    for (final e in this) if (check(e)) return true;
    return false;
  }

  E? firstWhereOrNull(bool Function(E) check) {
    for (final e in this) if (check(e)) return e;
    return null;
  }
}
