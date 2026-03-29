import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        'Speak\nEasy',
        style: Theme.of(context).textTheme.displayLarge,
      ),
    );
  }
}
