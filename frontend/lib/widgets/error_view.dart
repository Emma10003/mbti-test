import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red),
          SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          ),
          SizedBox(height: 24),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: Icon(Icons.refresh),
            label: Text('다시 시도'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
            ),
          ),
        ],
      ),
    );
  }
}