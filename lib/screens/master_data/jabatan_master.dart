import 'dart:convert';

import 'package:flutter/material.dart';
import '../../api/api.dart';
import '../../models/jabatan_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';

class jabatanMaster extends StatefulWidget {
  
  @override
  State<jabatanMaster> createState() => _jabatanMasterState();
}

class _jabatanMasterState extends State<jabatanMaster> {
  bool loading = true;
  GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();

  final list = [];
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  getPref() async {
    _lihatData();
  }

  Future<void> _lihatData() async {
    list.clear();
    setState(() {
      loading = true;
    });

    final response = await http.get(Uri.parse(BaseUrl.urlListJabatan));

    if (response.contentLength == 2) {
      print(response);
    } else {
      print(response);
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new JabatanModel(
            api['id_jabatan'], 
            api['nama_jabatan'],
            api['log_datetime']
        );
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

    Widget _item(String id, jabatan){
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.amber[100],
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(id + ".     "),
                  Text(jabatan),
                ],
              ),
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {}
            ),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {}),
          ]
        )
      );
    }
   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[500],
        title: const Text('Daftar Jabatan', style: TextStyle(fontWeight: FontWeight.bold),)
      ),
      body: 
      RefreshIndicator(
        onRefresh: _lihatData,
        key: _refresh,
        child: loading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder( 
            itemCount: list.length,
            itemBuilder: (context, i) {
              final x = list[i];
              return  Container( 
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child:(_item(x.idJabatan.toString(), x.namaJabatan.toString()))
                );
            },
          ) 
      ) 
    );
  }
}