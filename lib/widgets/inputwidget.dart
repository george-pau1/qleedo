import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final double height;
  final String hintLabel;
  final String labelText;
  final String inputType;
  final Function onChangeText;
  final String widgetInput;
  InputWidget(
      {required this.height,
      required this.hintLabel,
      required this.labelText,
      required this.inputType,
      required this.onChangeText,
      required this.widgetInput});

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  var nameController = TextEditingController();
  var isValidText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      height: widget.height,
      child: TextField(
        controller: nameController,
        decoration: InputDecoration(
          hintText: widget.hintLabel != null ? widget.hintLabel : '',
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Colors.black87, fontSize: 20),
          border: const OutlineInputBorder(),
          errorText: this.isValidText,
          errorStyle: TextStyle(color: Colors.red),
          enabledBorder: const OutlineInputBorder(
            // width: 0.0 produces a thin "hairline" border
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ),
        keyboardType: this.widget.inputType == 'email'
            ? TextInputType.emailAddress
            : TextInputType.text,
        onChanged: (text) {
          this.widget.onChangeText(widget.widgetInput, text);
          this.errorValidateLocal(widget.widgetInput, text);
          print('...onChanged....' + this.nameController.text);
        },
        obscureText: this.widget.inputType == 'password' ? true : false,
      ),
    );
  }

  errorValidateLocal(String type, String value) {
    print(type + '.....setInputFields..77777...' + value);
    if (type == 'email') {
      if (value.length < 5) {
        setState(() {
          isValidText = 'Password should contains more then 5 character';
        });
      } else
        setState(() {
          isValidText = "";
        });
    } else if (type == 'password') {
      if (value.length < 5) {
        setState(() {
          isValidText = 'Password should contains more then 5 character';
        });
      } else
        setState(() {
          isValidText = "";
        });
    } else
      setState(() {
        isValidText = "";
      });
  }
}
