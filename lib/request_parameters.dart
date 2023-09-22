//

enum StoryblokVersion {
  draft,
  published,
}

sealed class StoryIdentifier {
  const StoryIdentifier();
}

final class StoryIdentifierID extends StoryIdentifier {
  final int id;
  const StoryIdentifierID(this.id);
}

final class StoryIdentifierUUID extends StoryIdentifier {
  final String uuid;
  const StoryIdentifierUUID(this.uuid);
}

final class StoryIdentifierFullSlug extends StoryIdentifier {
  final String slug;
  const StoryIdentifierFullSlug(this.slug);
}

final class Pagination {
  final int perPage;
  final int page;

  const Pagination({required this.perPage, required this.page});

  Map<String, String> toParameters() => {
        "page": page.toString(),
        "per_page": perPage.toString(),
      };
}
