import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_app/pages/login_page.dart';
import 'package:rider_app/pages/main_page.dart';
import 'package:rider_app/rider_app.dart';
import 'package:rider_app/widgets/progress_dialog.dart';

class RegisterPage extends StatelessWidget {
  static const String idScreen = "register";
  TextEditingController nameTec = TextEditingController();
  TextEditingController emailTec = TextEditingController();
  TextEditingController phoneTec = TextEditingController();
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
                height: 20.0,
              ),
              Image(
                image: AssetImage("images/logo.png"),
                width: 350.0,
                height: 350.0,
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 1.0,
              ),
              Text(
                "Register as a Rider",
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
                      controller: nameTec,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(fontSize: 14.0),
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 10.0)),
                      style: TextStyle(fontSize: 14.0),
                    ),
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
                      controller: phoneTec,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone",
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
                        if (nameTec.text.length < 3) {
                          displayMessage(
                              "Name must be at least 3 characters.", context);
                        } else if (!emailTec.text.contains("@")) {
                          displayMessage(
                              "Email address is not valid.", context);
                        } else if (phoneTec.text.isEmpty) {
                          displayMessage("Phone Number is mandatory.", context);
                        } else if (passwordTec.text.length < 6) {
                          displayMessage(
                              "Password must be at least 6 characters.",
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 50.0,
                        child: Center(
                          child: Text(
                            "Create Account",
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
                        context, LoginPage.idScreen, (route) => false);
                  },
                  child: Text(
                    "Already have an Account? Login Here.",
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return ProgressDialog(
            message: "Registering, Please Wait...",
          );
        });

    final User user = (await fbAuth
            .createUserWithEmailAndPassword(
                email: emailTec.text, password: passwordTec.text)
            .catchError((errMsg) {
      displayMessage("Error: " + errMsg.toString(), context);
    }))
        .user;

    if (user != null) {
      Map userDataMap = {
        "name": nameTec.text.trim(),
        "email": emailTec.text.trim(),
        "phone": phoneTec.text.trim()
      };

      usersRef.child(user.uid).set(userDataMap);
      displayMessage(
          "Congratulations, your account has been created.", context);

      Navigator.pushNamedAndRemoveUntil(
          context, MainPage.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      displayMessage("New user account has not been created.", context);
    }
  }

  void displayMessage(String message, BuildContext context) {
    Fluttertoast.showToast(msg: message);
  }
}
