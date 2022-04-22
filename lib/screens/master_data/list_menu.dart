import 'package:asik/screens/absensi_page.dart';
import 'package:asik/screens/master_data/jabatan_master.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListMenuMaster extends StatelessWidget {
  const ListMenuMaster({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _menuMasterData(String Title, Deskripsi, DynamicIcon, Nav){
      return ListTile(
            leading: Material(
              borderRadius: BorderRadius.circular(100.0),
              color: Colors.grey[200],
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(DynamicIcon),
                color: Colors.amber[500],
                iconSize: 30.0,
                onPressed: () {},
              ),
            ),
            title: Text(Title),
            contentPadding: EdgeInsets.all(7.0),
            subtitle: Text(Deskripsi),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Nav
                ));
            },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[500],
        title: const Text('Menu Master Data', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          _menuMasterData('Karyawan', 'Pengelolaan Data Karyawan', Icons.group, AbsenPage()),        
          Divider(),
          _menuMasterData('Jabatan', 'Pengelolaan Data Jabatan', Icons.work, jabatanMaster()),
          Divider(),
          _menuMasterData('Cuti Bersama', 'Pengelolaan Data Cuti Bersama', Icons.time_to_leave, AbsenPage()),
          Divider(),
          _menuMasterData('Jam Kerja', 'Pengelolaan Data Jam Kerja', Icons.hourglass_bottom, AbsenPage()),

        ],
      )
    );
  }
}