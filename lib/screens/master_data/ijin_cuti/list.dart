import 'dart:convert';

import 'package:asik/screens/master_data/ijin_cuti/add.dart';
import 'package:asik/screens/master_data/ijin_cuti/edit.dart';
import 'package:flutter/material.dart';
import '../../../api/api.dart';
import '../../../models/ijinCuti_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListIjinCuti extends StatefulWidget {
  @override
  State<ListIjinCuti> createState() => _ListIjinCutiState();
}

class _ListIjinCutiState extends State<ListIjinCuti> {
  bool loading = true;
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

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

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http
        .post(Uri.parse(BaseUrl.urlListIjinCuti), body: {"id_user": iduser});

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

  _proseshapus(String idIjin) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusIjinCuti), body: {"id_ijin": idIjin});
    final data = jsonDecode(response.body);
    int value = data['success'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _lihatData();
      });
    } else {
      print(pesan);
      print(idIjin);
    }
  }

  dialogHapus(String idIjin) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Apakah anda yakin ingin menghapus data ini?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 18.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Tidak",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 25.0),
                    InkWell(
                      onTap: () {
                        _proseshapus(idIjin);
                      },
                      child: Text(
                        "Ya",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ]),
        );
      },
    );
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
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
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
                if (data.persetujuan == "0") ...[
                  IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EditIjinCuti(data, _lihatData)));
                      }),
                  IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        dialogHapus(data.idIjin.toString());
                      }),
                ] else if (data.persetujuan == "1") ...[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: const Text("Disetujui"),
                    color: Colors.green,
                  ),
                ] else ...[
                  Container(
                    padding: EdgeInsets.all(10),
                    child: const Text("Ditolak"),
                    color: Colors.red,
                  ),
                ]
              ],
            ),
          ]));
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber[500],
          title: const Text(
            'Daftar Ijin/Cuti',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => new AddIjinCuti(_lihatData)));
        },
        backgroundColor: Colors.amber[500],
        child: const Icon(Icons.add),
      ),
    );
  }
}
