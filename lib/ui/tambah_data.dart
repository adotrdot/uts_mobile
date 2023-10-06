import 'dart:convert';
import 'dart:io';
import 'package:uts_mobile/ui/list_data.dart';
import 'package:uts_mobile/ui/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);
  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final _formKey = GlobalKey<FormState>();
  final judulController = TextEditingController();
  final penulisController = TextEditingController();
  final tahunController = TextEditingController();
  Future postData(String judul, String penulis, int tahun_terbit) async {
    // print(nama);
    String url = Platform.isAndroid
        ? 'http://10.98.3.87/uts-mobile/index.php'
        : 'http://localhost/uts-mobile/index.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"judul": "$judul", "penulis": "$penulis", "tahun_terbit": "$tahun_terbit"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal tambah data');
    }
  }

  _buatInput(control, String hint) {
    return TextFormField(
      controller: control,
      decoration: InputDecoration(
        hintText: hint,
      ),
      validator: (String? value) {
        return (value == null || value.isEmpty) ? "Tidak boleh kosong" : null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tambah Data Buku'),
        ),
        drawer: const SideMenu(),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buatInput(judulController, 'Masukkan Judul Buku'),
                _buatInput(penulisController, 'Masukkan Nama Penulis'),
                TextFormField(
                  controller: tahunController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan Tahun Terbit',
                  ),
                  validator: (String? value) {
                    return (value == null ||
                            value.isEmpty ||
                            !RegExp(r'^[1-9][0-9]+$').hasMatch(value))
                        ? "Bukan sebuah tahun"
                        : null;
                  },
                ),
                ElevatedButton(
                  child: const Text('Tambah Buku'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String judul = judulController.text;
                      String penulis = penulisController.text;
                      int tahun = int.parse(tahunController.text);
                      postData(judul, penulis, tahun).then((result) {
                        if (result['pesan'] == 'berhasil') {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Data berhasil ditambah'),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ListData(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                        setState(() {});
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
