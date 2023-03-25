import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const LargeButton({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: const Color.fromRGBO(31, 45, 65, 0.4),
            disabledForegroundColor: Theme.of(context).backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: "Lato",
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            ),
          ),
          child: Text(
            title,
          ),
        ),
      ),
    );
  }
}
