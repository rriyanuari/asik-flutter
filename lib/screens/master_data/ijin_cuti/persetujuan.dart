import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../models/persetujuan_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asik/screens/master_data/ijin_cuti/edit_persetujuan.dart';

class ListPersetujuan extends StatefulWidget {
  @override
  State<ListPersetujuan> createState() => _ListPersetujuanState();
}

class _ListPersetujuanState extends State<ListPersetujuan> {
  bool loading = true;
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  var value;
  String status = "", username = "", email = "", tanggal = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt('value');
      status = preferences.getString('status')!;
      username = preferences.getString('username')!;
      email = preferences.getString('email')!;
      tanggal = preferences.getString('tanggal')!;
      _lihatData();
    });
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.post(Uri.parse(BaseUrl.urlListPersetujuan));

    if (response.contentLength == 2) {
      print(response);
    } else {
      print(response);
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new IjinCutiModel(
            api['id_user'],
            api['id_ijin'],
            api['jenis_ijin'],
            api['tanggal_awal'],
            api['tanggal_akhir'],
            api['alasan'],
            api['persetujuan'],
            api['nama']);
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

  var noUrut = 1;
  @override
  Widget build(BuildContext context) {
    Widget _item(data) {
      return Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          color: Colors.amber[100],
          child: Row(children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("$noUrut.     "),
                  Text(data.tanggalAwal + "  s/d   "),
                  Text(data.tanggalAkhir),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EditPersetujuan(data, _lihatData)));
                    }),
              ],
            ),
          ]));
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber[500],
          title: const Text(
            'Daftar Persetujuan',
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
                    noUrut = i + 1;
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: (_item(data)));
                  },
                )),
    );
  }
}
