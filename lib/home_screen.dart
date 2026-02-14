import 'package:flutter/material.dart';
import 'package:my_app/components/category_chips.dart';
import 'package:my_app/components/promo_banner.dart';
import 'package:my_app/components/search_bar.dart';
import 'package:my_app/components/service_grid.dart';
import 'package:my_app/components/service_header.dart';
import 'models/service_model.dart';
import 'models/user_model.dart';

class HomeScreen extends StatefulWidget {
  final Function(Service) onServiceSelected;
  final VoidCallback? onProfileSelected;
  const HomeScreen({
    super.key,
    required this.onServiceSelected,
    this.onProfileSelected,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userStore = UserStore();

  @override
  void initState() {
    super.initState();
    userStore.addListener(_handleUpdate);
  }

  @override
  void dispose() {
    userStore.removeListener(_handleUpdate);
    super.dispose();
  }

  void _handleUpdate() {
    if (mounted) setState(() {});
  }

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
            ServiceHeader(
              onProfileSelected: widget.onProfileSelected,
              userName: userStore.user.firstName,
            ),
            const CustomSearchBar(),
            const SizedBox(height: 24),
            const CategoryChips(),
            const SizedBox(height: 24),
            const PromoBanner(),
            const SizedBox(height: 24),
            ServiceGrid(onServiceSelected: widget.onServiceSelected),
          ],
        ),
      ),
    );
  }
}
