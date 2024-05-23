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
