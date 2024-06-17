typedef JSONMap = Map<String, dynamic>;

Out? mapIfNotNull<In, Out>(In? valueIn, Out? Function(In v) mapper) {
  if (valueIn != null) return mapper(valueIn);
  return null;
}

T? tryCast<T>(dynamic value) {
  return value is T ? value : null;
}

Never throwMessage(String message) {
  throw "❌ $message";
}
