import 'package:flutter/material.dart';
import 'theme.dart';
import 'components/bottom_nav_bar.dart';
import 'home_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/support_screen.dart';
import 'models/service_model.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Service? _selectedService;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onServiceSelected(Service service) {
    setState(() {
      _selectedService = service;
      _selectedIndex = 1; // Switch to Bookings tab
    });
  }

  void _handleBack() {
    setState(() {
      _selectedIndex = 0; // Always go back to Home
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeScreen(
        onServiceSelected: _onServiceSelected,
        onProfileSelected: () => _onItemTapped(2),
      ),
      BookingsScreen(service: _selectedService, onBack: _handleBack),
      ProfileScreen(onBack: _handleBack),
      SupportScreen(onBack: _handleBack),
    ];

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      extendBody: true,
      body: pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
        child: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}
