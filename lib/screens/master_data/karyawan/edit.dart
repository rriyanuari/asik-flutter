import 'dart:convert';
import 'dart:io';
import 'package:asik/screens/master_data/jabatan/list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import '../../../models/karyawan_model.dart';
import '../../../api/api.dart';
import '../../../models/jabatan_model.dart';
import 'package:asik/custom/datePicker.dart';

class EditKaryawan extends StatefulWidget {
  final VoidCallback reload;
  final KaryawanModel model;
  EditKaryawan(this.model, this.reload);

  @override
  _EditKaryawanState createState() => _EditKaryawanState();
}

class _EditKaryawanState extends State<EditKaryawan> {
  String? namaPegawai,
      namaJabatan,
      tanggalLahir,
      tanggalGabung,
      idJabatan,
      jenisKelamin;

  final _key = new GlobalKey<FormState>();

  TextEditingController? txtNamaLengkap;

  setup() async {
    txtNamaLengkap = TextEditingController(text: widget.model.namaLengkap);
    jenisKelamin = widget.model.jenisKelamin;
    tanggalLahir = widget.model.tanggalLahir;
    namaJabatan = widget.model.namaJabatan;
    tanggalGabung = widget.model.tanggalGabung;
    idJabatan = widget.model.idJabatan;
  }

  JabatanModel? _currentJabatan;
  final listJabatan = [];
  final String? linkJabatan = BaseUrl.urlListJabatan;

  Future<List<JabatanModel>> _fetchJabatan() async {
    var response = await http.get(Uri.parse(linkJabatan.toString()));
    print('hasil:' + response.statusCode.toString());
    if (response.statusCode == 200) {
      final items = json.decode(response.body).cast<Map<String, dynamic>>();
      List<JabatanModel> listOfJabatan = items.map<JabatanModel>((json) {
        return JabatanModel.fromJson(json);
      }).toList();
      return listOfJabatan;
    } else {
      throw Exception('Failed to load internet');
    }
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
      var uri = Uri.parse(BaseUrl.urlUbahKaryawan);
      var request = http.MultipartRequest("POST", uri);
      request.fields['id_user'] = widget.model.idUser!;
      request.fields['nama_lengkap'] = namaPegawai!;
      request.fields['jenis_kelamin'] = jenisKelamin!;
      request.fields['tanggal_lahir'] = '$tgl';
      request.fields['id_jabatan'] = idJabatan.toString();
      request.fields['tanggal_gabung'] = tanggalGabung!;
      print('print idjabatan: $idJabatan');
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
  DateTime tgl = new DateTime.now();
  DateTime tglG2 = new DateTime.now();

  final TextStyle valueStyle = TextStyle(fontSize: 16.0);

  Future<Null> _selectedDate(BuildContext context) async {
    tgl = DateTime.parse(widget.model.tanggalLahir.toString());
    print('tanggal :' + tgl.toString());
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1972),
        lastDate: DateTime(2099));
    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        tanggalLahir = new DateFormat("y-MM-dd").format(tgl);
      });
    } else {}
  }

  Future<Null> _selectedDate2(BuildContext context) async {
    tglG2 = DateTime.parse(widget.model.tanggalGabung.toString());
    print('tanggal :' + tglG2.toString());
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tglG2,
        firstDate: DateTime(1972),
        lastDate: DateTime(2099));
    if (picked != null && picked != tglG2) {
      setState(() {
        tglG2 = picked;
        tanggalGabung = new DateFormat("y-MM-dd").format(tglG2);
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
              'Edit Karyawan',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(
                controller: txtNamaLengkap,
                validator: (e) {
                  if ((e as dynamic).isEmpty) {
                    return "Silahkan ubah nama lengkap";
                  }
                },
                onSaved: (e) => namaPegawai = e,
                decoration: InputDecoration(labelText: "Nama Lengkap"),
              ),
              const Text("Jenis Kelamin"),
              DropdownButton(
                value: jenisKelamin,
                items: <String>['laki-laki', 'perempuan']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    jenisKelamin = newValue!;
                  });
                },
              ),
              Text("Tanggal Lahir"),
              DateDropDown(
                labelText: labelText,
                valueText: new DateFormat("d MMM y")
                    .format(DateTime.parse(tanggalLahir!)),
                valueStyle: valueStyle,
                onPressed: () {
                  _selectedDate(context);
                },
              ),
              Text("Nama Jabatan"),
              FutureBuilder<List<JabatanModel>>(
                  future: _fetchJabatan(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<JabatanModel>> snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return DropdownButton<JabatanModel>(
                      items: snapshot.data!
                          .map((listJabatan) => DropdownMenuItem<JabatanModel>(
                                child: Text(listJabatan.namaJabatan.toString()),
                                value: listJabatan,
                              ))
                          .toList(),
                      onChanged: (JabatanModel? newvalue) {
                        setState(() {
                          _currentJabatan = newvalue;
                          idJabatan = _currentJabatan!.idJabatan;
                          namaJabatan = _currentJabatan!.namaJabatan;
                          print('tee 2: $idJabatan');
                        });
                      },
                      isExpanded: false,
                      hint: Text(
                          idJabatan == null ? "pilih jabatan" : "$namaJabatan"),
                      // : _currentJabatan!.namaJabatan.toString()),
                    );
                  }),
              // Text("Tanggal Lahir"),
              DateDropDown(
                labelText: labelText,
                valueText: new DateFormat("d MMM y")
                    .format(DateTime.parse(tanggalGabung!)),
                valueStyle: valueStyle,
                onPressed: () {
                  _selectedDate2(context);
                },
              ),
              MaterialButton(
                padding: EdgeInsets.all(25.0),
                color: Colors.amber[500],
                onPressed: () => check(),
                child: Text(
                  'Simpan',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
