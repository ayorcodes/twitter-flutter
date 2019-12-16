import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:news_app/api/authApi.dart';
import 'package:fluttertoast/fluttertoast.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final api = Auth();
  bool loading = false;

  handleLogin(String email, String password) async{
    await api.login(email, password).then((response) async{
      var output = response.data;
      await api.setToken(output['access_token']);
      Navigator.pushReplacementNamed(context, '/home');
    }).catchError((error) {
      return Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.lightBlue,
        textColor: Colors.white,
        fontSize: 16.0,
    );
    });
    
  }

  @override
  Widget build(BuildContext context) {

    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    final emailField = FormBuilderTextField(
      attribute: "email",
      style: style,
      validators: [
        FormBuilderValidators.required(),
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = FormBuilderTextField(
      attribute: "password",
      obscureText: true,
      style: style,
      validators: [
        FormBuilderValidators.required(),
      ],
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );


    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (_fbKey.currentState.saveAndValidate()) {
            var email = _fbKey.currentState.value['email'].toString();
            var password = _fbKey.currentState.value['password'].toString();
            handleLogin(email, password);
          }
        },
        child: Text("Login",
          textAlign: TextAlign.center,
          style: style.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
          body: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: FormBuilder(
                  key: _fbKey,
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 155.0,
                        child: Image.asset(
                          "assets/images/login.jpg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 45.0),
                      emailField,
                      SizedBox(height: 25.0),
                      passwordField,
                      SizedBox(height: 35.0),
                      loginButton,
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
