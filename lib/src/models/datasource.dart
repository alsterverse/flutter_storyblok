import 'package:flutter_storyblok/src/utils.dart';

final class Datasource {
  final int id;
  final String name;
  final String slug;
  final List<DatasourceDimension> dimensions;

  const Datasource({
    required this.id,
    required this.name,
    required this.slug,
    required this.dimensions,
  });

  factory Datasource.fromJson(JSONMap json) => Datasource(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        dimensions: List<JSONMap>.from(json["dimensions"]).map(DatasourceDimension.fromJson).toList(),
      );
}

final class DatasourceDimension {
  final int id;
  final int datasourceId;
  final String name;
  final String entryValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DatasourceDimension({
    required this.id,
    required this.datasourceId,
    required this.name,
    required this.entryValue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DatasourceDimension.fromJson(JSONMap json) => DatasourceDimension(
        id: json["id"],
        datasourceId: json["datasourceId"],
        name: json["name"],
        entryValue: json["entryValue"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}

final class DatasourceEntry {
  final int id;
  final String name;
  final String value;
  final String? dimensionValue;

  const DatasourceEntry({
    required this.id,
    required this.name,
    required this.value,
    required this.dimensionValue,
  });

  factory DatasourceEntry.fromJson(JSONMap json) => DatasourceEntry(
        id: json["id"],
        name: json["name"],
        value: json["value"],
        dimensionValue: json["dimensionValue"],
      );
}
