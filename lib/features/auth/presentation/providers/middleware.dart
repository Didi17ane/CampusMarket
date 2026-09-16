import 'package:campusmarket/features/auth/presentation/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Ce provider permet d'ecouter les differents etats de l'application
//en prenant en compte l'etat de la connexion user, l'ouverture initiale de l'application ou une connexion
class RouterAuthNotifier extends ChangeNotifier {
  final Ref _ref;
  bool _isLoggedIn = false;
  bool _initialBoot = true;

  RouterAuthNotifier(this._ref) {
    _ref.listen<AsyncValue<User?>>(userLoginProvider, (previous, next) {
      next.when(
        data: (user) {
          _isLoggedIn = user != null;
          _initialBoot = false;
          notifyListeners();
        },
        error: (_, _) {
          _isLoggedIn = false;
          _initialBoot = false;
          notifyListeners();
        },
        loading: () {
          if (previous == null) {
            _initialBoot = true;
          }
        },
      );
    });
  }

  bool get isConnected => _isLoggedIn;
  bool get isLoading => _initialBoot;
}
