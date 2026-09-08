import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(
            children: [
              Image.asset('assets/images/Logo_Campus_market.png'),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}