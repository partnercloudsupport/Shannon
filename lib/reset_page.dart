import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shannon/widgets/button.dart';
import 'package:shannon/builder/scaffold_builder.dart';
import 'package:shannon/handler/login_handler.dart';
import 'package:shannon/globals/strings.dart';

class ResetPage extends StatefulWidget {
  @override
  createState() => _ResetPage();
}

class _ResetPage extends State<ResetPage> {
  static final formKey = GlobalKey<FormState>();
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  bool _enabled = true;

  final TextEditingController emailController = TextEditingController();

  LoginHandler loginHandler = LoginHandler();
  Strings strings = Strings();
  bool validate() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      toggle();
      return true;
    } else {
      return false;
    }
  }

  void toggle() {
    setState(() {
      _enabled = !_enabled;
    });
  }

  // void submit() {
  //   if (validate()) {
  //     loginHandler.reset(_email).then((response) {
  //       toggle();
  //       if ((response)) {
  //         buildScaffold(
  //             key: scaffoldKey.currentState, text: strings.resetEmail);
  //       } else {
  //         formKey.currentState.reset();
  //         buildScaffold(
  //             key: scaffoldKey.currentState, text: strings.notfoundEmail);
  //       }
  //     });
  //   }
  // }

  Widget form() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      child: TextFormField(
        keyboardType: TextInputType.text,
        autocorrect: false,
        controller: emailController,
        validator: (val) {
          if (val.isEmpty) {
            return strings.emptyEmail;
          }
          if (!EmailValidator.validate(val)) {
            return strings.invalidEmail;
          }
        },
        onSaved: (val) => _email = val,
        inputFormatters: [
          WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
        ],
        decoration: InputDecoration(
          hintText: "email",
          contentPadding: EdgeInsets.all(10.0),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
          child: Text(
        "reset",
        style: TextStyle(fontSize: 50.0),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(32.0),
          child: ListView(
            children: <Widget>[
              title(),
              form(),
              // longButton(
              //     text: "reset my password",
              //     color: 'RED',
              //     action: _enabled ? submit : null),
              circleButton(Icon(Icons.arrow_back), 'YELLOW',
                  () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }
}
