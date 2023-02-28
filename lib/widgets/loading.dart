import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/pelangi_background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: SpinKitChasingDots(
          color: Colors.purple,
          size: 50.0,
        ),
      ),
    );
  }
}
