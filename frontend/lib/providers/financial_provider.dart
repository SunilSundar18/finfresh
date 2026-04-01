import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/financial_models.dart';

class FinancialProvider with ChangeNotifier {
  final ApiService _api = ApiService();

  Summary? _summary;
  HealthScore? _healthScore;
  bool _isLoading = false;
  String? _errorMessage;

  Summary? get summary => _summary;
  HealthScore? get healthScore => _healthScore;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Matches your Django urls: path('summary', ...) and path('financial-health', ...)
      final responses = await Future.wait([
        _api.get('/summary'),
        _api.get('/financial-health'),
      ]);

      _summary = Summary.fromJson(responses[0].data);
      _healthScore = HealthScore.fromJson(responses[1].data);
    } catch (e) {
      _errorMessage = "Could not fetch data. Check API endpoints.";
      print("Provider Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // NEW: Method to send transaction to Django backend
  Future<bool> addTransaction(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Matches path('transactions', ...) in your Django urls
      await _api.post('/transactions/', data); 
      
      // Immediately refresh dashboard numbers
      await fetchData(); 
      return true;
    } catch (e) {
      print("Add Transaction Error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _summary = null;
    _healthScore = null;
    notifyListeners();
  }
}