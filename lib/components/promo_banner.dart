import 'package:flutter/material.dart';
import '../theme.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFFDF8F2),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Mesh Gradients
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFEEF8F4), // hsla(158, 41%, 95%, 1) approx
                    const Color(0xFFEEF8F4).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFDF5ED), // hsla(38, 77%, 96%, 1) approx
                    const Color(0xFFFDF5ED).withOpacity(0),
                  ],
                ),
              ),
            ),
          ),
          
          // Decor Icon
          Positioned(
             right: -8,
             top: -8,
             child: Transform.rotate(
               angle: 0.2,
               child: Icon(
                 Icons.auto_awesome,
                 size: 80,
                 color: AppTheme.primary.withOpacity(0.1),
               ),
             ),
          ),
          
           // Blur circle
          Positioned(
            right: -16,
            bottom: -16,
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    "LIMITED OFFER",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "20% தள்ளுபடி!",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppTheme.brandDark,
                    fontSize: 18,
                    height: 1.1,
                  ),
                ),
                const Text(
                  "20% OFF on First Booking",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.brandSlate,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: AppTheme.primary.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                  child: const Text("BOOK NOW"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
