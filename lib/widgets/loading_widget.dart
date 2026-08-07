import 'package:flutter/material.dart';

/// Reusable loading widget displaying a centered indicator with an optional text message.
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color color;

  const LoadingWidget({
    super.key,
    this.message,
    this.color = Colors.deepPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: color),
          if (message != null && message!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
