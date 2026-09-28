import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/animated_back_button.dart';

class HajjScreen extends StatefulWidget {
  final VoidCallback onBack;

  const HajjScreen({super.key, required this.onBack});

  @override
  State<HajjScreen> createState() => _HajjScreenState();
}

class _HajjScreenState extends State<HajjScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Set<String> _checkedItems = {};

  // Countdown timer
  Timer? _timer;
  Duration _timeLeft = Duration.zero;

  // Cost Calculator inputs
  int _travelers = 1;
  String _departureRegion = 'North America';
  String _hotelTier = 'Standard';
  int _durationDays = 14;
  bool _includeUmrah = false;

  static const Map<String, int> _flightPrices = {
    'North America': 1500,
    'Europe': 800,
    'Africa': 700,
    'Asia': 600,
    'Middle East': 300,
    'Oceania': 2000,
    'South America': 1800,
  };

  static const Map<String, int> _hotelPricesPerDay = {
    'Budget': 80,
    'Standard': 150,
    'Premium': 300,
    'Luxury': 600,
  };

  static const List<Map<String, String>> hajjSteps = [
    {
      "day": "Day 1 (8th Dhul Hijjah)",
      "title": "Enter Ihram & Travel to Mina",
      "desc": "Wear the two white Ihram garments, formulate the intention (Niyyah), and stay in Mina praying Dhuhr, Asr, Maghrib, Isha, and Fajr.",
    },
    {
      "day": "Day 2 (9th Dhul Hijjah)",
      "title": "Day of Arafah (The Peak)",
      "desc": "Travel to plains of Arafah after Fajr. Stand before Allah in earnest prayer, dua, & repentance until sunset. This is the greatest pillar of Hajj.",
    },
    {
      "day": "Night of 9th - 10th",
      "title": "Muzdalifah Night",
      "desc": "Sleep under the open sky at Muzdalifah, combine Maghrib & Isha, and collect 49-70 small pebbles for the Jamarat.",
    },
    {
      "day": "Day 3 (10th Dhul Hijjah)",
      "title": "Eid, Jamarat & Tawaf al-Ifadah",
      "desc": "Pebble throwing at Jamarat al-Aqaba (7 pebbles), animal sacrifice (Qurbani), shave or trim hair (Tahallul), and perform Tawaf al-Ifadah.",
    },
    {
      "day": "Days 4-6 (11th-13th)",
      "title": "Days of Tashreeq in Mina",
      "desc": "Stone all three Jamarat daily after Dhuhr, stay in Mina, and perform Farewell Tawaf (Tawaf al-Wida) before leaving Makkah.",
    },
  ];

  static const List<String> ihramDos = [
    "Make sincere intention (Niyyah) for Allah alone",
    "Keep patient during heavy crowds & long waits",
    "Recite the Talbiyah frequently throughout the journey",
    "Help elderly and fellow pilgrims at every step",
    "Stay hydrated and protect yourself from excessive heat",
  ];

  static const List<String> ihramDonts = [
    "No arguing, anger, or vulgar/indecent speech",
    "No cutting hair or clipping nails while in Ihram",
    "No perfumes, scented soaps, or scented toiletries",
    "No covering head for men or face/gloves for women",
    "No hunting animals or cutting green trees in Haram",
  ];

  static const List<Map<String, String>> officialLinks = [
    {
      "title": "Nusuk Hajj Portal",
      "desc": "Official Saudi platform for individual international pilgrim booking",
      "url": "https://hajj.nusuk.sa/",
    },
    {
      "title": "Saudi eVisa Portal",
      "desc": "Official tourist & pilgrimage visa processing",
      "url": "https://visa.visitsaudi.com/",
    },
    {
      "title": "Ministry of Hajj & Umrah",
      "desc": "Guidelines, health regulations & pilgrim support services",
      "url": "https://www.haj.gov.sa/en",
    },
    {
      "title": "Saudia Airlines",
      "desc": "Direct scheduled pilgrimage flights to Jeddah & Madinah",
      "url": "https://www.saudia.com/",
    },
  ];

  static const List<Map<String, String>> hajjFaqs = [
    {
      "q": "What is the best time to book Hajj?",
      "a": "We recommend registering on Nusuk and preparing 6-12 months in advance. Early registration gives time for visa processing, mandatory vaccinations, and securing preferred packages.",
    },
    {
      "q": "How much does Hajj typically cost?",
      "a": "Hajj costs range depending on departure country, airline rates, and hotel tier. Standard packages typically run between \$6,000 - \$12,000 USD per pilgrim.",
    },
    {
      "q": "What vaccinations are mandatory?",
      "a": "Meningococcal (ACWY) vaccination is strictly mandatory for all pilgrims. COVID-19 and seasonal influenza vaccinations are also widely required.",
    },
    {
      "q": "Can women perform Hajj without a Mahram?",
      "a": "Saudi regulations now permit women of all ages to perform Hajj and Umrah in organized pilgrim groups without requiring an accompanying male guardian (Mahram).",
    },
    {
      "q": "How physically demanding is Hajj?",
      "a": "Hajj requires walking between 5 to 15 km daily in high temperatures. Pilgrims should begin physical walking preparation several weeks before departure.",
    },
    {
      "q": "What is the difference between Hajj and Umrah?",
      "a": "Umrah can be performed at any time of year and consists of Ihram, Tawaf, and Sa'i. Hajj is mandatory once in a lifetime, occurs only during the specific days of Dhul Hijjah, and includes standing at Arafah, Muzdalifah, and Mina.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _calculateTimeLeft());
  }

  void _calculateTimeLeft() {
    final now = DateTime.now();
    // Next Hajj starts approximately on May 24, 2026 / 8th Dhul Hijjah
    final targetHajj = DateTime(2026, 5, 24, 0, 0, 0);
    final diff = targetHajj.isAfter(now)
        ? targetHajj.difference(now)
        : DateTime(now.year + 1, 5, 24).difference(now);
    if (mounted) {
      setState(() {
        _timeLeft = diff;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  int _calculateTotalCost() {
    final flight = _flightPrices[_departureRegion] ?? 1000;
    final hotelPerDay = _hotelPricesPerDay[_hotelTier] ?? 150;
    final hotel = hotelPerDay * _durationDays;
    const services = 150 + 200 + 300 + 100; // visa, transport, guidance, insurance
    final meals = 40 * _durationDays;
    final umrah = _includeUmrah ? 800 : 0;
    final perPerson = flight + hotel + services + meals + umrah;
    return perPerson * _travelers;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        children: [
          // Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                AnimatedBackButton(onPressed: widget.onBack),
                const SizedBox(width: 14),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hajj & Umrah Portal",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                    ),
                    Text(
                      "Fifth Pillar of Islam — The Sacred Journey",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Countdown Card (Makkah Countdown)
          Container(
            margin: const EdgeInsets.fromLTRB(16, 6, 16, 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF312E81), Color(0xFF1E1B4B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.islamicGold.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text("🕋", style: TextStyle(fontSize: 22)),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hajj 1447 AH Countdown",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Makkah Al-Mukarramah, Saudi Arabia",
                              style: TextStyle(color: Colors.white60, fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.islamicGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.islamicGold.withOpacity(0.4)),
                      ),
                      child: const Text(
                        "Dhul Hijjah",
                        style: TextStyle(color: AppColors.islamicGold, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildCountdownUnit("${_timeLeft.inDays}", "Days", isDark),
                    const SizedBox(width: 8),
                    _buildCountdownUnit("${_timeLeft.inHours % 24}".padLeft(2, '0'), "Hours", isDark),
                    const SizedBox(width: 8),
                    _buildCountdownUnit("${_timeLeft.inMinutes % 60}".padLeft(2, '0'), "Mins", isDark),
                    const SizedBox(width: 8),
                    _buildCountdownUnit("${_timeLeft.inSeconds % 60}".padLeft(2, '0'), "Secs", isDark),
                  ],
                ),
              ],
            ),
          ),

          // Scrollable Tab Navigation
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.islamicGold,
            unselectedLabelColor: isDark ? Colors.white60 : Colors.grey,
            indicatorColor: AppColors.islamicGold,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            tabs: const [
              Tab(text: "Rituals Guide"),
              Tab(text: "Cost Estimator"),
              Tab(text: "Rules & Advice"),
              Tab(text: "Packing List"),
              Tab(text: "Nusuk & FAQ"),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // 1. Rituals Guide
                _buildRitualsTab(isDark),

                // 2. Cost Calculator
                _buildCostTab(isDark),

                // 3. Rules & Dos/Don'ts
                _buildRulesTab(isDark),

                // 4. Packing List
                _buildPackingTab(isDark),

                // 5. Booking Links & FAQ
                _buildBookingFaqTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdownUnit(String value, String label, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.islamicGold,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRitualsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        // Talbiyah Banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.heroPrayerGradient,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            children: [
              Text("TALBIYAH — CALL OF THE PILGRIM", style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
              SizedBox(height: 6),
              Text(
                "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Amiri', color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                "\"Here I am, O Allah, here I am. Here I am, You have no partner, here I am. Truly all praise, favor, and sovereignty belong to You.\"",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Steps
        ...hajjSteps.map((step) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEF2FF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step["day"]!,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.islamicGold),
                ),
                const SizedBox(height: 4),
                Text(
                  step["title"]!,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  step["desc"]!,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.45,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCostTab(bool isDark) {
    final totalCost = _calculateTotalCost();
    final perPerson = (_travelers > 0) ? (totalCost / _travelers).round() : totalCost;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        // Total Estimate Summary Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: AppColors.purpleGoldShiningGradient,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppColors.islamicGold.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text("ESTIMATED TOTAL BUDGET", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(
                "\$$totalCost USD",
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(
                "~\$$perPerson per pilgrim ($_travelers ${_travelers == 1 ? 'person' : 'people'})",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Controls Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEF2FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Travelers Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Number of Pilgrims", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _travelers > 1 ? () => setState(() => _travelers--) : null,
                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                        color: AppColors.islamicGold,
                      ),
                      Text("$_travelers", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: _travelers < 10 ? () => setState(() => _travelers++) : null,
                        icon: const Icon(Icons.add_circle_outline, size: 20),
                        color: AppColors.islamicGold,
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(height: 20),

              // Departure Region Dropdown
              const Text("Departure Region", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _departureRegion,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: _flightPrices.keys.map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _departureRegion = val);
                },
              ),
              const SizedBox(height: 14),

              // Hotel Tier
              const Text("Hotel Tier", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _hotelTier,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                items: _hotelPricesPerDay.keys.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _hotelTier = val);
                },
              ),
              const SizedBox(height: 14),

              // Duration Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Trip Duration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text("$_durationDays Days", style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.islamicGold)),
                ],
              ),
              Slider(
                value: _durationDays.toDouble(),
                min: 7,
                max: 30,
                divisions: 23,
                activeColor: AppColors.islamicGold,
                onChanged: (v) => setState(() => _durationDays = v.round()),
              ),

              // Umrah Addon Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Include Umrah Pre-Trip (+\$800)", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text("Perform Umrah in Makkah before entering Hajj rites", style: TextStyle(fontSize: 11)),
                value: _includeUmrah,
                activeColor: AppColors.islamicGold,
                onChanged: (v) => setState(() => _includeUmrah = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRulesTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        const Text("Prescribed Deeds (Dos)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF10B981))),
        const SizedBox(height: 8),
        ...ihramDos.map((d) => _buildCheckTile(d, true, isDark)),
        const SizedBox(height: 16),
        const Text("Prohibitions in Ihram (Don'ts)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFFEF4444))),
        const SizedBox(height: 8),
        ...ihramDonts.map((d) => _buildCheckTile(d, false, isDark)),
      ],
    );
  }

  Widget _buildPackingTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        // Interactive Progress Card
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.purpleGoldShiningGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.islamicGold.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Packing Readiness",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    "${_checkedItems.length} / 12 Packed",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (_checkedItems.length / 12).clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),
        _buildChecklistCategory("Essential Travel Documents", [
          "Valid International Passport (6+ months validity)",
          "Nusuk Hajj Visa and ID Card printouts",
          "ACWY Meningitis & mandatory vaccination certificates",
        ], isDark),
        _buildChecklistCategory("Ihram & Modest Attire", [
          "2 sets of white Ihram towels (men)",
          "Ihram belt or waist pouch with clip",
          "Light, breathable modest Abayas/Jilbabs (women)",
          "Comfortable walking flip-flops / padded sandals",
        ], isDark),
        _buildChecklistCategory("Toiletries & Health Essentials", [
          "Fragrance-free soap & unscented sunscreen",
          "Electrolyte hydration packets & reusable water flask",
          "Personal prescription medications with prescriptions",
        ], isDark),
        _buildChecklistCategory("Spiritual Companion Items", [
          "Pocket Quran or MyIslam app loaded offline",
          "Authentic Hisnul Muslim (Fortress of the Muslim) Dua guide",
        ], isDark),
      ],
    );
  }

  Widget _buildBookingFaqTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
      children: [
        const Text("Official Portals & Resources", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.islamicGold)),
        const SizedBox(height: 8),
        ...officialLinks.map((link) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.islamicGold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.public_rounded, color: AppColors.islamicGold, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(link["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(link["desc"]!, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.open_in_new_rounded, size: 18, color: AppColors.islamicGold),
                  onPressed: () => _openUrl(link["url"]!),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),

        const Text("Frequently Asked Questions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.islamicGold)),
        const SizedBox(height: 8),
        ...hajjFaqs.map((faq) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
            ),
            child: ExpansionTile(
              shape: const Border(),
              title: Text(faq["q"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              children: [
                Text(
                  faq["a"]!,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.grey[800],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCheckTile(String text, bool isDo, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(
            isDo ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isDo ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildChecklistCategory(String title, List<String> items, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFEEF2FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.islamicGold)),
          const SizedBox(height: 8),
          ...items.map((i) {
            final isChecked = _checkedItems.contains(i);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isChecked) {
                    _checkedItems.remove(i);
                  } else {
                    _checkedItems.add(i);
                  }
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Row(
                  children: [
                    Icon(
                      isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      size: 20,
                      color: isChecked ? AppColors.islamicGold : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        i,
                        style: TextStyle(
                          fontSize: 12.5,
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked ? Colors.grey : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
