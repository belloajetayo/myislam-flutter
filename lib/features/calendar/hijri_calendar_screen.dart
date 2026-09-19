import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/hijri_calendar.dart';
import '../../core/widgets/animated_back_button.dart';

class HijriCalendarScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String routeName)? onNavigate;

  const HijriCalendarScreen({
    super.key,
    required this.onBack,
    this.onNavigate,
  });

  @override
  State<HijriCalendarScreen> createState() => _HijriCalendarScreenState();
}

class _HijriCalendarScreenState extends State<HijriCalendarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  late HijriDate _todayHijri;

  // For Date Converter tool
  DateTime _converterGregorianDate = DateTime.now();
  late HijriDate _converterHijriResult;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final now = DateTime.now();
    _todayHijri = HijriDate.fromGregorian(now);
    _selectedYear = _todayHijri.year;
    _selectedMonth = _todayHijri.month;
    _selectedDay = _todayHijri.day;
    _converterHijriResult = _todayHijri;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToPreviousMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear -= 1;
      } else {
        _selectedMonth -= 1;
      }
      final maxDays = HijriDate.daysInMonth(_selectedYear, _selectedMonth);
      if (_selectedDay > maxDays) _selectedDay = maxDays;
    });
  }

  void _goToNextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear += 1;
      } else {
        _selectedMonth += 1;
      }
      final maxDays = HijriDate.daysInMonth(_selectedYear, _selectedMonth);
      if (_selectedDay > maxDays) _selectedDay = maxDays;
    });
  }

  void _resetToToday() {
    setState(() {
      _selectedYear = _todayHijri.year;
      _selectedMonth = _todayHijri.month;
      _selectedDay = _todayHijri.day;
    });
  }

  String _formatGregorianDate(DateTime date) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    const weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return "${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBgStart : AppColors.lightBgStart,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(isDark),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.06) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  gradient: AppColors.purpleGoldShiningGradient,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.islamicGold.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: isDark ? Colors.white60 : Colors.grey[600],
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                tabs: const [
                  Tab(icon: Icon(Icons.calendar_month_rounded, size: 16), text: "Month Grid"),
                  Tab(icon: Icon(Icons.star_rounded, size: 16), text: "Sacred Events"),
                  Tab(icon: Icon(Icons.swap_horiz_rounded, size: 16), text: "Converter"),
                ],
              ),
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Interactive Month Calendar
                  _buildMonthCalendarTab(isDark),

                  // Tab 2: Sacred Events & Holidays
                  _buildEventsTab(isDark),

                  // Tab 3: Gregorian <-> Hijri Converter
                  _buildConverterTab(isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          AnimatedBackButton(
            onPressed: widget.onBack,
            tooltip: "Back to Home",
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Islamic Calendar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGoldShiningGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "1448 AH",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "التقويم الهجري • Accurate Lunar Phases & Sunnah Days",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.today_rounded, color: AppColors.islamicGold),
            tooltip: "Jump to Today",
            onPressed: _resetToToday,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthCalendarTab(bool isDark) {
    final monthName = HijriDate.monthNames[_selectedMonth - 1];
    final monthArabic = HijriDate.monthArabicNames[_selectedMonth - 1];
    final totalDays = HijriDate.daysInMonth(_selectedYear, _selectedMonth);

    // Calculate Gregorian range for this Hijri month
    final firstGregorian = HijriDate.toGregorian(_selectedYear, _selectedMonth, 1);
    final lastGregorian = HijriDate.toGregorian(_selectedYear, _selectedMonth, totalDays);

    // Day of the week of day 1: Sunday = 7 in DateTime.weekday (we map Sunday to 0, Mon=1, ..., Sat=6)
    final firstWeekdayOffset = firstGregorian.weekday == DateTime.sunday ? 0 : firstGregorian.weekday;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      children: [
        // Month Selector Header Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.purpleGoldHeroGradient : AppColors.purpleGoldShiningGradient,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.islamicGold.withOpacity(0.35),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.islamicPurpleDeep.withOpacity(isDark ? 0.3 : 0.15),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _goToPreviousMonth,
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        monthArabic,
                        style: GoogleFonts.amiriQuran(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.islamicGoldLight,
                        ),
                      ),
                      Text(
                        "$monthName $_selectedYear AH",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${firstGregorian.day} ${_getMonthAbbr(firstGregorian.month)} – ${lastGregorian.day} ${_getMonthAbbr(lastGregorian.month)} ${lastGregorian.year}",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: _goToNextMonth,
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Calendar Legend (White Days, Friday, Holiday)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendPill("🌙 White Days (13-15)", AppColors.islamicGold, isDark),
              _buildLegendPill("🕌 Jumu'ah (Friday)", const Color(0xFF10B981), isDark),
              _buildLegendPill("⭐ Holy Event", const Color(0xFFA855F7), isDark),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Weekday Headers
        Row(
          children: const [
            Expanded(child: _WeekdayHeader("Sun")),
            Expanded(child: _WeekdayHeader("Mon")),
            Expanded(child: _WeekdayHeader("Tue")),
            Expanded(child: _WeekdayHeader("Wed")),
            Expanded(child: _WeekdayHeader("Thu")),
            Expanded(child: _WeekdayHeader("Fri", isFriday: true)),
            Expanded(child: _WeekdayHeader("Sat")),
          ],
        ),

        const SizedBox(height: 6),

        // Month Grid
        _buildDaysGrid(isDark, totalDays, firstWeekdayOffset),

        const SizedBox(height: 18),

        // Selected Day Details Card
        _buildSelectedDayCard(isDark),
      ],
    );
  }

  Widget _buildDaysGrid(bool isDark, int totalDays, int offset) {
    final totalCells = totalDays + offset;
    final rowCount = (totalCells / 7).ceil();

    return Column(
      children: List.generate(rowCount, (rowIndex) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: List.generate(7, (colIndex) {
              final cellIndex = (rowIndex * 7) + colIndex;
              final dayNumber = cellIndex - offset + 1;

              if (dayNumber < 1 || dayNumber > totalDays) {
                return const Expanded(child: SizedBox(height: 52));
              }

              final isSelected = dayNumber == _selectedDay;
              final isToday = dayNumber == _todayHijri.day &&
                  _selectedMonth == _todayHijri.month &&
                  _selectedYear == _todayHijri.year;
              final isWhiteDay = HijriDate.isWhiteDay(dayNumber);
              final isFriday = colIndex == 5;
              final event = HijriDate.getEventFor(_selectedMonth, dayNumber);
              final gregDate = HijriDate.toGregorian(_selectedYear, _selectedMonth, dayNumber);

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDay = dayNumber;
                    });
                  },
                  child: Container(
                    height: 54,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? AppColors.purpleGoldShiningGradient
                          : (isToday
                              ? LinearGradient(
                                  colors: [
                                    AppColors.islamicGold.withOpacity(0.2),
                                    AppColors.islamicPurple.withOpacity(0.2),
                                  ],
                                )
                              : null),
                      color: isSelected
                          ? null
                          : (isDark
                              ? (isFriday
                                  ? const Color(0xFF064E3B).withOpacity(0.25)
                                  : AppColors.darkCardBg)
                              : (isFriday
                                  ? const Color(0xFFECFDF5)
                                  : Colors.white)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : (isToday
                                ? AppColors.islamicGold
                                : (isWhiteDay
                                    ? AppColors.islamicGold.withOpacity(0.4)
                                    : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)))),
                        width: isToday || isSelected ? 1.8 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.islamicGold.withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Stack(
                      children: [
                        // White Day crescent or Event indicator
                        if (isWhiteDay)
                          Positioned(
                            top: 2,
                            right: 3,
                            child: Icon(
                              Icons.nightlight_round,
                              size: 8,
                              color: isSelected ? Colors.white : AppColors.islamicGold,
                            ),
                          ),
                        if (event != null)
                          Positioned(
                            top: 2,
                            left: 3,
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.white : const Color(0xFFA855F7),
                              ),
                            ),
                          ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "$dayNumber",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : (isFriday
                                          ? const Color(0xFF10B981)
                                          : (isDark ? Colors.white : const Color(0xFF1E293B))),
                                ),
                              ),
                              Text(
                                "${gregDate.day}",
                                style: TextStyle(
                                  fontSize: 9,
                                  color: isSelected
                                      ? Colors.white70
                                      : (isDark ? Colors.white38 : Colors.grey[500]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildSelectedDayCard(bool isDark) {
    final monthName = HijriDate.monthNames[_selectedMonth - 1];
    final monthArabic = HijriDate.monthArabicNames[_selectedMonth - 1];
    final gregDate = HijriDate.toGregorian(_selectedYear, _selectedMonth, _selectedDay);
    final isWhiteDay = HijriDate.isWhiteDay(_selectedDay);
    final isFriday = gregDate.weekday == DateTime.friday;
    final event = HijriDate.getEventFor(_selectedMonth, _selectedDay);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: event != null
              ? AppColors.islamicGold.withOpacity(0.6)
              : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
          width: event != null ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 12,
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
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGoldShiningGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$_selectedDay",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$_selectedDay $monthName $_selectedYear AH",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatGregorianDate(gregDate),
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "$_selectedDay $monthArabic",
                style: GoogleFonts.amiriQuran(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.islamicGold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Badges row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (isWhiteDay)
                _buildActionChip(
                  "🌙 White Day (Ayyam al-Beed)",
                  "Sunnah to Fast today",
                  AppColors.islamicGold,
                  isDark,
                ),
              if (isFriday)
                _buildActionChip(
                  "🕌 Jumu'ah Mubarak",
                  "Read Surah Al-Kahf & Salawat",
                  const Color(0xFF10B981),
                  isDark,
                ),
              if (event != null)
                _buildActionChip(
                  "${event.icon} ${event.name}",
                  event.isHoliday ? "Islamic Holiday" : "Special Milestone",
                  const Color(0xFFA855F7),
                  isDark,
                ),
            ],
          ),

          if (event != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.islamicGold.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.islamicGold.withOpacity(0.25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(event.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${event.name} (${event.arabic})",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: isDark ? Colors.white70 : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Virtue: ${event.virtue}",
                    style: const TextStyle(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: AppColors.islamicGold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventsTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
      itemCount: HijriDate.keyEvents.length,
      itemBuilder: (context, index) {
        final event = HijriDate.keyEvents[index];
        final monthName = HijriDate.monthNames[event.month - 1];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: event.isHoliday
                  ? AppColors.islamicGold.withOpacity(0.5)
                  : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: event.isHoliday
                              ? AppColors.purpleGoldShiningGradient
                              : LinearGradient(
                                  colors: [
                                    AppColors.islamicIndigo.withOpacity(0.3),
                                    AppColors.islamicPurple.withOpacity(0.3),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(event.icon, style: const TextStyle(fontSize: 18)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${event.day} $monthName",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.islamicGold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    event.arabic,
                    textDirection: TextDirection.rtl,
                    style: GoogleFonts.amiriQuran(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.islamicGoldLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: isDark ? Colors.white70 : const Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 12, color: AppColors.islamicGold),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.virtue,
                        style: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: isDark ? Colors.white60 : Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConverterTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      children: [
        // Gregorian to Hijri Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: AppColors.purpleGoldShiningGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Gregorian ➔ Hijri Date",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                "Select any Gregorian date to find the corresponding Islamic Lunar date:",
                style: TextStyle(fontSize: 12, color: isDark ? Colors.white60 : Colors.grey[600]),
              ),
              const SizedBox(height: 14),

              // Date Picker Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  side: BorderSide(color: AppColors.islamicGold.withOpacity(0.5)),
                ),
                icon: const Icon(Icons.edit_calendar_rounded, color: AppColors.islamicGold),
                label: Text(
                  _formatGregorianDate(_converterGregorianDate),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _converterGregorianDate,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _converterGregorianDate = picked;
                      _converterHijriResult = HijriDate.fromGregorian(picked);
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              // Output Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: isDark ? AppColors.purpleGoldHeroGradient : AppColors.purpleGoldShiningGradient,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.islamicGold.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    const Text(
                      "CORRESPONDING HIJRI DATE",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: AppColors.islamicGoldLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _converterHijriResult.formatted,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _converterHijriResult.formattedArabic,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.amiriQuran(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Sacred Months Info Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("📜", style: TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  const Text(
                    "The Four Sacred Months",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "“Indeed, the number of months with Allah is twelve [lunar] months... of these, four are sacred. That is the correct religion, so do not wrong yourselves during them.” (Surah At-Tawbah 9:36)",
                style: TextStyle(
                  fontSize: 11.5,
                  fontStyle: FontStyle.italic,
                  height: 1.45,
                  color: isDark ? Colors.white70 : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildSacredMonthChip("1. Dhul Qi'dah", isDark),
                  _buildSacredMonthChip("2. Dhul Hijjah (Hajj)", isDark),
                  _buildSacredMonthChip("3. Muharram (Ashura)", isDark),
                  _buildSacredMonthChip("4. Rajab", isDark),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSacredMonthChip(String name, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.islamicGold.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.islamicGold.withOpacity(0.35)),
      ),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.bold,
          color: AppColors.islamicGold,
        ),
      ),
    );
  }

  Widget _buildLegendPill(String title, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : const Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(String title, String subtitle, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9.5,
              color: isDark ? Colors.white60 : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthAbbr(int month) {
    const m = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return m[month.clamp(1, 12) - 1];
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String title;
  final bool isFriday;

  const _WeekdayHeader(this.title, {this.isFriday = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isFriday
                ? const Color(0xFF10B981)
                : (isDark ? Colors.white54 : Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
