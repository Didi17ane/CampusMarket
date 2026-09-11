import 'package:campusmarket/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/colors.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.black,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.1),
            child: Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Logo_Campus_market.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Campus",
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: "Market",
                          style: GoogleFonts.poppins(
                            color: primaryColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                          )
                        )
                      ]
                    ),
                  ),
                  Text("Achat, vente et echange d'objet de seconde main",
                    style: GoogleFonts.poppins(
                      color: Colors.white
                    ),
                  ),
                  SizedBox(height: 20),
                  LoginForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
