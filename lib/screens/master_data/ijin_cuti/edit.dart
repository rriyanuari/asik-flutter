import 'dart:convert';
import 'dart:io';
import 'package:asik/screens/master_data/ijin_cuti/list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import '../../../models/ijinCuti_model.dart';
import '../../../api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:asik/custom/datePicker.dart';

class EditIjinCuti extends StatefulWidget {
  final VoidCallback reload;
  final IjinCutiModel model;
  EditIjinCuti(this.model, this.reload);

  @override
  _EditIjinCutiState createState() => _EditIjinCutiState();
}

class _EditIjinCutiState extends State<EditIjinCuti> {
  String? jenisIjin, tanggalAwal, tanggalAkhir, alasan;
  // String iduser = "";

  // getPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     iduser = preferences.getString('id_user')!;
  //   });
  // }

  final _key = new GlobalKey<FormState>();

  TextEditingController? txtAlasan;

  setup() async {
    // txtJenisIjin = TextEditingController(text: widget.model.jenisIjin);
    // txtNamaLengkap = TextEditingController(text: widget.model.namaLengkap);
    // jenisKelamin = widget.model.jenisKelamin;
    jenisIjin = widget.model.jenisIjin;
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
      proses();
    }
  }

  proses() async {
    try {
      var uri = Uri.parse(BaseUrl.urlUbahIjinCuti);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id_ijin'] = widget.model.idIjin!;
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
                  Container(child: Text("Jenis Ijin")),
                  DropdownButton(
                    alignment: Alignment.topLeft,
                    // style: valueStyle,
                    value: jenisIjin,
                    items: <String>['Cuti', 'Sakit', 'Ijin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        jenisIjin = newValue!;
                      });
                    },
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
                    controller: txtAlasan,
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi alasan";
                      }
                    },
                    onSaved: (e) => alasan = e,
                    decoration: InputDecoration(labelText: "Alasan"),
                  ),
                  Center(
                    child: Container(
                      // alignment: Alignment.center,
                      // color: Colors.blue,
                      width: double.infinity,
                      child: MaterialButton(
                        padding: EdgeInsets.all(25.0),
                        color: Colors.amber[500],
                        onPressed: () => check(),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
