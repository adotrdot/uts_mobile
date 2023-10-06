import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:uts_mobile/ui/side_menu.dart';
import 'package:uts_mobile/ui/tambah_data.dart';
import 'package:uts_mobile/ui/edit_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListData extends StatefulWidget {
  const ListData({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataBuku = [];
  String url = Platform.isAndroid
      ? 'http://10.98.3.87/uts-mobile/index.php'
      : 'http://localhost/uts-mobile/index.php';
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if ((response.statusCode == 200) && response.body != "Data buku kosong.") {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        dataBuku = List<Map<String, String>>.from(data.map((item) {
          return {
            'id': item['id'] as String,
            'judul': item['judul'] as String,
            'penulis': item['penulis'] as String,
            'tahun_terbit': item['tahun_terbit'] as String
          };
        }));
      });
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal hapus data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List Data Buku'),
        ),
        drawer: const SideMenu(),
        body: Column(children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TambahData(),
                ),
              );
            },
            child: const Text('Tambah Data Buku'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataBuku.length,
              itemBuilder: (context, index) {
                var subtitle =
                    "Penulis: ${dataBuku[index]['penulis']}\nTahun Terbit: ${dataBuku[index]['tahun_terbit']}";
                return ListTile(
                  title: Text(dataBuku[index]['judul']!),
                  subtitle: Text(subtitle),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    title: Text('${dataBuku[index]['judul']}'),
                                    content: Text(subtitle));
                              });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditData(
                                      id: int.parse(dataBuku[index]['id']!),
                                      judul: '${dataBuku[index]['judul']}',
                                      penulis: '${dataBuku[index]['penulis']}',
                                      tahun: int.parse(
                                          '${dataBuku[index]['tahun_terbit']}'))));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteData(int.parse(dataBuku[index]['id']!))
                              .then((result) {
                            if (result['pesan'] == 'berhasil') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Data berhasil dihapus'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pushReplacement(
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
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ]));
  }
}
