import 'package:campusmarket/core/constants/theme_contants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snackify/enums/snack_enums.dart';
import 'package:snackify/snackify.dart';
import '../../data/models/users_models.dart';
import '../../domain/usecases/signup_user.dart';
import '../../../../core/constants/colors.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isObscured = true;
  bool _isLoading = false;

  final _nameUserController = TextEditingController();
  final _lastNameUserController = TextEditingController();
  final _emailUserController = TextEditingController();
  final _phoneNumberUserController = TextEditingController();
  final _passwordController = TextEditingController();

  void setIsObscured() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  void setIsLoading() {
    setState(() => _isLoading = true);
  }

  @override
  void dispose() {
    _nameUserController.dispose();
    _lastNameUserController.dispose();
    _emailUserController.dispose();
    _phoneNumberUserController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              controller: _nameUserController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Nom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                    ? 'Entrer votre nom'
                    : null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _lastNameUserController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Prenom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                    ? 'Entrer votre prenom'
                    : null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailUserController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                return (value != null && !value.contains('@'))
                    ? 'Entrer un email correct'
                    : null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneNumberUserController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Numero de Telephone',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                    ? 'Vous devez saisir un mot de passe'
                    : null;
              },
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: _isObscured,
              decoration: InputDecoration(
                labelText: 'Mot de passe',
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  onPressed: () => setIsObscured(),
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
              validator: (String? value) {
                return (value != null && value.isEmpty)
                    ? 'Vous devez saisir un mot de passe'
                    : null;
              },
            ),
            SizedBox(height: 30),
            GestureDetector(
              child: !_isLoading
                  ? Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.orangePrincipal,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          "S'inscrire",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.grisClair,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.grisTexte,
                        ),
                      ),
                    ),
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  setIsLoading();
                  try {
                    await signUpUser(
                      utilisateurs: Users(
                        name: _nameUserController.text.trim(),
                        lastname: _lastNameUserController.text.trim(),
                        email: _emailUserController.text.trim(),
                        phoneNumber: _phoneNumberUserController.text.trim(),
                      ),
                      password: _passwordController.text.trim(),
                    );
                  } catch (e) {
                    final message = e.toString().replaceAll("Exception:", "");
                    Snackify.show(
                      context: context,
                      type: SnackType.error,
                      position: SnackPosition.top,
                      title: Text(
                        ' Oops',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      subtitle: Text(
                        message,
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      duration: const Duration(seconds: 3),
                      animationDuration: const Duration(milliseconds: 500),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                }
              },
            ),
            SizedBox(height: 10),
            GestureDetector(
              child: Text(
                'Vous avez deja un compte ? Se connecter',
                style: GoogleFonts.poppins(color: AppColors.orangePrincipal),
              ),
              onTap: () => context.go('/login'),
            ),
          ],
        ),
      ),
    );
  }
}
