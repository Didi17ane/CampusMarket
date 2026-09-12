import 'package:flutter/material.dart';
import '../constants/theme_contants.dart';

class CustomButton extends StatelessWidget {
  final String text; // Text de description
  final VoidCallback onPressed; // la fonction quant on cliquera sur le boutton
  final bool isLoading; // pour gerer l'etat du boutton: active ou desactive

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.orangePrincipal.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(4, 4), // Légère ombre portée
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangePrincipal,
          foregroundColor: AppColors.blanc,
          minimumSize: const Size(double.infinity, 50),
          shape: const StadiumBorder(), // Forme Pilule (Pill shape)
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.blanc,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
