import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mytimses/layanan/layanan_otentikasi.dart';
import 'package:mytimses/models/pengguna.dart';
import 'package:mytimses/wrapper.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyTimses());
}

class MyTimses extends StatelessWidget {
  const MyTimses({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // pengguna sistem
        StreamProvider<Pengguna>.value(
          value: LayananOtentikasi().onAuthStateChanges,
          initialData: Pengguna(uid: "", email: ""),
          catchError: (BuildContext context, Object? exception) {
            return Pengguna(
                uid: "Pengguna belum sign-in",
                email: "noone@noweb.com"
            );
          },
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: const Wrapper(),
      ),
    );
  }
}
