import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'app_drawer.dart';
import 'bottom_navigation.dart';
import 'mini_player.dart';
import '../home/home_screen.dart';
import '../prayer/prayer_screen.dart';
import '../qiblah/qiblah_screen.dart';
import '../quran/quran_screen.dart';
import '../podcasts/podcasts_screen.dart';
import '../duas/duas_screen.dart';
import '../zakat/zakat_screen.dart';
import '../fasting/fasting_screen.dart';
import '../hajj/hajj_screen.dart';
import '../donate/donate_screen.dart';
import '../profile/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentBottomNavIndex = 0;
  String? _activeSubRoute;

  void _handleNavigate(String routeName) {
    setState(() {
      switch (routeName) {
        case "home":
          _currentBottomNavIndex = 0;
          _activeSubRoute = null;
          break;
        case "prayer":
          _currentBottomNavIndex = 1;
          _activeSubRoute = null;
          break;
        case "qiblah":
          _currentBottomNavIndex = 2;
          _activeSubRoute = null;
          break;
        case "quran":
          _currentBottomNavIndex = 3;
          _activeSubRoute = null;
          break;
        case "podcasts":
          _currentBottomNavIndex = 4;
          _activeSubRoute = null;
          break;
        default:
          _activeSubRoute = routeName;
      }
    });
  }

  void _handleBottomNavSelected(int index) {
    setState(() {
      _currentBottomNavIndex = index;
      _activeSubRoute = null;
    });
  }

  Widget _buildBody() {
    if (_activeSubRoute != null) {
      switch (_activeSubRoute) {
        case "duas":
          return DuasScreen(onBack: () => setState(() => _activeSubRoute = null));
        case "zakat":
          return ZakatScreen(
            onBack: () => setState(() => _activeSubRoute = null),
            onDonateTap: () => setState(() => _activeSubRoute = "donate"),
          );
        case "fasting":
          return FastingScreen(onBack: () => setState(() => _activeSubRoute = null));
        case "hajj":
          return HajjScreen(onBack: () => setState(() => _activeSubRoute = null));
        case "donate":
          return DonateScreen(onBack: () => setState(() => _activeSubRoute = null));
        case "profile":
          return ProfileScreen(onBack: () => setState(() => _activeSubRoute = null));
      }
    }

    switch (_currentBottomNavIndex) {
      case 0:
        return HomeScreen(
          onNavigate: _handleNavigate,
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
      case 1:
        return PrayerScreen(
          onBack: () => setState(() => _currentBottomNavIndex = 0),
        );
      case 2:
        return QiblahScreen(
          onBack: () => setState(() => _currentBottomNavIndex = 0),
        );
      case 3:
        return QuranScreen(
          onBack: () => setState(() => _currentBottomNavIndex = 0),
        );
      case 4:
        return PodcastsScreen(
          onBack: () => setState(() => _currentBottomNavIndex = 0),
        );
      default:
        return HomeScreen(
          onNavigate: _handleNavigate,
          onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(onNavigate: _handleNavigate),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : AppColors.lightBackgroundGradient,
        ),
        child: Stack(
          children: [
            _buildBody(),

            // Persistent Floating MiniPlayer and Bottom Navigation
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const MiniPlayer(),
                  CustomBottomNavigation(
                    currentIndex: _currentBottomNavIndex,
                    onTabSelected: _handleBottomNavSelected,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
