import 'package:example/bloks.generated.dart' as bloks;
import 'package:example/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class TestMultiAssetsBlock extends StatefulWidget {
  final bloks.TestMultiAssetsBlock options;
  const TestMultiAssetsBlock({super.key, required this.options});

  @override
  State<TestMultiAssetsBlock> createState() => _TestMultiAssetsBlockScreenState();
}

class _TestMultiAssetsBlockScreenState extends State<TestMultiAssetsBlock> {
  bloks.TestMultiAssetsBlock get options => widget.options;

  List<String> testOptions = ["hej", "hej då", "hallå"];
  List<String> selectedValues = [];
  //List<String> formattedList = options.map

  @override
  Widget build(BuildContext context) {
    print("***");
    print("*** OPTIONS $options");
    return Container(
      width: MediaQuery.of(context).size.width / 1,
      height: 100,
      padding: const EdgeInsets.all(10),
      child: DropDownMultiSelect(
        options: testOptions,
        selectedValues: selectedValues,
        selected_values_style: const TextStyle(color: AppColors.white),
        onChanged: (List<dynamic> value) {
          print("SELECTED");
          print("$selectedValues");
        },
        whenEmpty: "Gör ett val",
      ),
    );
  }
}
