import 'package:flutter/material.dart';
import '../models/financial_models.dart';

class HealthScoreCard extends StatelessWidget {
  final HealthScore? score;

  const HealthScoreCard({super.key, this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.indigo.shade700, Colors.indigo.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Text(
              "Financial Health Score",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              "${score?.score.toInt() ?? 0}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 60,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              score?.label.toUpperCase() ?? "CALCULATING...",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(color: Colors.white24),
            ),
            // Suggestions List
            ... (score?.suggestions.map((text) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white70, size: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            )).toList() ?? []),
          ],
        ),
      ),
    );
  }
}