import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'middleware.dart';

//Provider lié au routage, c'est lui qui est directement lié a GoRouter
//Parce que GoRouter n'ecoute pas de Stream Brute ce qui est renvoyé UserLoginProvider
final routerAuthNotifierProvider = Provider((ref) {
  return RouterAuthNotifier(ref);
});
