import 'package:collection/collection.dart';
import 'package:flutter_storyblok/src/utils.dart';

final class Table {
  Table({
    required this.columns,
    required this.rows,
  });
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
      rows: [thead, ...tbody],
    );
  }

  /// Lists data as columns. Each root list contains all items of that column.
  /// The first item of each column is the heading.
  final List<List<String>> columns;

  /// Lists data as rows. Each root list contains all items of that row.
  /// The first row is the heading.
  final List<List<String>> rows;
}
