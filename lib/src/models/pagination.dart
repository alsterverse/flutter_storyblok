/// Used on paginatable resources
final class Pagination {
  const Pagination({required this.page, required this.perPage});

  /// Page number starting at 1
  final int page;

  /// How many pages per page
  final int perPage;

  Map<String, String> toParameters() => {
        "page": page.toString(),
        "per_page": perPage.toString(),
      };
}
