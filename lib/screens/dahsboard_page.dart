import 'package:asik/screens/absensi_page.dart';
import 'package:asik/screens/master_data/list_menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback signOut;
  DashboardPage(this.signOut);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  var value;
  String status = "", username = "", email = "", tanggal = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt('value');
      status = preferences.getString('status')!;
      username = preferences.getString('username')!;
      email = preferences.getString('email')!;
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    Widget _menuDashboard(String Title, DynamicIcon, Nav) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.amber[500],
          ),
          child: MaterialButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Nav));
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      DynamicIcon,
                      color: Colors.white,
                      size: 50,
                    ),
                    Text(
                      '$Title',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ])));
    }

    ;

    Widget _menuAdmin() {
      return Column(
        children: [
          ListTile(
            title: Text("Master Data"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new ListMenuMaster()));
            },
          ),
          ListTile(
            title: Text("Persetujuan"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Laporan"),
            onTap: () {},
          ),
        ],
      );
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber[500],
          title: Text('Dashboard $status',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(username),
                accountEmail: Text(status),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: AssetImage('assets/img/user.png'),
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[500],
                ),
              ),
              if (status == "admin") _menuAdmin(),
              ListTile(title: Text("Logout"), onTap: () => signOut()),
            ],
          ),
        ),
        body: Container(
            margin: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(children: <Widget>[
              Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                    ),
                    Text('Halo selamat datang', style: TextStyle(fontSize: 16)),
                    Text('$username'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                    Text('Have a nice day.. ', style: TextStyle(fontSize: 16))
                  ],
                ),
              ),
              Flexible(
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 40),
                      child: GridView.count(
                          padding: EdgeInsets.all(20),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          crossAxisCount: 2,
                          children: [
                            _menuDashboard('Absensi', Icons.punch_clock_rounded,
                                AbsenPage()),
                            _menuDashboard(
                                'Cuti', Icons.file_copy, AbsenPage()),
                            _menuDashboard(
                                'Perdin', Icons.bus_alert, AbsenPage()),
                            _menuDashboard(
                                'Gaji', Icons.monetization_on, AbsenPage())
                          ])))
            ])));
  }
}
