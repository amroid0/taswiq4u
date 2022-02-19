import 'package:flutter/material.dart';

class AuthInputWidget extends StatelessWidget {
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChange;
  final Function(String)? onSaved;
  final String? labelText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool invisbleText;
  final TextEditingController? contoller;
  final bool readOnly;
  final Icon? suffixIcon;
  final Function? onTap;

  AuthInputWidget(
      {this.labelText,
      this.focusNode,
      this.onFieldSubmitted,
      this.onChange,
      this.errorText,
        this.onSaved,
        this.invisbleText=false,
      this.keyboardType,
        this.contoller,
      this.textInputAction,
        this.readOnly=false,
        this. suffixIcon,
        this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(color:Colors.black12,border: Border.all(
        width: 2.0,
        color: Colors.green,


      ),
        borderRadius: BorderRadius.all(
            Radius.circular(8.0) //         <--- border radius here
        ),
      ),
      child: TextFormField(
        focusNode: focusNode,
        readOnly: readOnly,
        onTap: onTap as void Function()?,

        keyboardType:keyboardType,
        decoration: InputDecoration(
          labelText: labelText,filled: true,
          border: InputBorder.none,
          errorText: errorText,
          errorStyle:TextStyle(fontSize:10,fontWeight:FontWeight.bold,height: 2),
          fillColor: Color(0xffF2F4F6),
          isDense: true,
          suffixIcon: suffixIcon

        ),
        obscureText: invisbleText,
        controller: contoller,
        textInputAction: TextInputAction.next,
        onFieldSubmitted:onFieldSubmitted,
        onChanged: onChange,


      ),
    );
  }
}
