import 'package:flutter/material.dart';

class CheckboxLabel extends StatelessWidget {
  final String? label;
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final TextStyle? labelStyle;

  const CheckboxLabel(
      {Key? key, this.label, this.value, this.onChanged, this.labelStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged!(!value!);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Checkbox(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: value,
                onChanged: onChanged,
                activeColor: Theme.of(context).primaryColor),
            Text(label!, style: labelStyle),
          ],
        ),
      ),
    );
  }
}