import 'package:asik/custom/datePicker.dart';
import 'package:flutter/material.dart';

class CutiPage extends StatefulWidget {
  const CutiPage({ Key? key }) : super(key: key);

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  String firstName = "";
  String lamaHari = "";
  String bodyTemp = "";
  var measure;

  final dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber[500],
          title: Text('Pengajuan Cuti',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Align(
              alignment: Alignment.center,
              child: Text("Data Cuti",
                  style: TextStyle(
                    fontSize: 24,
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Jatah Cuti 2022"),
                Text("12")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Cuti Bersama 2022"),
                Text("5")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pengguanaan Cuti 2022"),
                Text("5")
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sisa cuti"),
                Text("2")
              ],
            ),
            Divider(),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Tanggal Mulai Cuti"),
                  SizedBox(height: 10),
                  TextField(
                    readOnly: true,
                    controller: dateController,
                    decoration: InputDecoration(
                        hintText: 'Pick your Date',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()
                    ),
                    onTap: () async {
                    var date =  await showDatePicker(
                          context: context, 
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));
                    dateController.text = date.toString().substring(0,10);      
                  }),
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //       labelText: 'First Name',
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //         borderSide:
                  //             BorderSide(color: Colors.grey, width: 0.0),
                  //       ),
                  //       border: OutlineInputBorder()),
                  //   onFieldSubmitted: (value) {
                  //     setState(() {
                  //       firstName = value;
                  //       // firstNameList.add(firstName);
                  //     });
                  //   },
                  //   onChanged: (value) {
                  //     setState(() {
                  //       firstName = value;
                  //     });
                  //   },
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty || value.length < 3) {
                  //       return 'First Name must contain at least 3 characters';
                  //     } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                  //       return 'First Name cannot contain special characters';
                  //     }
                  //   },
                  // ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Lama Hari',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide:
                              BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Last Name must contain at least 3 characters';
                      } else if (value.contains(RegExp(r'^[0-9_\-=@,\.;]+$'))) {
                        return 'Last Name cannot contain special characters';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        lamaHari = value;
                        // lamaHariList.add(lamaHari);
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        lamaHari = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // TextFormField(
                  //   decoration: const InputDecoration(
                  //       labelText: 'Body Temperature',
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  //         borderSide:
                  //             BorderSide(color: Colors.grey, width: 0.0),
                  //       ),
                  //       border: OutlineInputBorder()),
                  //   keyboardType: TextInputType.number,
                  //   validator: (value) {
                  //     if (value == null ||
                  //         value.isEmpty ||
                  //         value.contains(RegExp(r'^[a-zA-Z\-]'))) {
                  //       return 'Use only numbers!';
                  //     }
                  //   },
                  //   onFieldSubmitted: (value) {
                  //     setState(() {
                  //       bodyTemp = value;
                  //       // bodyTempList.add(bodyTemp);
                  //     });
                  //   },
                  //   onChanged: (value) {
                  //     setState(() {
                  //       bodyTemp = value;
                  //     });
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  // DropdownButtonFormField(
                  //     decoration: const InputDecoration(
                  //         enabledBorder: OutlineInputBorder(
                  //           borderRadius:
                  //               BorderRadius.all(Radius.circular(20.0)),
                  //           borderSide:
                  //               BorderSide(color: Colors.grey, width: 0.0),
                  //         ),
                  //         border: OutlineInputBorder()),
                  //     items: [
                  //       const DropdownMenuItem(
                  //         child: Text("ºC"),
                  //         value: 1,
                  //       ),
                  //       const DropdownMenuItem(
                  //         child: Text("ºF"),
                  //         value: 2,
                  //       )
                  //     ],
                  //     hint: const Text("Select item"),
                  //     onChanged: (value) {
                  //       setState(() {
                  //         measure = value;
                  //         // measureList.add(measure);
                  //       });
                  //     },
                  //     onSaved: (value) {
                  //       setState(() {
                  //         measure = value;
                  //       });
                  //     }),
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60)),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // _submit();
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}