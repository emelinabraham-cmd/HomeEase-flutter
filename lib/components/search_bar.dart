import 'package:flutter/material.dart';
import '../theme.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(
            Icons.search,
            color: AppTheme.brandSlate,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "தேடல் (Search services...)",
                hintStyle: TextStyle(
                  color: AppTheme.brandSlate.withOpacity(0.6),
                  fontSize: 15,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(
                color: AppTheme.brandDark,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
