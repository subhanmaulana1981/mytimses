import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mytimses/layanan/layanan_database.dart';
import 'package:mytimses/models/kecamatan.dart';
import 'package:mytimses/models/pengguna.dart';
import 'package:mytimses/models/timses.dart';
import 'package:mytimses/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:mytimses/models/kelurahan.dart';

class FormMember extends StatefulWidget {
  const FormMember({Key? key}) : super(key: key);

  @override
  State<FormMember> createState() => _FormMemberState();
}

enum Kelamin { pria, wanita }

class _FormMemberState extends State<FormMember> {

  // enumerasi kelamin
  Kelamin? _kelamin = Kelamin.pria;
  
  // date time picker
  DateTime? _dateTime;

  // form field states
  String? _currentTimsesID;
  String? _currentNamaKetuaTimses;
  int? _currentAnggotaTimses;

  String? _currentNomorKTP;
  String? _currentNamaAnggota;
  String? _currentJenisKelamin;
  String? _currentTempatLahir;
  String? _currentTanggalLahir;
  String? _currentAlamat;

  String? _currentKelurahanID;
  String? _currentKelurahan;
  int? _currentAnggotaKelurahan;

  String? _currentKecamatanID;
  String? _currentKecamatan;
  int? _currentAnggotaKecamatan;

  String? _currentNomorTelepon;

  // text editing controller
  final TextEditingController _controllerKetuaTimses = TextEditingController();
  final TextEditingController _controllerTanggalLahir = TextEditingController();

  @override
  Widget build(BuildContext context) {

    // timses id
    final pengguna = Provider.of<Pengguna>(context);
    _currentTimsesID = pengguna.uid.toString();
    /*print("dari form anggota");
    print("timses id: $_currentTimsesID");*/

    // jenis kelamin
    _currentJenisKelamin =
        (_kelamin == Kelamin.pria)
        ? "pria"
        : "wanita";

    // tanggal lahir
    _currentTanggalLahir = DateTime.utc(1981, 09, 12).toString();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Form Anggota"),
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

          // form anggota
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 15.0, 50.0, 0.0),
              child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      // ketua timses
                      StreamBuilder<TimSes>(
                        initialData: TimSes(namaKetuaTimses: ""),
                        stream: LayananDatabase(timsesID: _currentTimsesID).timses,
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {

                            // print("timses ketua: $_currentNamaKetuaTimses");
                            String namaKetuaTimses = snapshot
                                .data!
                                .namaKetuaTimses
                                .toString();
                            _currentNamaKetuaTimses = namaKetuaTimses;
                            // print("ketua timses: $_currentNamaKetuaTimses");
                            _controllerKetuaTimses.text = _currentNamaKetuaTimses.toString();

                            // jumlah anggota timses
                            int? jumlahAnggotaTimses = snapshot.data!.jumlahAnggota;
                            _currentAnggotaTimses = jumlahAnggotaTimses;

                            return TextFormField(
                              readOnly: true,
                              enabled: false,
                              controller: _controllerKetuaTimses,
                              decoration: const InputDecoration(
                                  label: Text("Ketua Tim Sukses"),
                                  hintText: "Ketua tim sukses"),
                              onChanged: (val) {
                                setState(() {
                                  _currentNamaKetuaTimses = val;
                                });
                              },
                            );
                          } else {
                            return const Loading();
                          }
                        }
                      ),

                      // nomor ktp
                      TextFormField(
                        initialValue: _currentNomorKTP,
                        decoration: const InputDecoration(
                          label: Text("NIK"),
                          hintText: "Nomor Induk Kependudukan"),
                        onChanged: (val) {
                          setState(() {
                            _currentNomorKTP = val;
                          });
                        },
                      ),

                      // nama anggota
                      TextFormField(
                        initialValue: _currentNamaAnggota,
                        decoration: const InputDecoration(
                          label: Text("Nama Lengkap"),
                          hintText: "Masukkan nama lengkap"),
                        onChanged: (val) {
                          setState(() {
                            _currentNamaAnggota = val;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 8.0,
                      ),

                      // jenis kelamin
                      Row(
                        children: <Widget>[
                          const Text(
                              "Kelamin",
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Radio<Kelamin>(
                                  value: Kelamin.pria,
                                  groupValue: _kelamin,
                                  onChanged: (Kelamin? value) {
                                    setState(() {
                                      _kelamin = value;
                                      _currentJenisKelamin =
                                          (_kelamin == Kelamin.pria)
                                          ? "pria"
                                          : "wanita";
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                      "Pria",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Radio<Kelamin>(
                                  value: Kelamin.wanita,
                                  groupValue: _kelamin,
                                  onChanged: (Kelamin? value) {
                                    setState(() {
                                      _kelamin = value;
                                      _currentJenisKelamin =
                                          (_kelamin == Kelamin.wanita)
                                          ? "wanita"
                                          : "pria";

                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                      "Wanita",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // tempat lahir
                      TextFormField(
                        initialValue: _currentTempatLahir,
                        decoration: const InputDecoration(
                            label: Text("Tempat Lahir"),
                            hintText: "Tempat Kelahiran"),
                        onChanged: (val) {
                          setState(() {
                            _currentTempatLahir = val;
                          });
                        },
                      ),

                      // tanggal lahir
                      TextFormField(
                        controller: _controllerTanggalLahir,
                        decoration: const InputDecoration(
                            label: Text("Tanggal Lahir"),
                            hintText: "Pilih tanggal lahir"),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DatePickerDialog(
                                initialDate: DateTime.now(),
                                firstDate: DateTime.utc(1945, 1, 1),
                                lastDate: DateTime.now(),
                              );
                            }
                          ).then((date) {
                            setState(() {
                              _dateTime = date;
                              _currentTanggalLahir = _dateTime.toString();
                              _controllerTanggalLahir.text = _currentTanggalLahir.toString();
                            });
                          });
                        },
                      ),

                      // alamat
                      TextFormField(
                        initialValue: _currentAlamat,
                        decoration: const InputDecoration(
                          label: Text("Alamat"),
                          hintText: "Tempat tinggal"
                        ),
                        onChanged: (val) {
                          setState(() {
                            _currentAlamat = val;
                          });
                        },
                      ),

                      // kecamatan
                      StreamBuilder<Iterable<Kecamatan>>(
                        stream: LayananDatabase().kecamatans,
                        builder: (context, snapshot) {
                           if(snapshot.hasData) {
                             List<Kecamatan> listKecamatan = snapshot.data!.toList();
                             return DropdownButtonFormField<String>(
                               value: _currentKecamatan,
                               items: listKecamatan.map<DropdownMenuItem<String>>((Kecamatan kecamatan) {
                                 return DropdownMenuItem<String>(
                                   value: kecamatan.namaKecamatan,
                                   child: Text(kecamatan.namaKecamatan.toString()),
                                 );
                               }).toList(),
                               onChanged: (val) {
                                  setState(() {
                                    _currentKecamatan = val;
                                  });
                               },
                             );
                           } else {
                             return const Loading();
                           }
                        }
                      ),

                      // kelurahan
                      StreamBuilder<Iterable<Kelurahan>>(
                        stream: LayananDatabase(kecamatan: _currentKecamatan.toString()).kelurahans,
                        builder: (context, snapshot) {
                          if(snapshot.hasData) {
                            List<Kelurahan> listKelurahan = snapshot.data!.toList();

                            return DropdownButtonFormField<String>(
                              value: _currentKelurahan,
                              items: listKelurahan.map<DropdownMenuItem<String>>((Kelurahan kelurahan) {
                                return DropdownMenuItem<String>(
                                  value: kelurahan.namaKelurahan,
                                  child: Text(kelurahan.namaKelurahan.toString()),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _currentKelurahan = val;
                                });
                              },
                            );
                          } else {
                            return const Loading();
                          }
                        }
                      ),

                      // nomor telepon
                      TextFormField(
                        initialValue: _currentNomorTelepon,
                        decoration: const InputDecoration(
                            label: Text("Nomor Telepon"),
                            hintText: "Masukan nomor telepon"
                        ),
                        onChanged: (val) {
                          setState(() {
                            _currentNomorTelepon = val;
                          });
                        },
                      ),

                      const SizedBox(
                        height: 50.0,
                      ),

                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () async {

                              try {
                                /*print("timses id: ${_currentTimsesID.toString()}");
                                print("timses: ${_currentNamaKetuaTimses.toString()}");
                                print("ktp: ${_currentNomorKTP.toString()}");
                                print("anggota: ${_currentNamaAnggota.toString()}");
                                print("kelamin: ${_currentJenisKelamin.toString()}");
                                print("tempat lahir: ${_currentTempatLahir.toString()}");
                                print("tanggal lahir: ${_currentTanggalLahir.toString()}");
                                print("alamat: ${_currentAlamat.toString()}");
                                print("kecamatan ${_currentKecamatan.toString()}");
                                print("kelurahan ${_currentKelurahan.toString()}");
                                print("telepon: ${_currentNomorTelepon.toString()}");*/

                                await LayananDatabase(uid: _currentTimsesID.toString()).setAnggotaData(
                                    (_currentTimsesID.toString()),
                                    (_currentNamaKetuaTimses.toString()),
                                    (_currentNomorKTP.toString()),
                                    (_currentNamaAnggota.toString()),
                                    (_currentJenisKelamin.toString()),
                                    (_currentTempatLahir.toString()),
                                    (_currentTanggalLahir.toString()),
                                    (_currentAlamat.toString()),
                                    (_currentKelurahan.toString()),
                                    (_currentKecamatan.toString()),
                                    (_currentNomorTelepon.toString())
                                );

                                // cari info terkait timses
                                QuerySnapshot timsesSnapshot = await LayananDatabase()
                                    .getTimses(_currentNamaKetuaTimses.toString());
                                for (var doc in timsesSnapshot.docs) {
                                  /*print("timses: ${doc['namaKetuaTimses']}");
                                print("timses id: ${doc['timsesID']}");
                                print("anggota: ${doc['jumlahanggota']}");*/

                                  setState(() {
                                    _currentTimsesID = doc["timsesID"];
                                    _currentAnggotaTimses = doc["jumlahanggota"];
                                  });
                                }

                                // update aggregate anggota timses
                                LayananDatabase().setAnggotaTimses(
                                    _currentTimsesID.toString(),
                                    _currentAnggotaTimses!
                                );

                                // cari info terkait kecamatan
                                QuerySnapshot kecamatanSnapshot = await LayananDatabase()
                                    .getKecamatan(_currentKecamatan.toString());
                                for (var doc in kecamatanSnapshot.docs) {
                                  /*print("kecamatan: ${doc['nama']}");
                                print("kecamatan id: ${doc['kecamatanid']}");
                                print("anggota: ${doc['jumlahanggota']}");*/

                                  setState(() {
                                    _currentKecamatanID = doc["kecamatanid"];
                                    _currentAnggotaKecamatan = doc["jumlahanggota"];
                                  });
                                }

                                // update aggregate anggota kecamatan
                                LayananDatabase().setAnggotaKecamatan(
                                    _currentKecamatanID.toString(),
                                    _currentAnggotaKecamatan!
                                );

                                // cari info terkait kelurahan
                                QuerySnapshot kelurahanSnapshot = await LayananDatabase()
                                    .getKelurahan(_currentKelurahan.toString());
                                for (var doc in kelurahanSnapshot.docs) {
                                  /*print("kelurahan: ${doc['namakelurahan']}");
                                print("kelurahan id: ${doc['kelurahanid']}");
                                print("anggota: ${doc['jumlahanggota']}");*/

                                  setState(() {
                                    _currentKelurahanID = doc["kelurahanid"];
                                    _currentAnggotaKelurahan = doc["jumlahanggota"];
                                  });
                                }

                                // update aggregate anggota kelurahan
                                LayananDatabase().setAnggotaKelurahan(
                                    _currentKelurahanID.toString(),
                                    _currentAnggotaKelurahan!
                                );

                              } catch(e) {
                                // print(e.toString());
                              } finally {
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text("Rekrut anggota"),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 50.0,
                      ),

                      const Text(
                        "(c) 2022 Maju Bersama production",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            ),
          ),

        ],
      ),
    );
  }
}
