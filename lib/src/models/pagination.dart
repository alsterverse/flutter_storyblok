final class Pagination {
  final int page;
  final int perPage;

  const Pagination({required this.page, required this.perPage});

  Map<String, String> toParameters() => {
        "page": page.toString(),
        "per_page": perPage.toString(),
      };
}
