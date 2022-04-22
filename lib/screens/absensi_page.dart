import 'package:flutter/material.dart';

class AbsenPage extends StatefulWidget {
  const AbsenPage({ Key? key }) : super(key: key);

  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

  Widget _profile(String nama, jabatan){
    return Center(
      child: Column(
        children: [
          Icon(Icons.person_outline_rounded, size: 50,),
          Text('Hamdani', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Project Manager', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic))
        ],
      ),
    );
  }

  Widget _itemAbsen(String tanggal, absenMasuk, absenKeluar){
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.amber[100],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text('$tanggal', style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Absen Masuk'),
                Text('$absenMasuk'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Absen Keluar'),
                Text('$absenKeluar'),
              ],
            )
          ]
        )
    );
  }

class _AbsenPageState extends State<AbsenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[500],
        title: const Text('Daftar Absensi', style: TextStyle(fontWeight: FontWeight.bold),)
      ),
      body: ListView( 
        children: <Widget>[
          Container( 
            margin: EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              children:<Widget>[
                _profile('Hamdani', 'Project Manager'),
                Divider(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children:[
                      // Text('List Absensi Karyawan'),
                      _itemAbsen('01-04-2022', '07:56', '17:31'),
                      _itemAbsen('02-04-2022', '07:42', '17:03'),
                      _itemAbsen('03-04-2022', '07:48', '-'),
                      _itemAbsen('04-04-2022', '07:48', '17:24'),
                      _itemAbsen('05-04-2022', '07:48', '17:24'),
                      _itemAbsen('06-04-2022', '07:48', '17:24'),
                      _itemAbsen('07-04-2022', '07:48', '-'),
                      _itemAbsen('08-04-2022', '07:48', '17:24'),
                    ]
                  )
                ) 
              ]
            )
          )
        ]
      ));
  }
}