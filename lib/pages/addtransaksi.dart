import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ta_sispem/home.dart';

class AddTransaksi extends StatefulWidget {
  @override
  _AddTransaksiState createState() => _AddTransaksiState();
}

class _AddTransaksiState extends State<AddTransaksi> {
  final _formKey = GlobalKey<FormState>();
  DateTime _dateTime;
  TextEditingController _tanggalMulai = TextEditingController();
  TextEditingController _tanggalSelesai = TextEditingController();
  TextEditingController _namaAcara = TextEditingController();
  TextEditingController _penanggungJawab = TextEditingController();
  TextEditingController _kontak = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaksi"),
        backgroundColor: Color(0xFF006600),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2030));

                  String date = DateFormat('dd/MM/yyyy').format(_dateTime);
                  _tanggalMulai.text = date;
                },
                controller: _tanggalMulai,
                decoration: InputDecoration(labelText: "Tanggal Mulai"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              TextFormField(
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _dateTime = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2010),
                      lastDate: DateTime(2030));

                  String date = DateFormat('dd/MM/yyyy').format(_dateTime);
                  _tanggalSelesai.text = date;
                },
                controller: _tanggalSelesai,
                decoration: InputDecoration(labelText: "Tanggal Selesai"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaAcara,
                decoration: InputDecoration(labelText: "Nama Acara"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _penanggungJawab,
                decoration: InputDecoration(labelText: "Penanggung Jawab"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kontak,
                decoration: InputDecoration(labelText: "kontak"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please input this field !";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Transaksi saved successfully')));
                        }
                      },
                      child: Text("Save")),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey,
                        onPrimary: Colors.black,
                      ),
                      onPressed: () {},
                      child: Text("Cancel")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
