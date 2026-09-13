import 'package:flutter/material.dart';
import '../../domain/usecases/disconnect_user.dart';

class TestConnect extends StatelessWidget {
  const TestConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('test Connexion'),
            FilledButton(
              onPressed: () {
                disconnectUser();
              },
              child: Text('Se deconnecter'),
            ),
          ],
        ),
      ),
    );
  }
}
