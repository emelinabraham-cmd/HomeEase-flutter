import 'package:flutter/material.dart';
import '../theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.brandDark,
        borderRadius: BorderRadius.circular(36),
        boxShadow: const [
           BoxShadow(
            color: Colors.black26,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           _buildNavItem(Icons.home, "HOME", true),
           _buildNavItem(Icons.calendar_today, "BOOKINGS", false),
           _buildNavItem(Icons.person, "PROFILE", false),
           _buildNavItem(Icons.support_agent, "SUPPORT", false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon, 
          color: isSelected ? AppTheme.primary : Colors.white.withOpacity(0.4),
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: isSelected ? AppTheme.primary : Colors.white.withOpacity(0.4),
          ),
        ),
      ],
    );
  }
}
