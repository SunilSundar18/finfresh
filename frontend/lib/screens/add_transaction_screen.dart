import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/financial_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  
  // Default values must match the lists below
  String _type = 'expense'; 
  String _category = 'food';

  // Specific category lists
  final List<String> _incomeCategories = ['salary'];
  
  final List<String> _expenseCategories = [
    'food', 'rent', 'shopping', 'transport', 'entertainment', 'debt', 'investment'
  ];

  // Helper to determine which list to display in the dropdown
  List<String> get _currentCategories => 
      _type == 'income' ? _incomeCategories : _expenseCategories;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final success = await context.read<FinancialProvider>().addTransaction({
        "type": _type,
        "category": _category,
        // Sending as a string ensures Django's DecimalField parses it correctly
        "amount": _amountController.text,
        "description": _descController.text,
        "date": DateTime.now().toIso8601String().split('T')[0], // YYYY-MM-DD
      });

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction added successfully!")),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Type Selector
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'income', label: Text('Income'), icon: Icon(Icons.add_circle)),
                    ButtonSegment(value: 'expense', label: Text('Expense'), icon: Icon(Icons.remove_circle)),
                  ],
                  selected: {_type},
                  onSelectionChanged: (val) {
                    setState(() {
                      _type = val.first;
                      // CRITICAL: Reset category to valid default when switching types
                      _category = _type == 'income' ? 'salary' : 'food';
                    });
                  },
                ),
                const SizedBox(height: 25),

                // Amount Field
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: "Amount (₹)",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || double.tryParse(val) == null || double.parse(val) <= 0) 
                      ? "Enter a valid positive amount" : null,
                ),
                const SizedBox(height: 20),

                // Dynamic Category Dropdown
                DropdownButtonFormField<String>(
                  value: _category,
                  items: _currentCategories.map((c) => 
                    DropdownMenuItem(value: c, child: Text(c))
                  ).toList(),
                  onChanged: (val) => setState(() => _category = val!),
                  decoration: const InputDecoration(
                    labelText: "Category", 
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Field
                TextFormField(
                  controller: _descController, 
                  decoration: const InputDecoration(
                    labelText: "Description", 
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 35),

                // Save Button
                ElevatedButton(
                  onPressed: context.watch<FinancialProvider>().isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Save Transaction", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}