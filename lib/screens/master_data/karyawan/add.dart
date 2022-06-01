import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

import '../../../models/jabatan_model.dart';
import '../../../api/api.dart';

class AddKaryawan extends StatefulWidget {
  final VoidCallback reload;
  AddKaryawan(this.reload);

  @override
  _AddKaryawanState createState() => _AddKaryawanState();
}

class _AddKaryawanState extends State<AddKaryawan> {
  String? namaJabatan, jabatan, jenisKelamin;
  final _key = new GlobalKey<FormState>();

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      proses();
    }
  }

  proses() async {
    try {
      var uri = Uri.parse(BaseUrl.urlTambahJabatan);
      var request = http.MultipartRequest("POST", uri);
      request.fields['namaJabatan'] = namaJabatan!;

      var response = await request.send();
      if (response.statusCode > 2) {
        if (this.mounted) {
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
        }
      } else {
        print("Data Gagal Ditambahkan");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  final TextStyle valueStyle = TextStyle(fontSize: 16.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
          backgroundColor: Colors.amber[500],
          title: const Text('Tambah Karyawan', style: TextStyle(fontWeight: FontWeight.bold),)
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16.0), 
            children: <Widget>[
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi nama karyawan";
                  }
                },
                onSaved: (e) => namaJabatan = e,
                decoration: InputDecoration(labelText: "Nama Jabatan"),
              ),
              TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi jenis kelamin karyawan";
                  }
                },
                onSaved: (e) => jenisKelamin = e,
                decoration: InputDecoration(labelText: "Jenis Kelamin"),
              ),
                            TextFormField(
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan isi jabatan";
                  }
                },
                onSaved: (e) => jabatan = e,
                decoration: InputDecoration(labelText: "Jabatan"),
              ),
              MaterialButton(
                padding: EdgeInsets.all(25.0),
                color: Colors.amber[500],
                onPressed: () => check(),
                child: Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ],
          ),
        ));
  }
}
