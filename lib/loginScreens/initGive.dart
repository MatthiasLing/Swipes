import 'package:flutter/material.dart';
import 'loginScreens.dart';

class InitGivePage extends StatefulWidget {
  const InitGivePage({Key key}) : super(key: key);

  @override
  _InitGivePageState createState() => _InitGivePageState();
}

class _InitGivePageState extends State<InitGivePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email;
  String _name;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                // alignment: Alignment.topCenter,
                child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/email.png'),
        Text(
          "Please verify your UChicago email address",
          style: TextStyle(color: Colors.black),
        ),
        Container(
            margin: new EdgeInsets.all(15.0),
            child: new Form(
                key: _formKey, autovalidate: _autoValidate, child: FormUI())),
      ],
    ))));
  }

// Here is our Form UI
  Widget FormUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          decoration: const InputDecoration(labelText: 'Preferred First Name'),
          keyboardType: TextInputType.text,
          validator: validateName,
          onSaved: (String val) {
            _name = val;
          },
        ),
        new TextFormField(
          decoration: const InputDecoration(labelText: 'UChicago Email'),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          onSaved: (String val) {
            _email = val;
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
        new BottomScreenButton(function: _validateInputs)
      ],
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid email';
    else
      return null;
  }

  String validateName(String value) {
    value = value.trim();
    if (value.length == 0)
      return 'Please enter your a valid name';
    else
      return null;
  }

  List<String> _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      return [_name, _email];
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      return null;
    }
  }
}
