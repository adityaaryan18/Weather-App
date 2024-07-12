import "package:flutter/material.dart";

class AdditionalInfoItems extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalInfoItems({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(label,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

