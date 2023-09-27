import 'dart:math';

extension IterableUtils<E> on Iterable<E> {
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

T? tryCast<T>(dynamic object) => object is T ? object : null;

extension DoubleExtensions on double {
  double roundToDecimals(int decimals) {
    assert(decimals >= 0);
    final n = pow(10, decimals);
    return (this * n).roundToDouble() / n;
  }
}
