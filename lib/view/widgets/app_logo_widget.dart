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
        Image.asset('assets/img/logomarca.png', height: 70),
        const SizedBox(height: 5),
        Text(
          'Gestão de Atendimentos',
          style: TextStyle(
            color: Colors.black45,
            fontSize: size.height * 0.016,
          ),
        ),
      ],
    );
  }
}
