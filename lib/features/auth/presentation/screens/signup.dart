import 'package:campusmarket/core/constants/theme_contants.dart';
import 'package:campusmarket/features/auth/presentation/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_safe/keyboard_safe.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: KeyboardSafe(
          scroll: true,
          child: SafeArea(
            child: Container(
              color: Colors.black,
              padding: EdgeInsets.only(top: 20),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/CampusMarket_logo_icone.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Campus",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "Market",
                            style: GoogleFonts.poppins(
                              color: AppColors.orangePrincipal,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Achat, vente et echange d'objet de seconde main",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    SignupForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
