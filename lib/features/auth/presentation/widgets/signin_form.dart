import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({super.key});

  @override
  State<SigninForm> createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = false;

  void setIsObscured(){
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.90,
      // height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
              'Inscription',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Nom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              validator: (String? value) {
                return (value != null && !value.contains('@'))
                    ? 'Entrer un email correct'
                    : null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Prenom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              validator: (String? value) {
                return (value != null && !value.contains('@'))
                    ? 'Entrer un email correct'
                    : null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
              validator: (String? value) {
                return (value != null && !value.contains('@'))
                    ? 'Entrer un email correct'
                    : null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              obscureText: _isObscured,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                suffixIcon: IconButton(
                  onPressed: () => setIsObscured(),
                  icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                )
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                    ? 'Vous devez saisir un mot de passe'
                    : null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              obscureText: _isObscured,
              decoration: InputDecoration(
                labelText: 'Confirmer Mot de passe',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                suffixIcon: IconButton(
                  onPressed: () => setIsObscured(),
                  icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                ),
                )
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                    ? 'Vous devez saisir un mot de passe'
                    : null;
              },
            ),
            SizedBox(height: 30,),
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Center(child: Text("S'inscrire", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold ),)),
              ),
              onTap: (){},
            ),
            SizedBox(height: 10,),
            GestureDetector(
              child: Text(
                'Vous avez deja un compte ? Se connecter',
                style: GoogleFonts.poppins(color: Colors.red)
              ),
              onTap: (){},
            )
          ],
        ),
      ),
    );
  }
}
