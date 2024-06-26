import 'package:flutter/material.dart';

class AppTextCounter extends StatelessWidget {
  const AppTextCounter({
    required this.currentLength,
    required this.maxLength,
    super.key,
  });

  final int currentLength;
  final int maxLength;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          '$currentLength/$maxLength',
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            letterSpacing: 0,
            height: 1.45,
            color: Color(0xffEF4848),
          ),
        ),
      );
}
