typedef JSONMap = Map<String, dynamic>;

Out? mapIfNotNull<In, Out>(In? dataIn, Out? Function(In) mapper) {
  if (dataIn != null) return mapper(dataIn);
  return null;
}

T? tryCast<T>(dynamic value) {
  return value is T ? value : null;
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

  /// Inserts [separator] between every element of [this]
  Iterable<E> separatedBy(E Function() separator) => separatedByIndexed((_) => separator());

  /// Inserts [separator] between every element of [this]
  Iterable<E> separatedByIndexed(E Function(int index) separator) {
    if (length < 2) return this; // Require minimum of 2 elements
    return Iterable.generate(
      length * 2 - 1,
      (index) {
        final elementIndex = index ~/ 2;
        return index.isEven ? elementAt(elementIndex) : separator(elementIndex);
      },
    );
  }
}
