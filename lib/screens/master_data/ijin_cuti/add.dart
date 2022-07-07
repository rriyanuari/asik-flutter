import 'dart:convert';
import 'dart:io';
import 'package:asik/screens/master_data/ijin_cuti/list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import '../../../api/api.dart';
import 'package:asik/custom/datePicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddIjinCuti extends StatefulWidget {
  final VoidCallback reload;
  AddIjinCuti(this.reload);

  @override
  _AddIjinCutiState createState() => _AddIjinCutiState();
}

class _AddIjinCutiState extends State<AddIjinCuti> {
  String? jenisIjin, alasan;
  // tanggalGabung;
  final _key = new GlobalKey<FormState>();

  var value;
  String iduser = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt('value');
      iduser = preferences.getString('id_user')!;
    });
  }

  final TextEditingController _userController = new TextEditingController();

  // JabatanModel? _currentJabatan;
  // final String? linkJabatan = BaseUrl.urlListJabatan;

  // Future<List<JabatanModel>> _fetchJabatan() async {
  //   var response = await http.get(Uri.parse(linkJabatan.toString()));
  //   print('hasil:' + response.statusCode.toString());
  //   if (response.statusCode == 200) {
  //     final items = json.decode(response.body).cast<Map<String, dynamic>>();
  //     List<JabatanModel> listOfJabatan = items.map<JabatanModel>((json) {
  //       return JabatanModel.fromJson(json);
  //     }).toList();
  //     return listOfJabatan;
  //   } else {
  //     throw Exception('Failed to load internet');
  //   }
  // }

  check() {
    final form = _key.currentState;
    if ((form as dynamic).validate()) {
      (form as dynamic).save();
      proses();
    }
  }

  proses() async {
    try {
      var uri = Uri.parse(BaseUrl.urlTambahIjinCuti);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id_user'] = iduser;
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
        print("Data Gagal Ditambahkan");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String? pilihTanggal, labelText;
  DateTime tanggalAwal = new DateTime.now();
  DateTime tanggalAkhir = new DateTime.now();

  final TextStyle valueStyle = TextStyle(fontSize: 16.0);

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tanggalAwal,
        firstDate: DateTime(1972),
        lastDate: DateTime(2099));
    if (picked != null && picked != tanggalAwal) {
      setState(() {
        tanggalAwal = picked;
        pilihTanggal = new DateFormat.yMd().format(tanggalAwal);
      });
    } else {}
  }

  Future<Null> _selectedDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tanggalAkhir,
        firstDate: DateTime(1972),
        lastDate: DateTime(2099));
    if (picked != null && picked != tanggalAkhir) {
      setState(() {
        tanggalAkhir = picked;
        pilihTanggal = new DateFormat.yMd().format(tanggalAkhir);
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
            backgroundColor: Colors.amber[500],
            title: const Text(
              'Tambah Ijin/Cuti',
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
                    valueText: new DateFormat("d MMM y").format(tanggalAwal),
                    valueStyle: valueStyle,
                    onPressed: () {
                      _selectedDate(context);
                    },
                  ),
                  Text("sampai dengan tanggal"),
                  DateDropDown(
                    labelText: labelText,
                    // valueText: new DateFormat.yMd().format(tanggalGabung),
                    valueText: new DateFormat("d MMM y").format(tanggalAkhir),
                    valueStyle: valueStyle,
                    onPressed: () {
                      _selectedDate2(context);
                    },
                  ),
                  TextFormField(
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
