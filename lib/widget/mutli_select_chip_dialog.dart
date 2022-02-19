import 'package:flutter/material.dart';
import 'package:olx/model/field_proprtires_entity.dart';
import 'package:olx/utils/global_locale.dart';

class MultiSelectChip extends StatefulWidget {
  final List<FieldProprtiresSpecificationoption>? reportList;
  final Function(List<FieldProprtiresSpecificationoption>)? onSelectionChanged; // +added
  MultiSelectChip(
      this.reportList,
      {this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}
class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<FieldProprtiresSpecificationoption> selectedChoices = List.empty();
  _buildChoiceList() {
    List<Widget> choices = List.empty();
    widget.reportList!.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(allTranslations.isEnglish ?item.EnglishName! :item.ArabicName!),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged!(selectedChoices); // +added
            });
          },
        ),
      ));
    });
    return choices;
  }
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}