import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//enum textFieldSuffixType { PASSWORD, TEXT }

class TextFieldDecoration extends StatefulWidget {
  final bool enabled;
  final String hintText;
  final String labelText;
  final String initValue;
  final bool isPassword;
  final prefixIcon;
  final bool isPrefixWidget;
  final bool autoFocus;
  final FocusNode focusNode;
  var onTap;
  final int maxLength;
  var suffixIcon;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final Function(String) onSaved;
  final TextInputAction textInputAction;
  final String Function(String) validator;
  final TextDirection textDirection;
  final TextAlign textAlign;
  final contentPaddingVertical;
  final bool readOnly;
  final String errorText;
  final bool invisbleText;
  final Function(String) onFieldSubmitted;
  final TextEditingController textEditingController;
  int maxLine;
  Color fillColor;
  Color suffixIconColor;
  Color hintTextColor;
  Color labelTextColor;
  Color textColor;
  Color borderColor;
  var fontSize;
  var borderRadius;
  bool isDense;
  var elevation;
  bool autoValdite;
  Widget child;

  TextFieldDecoration(
      {this.hintText,
      @required this.keyboardType,
      this.validator,
      this.prefixIcon,
      this.isPrefixWidget = true,
      this.onChanged,
      this.maxLine = 1,
      this.focusNode,
      this.suffixIcon,
      this.suffixIconColor,
      this.isPassword = false,
      this.textInputAction = TextInputAction.done,
      this.enabled = true,
      this.onFieldSubmitted,
      @required this.textEditingController,
      this.fillColor,
      this.fontSize,
      this.onTap,
      this.textDirection,
      this.hintTextColor,
      @required this.labelText,
      this.labelTextColor,
      this.borderColor,
      this.autoFocus = false,
      this.initValue,
      this.maxLength,
      this.borderRadius = 32,
      this.isDense = true,
      this.textColor = Colors.black,
      this.textAlign = TextAlign.center,
      this.elevation,
      this.contentPaddingVertical = 0.0,
      this.errorText,
      this.invisbleText,
      this.readOnly = false,
      this.onSaved,
      this.autoValdite = false,
      this.child
//      this.textFieldType = textFieldSuffixType.TEXT
      });

  @override
  _TextFieldDecorationState createState() => _TextFieldDecorationState();
}

class _TextFieldDecorationState extends State<TextFieldDecoration> {
  bool isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    // widget.fillColor = widget.fillColor ?? Colors.white;
    widget.suffixIconColor = widget.suffixIconColor ?? Color(0xffB4BBC9);
    widget.hintTextColor = widget.hintTextColor ?? Color(0xffCAD1E0);
    widget.labelTextColor = widget.labelTextColor ?? Colors.black;
    widget.borderColor = widget.borderColor ?? Color(0xffB5B5B5);
    return Card(
        margin: const EdgeInsets.symmetric(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0),
        ),
        color: widget.fillColor ?? Colors.white,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.0),
              border: Border.all(color: widget.borderColor, width: 0.5)),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: TextFormField(
                readOnly: widget.readOnly,
                maxLength: widget.maxLength,
                maxLengthEnforced: true,
                obscureText: widget.isPassword && !isShowPassword,
                maxLines: widget.maxLine,
                enabled: widget.enabled,
                autovalidate: widget.autoValdite,
                inputFormatters: [
                  if (widget.keyboardType == TextInputType.phone)
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                cursorWidth: 0.5,
                initialValue: widget.initValue,
                onTap: () {
                  try {
                    widget.onTap();
                  } catch (e) {}
                },
                style: TextStyle(color: widget.textColor, fontSize: 14),
                validator: widget.validator,
                onChanged: widget.onChanged,
                focusNode: widget.focusNode,

                // textDirection: widget.textDirection,
                // textDirection: widget.textDirection,
                keyboardType: widget.keyboardType,
                textInputAction: TextInputAction.next,
                controller: widget.textEditingController,
                onFieldSubmitted: widget.onFieldSubmitted,
                textAlign: TextAlign.start,
                cursorColor: Colors.black12,
                autofocus: widget.autoFocus,
                decoration: InputDecoration(
                    // errorStyle: TextStyle(
                    //     fontSize: 10, fontWeight: FontWeight.bold, height: 10),
                    isDense: widget.isDense,
                    //     filled: widget.fillColor == null ? false : true,
                    hintText: widget.labelText,
                    //     fillColor: widget.fillColor,
                    //     // isDense: false,
                    hintStyle: TextStyle(
                        color: widget.hintTextColor,
                        fontSize: widget.fontSize != null
                            ? widget.fontSize.toDouble()
                            : null),
                    prefixIcon: widget.prefixIcon == null
                        ? null
                        : widget.isPrefixWidget
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [widget.prefixIcon])
                            : Icon(widget.prefixIcon, color: Color(0xffB4BBC9)),
                    suffixIcon: widget.isPassword
                        ? GestureDetector(
                            onTap: () {
                              isShowPassword = !isShowPassword;
                              setState(() {});
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.symmetric(),
                                      child: Image.asset(
                                          !isShowPassword
                                              ? 'images/hide.png'
                                              : 'images/hide.png',
                                          height: 30,
                                          width: 30))
                                ]))
                        : widget.suffixIcon != null
                            ? widget.suffixIcon
                            : null,
                    border: InputBorder.none,
                    // counterText: '',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 12))),
          ),
        ));
  }
}
