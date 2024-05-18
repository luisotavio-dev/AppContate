import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final IconData? icon;
  final Widget title;
  final Color? backColor;
  final int? badge;
  final GestureTapCallback onPressed;

  const CardWidget({
    super.key,
    this.icon,
    required this.title,
    this.backColor,
    this.badge,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      constraints: const BoxConstraints(
        minHeight: 60,
      ),
      width: size.width * 0.9,
      margin: EdgeInsets.only(bottom: size.height * 0.01),
      decoration: BoxDecoration(
        color: backColor ?? Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color.fromARGB(255, 237, 237, 237)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                icon != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Icon(icon),
                      )
                    : const SizedBox(width: 15),
                Expanded(child: title),
                badge != null
                    ? Container(
                        padding: const EdgeInsets.all(5),
                        constraints: const BoxConstraints(minWidth: 30),
                        height: 30,
                        margin: const EdgeInsets.only(right: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Center(
                          child: Text(
                            badge!.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Visibility(visible: false, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
