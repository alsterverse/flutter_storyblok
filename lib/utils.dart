import 'package:characters/characters.dart';

typedef JSONMap = Map<String, dynamic>;

Out? mapIfNotNull<In, Out>(In? dataIn, Out Function(In) mapper) {
  if (dataIn != null) return mapper(dataIn);
  return null;
}

T? tryCast<T>(dynamic object) => object is T ? object : null;

extension StringExtensions on String {
  String capitalized() {
    if (isEmpty) return this;
    return "${characters.first.toUpperCase()}${characters.skip(1)}";
  }
}

extension IterableUtils<E> on Iterable<E> {
  Iterable<Out> mapIndexed<Out>(Out Function(int, E) mapper) {
    int i = 0;
    return map((e) => mapper(i++, e));
  }
}
