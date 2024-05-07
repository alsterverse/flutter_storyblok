import 'package:flutter_storyblok/utils.dart';

final class Table {
  Table({required this.columns});
  factory Table.fromJson(JSONMap json) {
    final thead = List<JSONMap>.from(json["thead"]).map((e) => e["value"] as String).toList();
    final tbody = List<JSONMap>.from(json["tbody"])
        .map(
          (e) => List<JSONMap>.from(e["body"]) //
              .map((e) => e["value"] as String)
              .toList(),
        )
        .toList();

    return Table(
      columns: thead
          .mapIndexed((i, head) => [
                head,
                ...tbody.map((body) => body[i]),
              ])
          .toList(),
    );
  }

  final List<List<String>> columns;
}
