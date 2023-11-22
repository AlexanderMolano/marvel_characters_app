import 'dart:async';

import 'package:flutter/material.dart';

class MessageUtils {
  static void showMessage(BuildContext context, String text, Color iconColor) {
    const messageDuration = Duration(seconds: 3);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: iconColor,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
        );
      },
    );
    Timer(messageDuration, () {
      Navigator.of(context).pop();
    });
  }
}
