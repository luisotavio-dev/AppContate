import 'package:flutter/material.dart';
import 'package:lancamento_contatos/theme.dart';

class GradientFloatingActionButtonWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;
  const GradientFloatingActionButtonWidget({
    required this.text,
    required this.icon,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: gradient,
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onTap(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 23,
                ),
                const SizedBox(width: 5),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
