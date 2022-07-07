import 'dart:convert';

import 'package:asik/screens/master_data/karyawan/add.dart';
import 'package:asik/screens/master_data/karyawan/edit.dart';
import 'package:flutter/material.dart';
import 'package:asik/screens/master_data/list_menu.dart';
import '../../../api/api.dart';
import '../../../models/karyawan_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';

class ListCari extends StatefulWidget {
  ListCari() : super();

  final String title = "";
  @override
  State<ListCari> createState() => _ListCariState();
}

class _ListCariState extends State<ListCari> {
  late AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<KaryawanModel>> key = new GlobalKey();
  static List<KaryawanModel> products = <KaryawanModel>[];
  bool loading = true;

  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  //

  Future<void> _lihatData() async {
    try {
      final response = await http.get(Uri.parse(BaseUrl.urlListKaryawan));
      if (response.statusCode == 200) {
        products = loadUsers(response.body);
        print('Karyawan: ${products.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting product.");
      }
    } catch (e) {
      print("Error getting data api.");
    }
  }

  static List<KaryawanModel> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed
        .map<KaryawanModel>((json) => KaryawanModel.fromJson(json))
        .toList();
  }

  _proseshapus(String idUser) async {
    final response = await http
        .post(Uri.parse(BaseUrl.urlHapusKaryawan), body: {"id_user": idUser});
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
      print(idUser);
    }
  }

  dialogHapus(String idUser) {
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
                        _proseshapus(idUser);
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

  Widget row(KaryawanModel product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          product.namaLengkap!,
          style: TextStyle(fontSize: 16.0),
        ),
        SizedBox(
          width: 10.0,
        ),
        Text(
          product.namaJabatan!,
        ),
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => EditKaryawan(product, _lihatData)));
            }),
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              dialogHapus(product.idUser.toString());
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber[500],
          title: const Text(
            'Cari Karyawan',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            //jika search bernilai false maka tampilkan icon search
            //jika search bernilai true maka tampilkan icon close
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ListCari()));
              },
            )
          ]),
      body: RefreshIndicator(
          onRefresh: _lihatData,
          key: _refresh,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : searchTextField = AutoCompleteTextField<KaryawanModel>(
                  key: key,
                  clearOnSubmit: false,
                  suggestions: products,
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                    hintText: "Masukan Nama",
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  itemFilter: (item, query) {
                    return item.namaLengkap!
                        .toLowerCase()
                        .startsWith(query.toLowerCase());
                  },
                  itemSorter: (a, b) {
                    return a.namaLengkap!.compareTo(b.namaLengkap!);
                  },
                  itemSubmitted: (item) {
                    setState(() {
                      searchTextField.textField!.controller?.text =
                          item.namaLengkap!;
                    });
                  },
                  itemBuilder: (context, item) {
                    return row(item);
                  },
                )),
    );
  }
}
