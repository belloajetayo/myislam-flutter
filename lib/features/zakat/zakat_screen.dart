import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';

enum NisabStandard { gold, silver }

class ZakatScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onDonateTap;

  const ZakatScreen({super.key, required this.onBack, required this.onDonateTap});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  // Input Controllers
  final _cashCtrl = TextEditingController();
  final _bankCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  final _silverCtrl = TextEditingController();
  final _investmentsCtrl = TextEditingController();
  final _cryptoCtrl = TextEditingController();
  final _businessStockCtrl = TextEditingController();
  final _moneyOwedCtrl = TextEditingController();
  final _debtsCtrl = TextEditingController();

  // Settings
  NisabStandard _selectedNisab = NisabStandard.gold;
  String _selectedCurrency = "USD";
  String _currencySymbol = "\$";

  // Metal Prices per gram
  double _goldPricePerGram = 68.0; // USD default
  double _silverPricePerGram = 0.90; // USD default

  double _totalAssets = 0;
  double _totalDebts = 0;
  double _netZakatableWealth = 0;
  double _calculatedZakat = 0;

  static const Map<String, String> _currencySymbols = {
    "USD": "\$",
    "GBP": "£",
    "EUR": "€",
    "NGN": "₦",
    "SAR": "﷼",
    "AED": "د.إ",
    "CAD": "\$",
    "AUD": "\$",
  };

  double get _currentNisabThreshold {
    if (_selectedNisab == NisabStandard.gold) {
      // 87.48 grams of gold
      return 87.48 * _goldPricePerGram;
    } else {
      // 612.36 grams of silver
      return 612.36 * _silverPricePerGram;
    }
  }

  @override
  void initState() {
    super.initState();
    // Add real-time listeners
    for (final c in [
      _cashCtrl,
      _bankCtrl,
      _goldCtrl,
      _silverCtrl,
      _investmentsCtrl,
      _cryptoCtrl,
      _businessStockCtrl,
      _moneyOwedCtrl,
      _debtsCtrl,
    ]) {
      c.addListener(_calculateLive);
    }
  }

  @override
  void dispose() {
    _cashCtrl.dispose();
    _bankCtrl.dispose();
    _goldCtrl.dispose();
    _silverCtrl.dispose();
    _investmentsCtrl.dispose();
    _cryptoCtrl.dispose();
    _businessStockCtrl.dispose();
    _moneyOwedCtrl.dispose();
    _debtsCtrl.dispose();
    super.dispose();
  }

  void _calculateLive() {
    final cash = double.tryParse(_cashCtrl.text) ?? 0;
    final bank = double.tryParse(_bankCtrl.text) ?? 0;
    final gold = double.tryParse(_goldCtrl.text) ?? 0;
    final silver = double.tryParse(_silverCtrl.text) ?? 0;
    final inv = double.tryParse(_investmentsCtrl.text) ?? 0;
    final crypto = double.tryParse(_cryptoCtrl.text) ?? 0;
    final business = double.tryParse(_businessStockCtrl.text) ?? 0;
    final owed = double.tryParse(_moneyOwedCtrl.text) ?? 0;
    final debts = double.tryParse(_debtsCtrl.text) ?? 0;

    final assets = cash + bank + gold + silver + inv + crypto + business + owed;
    final net = assets - debts;

    setState(() {
      _totalAssets = assets;
      _totalDebts = debts;
      _netZakatableWealth = net > 0 ? net : 0;

      if (_netZakatableWealth >= _currentNisabThreshold) {
        _calculatedZakat = _netZakatableWealth * 0.025;
      } else {
        _calculatedZakat = 0.0;
      }
    });
  }

  void _changeCurrency(String newCurr) {
    setState(() {
      _selectedCurrency = newCurr;
      _currencySymbol = _currencySymbols[newCurr] ?? "\$";
      // Adjust standard gold/silver prices according to currency approx
      switch (newCurr) {
        case "GBP":
          _goldPricePerGram = 54.0;
          _silverPricePerGram = 0.72;
          break;
        case "EUR":
          _goldPricePerGram = 63.0;
          _silverPricePerGram = 0.84;
          break;
        case "NGN":
          _goldPricePerGram = 105000.0;
          _silverPricePerGram = 1400.0;
          break;
        case "SAR":
        case "AED":
          _goldPricePerGram = 255.0;
          _silverPricePerGram = 3.40;
          break;
        default:
          _goldPricePerGram = 68.0;
          _silverPricePerGram = 0.90;
      }
      _calculateLive();
    });
  }

  static const List<Map<String, String>> recipients = [
    {
      "title": "The Poor (Al-Fuqara)",
      "arabic": "الفقراء",
      "desc": "Those who have little to no income or property.",
    },
    {
      "title": "The Needy (Al-Masakin)",
      "arabic": "المساكين",
      "desc": "Those who earn but cannot meet basic life necessities.",
    },
    {
      "title": "Zakat Administrators ('Amilina 'Alayha)",
      "arabic": "العاملين عليها",
      "desc": "Trustworthy collectors and distributors of Zakat funds.",
    },
    {
      "title": "Reconciling Hearts (Mu'allafati Qulubuhum)",
      "arabic": "المؤلفة قلوبهم",
      "desc": "New Muslims or friends of the faith needing social support.",
    },
    {
      "title": "Freeing Captives (Fi Ar-Riqab)",
      "arabic": "في الرقاب",
      "desc": "Liberating oppressed individuals or victims of modern bondage.",
    },
    {
      "title": "Those in Overwhelming Debt (Al-Gharimin)",
      "arabic": "الغارمين",
      "desc": "Debtors whose essential loans exceed their financial capacity.",
    },
    {
      "title": "In the Cause of Allah (Fi Sabilillah)",
      "arabic": "في سبيل الله",
      "desc": "Supporting community welfare, Islamic education & guidance.",
    },
    {
      "title": "The Stranded Traveler (Ibn As-Sabil)",
      "arabic": "ابن السبيل",
      "desc": "Travelers stranded away from home without access to funds.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEligible = _netZakatableWealth >= _currentNisabThreshold;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
        children: [
          // Header Bar
          Row(
            children: [
              AnimatedBackButton(onPressed: widget.onBack),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Zakat Calculator (الزكاة)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.islamicGold,
                      ),
                    ),
                    Text(
                      "Purify your wealth • Third Pillar of Islam",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              // Currency Dropdown Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCurrency,
                    dropdownColor: isDark ? AppColors.darkCardBg : Colors.white,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                    icon: const Icon(Icons.arrow_drop_down_rounded, size: 20),
                    items: _currencySymbols.keys.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) _changeCurrency(v);
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Nisab Standard Selector Bar
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedNisab = NisabStandard.gold;
                        _calculateLive();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedNisab == NisabStandard.gold
                            ? AppColors.islamicGold
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _selectedNisab == NisabStandard.gold
                            ? [
                                BoxShadow(
                                  color: AppColors.islamicGold.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Gold Nisab (87.48g)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _selectedNisab == NisabStandard.gold
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.grey[700]),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedNisab = NisabStandard.silver;
                        _calculateLive();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedNisab == NisabStandard.silver
                            ? AppColors.islamicIndigo
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: _selectedNisab == NisabStandard.silver
                            ? [
                                BoxShadow(
                                  color: AppColors.islamicIndigo.withOpacity(0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Silver Nisab (612.36g)",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _selectedNisab == NisabStandard.silver
                              ? Colors.white
                              : (isDark ? Colors.white70 : Colors.grey[700]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Nisab Info Callout
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1B4B).withOpacity(0.6) : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, color: Color(0xFF6366F1), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Current Nisab: $_currencySymbol${_currentNisabThreshold.toStringAsFixed(0)} "
                    "(${_selectedNisab == NisabStandard.gold ? '87.48g Gold' : '612.36g Silver'}). "
                    "Zakat of 2.5% is due if net wealth exceeds this value for one lunar year.",
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white.withOpacity(0.85) : const Color(0xFF3730A3),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // 1. Cash & Bank Balances Section
          _buildCategoryHeader("1. Cash & Bank Accounts", Icons.account_balance_wallet_rounded, isDark),
          _buildField(_cashCtrl, "Cash in hand & at home ($_currencySymbol)", Icons.money_rounded, isDark),
          _buildField(_bankCtrl, "Bank checking & savings balances ($_currencySymbol)", Icons.account_balance_rounded, isDark),

          const SizedBox(height: 14),

          // 2. Gold & Precious Metals
          _buildCategoryHeader("2. Gold, Silver & Precious Metals", Icons.monetization_on_rounded, isDark),
          _buildField(_goldCtrl, "Gold jewelry, coins & bars value ($_currencySymbol)", Icons.stars_rounded, isDark),
          _buildField(_silverCtrl, "Silver items & ornaments value ($_currencySymbol)", Icons.toll_rounded, isDark),

          const SizedBox(height: 14),

          // 3. Investments & Crypto
          _buildCategoryHeader("3. Investments, Shares & Crypto", Icons.trending_up_rounded, isDark),
          _buildField(_investmentsCtrl, "Stocks, mutual funds, ETFs market value ($_currencySymbol)", Icons.show_chart_rounded, isDark),
          _buildField(_cryptoCtrl, "Cryptocurrency & digital assets value ($_currencySymbol)", Icons.currency_bitcoin_rounded, isDark),

          const SizedBox(height: 14),

          // 4. Business Assets & Money Owed
          _buildCategoryHeader("4. Business Merchandise & Receivables", Icons.store_rounded, isDark),
          _buildField(_businessStockCtrl, "Saleable inventory & wholesale goods ($_currencySymbol)", Icons.inventory_2_rounded, isDark),
          _buildField(_moneyOwedCtrl, "Loans given to others (likely to be repaid) ($_currencySymbol)", Icons.handshake_rounded, isDark),

          const SizedBox(height: 14),

          // 5. Deductible Liabilities
          _buildCategoryHeader("5. Deductible Liabilities & Debts", Icons.money_off_rounded, isDark, isDeduction: true),
          _buildField(_debtsCtrl, "Short-term debts, rent, bills due now ($_currencySymbol)", Icons.credit_card_off_rounded, isDark),

          const SizedBox(height: 18),

          // Live Calculation Dashboard Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: isEligible
                  ? const LinearGradient(
                      colors: [Color(0xFF065F46), Color(0xFF047857), Color(0xFF059669)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : (isDark
                      ? const LinearGradient(
                          colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : AppColors.heroPrayerGradient),
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: (isEligible ? const Color(0xFF059669) : const Color(0xFF6366F1))
                      .withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ZAKAT CALCULATION SUMMARY",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isEligible
                            ? const Color(0xFF10B981)
                            : Colors.black.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isEligible ? "ELIGIBLE" : "BELOW NISAB",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Main Output Number
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "$_currencySymbol${_calculatedZakat.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Zakat Due (2.5%)",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                Divider(height: 1, color: Colors.white.withOpacity(0.2)),
                const SizedBox(height: 12),

                // Breakdown line items
                _buildSummaryLine("Total Zakatable Assets", "$_currencySymbol${_totalAssets.toStringAsFixed(2)}"),
                const SizedBox(height: 6),
                _buildSummaryLine("Less Deductible Debts", "- $_currencySymbol${_totalDebts.toStringAsFixed(2)}"),
                const SizedBox(height: 6),
                _buildSummaryLine("Net Zakatable Wealth", "$_currencySymbol${_netZakatableWealth.toStringAsFixed(2)}", isBold: true),
                const SizedBox(height: 6),
                _buildSummaryLine("Active Nisab Threshold", "$_currencySymbol${_currentNisabThreshold.toStringAsFixed(2)}"),

                const SizedBox(height: 16),

                // Pay Zakat / Sadaqah Now Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: isEligible ? const Color(0xFF065F46) : const Color(0xFF4338CA),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: widget.onDonateTap,
                    icon: const Icon(Icons.volunteer_activism_rounded, size: 18),
                    label: const Text(
                      "Give Zakat & Sadaqah Now",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // 8 Categories of Recipients (Quran 9:60)
          const Row(
            children: [
              Icon(Icons.people_alt_rounded, color: AppColors.islamicGold, size: 20),
              SizedBox(width: 8),
              Text(
                "8 Eligible Recipients of Zakat",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Specified in the Holy Quran (Surah At-Tawbah, 9:60):",
            style: TextStyle(fontSize: 11.5, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Quran Verse Callout Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1B4B).withOpacity(0.4) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  "إِنَّمَا الصَّدَقَاتُ لِلْفُقَرَاءِ وَالْمَسَاكِينِ وَالْعَامِلِينَ عَلَيْهَا وَالْمُؤَلَّفَةِ قُلُوبُهُمْ وَفِي الرِّقَابِ وَالْغَارِمِينَ وَفِي سَبِيلِ اللَّهِ وَابْنِ السَّبِيلِ ۖ فَرِيضَةً مِّنَ اللَّهِ ۗ وَاللَّهُ عَلِيمٌ حَكِيمٌ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 14,
                    height: 1.8,
                    color: AppColors.islamicGold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "\"Alms-tax is only for the poor and the needy, for those employed to collect it, for that they whose hearts are inclined to truth, for freeing captives, for those in debt, in the cause of Allah, and for the stranded traveler. An obligation from Allah.\" [9:60]",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white70 : Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 8 Asnaf List
          Column(
            children: recipients.map((r) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.islamicGold.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        r["arabic"]!,
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.islamicGold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r["title"]!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            r["desc"]!,
                            style: const TextStyle(fontSize: 11, color: Colors.grey),
                          ),
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

  Widget _buildCategoryHeader(String title, IconData icon, bool isDark, {bool isDeduction = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: isDeduction ? const Color(0xFFEF4444) : AppColors.islamicIndigo,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDeduction
                  ? (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFDC2626))
                  : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(
          fontSize: 13.5,
          color: isDark ? Colors.white : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white60 : Colors.grey[600],
          ),
          prefixIcon: Icon(icon, size: 18, color: isDark ? Colors.white54 : Colors.grey[600]),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF8FAFC),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSummaryLine(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(isBold ? 0.95 : 0.8),
            fontSize: 12,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.5,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
