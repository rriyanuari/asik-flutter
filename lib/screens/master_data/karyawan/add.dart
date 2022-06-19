import 'dart:convert';
import 'dart:io';
import 'package:asik/screens/master_data/jabatan/list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;

import '../../../models/jabatan_model.dart';
import '../../../api/api.dart';
import 'package:asik/custom/datePicker.dart';

class AddKaryawan extends StatefulWidget {
  final VoidCallback reload;
  AddKaryawan(this.reload);

  @override
  _AddKaryawanState createState() => _AddKaryawanState();
}

class _AddKaryawanState extends State<AddKaryawan> {
  String? namaPegawai,
      jenisKelamin = 'laki-laki',
      idJabatan,
      userName,
      password,
      email,
      status,
      pangkat,
      masaKerja,
      statusKawin,
      bpjs;
  // tanggalGabung;
  final _key = new GlobalKey<FormState>();

  final TextEditingController _userController = new TextEditingController();

  JabatanModel? _currentJabatan;
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
      var uri = Uri.parse(BaseUrl.urlTambahKaryawan);
      var request = http.MultipartRequest("POST", uri);
      request.fields['user_name'] = userName!;
      request.fields['password'] = password!;
      request.fields['email'] = email!;
      request.fields['status'] = status!;
      request.fields['nama_lengkap'] = namaPegawai!;
      request.fields['jenis_kelamin'] = jenisKelamin!;
      request.fields['tanggal_lahir'] = "$tanggalLahir";
      request.fields['id_jabatan'] = idJabatan.toString();
      request.fields['tanggal_gabung'] = "$tanggalGabung";
      request.fields['pangkat'] = pangkat!;
      request.fields['masa_kerja'] = masaKerja!;
      request.fields['status_kawin'] = statusKawin!;
      request.fields['bpjs'] = bpjs!;

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
  DateTime tanggalLahir = new DateTime.now();
  DateTime tanggalGabung = new DateTime.now();

  final TextStyle valueStyle = TextStyle(fontSize: 16.0);

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tanggalLahir,
        firstDate: DateTime(1972),
        lastDate: DateTime(2099));
    if (picked != null && picked != tanggalLahir) {
      setState(() {
        tanggalLahir = picked;
        pilihTanggal = new DateFormat.yMd().format(tanggalLahir);
      });
    } else {}
  }

  Future<Null> _selectedDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: tanggalGabung,
        firstDate: DateTime(1972),
        lastDate: DateTime(2099));
    if (picked != null && picked != tanggalGabung) {
      setState(() {
        tanggalGabung = picked;
        pilihTanggal = new DateFormat.yMd().format(tanggalGabung);
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        appBar: AppBar(
            backgroundColor: Colors.amber[500],
            title: const Text(
              'Tambah Karyawan',
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
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi username";
                      }
                    },
                    onSaved: (e) => userName = e,
                    decoration: const InputDecoration(labelText: "User Name"),
                  ),
                  TextFormField(
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi password";
                      }
                    },
                    onSaved: (e) => password = e,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  TextFormField(
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi email";
                      }
                    },
                    onSaved: (e) => email = e,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  Container(
                      child: Text(
                    "Status",
                    style: valueStyle,
                  )),
                  DropdownButton(
                    alignment: Alignment.topLeft,
                    // style: valueStyle,
                    value: status,
                    items: <String>['1', '2']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        status = newValue!;
                      });
                    },
                  ),
                  // TextFormField(
                  //   validator: (e) {
                  //     if ((e as dynamic).isEmpty) {
                  //       return "Silahkan isi status";
                  //     }
                  //   },
                  //   onSaved: (e) => status = e,
                  //   decoration: InputDecoration(labelText: "Status"),
                  // ),
                  TextFormField(
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi nama lengkap";
                      }
                    },
                    onSaved: (e) => namaPegawai = e,
                    decoration: InputDecoration(labelText: "Nama Lengkap"),
                  ),
                  Container(child: Text("Jenis Kelamin")),
                  DropdownButton(
                    alignment: Alignment.topLeft,
                    // style: valueStyle,
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
                    valueText: new DateFormat("d MMM y").format(tanggalLahir),
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
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        return DropdownButton<JabatanModel>(
                          items: snapshot.data!
                              .map((listJabatan) =>
                                  DropdownMenuItem<JabatanModel>(
                                    child: Text(
                                        listJabatan.namaJabatan.toString()),
                                    value: listJabatan,
                                  ))
                              .toList(),
                          onChanged: (JabatanModel? value) {
                            setState(() {
                              _currentJabatan = value;
                              idJabatan = _currentJabatan!.idJabatan;
                            });
                          },
                          isExpanded: false,
                          hint: Text(idJabatan == null
                              ? "pilih jabatan"
                              : _currentJabatan!.namaJabatan.toString()),
                        );
                      }),
                  Text("Tanggal Gabung"),
                  DateDropDown(
                    labelText: labelText,
                    // valueText: new DateFormat.yMd().format(tanggalGabung),
                    valueText: new DateFormat("d MMM y").format(tanggalGabung),
                    valueStyle: valueStyle,
                    onPressed: () {
                      _selectedDate2(context);
                    },
                  ),
                  TextFormField(
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi pangkat";
                      }
                    },
                    onSaved: (e) => pangkat = e,
                    decoration: InputDecoration(labelText: "Pangkat"),
                  ),
                  // TextFormField(
                  //   validator: (e) {
                  //     if ((e as dynamic).isEmpty) {
                  //       return "Silahkan masa kerja";
                  //     }
                  //   },
                  //   onSaved: (e) => masaKerja = e,
                  //   decoration: InputDecoration(labelText: "Masa Kerja"),
                  // ),
                  TextFormField(
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi masa kerja";
                      }
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onSaved: (e) => masaKerja = e,
                    decoration: const InputDecoration(
                        labelText: "Masa Kerja"), // Only numbers can be entered
                  ),

                  TextFormField(
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi status kawin";
                      }
                    },
                    onSaved: (e) => statusKawin = e,
                    decoration: InputDecoration(labelText: "Status Kawin"),
                  ),
                  TextFormField(
                    validator: (e) {
                      if ((e as dynamic).isEmpty) {
                        return "Silahkan isi BPJS";
                      }
                    },
                    onSaved: (e) => bpjs = e,
                    decoration: InputDecoration(labelText: "BPJS"),
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
