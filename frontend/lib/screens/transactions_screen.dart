import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Transactions")),
      body: FutureBuilder(
        // Ensure path matches Django exactly: /transactions (no trailing slash)
        future: ApiService().get('/transactions/'), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading transactions"));
          }

          final List transactions = snapshot.data?.data ?? [];

          if (transactions.isEmpty) {
            return const Center(child: Text("No transactions found for this month."));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final bool isIncome = tx['type'] == 'income';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(tx['category'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(tx['date']),
                trailing: Text(
                  "${isIncome ? '+' : '-'} ₹${tx['amount']}",
                  style: TextStyle(
                    color: isIncome ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}