import 'package:flutter/material.dart';

class AppChipDismissable extends StatelessWidget {
  const AppChipDismissable({
    required this.text,
    super.key,
    this.onDismiss,
  });
  final String text;
  final void Function()? onDismiss;

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
          color: Color(0xffe2e2e2),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.43,
                  letterSpacing: 0,
                  color: Color(0xff0e0e10),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 5.0),
            InkWell(
              onTap: onDismiss,
              child: const Icon(
                Icons.close_rounded,
                size: 16.0,
                color: Color(0x66696a6c),
              ),
            ),
          ],
        ),
      );
}
