import 'package:flutter/material.dart';
import '../constants/theme_contants.dart'; // Ajustez selon votre arborescence réelle
import 'custom_text_field.dart';
import 'custom_button.dart';

class CustomInputModal extends StatefulWidget {
  final String title;
  final String label;
  final String hintText;
  final String submitButtonText;

  const CustomInputModal({
    super.key,
    required this.title,
    required this.label,
    required this.hintText,
    this.submitButtonText = 'Valider',
  });

  static Future<String?> show(
    BuildContext context, {
    required String title,
    required String label,
    required String hintText,
    String submitButtonText = 'Valider',
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomInputModal(
        title: title,
        label: label,
        hintText: hintText,
        submitButtonText: submitButtonText,
      ),
    );
  }

  @override
  State<CustomInputModal> createState() => _CustomInputModalState();
}

class _CustomInputModalState extends State<CustomInputModal> {
  final _modalFormKey = GlobalKey<FormState>();
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.blanc,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      // CORRECTION : On force une contrainte de largeur finie via cette boite
      child: SizedBox(
        width: MediaQuery.of(
          context,
        ).size.width, // Donne la largeur exacte de l'écran
        child: SingleChildScrollView(
          child: Form(
            key: _modalFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.noir,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.grisTexte),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(color: AppColors.grisClair),
                const SizedBox(height: 16),

                CustomTextField(
                  label: widget.label,
                  hintText: widget.hintText,
                  controller: _inputController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Ce champ ne peut pas être vide'
                      : null,
                ),
                const SizedBox(height: 16),

                CustomButton(
                  text: widget.submitButtonText,
                  onPressed: () {
                    if (_modalFormKey.currentState!.validate()) {
                      Navigator.pop(context, _inputController.text.trim());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
