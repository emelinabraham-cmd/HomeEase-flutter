import 'package:flutter/material.dart';
import 'package:my_app/components/category_chips.dart';
import 'package:my_app/components/promo_banner.dart';
import 'package:my_app/components/search_bar.dart';
import 'package:my_app/components/service_grid.dart';
import 'package:my_app/components/service_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          60,
          24,
          120,
        ), // Bottom padding for nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ServiceHeader(),
            CustomSearchBar(),
            SizedBox(height: 24),
            CategoryChips(),
            SizedBox(height: 24),
            PromoBanner(),
            SizedBox(height: 24),
            ServiceGrid(),
          ],
        ),
      ),
    );
  }
}
