import 'package:flutter/material.dart';
import 'package:shannon/widgets/button.dart';
import 'package:flutter/services.dart';
import 'package:shannon/handler/login_handler.dart';
import 'package:shannon/builder/scaffold_builder.dart';

class LoginPage extends StatefulWidget {
  @override
  createState() => _LoginPage();
}

//Two form types.
enum FormType { login, register }

class _LoginPage extends State<LoginPage> {
  static final formKey = GlobalKey<FormState>();
  static final scaffoldKey = GlobalKey<ScaffoldState>();

  //Set of controllers to test validity of inputs.
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController validPassController = TextEditingController();

  //Switch for form type.
  FormType _formType = FormType.login;

  //String value for form fields.
  String _username;
  String _password;
  String _validPassword;

  //Boolean to disable button on empty fields.
  bool _enabled = true;

  //Instance of login handler to hangle form submission.
  LoginHandler loginHandler = LoginHandler();
  ScaffoldBuilder scaffoldBuilder = ScaffoldBuilder();

  bool validate() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_formType == FormType.login) {
        toggle();
        return true;
      }
      if (_formType == FormType.register) {
        if (_password == _validPassword) {
          toggle();
          return true;
        } else {
          scaffoldBuilder.buildScaffold(
              scaffoldKey.currentState, "password do not match 😔", 'LIGHT', 4, false);
          return false;
        }
      }
    }
    return false;
  }

  void toggle() {
    setState(() {
      _enabled = !_enabled;
    });
  }

  void submit() {
    if (validate()) {
      if (_formType == FormType.login) {
        loginHandler.login(_username, _password).then((response) {
          toggle();
          if (response) {
            //       Navigator.pop(context);
          } else {
            formKey.currentState.reset();
            scaffoldBuilder.buildScaffold(scaffoldKey.currentState,
                "wrong username/password, try again 😔", 'LIGHT', 4, false);
          }
        });
      } else {
        loginHandler.register(_username, _password).then((response) {
          toggle();
          if (response) {
            //       Navigator.pop(context);
          } else {
            formKey.currentState.reset();
            scaffoldBuilder.buildScaffold(scaffoldKey.currentState,
                "username already exists, try again 😔", 'LIGHT', 4, false);
          }
        });
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  Widget wrapper() {
    return Container(
        padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        child: Column(
          children: fields(),
        ));
  }

  List<Widget> fields() {
    switch (_formType) {
      /**
       * fields:
       * username.
       * password.
       */
      case FormType.login:
        return [
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            controller: userController,
            validator: (val) {
              if (val.isEmpty) {
                return "username cannot be empty";
              }
              if (val.length < 6) {
                return "username must be longer than 6 characters";
              }
            },
            onSaved: (val) => _username = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
              LengthLimitingTextInputFormatter(20),
            ],
            decoration: InputDecoration(
              hintText: "username",
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            autocorrect: false,
            controller: passController,
            validator: (val) {
              if (val.isEmpty) {
                return "password cannot be empty";
              }
              if (val.length < 6) {
                return "password must be longer than 6 characters";
              }
            },
            onSaved: (val) => _password = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
              LengthLimitingTextInputFormatter(20),
            ],
            decoration: InputDecoration(
              hintText: "password",
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
        ];
      /**
       * fields:
       * username.
       * password.
       * reeneter password.
       */
      case FormType.register:
        return [
          TextFormField(
            keyboardType: TextInputType.text,
            autocorrect: false,
            controller: userController,
            validator: (val) {
              if (val.isEmpty) {
                return "username cannot be empty";
              }
              if (val.length < 6) {
                return "username must be longer than 6 characters";
              }
            },
            onSaved: (val) => _username = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
              LengthLimitingTextInputFormatter(20),
            ],
            decoration: InputDecoration(
              hintText: "username",
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            autocorrect: false,
            controller: passController,
            validator: (val) {
              if (val.isEmpty) {
                return "password cannot be empty";
              }
              if (val.length < 6) {
                return "password must be longer than 6 characters";
              }
            },
            onSaved: (val) => _password = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.v]")),
              LengthLimitingTextInputFormatter(20),
            ],
            decoration: InputDecoration(
              hintText: "password",
              contentPadding: EdgeInsets.all(10.0),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            autocorrect: false,
            controller: validPassController,
            validator: (val) {
              if (val.isEmpty) {
                return "password cannot be empty";
              }
              if (val.length < 6) {
                return "password must be longer than 6 characters";
              }
            },
            onSaved: (val) => _validPassword = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
              LengthLimitingTextInputFormatter(20),
            ],
            decoration: InputDecoration(
              hintText: "reenter password",
              contentPadding: EdgeInsets.all(10.0),
            ),
          )
        ];
      default:
        return null;
    }
  }

  List<Widget> buttons() {
    switch (_formType) {
      /**
       * buttons:
       * login.
       * register a account.
       */
      case FormType.login:
        return [
          Expanded(
              child: longButton(
                  "login", "RED", _enabled ? submit : null, false)),
          Expanded(
              child: longButton(
                  "signup?", "RED", _enabled ? moveToRegister : null, false)),
        ];
      case FormType.register:
        return [
          Expanded(
              child: longButton(
                  "register", "RED", _enabled ? submit : null, false)),
          Expanded(
              child: longButton(
                  "login?", "RED", _enabled ? moveToLogin : null, false)),
        ];
      default:
        return null;
    }
  }

  Widget altButton() {
    return Container(
      child: Center(
          child: Column(
        children: <Widget>[
          Row(
            children: buttons(),
          ),
          // longButton("google login", "YELLOW", loginHandler.doLogin(), false),
          longButton("facebook login", "BLUE", () => null, false),
        ],
      )),
    );
  }

  Widget title() {
    var title;
    switch (_formType) {
      case FormType.login:
        title = "login";
        break;
      case FormType.register:
        title = "signup";
        break;
      default:
        title = "ohno";
    }
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Center(
          child: Text(
        title,
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
            children: <Widget>[title(), wrapper(), altButton()],
            // child: Column(
            // children: <Widget>[title()] + fields(),
          ),
          // ),
        ),
      ),
    );
  }
}
