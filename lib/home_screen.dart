import 'package:flutter/material.dart';
import 'package:my_app/components/category_chips.dart';
import 'package:my_app/components/promo_banner.dart';
import 'package:my_app/components/search_bar.dart';
import 'package:my_app/components/service_grid.dart';
import 'package:my_app/components/service_header.dart';
import 'models/service_model.dart';

class HomeScreen extends StatelessWidget {
  final Function(Service) onServiceSelected;
  const HomeScreen({super.key, required this.onServiceSelected});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          24,
          60,
          24,
          120,
        ), // Bottom padding for nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ServiceHeader(),
            const CustomSearchBar(),
            const SizedBox(height: 24),
            const CategoryChips(),
            const SizedBox(height: 24),
            const PromoBanner(),
            const SizedBox(height: 24),
            ServiceGrid(onServiceSelected: onServiceSelected),
          ],
        ),
      ),
    );
  }
}
