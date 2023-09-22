import 'package:reflectable/reflectable.dart';

final class Reflector extends Reflectable {
  const Reflector()
      : super.fromList(const [
          declarationsCapability,
          instanceInvokeCapability,
          metadataCapability,
          libraryCapability,
          newInstanceCapability,
          typeCapability,
          reflectedTypeCapability,
          typeRelationsCapability,
          superclassQuantifyCapability,
          subtypeQuantifyCapability,
          staticInvokeCapability,
          libraryCapability,
          libraryDependenciesCapability,
        ]);
}

const Reflectable reflector = Reflector();
