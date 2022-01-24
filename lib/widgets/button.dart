import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  const BuildButton({
    Key? key,
    required this.color,
    required this.name,
    required this.onPressed,
  }) : super(key: key);
  final Color color;
  final String name;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 42,
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
