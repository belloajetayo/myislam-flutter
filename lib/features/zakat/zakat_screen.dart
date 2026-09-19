import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';

class ZakatScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onDonateTap;

  const ZakatScreen({super.key, required this.onBack, required this.onDonateTap});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  final _savingsCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _investmentsCtrl = TextEditingController();
  final _businessCtrl = TextEditingController();
  final _debtsCtrl = TextEditingController();

  double? _calculatedZakat;
  double _netZakatableWealth = 0;
  final double _nisabThreshold = 5000.0; // Approx USD equivalent

  void _calculate() {
    final savings = double.tryParse(_savingsCtrl.text) ?? 0;
    final gold = double.tryParse(_goldCtrl.text) ?? 0;
    final silver = double.tryParse(_silverCtrl.text) ?? 0;
    final inv = double.tryParse(_investmentsCtrl.text) ?? 0;
    final bus = double.tryParse(_businessCtrl.text) ?? 0;
    final debts = double.tryParse(_debtsCtrl.text) ?? 0;

    final net = (savings + gold + silver + inv + bus) - debts;
    _netZakatableWealth = net > 0 ? net : 0;

    setState(() {
      if (_netZakatableWealth >= _nisabThreshold) {
        _calculatedZakat = _netZakatableWealth * 0.025;
      } else {
        _calculatedZakat = 0.0;
      }
    });
  }

  static const List<Map<String, String>> recipients = [
    {"title": "The Poor (Al-Fuqara)", "desc": "Those who have little to no income"},
    {"title": "The Needy (Al-Masakin)", "desc": "Those who cannot meet basic needs"},
    {"title": "Zakat Administrators", "desc": "Those who collect and distribute Zakat"},
    {"title": "Those in Debt", "desc": "Those overwhelmed by essential debts"},
    {"title": "In the Way of Allah", "desc": "Causes that serve Islam & the community"},
    {"title": "Travelers (Ibn As-Sabil)", "desc": "Stranded travelers in genuine need"},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          // Header Bar
          Row(
            children: [
              AnimatedBackButton(onPressed: widget.onBack),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Zakat Calculator",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                  ),
                  Text(
                    "Purify your wealth (Third Pillar of Islam)",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Intro Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(colors: [Color(0xFF1E1B4B), Color(0xFF172554)])
                  : AppColors.heroPrayerGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Row(
              children: [
                Text("🌾", style: TextStyle(fontSize: 28)),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Annual Zakat (2.5%)",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Zakat purifies wealth and protects the vulnerable. Current estimated Nisab threshold is \$5,000 USD.",
                        style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Inputs Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEF2FF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Your Assets & Wealth", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                _buildField(_savingsCtrl, "Cash & Bank Savings (\$)", Icons.savings_rounded, isDark),
                _buildField(_goldCtrl, "Gold Value (\$)", Icons.monetization_on_rounded, isDark),
                _buildField(_silverCtrl, "Silver Value (\$)", Icons.toll_rounded, isDark),
                _buildField(_investmentsCtrl, "Stocks, Crypto & Shares (\$)", Icons.trending_up_rounded, isDark),
                _buildField(_businessCtrl, "Business Merchandise (\$)", Icons.store_rounded, isDark),
                _buildField(_debtsCtrl, "Minus Short-term Debts (\$)", Icons.money_off_rounded, isDark),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.islamicGold,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: _calculate,
                    child: const Text("Calculate Zakat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),

          // Result Card
          if (_calculatedZakat != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF59E0B).withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text("ZAKAT OBLIGATION", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(
                    "\$${_calculatedZakat!.toStringAsFixed(2)}",
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _calculatedZakat! > 0
                        ? "Net Zakatable Wealth: \$${_netZakatableWealth.toStringAsFixed(2)} (Above Nisab)"
                        : "Wealth is below Nisab threshold (\$5,000). Zakat is not obligatory.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFEA580C),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: widget.onDonateTap,
                    icon: const Icon(Icons.volunteer_activism_rounded, size: 18),
                    label: const Text("Pay Zakat / Sadaqah Now", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Recipients List
          const Text("Who is Eligible to Receive Zakat?", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          Column(
            children: recipients.map((r) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.islamicGreen, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Text(r["desc"]!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 18),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF8FAFC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
