import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class DaftarUmkm {
  String nama;
  String jenis;

  DaftarUmkm({required this.nama, required this.jenis});
}

class UmkmCubit extends Cubit<List<DaftarUmkm>> {
  String url = "http://178.128.17.76:8000/daftar_umkm";
  UmkmCubit() : super([DaftarUmkm(nama: "", jenis: "")]);

  void setFromJson(Map<String, dynamic> json) {
    List<dynamic> json2 = json['data']!;
    List<DaftarUmkm> dataUmkm = json2
        .map((e) => DaftarUmkm(nama: e['nama'], jenis: e['jenis']))
        .toList() as List<DaftarUmkm>;
    emit(dataUmkm);
  }

  void fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setFromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load data');
    }
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => UmkmCubit(),
        child: const HalamanUtama(),
      ),
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MyApp',
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: [
            const Padding(padding: EdgeInsets.all(10)),
            const Text(
              '2101963, Rasyid Andriansyah; 2107980, Muhammad Yusuf Bahtiar, Saya berjanji tidak akan berbuat curang data atau membantu orang lain berbuat curang',
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<UmkmCubit>().fetchData();
                  },
                  child: const Text('Reload Daftar UMKM'),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<UmkmCubit, List<DaftarUmkm>>(
              buildWhen: (previousState, state) {
                developer.log('${previousState[0].nama}->${state[0].nama}',
                    name: 'log');
                return true;
              },
              builder: (context, listUniversity) {
                return Flexible(
                  child: ListView.builder(
                    itemCount: listUniversity.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(listUniversity[index].nama),
                              Divider(
                                thickness: 2.0,
                                color: Colors.black,
                              ),
                              Text(listUniversity[index].jenis),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
