import 'package:flutter/material.dart';
import 'package:mytimses/layanan/layanan_database.dart';
import 'package:mytimses/models/kecamatan.dart';
import 'package:mytimses/models/kelurahan.dart';
import 'package:mytimses/models/pengguna.dart';
import 'package:mytimses/models/timses.dart';
import 'package:mytimses/widgets/loading.dart';
import 'package:provider/provider.dart';

class ProfileTimses extends StatefulWidget {
  const ProfileTimses({Key? key}) : super(key: key);

  @override
  State<ProfileTimses> createState() => _ProfileTimsesState();
}

class _ProfileTimsesState extends State<ProfileTimses> {
  final _formKey = GlobalKey<FormState>();

  // form field state
  String? _currentTimsesID;
  String? _currentNamaKetuaTimses;
  String? _currentNamaCaleg;
  String? _currentKecamatan;
  String? _currentKelurahan;

  // text controller
  /*TextEditingController _controllerNamaKetuaTimses = TextEditingController();
  TextEditingController _controllerNamaCaleg = TextEditingController();*/

  @override
  Widget build(BuildContext context) {
    final pengguna = Provider.of<Pengguna>(context);
    _currentTimsesID = pengguna.uid;
    /*print("dari profil timses");
    print("id user: $_currentTimsesID");*/

    return StreamBuilder<TimSes>(
      stream: LayananDatabase(timsesID: _currentTimsesID.toString()).timses,
      builder: (context, asyncSnapshot) {
        if(asyncSnapshot.hasData) {
          TimSes? timSes = asyncSnapshot.data;
          /*print("dari stream builder");
          print(timSes?.namaKetuaTimses.toString());*/

          // inisialisasi state dari snapshot
          /*_currentTimsesID = timSes!.timsesID.toString();
          _currentNamaKetuaTimses = timSes.namaKetuaTimses.toString();
          _currentNamaCaleg = timSes.namaCaleg.toString();
          _currentKecamatan = timSes.namaKecamatan.toString();
          _currentKelurahan = timSes.namaKelurahan.toString();*/

          // inisialisasi state dari snapshot
          /*_controllerNamaKetuaTimses.text = _currentNamaKetuaTimses!;
          _controllerNamaCaleg.text = _currentNamaCaleg!;*/

          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text("Profile TimSes"),
            ),
            body: Stack(
              children: <Widget>[

                // back image
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/pelangi_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // form timses
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(35.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            // account image
                            Image.asset(
                              "assets/profile.png",
                              fit: BoxFit.fitWidth,
                              width: 196.0,
                            ),

                            // caleg
                            TextFormField(
                              validator: (val) {
                                (val!.isEmpty) ? "Registrasi ke caleg!" : null;
                                return null;
                              },
                              enabled: false,
                              initialValue: _currentNamaCaleg ?? timSes?.namaCaleg.toString(),
                              decoration: const InputDecoration(
                                label: Text("Calon Legislatif"),
                              ),
                            ),

                            // timses
                            TextFormField(
                              initialValue: _currentNamaKetuaTimses ?? timSes?.namaKetuaTimses.toString(),
                              validator: (val) {
                                (val!.isEmpty) ? "Timses tidak boleh kosong!" : null;
                                return null;
                              },
                              onChanged: (val) {
                                setState(() {
                                  _currentNamaKetuaTimses = val;
                                });
                              },
                              decoration: const InputDecoration(
                                label: Text("Nama Lengkap"),
                                hintText: "Masukkan nama lengkap"),
                            ),

                            // kecamatan
                            StreamBuilder<Iterable<Kecamatan>>(
                              stream: LayananDatabase().kecamatans,
                              builder: (BuildContext context, AsyncSnapshot<Iterable<Kecamatan>> asyncSnapshot) {
                                if(asyncSnapshot.hasData) {
                                  List<Kecamatan> listKecamatan = asyncSnapshot.data!.toList();
                                  return DropdownButtonFormField<String>(
                                    validator: (val) {
                                      (val!.isEmpty) ? "Pilih kecamatan!" : null;
                                      return null;
                                    },
                                    value: _currentKecamatan ?? timSes?.namaKecamatan.toString(),
                                    items: listKecamatan.map<DropdownMenuItem<String>>((Kecamatan kecamatan) {
                                      return DropdownMenuItem<String>(
                                        value: kecamatan.namaKecamatan,
                                        child: Text(kecamatan.namaKecamatan.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _currentKecamatan = val!;
                                      });
                                    }
                                  );
                                } else {
                                  return const Loading();
                                }
                              },
                            ),

                            // kelurahan
                            StreamBuilder<Iterable<Kelurahan>>(
                              stream: LayananDatabase(kecamatan: _currentKecamatan).kelurahans,
                              builder: (BuildContext context, AsyncSnapshot<Iterable<Kelurahan>> asyncSnapshot) {
                                if(asyncSnapshot.hasData) {
                                  List<Kelurahan> listKelurahan = asyncSnapshot.data!.toList();
                                  return DropdownButtonFormField<String>(
                                    validator: (val) {
                                      (val!.isEmpty) ? "Pilih kelurahan" : null;
                                      return null;
                                    },
                                    value: _currentKelurahan ?? timSes?.namaKelurahan.toString(),
                                    items: listKelurahan.map<DropdownMenuItem<String>>((Kelurahan kelurahan) {
                                      return DropdownMenuItem(
                                        value: kelurahan.namaKelurahan,
                                        child: Text(kelurahan.namaKelurahan.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        _currentKelurahan = val;
                                      });
                                    }
                                  );
                                } else {
                                  return const Loading();
                                }
                              }
                            ),

                            // separator
                            const SizedBox(
                              height: 25.0,
                            ),

                            // buttons
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: <Widget>[

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Batal"),
                                ),

                                ElevatedButton(
                                  onPressed: () async {
                                    if(_formKey.currentState!.validate()) {

                                      try {
                                        // print("timses id: $_currentTimsesID");
                                        await LayananDatabase(uid: _currentTimsesID).setTimsesData(
                                            (_currentTimsesID ?? timSes!.timsesID.toString()),
                                            (_currentNamaKetuaTimses ?? timSes!.namaKetuaTimses.toString()),
                                            (_currentNamaCaleg ?? timSes!.namaCaleg.toString()),
                                            (_currentKecamatan ?? timSes!.namaKecamatan.toString()),
                                            (_currentKelurahan ?? timSes!.namaKelurahan.toString()),
                                            (0)
                                        );

                                      } catch(error) {
                                        // print(error.toString());

                                      } finally {
                                        Navigator.of(context).pop();

                                      }

                                    }
                                  },
                                  child: const Text("Simpan"),
                                ),

                              ],
                            ),

                            // separator
                            const SizedBox(
                              height: 50.0,
                            ),

                            // copyright
                            const Text(
                              "(c) 2022 Maju Bersama production",
                              style: TextStyle(
                                fontSize: 14.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          );

        } else {
          return const Loading();
        }
      },
    );
  }
}
