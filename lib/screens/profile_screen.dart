import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/user_model.dart';
import 'edit_screens.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const ProfileScreen({super.key, this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final user = userStore.user;
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              _buildProfileHeader(user),
              const SizedBox(height: 32),
              _buildProfileDetails(context, user),
              const SizedBox(height: 32),
              _buildActivitySection(context),
              const SizedBox(height: 32),
              _buildActionButtons(context),
              const SizedBox(height: 48),
              _buildFooter(),
              const SizedBox(height: 120), // Bottom nav padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCircleButton(Icons.chevron_left_rounded, widget.onBack),
          Column(
            children: [
              Text(
                "சுயவிவரம்",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandDark,
                ),
              ),
              Text(
                "PROFILE SETTINGS",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.brandSlate,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(width: 40), // Balance
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: AppTheme.brandSlateDark, size: 20),
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuD09Mg3vepGG2fSdRJJLrnvXUEOzWulppEFjONMYqZANu0ki_knVa3SqpjJWsjaIzFKiaJ0DPDPsCJ5uNM3SouJqanOCNOE9a2gshg_Mxlvf-pxpBWR3Xt5LpeBa4sGqL6HWG27iYBRcD3ICREd698YA4Cnpg1N7rls54yKcQ-SO2rmCCzr0hbCuvzgiQYniycgf9sDxdbe9IN3XW8kKUeL6hac8cmmfnTmjF26CV7twg13T2uKEbzznU6fXA0-TK6XiIBwwRCv3wt4",
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  size: 16,
                  color: AppTheme.brandSlateDark,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
            ],
          ),
          child: const Text(
            "ID: TN-POLL-8821",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.brandSlateDark,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileDetails(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildInfoCard(
            icon: Icons.person_outline_rounded,
            title: user.firstName,
            subtitle: user.lastName,
            label: "FULL NAME",
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black12,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditNameScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.phone_outlined,
            title: user.phone,
            label: "VERIFIED NUMBER",
            trailing: const Icon(
              Icons.verified_rounded,
              color: Colors.green,
              size: 18,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditPhoneScreen()),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.location_on_outlined,
            title: user.village,
            subtitle: "Pollachi",
            label: "VILLAGE / TOWN",
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black12,
            ),
            onTap: () {}, // Optional: Add EditLocationScreen later
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.credit_card_rounded,
            title: user.billingAddress.isEmpty
                ? "Not set"
                : user.billingAddress,
            subtitle: user.billingCity,
            label: "BILLING INFO",
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.black12,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditBillingScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required String label,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.grey.shade400, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.brandDark,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          "|",
                          style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.black26,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              "ACTIVITY & SUPPORT",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Colors.black26,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _buildGridCard(
                  icon: Icons.history_rounded,
                  title: "பதிவு வரலாறு",
                  subtitle: "BOOKINGS",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGridCard(
                  icon: Icons.contact_support_outlined,
                  title: "உதவி மையம்",
                  subtitle: "SUPPORT",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.grey.shade400, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.brandDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.black26,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.forestGreen,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.forestGreen.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "சேமிக்கவும் / SAVE PROFILE",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.logout_rounded,
              size: 20,
              color: Colors.black45,
            ),
            label: const Text(
              "வெளியேறு / Logout",
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return const Column(
      children: [
        Text(
          "MADE WITH ❤️ FOR TAMIL NADU",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.black12,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
