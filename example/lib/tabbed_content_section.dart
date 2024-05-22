import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:example/tabbed_content_entry.dart';
import 'package:flutter/material.dart';

class TabbedContentSectionWidget extends StatefulWidget {
  const TabbedContentSectionWidget(this.blok, {Key? key}) : super(key: key);

  final bloks.TabbedContentSection blok;

  @override
  State<TabbedContentSectionWidget> createState() => _TabbedContentSectionWidgetState();
}

class _TabbedContentSectionWidgetState extends State<TabbedContentSectionWidget> {
  final expandedTiles = [];
  @override
  Widget build(BuildContext context) {
    final blok = widget.blok;

    return Column(
      children: [
        Text(blok.headline ?? "", style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Text(blok.lead ?? "", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 32),
        ExpansionPanelList(
          elevation: 0,
          expandIconColor: AppColors.primary,
          materialGapSize: 0,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              expandedTiles.contains(index) ? expandedTiles.remove(index) : expandedTiles.add(index);
            });
          },
          children: blok.entries.map((entry) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(entry.headline ?? "N/A"),
                );
              },
              canTapOnHeader: true,
              body: TabbedContentEntryWidget(entry),
              backgroundColor: AppColors.white,
              isExpanded: expandedTiles.contains(blok.entries.indexOf(entry)),
            );
          }).toList(),
        ),
      ],
    );
  }
}
