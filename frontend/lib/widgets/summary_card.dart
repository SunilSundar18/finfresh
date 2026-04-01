import 'package:flutter/material.dart';
import '../utils/formatters.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isPercentage;

  const SummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            const SizedBox(height: 8),
            Text(
              isPercentage ? "${value.toStringAsFixed(1)}%" : Formatters.toRupee(value),
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}