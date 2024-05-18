import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final List<Color> backColor;

  final List<Color> textColor;
  final GestureTapCallback onPressed;

  const ButtonWidget({
    super.key,
    required this.text,
    required this.backColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Shader textGradient = LinearGradient(
      colors: <Color>[textColor[0], textColor[1]],
    ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.06,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          stops: const [0.4, 2],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: backColor,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Align(
              child: Text(
                text,
                style: TextStyle(
                  foreground: Paint()..shader = textGradient,
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.02,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
