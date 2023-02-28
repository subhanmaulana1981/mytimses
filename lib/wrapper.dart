import 'package:flutter/material.dart';
import 'package:mytimses/models/pengguna.dart';
import 'package:mytimses/otentikasi/otentikasi.dart';
import 'package:mytimses/screens/homepage.dart';
import 'package:provider/provider.dart';
import 'package:mytimses/models/timses.dart';
import 'package:mytimses/layanan/layanan_database.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final pengguna = Provider.of<Pengguna>(context);
    String uid = pengguna.uid.toString();
    if(pengguna.uid == "" || pengguna.uid == "Pengguna belum sign-in") {
      return const Otentikasi();
    } else {
      return // provider timses
        StreamProvider<TimSes>.value(
          value: LayananDatabase(timsesID: uid).timses,
          initialData: TimSes(
              timsesID: "",
              namaKetuaTimses: "",
              namaCaleg: "",
              namaKecamatan: ""),
          catchError: (BuildContext context, Object? exception) {
            return TimSes(namaKetuaTimses: "Timses tidak ditemukan");
          },
          child: MyHomePage(),
        );
    }
  }

}
