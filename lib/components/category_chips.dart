import 'package:flutter/material.dart';
import '../theme.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _buildChip(
            label: "EMERGENCY",
            isEmergency: true,
          ),
          const SizedBox(width: 8),
          _buildChip(label: "PLUMBING"),
          const SizedBox(width: 8),
          _buildChip(label: "AC REPAIR"),
          const SizedBox(width: 8),
          _buildChip(label: "CLEANING"),
        ],
      ),
    );
  }

  Widget _buildChip({required String label, bool isEmergency = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isEmergency ? const Color(0xFFFFF1F2) : Colors.white, // rose-50 vs white
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isEmergency ? const Color(0xFFFFE4E6) : const Color(0xFFE2E8F0), // rose-100 vs slate-200
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isEmergency) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFFF43F5E), // rose-500
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isEmergency ? const Color(0xFFBE123C) : AppTheme.brandSlate, // rose-700 vs brandSlate
            ),
          ),
        ],
      ),
    );
  }
}
