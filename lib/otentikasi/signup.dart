
import 'package:flutter/material.dart';
import 'package:mytimses/layanan/layanan_otentikasi.dart';
import 'package:mytimses/widgets/loading.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, required this.toggleView}) : super(key: key);

  final Function toggleView;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // layanan otentikasi firebase
  final LayananOtentikasi _layananOtentikasi = LayananOtentikasi();

  // form state
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  // text field state
  String email = "";
  String password = "";

  // error handling
  String error = "";

  @override
  Widget build(BuildContext context) {
    return (_loading) ? const Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Daftar"),
        actions: <Widget>[
          Row(
            children: <Widget>[
              const Text("Masuk di sini"),
              IconButton(
                onPressed: () {
                  widget.toggleView();
                },
                icon: const Icon(Icons.login),
                tooltip: "Masuk",
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/pelangi_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // email
                      TextFormField(
                        validator: (val) => (val!.isEmpty) ? "Masukkan email!" : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: const InputDecoration(
                            label: Text("Email"), hintText: "Masukkan email"),
                      ),

                      const SizedBox(
                        height: 20.0,
                      ),

                      // password
                      TextFormField(
                        validator: (val) => (val!.length < 6) ? "Masukkan katakunci > 6 karakter!" : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                            label: Text("Password"),
                            hintText: "Minimal 8 karakter"),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: <Widget>[

                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });

                                dynamic result = await _layananOtentikasi
                                    .registerWithEmailAndPassword(
                                        email, password);

                                if (result == null) {
                                  setState(() {
                                    error = "Masukkan email yang benar!";
                                    _loading = false;
                                  });
                                }
                              }
                            },
                            child: const Text("Daftar"),
                          ),

                        ],
                      ),
                      Text(
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 18.0),
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
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
