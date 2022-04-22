import 'dart:convert';
import 'package:asik/screens/dahsboard_page.dart';
import 'package:flutter/material.dart';
import 'package:asik/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String? inputUsername, inputPassword;
  final _key = new GlobalKey<FormState>();
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
    }
    login();
  }

  login() async {
    final response = await http.post(Uri.parse(BaseUrl.urlLogin),
        body: {"username": inputUsername, "password": inputPassword});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    print(data);

    if (value == 1) {
      String statusAPI = data['status'];
      if(statusAPI == "1"){
        setState(() => statusAPI = "admin");
      }else{
        setState(() => statusAPI = "karyawan");
      }

      setState(() {
        String usernameAPI  = data['username'];
        String userIdAPI    = data['id_user'];
        String emailAPI   = data['email'];

        _loginStatus = LoginStatus.signIn;
        savePref(value, statusAPI, usernameAPI, userIdAPI, emailAPI);
      });
    } else {
      print(pesan);
    }
  }

  savePref(
      int val, 
      String statusAPI,
      String usernameAPI, 
      String userIdAPI,
      String emailAPI
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", val);
      preferences.setString("status", statusAPI);
      preferences.setString("username", usernameAPI);
      preferences.setString("id_user", userIdAPI);
      preferences.setString("email", emailAPI);
      preferences.commit();
    });
  }

  var value, status, username, email;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value       = preferences.getInt('value');
      status      = preferences.getString('status');
      username    = preferences.getString('username');
      email       = preferences.getString('email');

      if (value == 1) {
        _loginStatus = LoginStatus.signIn;
      } else {
        _loginStatus = LoginStatus.notSignIn;
      }
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.setString("status", "");
      preferences.setString("username", "");
      preferences.setString("email", "");
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  String dropdownValue = 'Absen';

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
            body: Form(
          key: _key,
          // autovalidate: _autovalidate,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: EdgeInsets.only(top: 90.0, left: 20.0, right: 20.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 40.0),
                child: Column(
                  children: [
                    Text(
                      "ASIK",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.5,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Aplikasi Sistem Kepegawaian",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
              TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return "Silahkan isi username";
                  } else {
                    return null;
                  }
                },
                onSaved: (e) => inputUsername = e,
                decoration: InputDecoration(
                  labelText: "username",
                ),
              ),
              TextFormField(
                obscureText: _secureText,
                onSaved: (e) => inputPassword = e,
                decoration: InputDecoration(
                    labelText: "password",
                    suffixIcon: IconButton(
                        icon: Icon(_secureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: showHide)),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: (
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(fontSize: 16,color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Absen', 'Cuti', 'Perdin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              ),
              MaterialButton(
                padding: EdgeInsets.all(25.0),
                color: Colors.amber[500],
                onPressed: () => check(),
                child: Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
              )
            ],
          ),
        ));
        break;
      case LoginStatus.signIn:
        return DashboardPage(signOut);
        break;
    }
  }
}
