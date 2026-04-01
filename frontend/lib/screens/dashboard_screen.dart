// lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/financial_provider.dart';
import '../services/auth_service.dart';
import '../widgets/summary_card.dart';
import '../widgets/health_score_card.dart';
import 'login_screen.dart';
import 'transactions_screen.dart';
import 'add_transaction_screen.dart'; // Ensure you have this file!

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data from Django API immediately on load
    Future.microtask(() => 
      context.read<FinancialProvider>().fetchData()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<FinancialProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("FinFresh", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.indigo),
            onPressed: () => provider.fetchData(),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await AuthService().logout();
              if (mounted) {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (_) => const LoginScreen())
                );
              }
            },
          ),
        ],
      ),
      body: _buildBody(provider),
      // Updated FAB to "Add Entry" instead of just "View"
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => const AddTransactionScreen())
          );
        },
        label: const Text("Add Entry", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.indigo,
      ),
    );
  }

  Widget _buildBody(FinancialProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.indigo),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
            const SizedBox(height: 16),
            Text(provider.errorMessage!, 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => provider.fetchData(),
              child: const Text("Retry Connection"),
            )
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchData(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row with "See All" for transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Monthly Overview", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (_) => const TransactionsScreen())
                  ),
                  child: const Text("Recent History", style: TextStyle(color: Colors.indigo)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Grid for Summary Metrics
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                SummaryCard(
                  label: "Income", 
                  value: provider.summary?.income ?? 0, 
                  color: Colors.green,
                ),
                SummaryCard(
                  label: "Expenses", 
                  value: provider.summary?.expenses ?? 0, 
                  color: Colors.redAccent,
                ),
                SummaryCard(
                  label: "Savings", 
                  value: provider.summary?.savings ?? 0, 
                  color: Colors.blueAccent,
                ),
                SummaryCard(
                  label: "Savings Rate", 
                  value: provider.summary?.savingsRate ?? 0, 
                  color: Colors.orange,
                  isPercentage: true, // Fixed: This now shows % instead of ₹
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            const Text("Financial Health Score", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            // Reusable Health Score Widget
            HealthScoreCard(score: provider.healthScore),
            
            const SizedBox(height: 100), // Extra padding for FAB
          ],
        ),
      ),
    );
  }
}