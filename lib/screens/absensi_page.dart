import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asik/models/logAbsen_model.dart';
import 'package:asik/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'dart:convert';

class AbsenPage extends StatefulWidget {
  const AbsenPage({Key? key}) : super(key: key);

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

Widget _profile(String nama, jabatan) {
  return Center(
    child: Column(
      children: [
        Icon(
          Icons.person_outline_rounded,
          size: 50,
        ),
        Text('$nama'.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text('$jabatan',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic))
      ],
    ),
  );
}

Widget _itemAbsen(String tanggal, absenMasuk, absenKeluar, ket) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.amber[100],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
        Divider(),
        Container(
            color:
                (absenMasuk == "-") ? Colors.red : Colors.amber[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Absen Masuk'),
                Text('$absenMasuk'),
              ],
            )),
        Container(
            color:
                (absenKeluar == "-") ? Colors.red : Colors.amber[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Absen Keluar'),
                Text('$absenKeluar'),
              ],
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Keterangan'),
            Text('$ket'),
          ],
        )
      ]));
}

class _AbsenPageState extends State<AbsenPage> {
//coba
  bool loading = true;

  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  var value;
  String status = "", username = "", email = "", tanggal = "", iduser = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt('value');
      status = preferences.getString('status')!;
      username = preferences.getString('username')!;
      email = preferences.getString('email')!;
      tanggal = preferences.getString('tanggal')!;
      iduser = preferences.getString('id_user')!;
      _lihatData();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http
        .post(Uri.parse(BaseUrl.urlListAbsen), body: {'id_user': iduser});
    final data = jsonDecode(response.body);

    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        String? jam_masuk = api['jam_masuk'].toString();
         (jam_masuk == "00:00:00") ? jam_masuk = "-" : jam_masuk == jam_masuk ;


        String? jam_pulang = api['jam_pulang'].toString();
        (jam_pulang == "00:00:00") ? jam_pulang = "-" : jam_pulang == jam_pulang ;

        var ParseDate = DateTime.parse(api['date']);
        var formatter = new DateFormat('dd MMMM yyyy');
        String formattedDate = formatter.format(ParseDate);

        final ab = new LogAbsenModel(api['id_absen'],
            formattedDate, jam_masuk, jam_pulang, api['Keterangan']);
        list.add(ab);
      });

      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    Widget _item(data) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 1),
          child: Column(children: <Widget>[
            Divider(),
            Container(
                margin: EdgeInsets.symmetric(vertical: 1),
                child: Column(children: [
                  _itemAbsen(data.date, data.jamMasuk, data.jamPulang,
                      data.keterangan),
                  // _itemAbsen('02-04-2022', '07:42', '17:03'),
                ]))
          ]));
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber[500],
          title: const Text(
            'Daftar Absensi',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
      body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final data = list[i];
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: (_item(data)));
                  },
                )),
    );
  }
}
