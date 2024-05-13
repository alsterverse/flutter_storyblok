enum LinkType {
  url,
  asset,
  email,
  story,
  ;

  static LinkType? fromName(String name) {
    return LinkType.values.asNameMap()[name];
  }
}
