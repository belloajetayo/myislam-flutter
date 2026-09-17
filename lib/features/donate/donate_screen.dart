import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

class DonateScreen extends StatefulWidget {
  final VoidCallback onBack;

  const DonateScreen({super.key, required this.onBack});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {
  int _selectedAmount = 50;
  bool _isMonthly = false;
  bool _isZakat = false;

  static const List<int> amounts = [10, 25, 50, 100, 250];

  static const List<Map<String, dynamic>> impacts = [
    {"amount": "\$10", "desc": "Powers daily server access for hundreds of global users"},
    {"amount": "\$50", "desc": "Promotes free Quran & prayer times to new communities"},
    {"amount": "\$100", "desc": "Contributes to mobile app features and audio stream reliability"},
    {"amount": "\$250+", "desc": "Funds major features like translations and worldwide outreach"},
  ];

  void _copyAddress(String label, String address) {
    Clipboard.setData(ClipboardData(text: address));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$label address copied to clipboard! ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Hero Background Image with dark gradient overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 260,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  "assets/images/donate_hero.jpg",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)]),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              children: [
                // Back Button
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onBack,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Hero Message
                const Text(
                  "Support MyIslam",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Empower every Muslim's daily connection to Allah through authentic prayers, Quran, and guidance. Help build lasting Sadaqah Jariyah.",
                  style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85), height: 1.45),
                ),

                const SizedBox(height: 36),

                // Donation Form Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF131131) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: isDark ? Colors.white12 : const Color(0xFFEEF2FF)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Donation Amount",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 14),

                      // Amount Pills
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: amounts.map((amt) {
                          final isSelected = amt == _selectedAmount;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedAmount = amt),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                gradient: isSelected ? AppColors.goldGradient : null,
                                color: isSelected ? null : (isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? Colors.transparent : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
                                ),
                              ),
                              child: Text(
                                "\$$amt",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 16),

                      // Toggles
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Make this a monthly gift", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        subtitle: const Text("Continuous monthly Sadaqah", style: TextStyle(fontSize: 11, color: Colors.grey)),
                        value: _isMonthly,
                        activeColor: AppColors.islamicGold,
                        onChanged: (v) => setState(() => _isMonthly = v),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("This donation is eligible for Zakat", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        value: _isZakat,
                        activeColor: AppColors.islamicGold,
                        onChanged: (v) => setState(() => _isZakat = v ?? false),
                      ),

                      const SizedBox(height: 12),

                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.islamicGold,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                            elevation: 0,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("JazakAllah Khair! Processing your ${_isMonthly ? 'monthly ' : ''}${_isZakat ? 'Zakat' : 'Sadaqah'} of \$$_selectedAmount 💛"),
                              ),
                            );
                          },
                          child: Text(
                            "Donate \$$_selectedAmount Now",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Impact Items
                const Text("Your Impact", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                ...impacts.map((imp) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.islamicGold.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            imp["amount"] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.islamicGold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(imp["desc"] as String, style: const TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // Crypto Section
                const Text("Crypto Giving (USDT / BTC)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                _buildCryptoTile("USDT (TRC20)", "TYDzsYbmF8zX4...G298zQ", isDark),
                _buildCryptoTile("Bitcoin (BTC)", "bc1qxy2kgdygjrsq...tz29", isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCryptoTile(String label, String address, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              Text(address, style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'monospace')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 18),
            onPressed: () => _copyAddress(label, address),
          ),
        ],
      ),
    );
  }
}
