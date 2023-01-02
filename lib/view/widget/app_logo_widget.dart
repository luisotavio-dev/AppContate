import 'package:flutter/material.dart';

class AppLogoWidget extends StatelessWidget {
  final MainAxisAlignment alignment;
  const AppLogoWidget({this.alignment = MainAxisAlignment.center, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: alignment,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contate',
              style: TextStyle(
                color: Colors.black,
                fontSize: size.height * 0.035,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '+',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: size.height * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Text(
          'Gestão de Atendimentos',
          style: TextStyle(
            color: Colors.black,
            fontSize: size.height * 0.016,
          ),
        ),
      ],
    );
  }
}
