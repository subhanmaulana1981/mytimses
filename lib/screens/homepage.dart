import 'package:flutter/material.dart';
import 'package:mytimses/layanan/layanan_database.dart';
import 'package:mytimses/layanan/layanan_otentikasi.dart';
import 'package:mytimses/models/anggota.dart';
import 'package:mytimses/models/pengguna.dart';
import 'package:mytimses/models/timses.dart';
import 'package:mytimses/screens/form_member.dart';
import 'package:mytimses/screens/profile_timses.dart';
import 'package:mytimses/screens/tentang.dart';
import 'package:mytimses/widgets/loading.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // layanan otentikasi firebase
  final LayananOtentikasi _layananOtentikasi = LayananOtentikasi();

  // form state

  @override
  Widget build(BuildContext context) {

    // provider pengguna
    Pengguna pengguna = Provider.of<Pengguna>(context);
    String uid = pengguna.uid;
    // print("user id: ${pengguna.uid}");

    // provider timses
    TimSes timSes = Provider.of<TimSes>(context);
    String namaCaleg = timSes.namaCaleg.toString();
    // String namaTimses = timSes.namaKetuaTimses.toString();

    /*print("dari homepage");
    print("timses: $namaTimses");
    print("caleg: $namaCaleg");*/

    return MultiProvider(
      providers: [

        // provider anggota
        StreamProvider<Iterable<Anggota>>.value(
          value: LayananDatabase(uid: uid).anggotas,
          initialData: const [],
          catchError: (BuildContext context, Object? exception) {
            return <Anggota>[Anggota(namaAnggota: "Anggota tidak ditemukan!")];
          },
        ),

      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text("Rekrutmen Anggota"),
          actions: <Widget>[

            Row(
              children: <Widget>[
                const Text("Ke luar di sini"),
                IconButton(
                  onPressed: () async {
                    setState(() {});

                    // firebase signing out method
                    await _layananOtentikasi.signOut();

                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.logout,
                  ),
                  tooltip: "Ke luar",
                ),
              ],
            ),

          ],
        ),
        drawer: Drawer(
          child: DrawerHeader(
            child: ListView(
              children: <Widget>[

                // user drawer header
                StreamBuilder<Pengguna>(
                    stream: LayananOtentikasi().onAuthStateChanges,
                    initialData: Pengguna(uid: "", email: ""),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Pengguna pengguna = Pengguna(
                            uid: snapshot.data!.uid,
                            email: snapshot.data!.email);

                        return UserAccountsDrawerHeader(
                          currentAccountPicture: const CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/profile.png",
                            ),
                          ),
                          currentAccountPictureSize: const Size(64.0, 64.0),
                          accountName: const Text("Hello, "),
                          accountEmail: Text(pengguna.email),
                        );
                      } else {
                        return const Loading();
                      }
                    }),

                // profil timses
                Card(
                  elevation: 10.0,
                  color: Colors.purple[100],
                  child: ListTile(
                    title: const Text('Profile TimSes'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const ProfileTimses();
                        }),
                      );
                    },
                  ),
                ),

                // tentang aplikasi
                Card(
                  elevation: 10.0,
                  color: Colors.purple[100],
                  child: ListTile(
                    title: const Text('Tentang Aplikasi'),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const Tentang();
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            // background
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/pelangi_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // list anggota
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<Iterable<Anggota>>(
                  stream: LayananDatabase(uid: uid).anggotas,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Anggota> listAnggota = snapshot.data!.toList();
                      return ListView.builder(
                          itemCount: listAnggota.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.purple[100],
                              elevation: 10.0,
                              child: ListTile(
                                leading: (listAnggota[index]
                                            .jenisKelamin
                                            .toString() ==
                                        "pria")
                                    ? const Icon(
                                        Icons.man,
                                        size: 32.0,
                                      )
                                    : const Icon(
                                        Icons.woman,
                                        size: 32.0,
                                      ),
                                title: Text(
                                    listAnggota[index].namaAnggota.toString()),
                                subtitle: Text(
                                    listAnggota[index].kelurahan.toString()),
                                trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            icon: const Icon(Icons.add_alert),
                                            title: const Text(
                                                "Konfirmasi Hapus data"),
                                            content: Text(
                                                "Yakin mau hapus ${listAnggota[index].namaAnggota.toString()}?"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {},
                                                child: const Text("Batal"),
                                              ),
                                              TextButton(
                                                onPressed: () {},
                                                child: const Text("Hapus"),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return const FormMember();
                                    }),
                                  );
                                },
                              ),
                            );
                          });
                    } else {
                      return const Loading();
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: Consumer<TimSes>(
          builder: (context, timSes, child) {
            return FloatingActionButton(
              onPressed: () {
                if(namaCaleg != "nama caleg") {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const FormMember();
                    }),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Anda belum diRekrut oleh Caleg!"),
                    duration: Duration(seconds: 5),
                    elevation: 10.0,
                  ));
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}
