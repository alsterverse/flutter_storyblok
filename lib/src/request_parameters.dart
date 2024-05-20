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
  final int page;
  final int perPage;

  const Pagination({required this.page, required this.perPage});

  Map<String, String> toParameters() => {
        "page": page.toString(),
        "per_page": perPage.toString(),
      };
}

enum ResolveLinks {
  link,
  url,
  story,
}
