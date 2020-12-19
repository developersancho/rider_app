import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/pages/main_page.dart';
import 'package:rider_app/pages/register_page.dart';
import 'package:rider_app/rider_app.dart';
import 'package:rider_app/widgets/progress_dialog.dart';

class LoginPage extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTec = TextEditingController();
  TextEditingController passwordTec = TextEditingController();

  final FirebaseAuth fbAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 45.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 350.0,
                height: 350.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "Login as a Rider",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand-Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: emailTec,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 1.0,
                    ),
                    TextField(
                      controller: passwordTec,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        if (!emailTec.text.contains("@")) {
                          displayMessage(
                              "Email address is not valid.", context);
                        } else if (passwordTec.text.isEmpty) {
                          displayMessage("Password is mandatory.", context);
                        } else {
                          loginUser(context);
                        }
                      },
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand-Bold"),
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0)),
                    )
                  ],
                ),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegisterPage.idScreen, (route) => false);
                  },
                  child: Text(
                    "Do not have an Account? Register Here.",
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void loginUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgressDialog(
            message: "Authenticating, Please Wait...",
          );
        });

    final User user = (await fbAuth
            .signInWithEmailAndPassword(
                email: emailTec.text, password: passwordTec.text)
            .catchError((errMsg) {
      Navigator.pop(context);
      displayMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (user != null) {
      usersRef.child(user.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.idScreen, (route) => false);
          displayMessage("Log In success.", context);
        } else {
          Navigator.pop(context);
          fbAuth.signOut();
          displayMessage("Please create new account.", context);
        }
      });
    } else {
      Navigator.pop(context);
      displayMessage("Error Occured.", context);
    }
  }

  void displayMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
