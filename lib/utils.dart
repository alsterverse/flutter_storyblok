typedef JSONMap = Map<String, dynamic>;

Out? mapIfNotNull<In, Out>(In? dataIn, Out Function(In) mapper) {
  if (dataIn != null) return mapper(dataIn);
  return null;
}

T? tryCast<T>(dynamic object) => object is T ? object : null;
