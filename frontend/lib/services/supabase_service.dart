import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  // ------------------------------------------------
  // INITIALIZE
  // ------------------------------------------------
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://pxhcheeetgfjkmrmjdqt.supabase.co',
      anonKey: 'sb_publishable_xlJr2MYlcYdjdC8jUbw-IA_dQVjgj5v',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  // ------------------------------------------------
  // AUTHENTICATION
  // ------------------------------------------------
  static Future<AuthResponse> signUp(String email, String password) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static User? get currentUser => client.auth.currentUser;

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  // ------------------------------------------------
  // PROFILE MANAGEMENT
  // ------------------------------------------------
  static Future<void> updateProfile(
    String userId, {
    required String name,
    required String phone,
  }) async {
    await client.from('profiles').update({
      'full_name': name,
      'phone': phone,
    }).eq('id', userId);
  }

  // ------------------------------------------------
  // WALLET OPERATIONS (Unified Wallet)
  // ------------------------------------------------
  static Future<void> createWallet(
    String userId, {
    double initialBalance = 0,
  }) async {
    final existing = await client
        .from('wallets')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (existing == null) {
      await client.from('wallets').insert({
        'user_id': userId,
        'balance': initialBalance,
        'savings_balance': 0,
      });
    }
  }

  // ✅ Fetch Wallet Balance
  static Future<double> getWalletBalance() async {
    final user = currentUser;
    if (user == null) throw "User not logged in";

    final res = await client
        .from('wallets')
        .select('balance')
        .eq('user_id', user.id)
        .maybeSingle();

    if (res == null) return 0;

    return (res['balance'] as num).toDouble();
  }

  // ✅ Fetch Savings Balance
  static Future<double> getSavingsBalance() async {
    final user = client.auth.currentUser;
    if (user == null) throw 'User not logged in';

    final res = await client
        .from('wallets')
        .select('savings_balance')
        .eq('user_id', user.id)
        .maybeSingle();

    return res == null ? 0.0 : (res['savings_balance'] as num).toDouble();
  }

  static Future<void> addMoney(double amount) async {
    final user = currentUser;
    if (user == null) throw "User not logged in";

    await client.rpc(
      'add_money',
      params: {
        'p_user_id': user.id,
        'p_amount': amount,
      },
    );
  }

  // ------------------------------------------------
  // PROCESS PAYMENT + AUTO-SAVE LOGIC
  // ------------------------------------------------
  static Future<Map<String, dynamic>> processPayment(
      double amount, String category) async {
    final user = client.auth.currentUser;
    if (user == null) throw "User not logged in";

    final wallet = await client
        .from('wallets')
        .select('balance, savings_balance')
        .eq('user_id', user.id)
        .maybeSingle();

    if (wallet == null) throw "Wallet not found";

    double currentBalance = (wallet['balance'] as num).toDouble();
    double savings = (wallet['savings_balance'] as num).toDouble();

    if (amount > currentBalance) throw "Insufficient funds";

    // 5% Auto-Save logic
    double savedAmount = amount * 0.05;
    double newBalance = currentBalance - amount;
    double newSavings = savings + savedAmount;

    await client.from('wallets').update({
      'balance': newBalance,
      'savings_balance': newSavings,
    }).eq('user_id', user.id);

    await client.from('transactions').insert({
      'user_id': user.id,
      'amount': amount,
      'type': 'debit',
      'category': category,
    });

    return {
      'new_balance': newBalance,
      'new_savings': newSavings,
      'saved_amount': savedAmount,
    };
  }

  // ------------------------------------------------
  // FETCH TRANSACTIONS BY USER
  // ------------------------------------------------
  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final user = currentUser;
    if (user == null) throw "User not logged in";

    final response = await client
        .from('transactions')
        .select('amount, type, category, created_at')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  // ------------------------------------------------
  // RECORD INVESTMENT (Deduct from savings)
  // ------------------------------------------------
  static Future<void> recordInvestment(
      String symbol, String name, double amount) async {
    final user = client.auth.currentUser;
    if (user == null) throw 'User not logged in';

    final wallet = await client
        .from('wallets')
        .select('savings_balance')
        .eq('user_id', user.id)
        .maybeSingle();

    if (wallet == null) throw 'No wallet found';

    final currentSavings = (wallet['savings_balance'] as num).toDouble();
    if (currentSavings < amount) throw 'Insufficient savings balance';

    final newBalance = currentSavings - amount;

    await client
        .from('wallets')
        .update({'savings_balance': newBalance}).eq('user_id', user.id);

    await client.from('investments').insert({
      'user_id': user.id,
      'stock_symbol': symbol,
      'stock_name': name,
      'invested_amount': amount,
    });
  }
}