import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import '../../../models/persetujuan_model.dart';
import '../../../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asik/custom/datePicker.dart';

class EditPersetujuan extends StatefulWidget {
  final VoidCallback reload;
  final IjinCutiModel model;
  EditPersetujuan(this.model, this.reload);

  @override
  _EditPersetujuanState createState() => _EditPersetujuanState();
}

class _EditPersetujuanState extends State<EditPersetujuan> {
  String? jenisIjin, idUser, tanggalAwal, tanggalAkhir, alasan;

  final _key = new GlobalKey<FormState>();

  TextEditingController? txtAlasan, txtNama, txtJenisIjin;

  setup() async {
    txtNama = TextEditingController(text: widget.model.nama);
    txtJenisIjin = TextEditingController(text: widget.model.jenisIjin);
    tanggalAwal = widget.model.tanggalAwal;
    tanggalAkhir = widget.model.tanggalAkhir;
    txtAlasan = TextEditingController(text: widget.model.alasan);
    // tanggalGabung = widget.model.tanggalGabung;
    // idJabatan = widget.model.idJabatan;
  }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      setuju();
    }
  }

  check2() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      tolak();
    }
  }

  setuju() async {
    try {
      var uri = Uri.parse(BaseUrl.urlSetujuPersetujuan);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id_ijin'] = widget.model.idIjin!;
      request.fields['id_user'] = widget.model.idUser!;
      request.fields['jenis_ijin'] = jenisIjin!;
      request.fields['tanggal_awal'] = "$tanggalAwal";
      request.fields['tanggal_akhir'] = "$tanggalAkhir";
      request.fields['alasan'] = alasan!;
      var response = await request.send();
      if (response.statusCode > 2) {
        if (this.mounted) {
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
        }
      } else {
        print("Data Gagal Diubah");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  tolak() async {
    try {
      var uri = Uri.parse(BaseUrl.urlTolakPersetujuan);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id_ijin'] = widget.model.idIjin!;
      var response = await request.send();
      if (response.statusCode > 2) {
        if (this.mounted) {
          setState(() {
            widget.reload();
            Navigator.pop(context);
          });
        }
      } else {
        print("Data Gagal Diubah");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String? pilihTanggal, labelText;
  DateTime tanggalAw = new DateTime.now();
  DateTime tanggalAk = new DateTime.now();

  final TextStyle valueStyle = TextStyle(fontSize: 16.0);

  Future<Null> _selectedDate(BuildContext context) async {
    tanggalAw = DateTime.parse(widget.model.tanggalAwal.toString());
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tanggalAw,
        firstDate: DateTime(1972),
        lastDate: DateTime(2099));
    if (picked != null && picked != tanggalAw) {
      setState(() {
        tanggalAw = picked;
        tanggalAwal = new DateFormat("y-MM-dd").format(tanggalAw);
      });
    } else {}
  }

  Future<Null> _selectedDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tanggalAk,
        firstDate: DateTime(1972),
        lastDate: DateTime(2099));
    if (picked != null && picked != tanggalAk) {
      setState(() {
        tanggalAk = picked;
        tanggalAkhir = new DateFormat("y-MM-dd").format(tanggalAk);
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();

    setup();
  }

  @override
  Widget build(BuildContext context) {
    // jenisKelamin = widget.model.jenisKelamin.toString();
    return Scaffold(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
            backgroundColor: Colors.amber[500],
            title: const Text(
              'Edit Ijin/Cuti',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        body: Form(
            key: _key,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                // padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: txtNama,
                    enabled: false,
                    decoration: InputDecoration(labelText: "Nama Pegawai"),
                  ),
                  TextFormField(
                    controller: txtJenisIjin,
                    onSaved: (e) => jenisIjin = e,
                    enabled: false,
                    decoration: InputDecoration(labelText: "Jenis Ijin"),
                  ),
                  Text("dari Tanggal"),
                  DateDropDown(
                    labelText: labelText,
                    valueText: new DateFormat("d MMM y")
                        .format(DateTime.parse(tanggalAwal!)),
                    valueStyle: valueStyle,
                    onPressed: () {
                      _selectedDate(context);
                    },
                  ),
                  Text("sampai dengan tanggal"),
                  DateDropDown(
                    labelText: labelText,
                    // valueText: new DateFormat.yMd().format(tanggalGabung),
                    valueText: new DateFormat("d MMM y")
                        .format(DateTime.parse(tanggalAkhir!)),
                    valueStyle: valueStyle,
                    onPressed: () {
                      _selectedDate2(context);
                    },
                  ),
                  TextFormField(
                    enabled: false,
                    controller: txtAlasan,
                    onSaved: (e) => alasan = e,
                    decoration: InputDecoration(labelText: "Alasan"),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      // alignment: Alignment.center,
                      // color: Colors.blue,
                      width: double.infinity,
                      child: Row(
                        children: [
                          MaterialButton(
                            padding: EdgeInsets.all(25.0),
                            color: Colors.green[500],
                            onPressed: () => check(),
                            child: const Text(
                              'Setuju',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          Spacer(),
                          MaterialButton(
                            padding: EdgeInsets.all(25.0),
                            color: Colors.red[500],
                            onPressed: () => check2(),
                            child: const Text(
                              'Tolak',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
