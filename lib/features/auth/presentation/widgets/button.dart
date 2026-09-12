import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: () => {}, child: Text(label));
  }
}
