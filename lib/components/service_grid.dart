import 'package:flutter/material.dart';
import '../theme.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "எப்படி உதவலாம்?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.brandDark,
          ),
        ),
        const Text(
          "HOW CAN WE HELP TODAY?",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppTheme.brandSlate,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        
        // Bento Grid Layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column (Tall Card)
            Expanded(
              child: _buildServiceCard(
                title: "மின் விளக்குகள்",
                subtitle: "LIGHT FIXTURES",
                icon: Icons.lightbulb,
                color: Colors.amber,
                height: 220, // Tall
                titleSize: 15,
                iconSize: 32,
                isTall: true,
              ),
            ),
            const SizedBox(width: 12),
            // Right Column (Two Stacked Cards)
            Expanded(
              child: Column(
                children: [
                   _buildServiceCard(
                    title: "கைவினைஞர்",
                    subtitle: "HANDYMAN",
                    icon: Icons.handyman,
                    color: Colors.blue,
                    height: 104,
                  ),
                  const SizedBox(height: 12),
                   _buildServiceCard(
                    title: "இடம் மாற்றம்",
                    subtitle: "MOVING",
                    icon: Icons.local_shipping,
                    color: Colors.orange,
                    height: 104,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Bottom Row
        Row(
          children: [
            Expanded(
              child: _buildSmallCard(
                title: "விளக்குகள்",
                subtitle: "HOLIDAY",
                icon: Icons.celebration,
                color: Colors.teal,
              ),
            ),
             const SizedBox(width: 12),
             Expanded(
              child: _buildSmallCard(
                title: "அலாரங்கள்",
                subtitle: "DETECTORS",
                icon: Icons.sensors, // detector_smoke not standard, using sensors
                color: Colors.pink, // rose
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required MaterialColor color,
    required double height,
    double titleSize = 14,
    double iconSize = 24,
    bool isTall = false,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade50),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Container(
                width: isTall ? 56 : 48,
                height: isTall ? 56 : 48,
                decoration: BoxDecoration(
                  color: color.shade500, // tailwind default shade
                  borderRadius: BorderRadius.circular(isTall ? 16 : 12),
                  boxShadow: [
                     BoxShadow(
                      color: color.shade100,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: iconSize),
              ),
              if (isTall) const Spacer(),
              if (!isTall) const SizedBox(height: 12),
              
              Text(
                title,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandDark,
                  height: 1.2,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.brandSlate,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallCard({
     required String title,
    required String subtitle,
    required IconData icon,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
         boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
         border: Border.all(color: Colors.grey.shade50),
      ),
      child: Row(
        children: [
           Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.shade500,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                title,
                style: const TextStyle( // 12px
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandDark,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle( // 8px
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandSlate,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
