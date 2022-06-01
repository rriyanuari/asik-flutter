import 'dart:convert';
import 'package:asik/screens/dahsboard_page.dart';
import 'package:flutter/material.dart';
import 'package:asik/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asik/screens/absensi_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginPageState extends State<LoginPage> {
  //coba

  //coba
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
      if (statusAPI == "1") {
        setState(() => statusAPI = "admin");
      } else {
        setState(() => statusAPI = "karyawan");
      }
      try {
        var now = new DateTime.now();
        var formatter = new DateFormat('yyyy-MM-dd');
        var timer = new DateFormat('H:m:s');
        var hour = new DateFormat('H');

        String formattedDate = formatter.format(now);

        String formattedtime = timer.format(now);
        var formathour = int.parse(hour.format(now));
        String jam_datang = "";
        String jam_pulang = "";
        //cobaawal
        final response1 = await http.post(Uri.parse(BaseUrl.urlLogAbsenPerson),
            body: {
              "id_user": data['id_user'],
              "date": formattedDate.toString()
            });
        final data1 = jsonDecode(response1.body);
        int value1 = data1['success'];
        String pesan = data1['message'];
        print(data1);
        if (value1 != 1) {
          print('tidak ada');
          if (formathour >= 6 && formathour <= 12) {
            jam_datang = formattedtime;
            final response2 = await http
                .post(Uri.parse(BaseUrl.urlLogAbsen.toString()), body: {
              "id_user": data['id_user'],
              "date": formattedDate.toString(),
              "jam_datang": jam_datang,
              "jam_pulang": jam_pulang,
              "ket": dropdownValue.toString()
              // "ket": jam_datang,
            });
            final data2 = jsonDecode(response2.body);
            print(data2);
            int code = data2['succes'];
            String pesan = data2['message'];
            print(data2);
          } else if (formathour >= 16 && formathour <= 23) {
            jam_pulang = formattedtime;
            final response2 = await http
                .post(Uri.parse(BaseUrl.urlLogAbsen.toString()), body: {
              "id_user": data['id_user'],
              "date": formattedDate.toString(),
              "jam_datang": jam_datang,
              "jam_pulang": jam_pulang,
              "ket": dropdownValue.toString()
              // "ket": jam_datang,
            });
            final data2 = jsonDecode(response2.body);
            print(data2);
            int code = data2['succes'];
            String pesan = data2['message'];
            print(data2);
          }
        } else if (formathour >= 16 && formathour <= 23) {
          print('data ada');
          jam_pulang = formattedtime;
          final response2 = await http
              .post(Uri.parse(BaseUrl.urlLogAbsenPulang.toString()), body: {
            "id_user": data['id_user'],
            "date": formattedDate.toString(),
            "jam_pulang": jam_pulang,
          });
          final data2 = jsonDecode(response2.body);
          print(data2);
          int code = data2['succes'];
          String pesan = data2['message'];
          print(data2);
          //cobaakhir

          //cobaawal
        } else {}
      } catch (e) {
        debugPrint(e.toString());
      }
      setState(() {
        String usernameAPI = data['username'];
        String userIdAPI = data['id_user'];
        String emailAPI = data['email'];

        _loginStatus = LoginStatus.signIn;
        savePref(value, statusAPI, usernameAPI, userIdAPI, emailAPI);
      });
    } else {
      print(pesan);
    }
  }

  savePref(int val, String statusAPI, String usernameAPI, String userIdAPI,
      String emailAPI) async {
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
      value = preferences.getInt('value');
      status = preferences.getString('status');
      username = preferences.getString('username');
      email = preferences.getString('email');

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
                child: (DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 16,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
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
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ));
        break;
      case LoginStatus.signIn:
        return DashboardPage(signOut);
        // return AbsenPage();

        break;
    }
  }
}
