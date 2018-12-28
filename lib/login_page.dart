import 'package:flutter/material.dart';
import 'package:shannon/widgets/button.dart';
import 'package:flutter/services.dart';
import 'package:shannon/handler/login_handler.dart';
import 'package:shannon/builder/snackbar_builder.dart';
import 'package:shannon/editor_page.dart';
import 'package:shannon/landing_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:shannon/globals/strings.dart';

class LoginPage extends StatefulWidget {
  @override
  createState() => _LoginPage();
}

//Two form types.
enum FormType { login, register }

class _LoginPage extends State<LoginPage> {
  static final loginFormKey = GlobalKey<FormState>();
  static final loginScaffoldKey = GlobalKey<ScaffoldState>();

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

  //Global strings.
  // Strings string = new Strings();

  bool verify() {
    var form = loginFormKey.currentState;
    if (form.validate()) {
      toggle();
      form.save();
      if (_formType == FormType.register) {
        if (_password != _validPassword) {
          buildSnackbar(
              key: loginScaffoldKey.currentState,
              text: passwordMismatch,
              color: 'LIGHT');
          return false;
        }
      }
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

  void submit() {
    if (verify()) {
      if (_formType == FormType.login) {
        loginHandler.login(_username, _password).then((response) {
          toggle();
          print(response);
          if (response == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LandingPage()),
            );
          } else if (response == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditorPage()),
            );
          } else {
            loginFormKey.currentState.reset();
            buildSnackbar(
                key: loginScaffoldKey.currentState,
                text: wrongLogin,
                color: 'LIGHT');
          }
        });
      } else {
        loginHandler.register(_username, _password).then((response) {
          toggle();
          if (response) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditorPage()),
            );
          } else {
            loginFormKey.currentState.reset();
            buildSnackbar(
                key: loginScaffoldKey.currentState,
                text: emailExists,
                color: 'LIGHT');
          }
        });
      }
    }
  }

  void moveToRegister() {
    loginFormKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    loginFormKey.currentState.reset();
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
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            controller: userController,
            validator: (val) {
              if (val.isEmpty) {
                return emptyEmail;
              }
              if (!EmailValidator.validate(val)) {
                return invalidEmail;
              }
            },
            onSaved: (val) => _username = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
            ],
            decoration: InputDecoration(
              hintText: "email",
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
                return emptyPassword;
              }
              if (val.length < 6) {
                return invalidPassword;
              }
            },
            onSaved: (val) => _password = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
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
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            controller: userController,
            validator: (val) {
              if (val.isEmpty) {
                return emptyPassword;
              }
              if (!EmailValidator.validate(val)) {
                return invalidEmail;
              }
            },
            onSaved: (val) => _username = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
            ],
            decoration: InputDecoration(
              hintText: "email",
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
                return emptyPassword;
              }
              if (val.length < 6) {
                return invalidPassword;
              }
            },
            onSaved: (val) => _password = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.v]")),
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
                return emptyPassword;
              }
              if (val.length < 6) {
                return invalidPassword;
              }
            },
            onSaved: (val) => _validPassword = val,
            inputFormatters: [
              WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9!.-_]")),
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
              child:
                  longButton("login", "RED", _enabled ? submit : null)),
          Expanded(
              child: longButton(
                  "signup?", "RED", _enabled ? moveToRegister : null)),
        ];
      case FormType.register:
        return [
          Expanded(
              child: longButton(
                  "register", "RED", _enabled ? submit : null)),
          Expanded(
              child: longButton(
                  "login?", "RED", _enabled ? moveToLogin : null)),
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
          longButton("google login", "YELLOW", _enabled ? () => null : null),
          longButton("facebook login", "BLUE", _enabled ? () => null : null),
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
      key: loginScaffoldKey,
      body: Form(
        key: loginFormKey,
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
