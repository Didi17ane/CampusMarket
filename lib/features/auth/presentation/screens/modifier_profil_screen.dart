import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';
import '../../data/models/users_models.dart';

class ModifierProfilScreen extends ConsumerStatefulWidget {
  final Users user;
  const ModifierProfilScreen({super.key, required this.user});

  @override
  ConsumerState<ModifierProfilScreen> createState() => _ModifierProfilScreenState();
}

class _ModifierProfilScreenState extends ConsumerState<ModifierProfilScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _lastnameCtrl;
  late final TextEditingController _phoneCtrl;
  bool _enregistrement = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _lastnameCtrl = TextEditingController(text: widget.user.lastname);
    _phoneCtrl = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _lastnameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _enregistrer() async {
    setState(() => _enregistrement = true);
    final userMisAJour = Users(
      id: widget.user.id,
      name: _nameCtrl.text.trim(),
      lastname: _lastnameCtrl.text.trim(),
      email: widget.user.email, // email non modifiable ici
      phoneNumber: _phoneCtrl.text.trim(),
      photo: widget.user.photo,
    );
    await ref.read(usersRepositoryProvider).updateUser(userMisAJour);
    if (mounted) {
      setState(() => _enregistrement = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Modifier mes informations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _lastnameCtrl,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneCtrl,
              decoration: const InputDecoration(labelText: 'Téléphone (WhatsApp)'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              enabled: false,
              controller: TextEditingController(text: widget.user.email),
              decoration: const InputDecoration(labelText: 'Email (non modifiable)'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _enregistrement ? null : _enregistrer,
              child: _enregistrement
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Enregistrer', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
