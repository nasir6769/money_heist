import 'dart:math';

class InvestmentService {
  static List<Map<String, dynamic>> getStockSuggestions(String preference, double amount) {
    // Example stock data
    final stocks = [
      {"symbol": "TCS", "name": "Tata Consultancy", "growth": "Stable", "risk": "Low"},
      {"symbol": "INFY", "name": "Infosys", "growth": "Balanced", "risk": "Medium"},
      {"symbol": "RELIANCE", "name": "Reliance Industries", "growth": "Aggressive", "risk": "High"},
      {"symbol": "HDFCBANK", "name": "HDFC Bank", "growth": "Steady", "risk": "Low"},
      {"symbol": "ITC", "name": "ITC Ltd", "growth": "Defensive", "risk": "Low"},
    ];

    final random = Random();
    List<Map<String, dynamic>> filtered = [];

    if (preference == "Short-Term") {
      filtered = stocks.where((s) => s["risk"] != "Low").toList();
    } else if (preference == "Long-Term") {
      filtered = stocks.where((s) => s["growth"] == "Stable" || s["growth"] == "Steady").toList();
    } else {
      filtered = stocks;
    }

    filtered.shuffle(random);
    return filtered.take(3).toList();
  }
}
