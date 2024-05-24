/// Story identifier by numeric ID, UUID or slug
sealed class StoryIdentifier {
  const StoryIdentifier();
}

/// Story by numeric ID
final class StoryIdentifierID extends StoryIdentifier {
  final int id;
  const StoryIdentifierID(this.id);
}

/// Story by UUID
final class StoryIdentifierUUID extends StoryIdentifier {
  final String uuid;
  const StoryIdentifierUUID(this.uuid);
}

/// Story by full slug
final class StoryIdentifierFullSlug extends StoryIdentifier {
  final String slug;
  const StoryIdentifierFullSlug(this.slug);
}
