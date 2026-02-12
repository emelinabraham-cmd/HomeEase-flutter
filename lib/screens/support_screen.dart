import 'package:flutter/material.dart';
import '../theme.dart';

class SupportScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const SupportScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.warmBackground,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 60), // Status bar padding
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      _buildConnectCard(),
                      const SizedBox(height: 32),
                      _buildSupportOptions(),
                      const SizedBox(height: 32),
                      _buildContactForm(),
                      const SizedBox(height: 32),
                      _buildMapPreview(),
                      const SizedBox(height: 140), // Space for button
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildSendButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: AppTheme.supportOrange,
                  ),
                ),
              ),
              const Expanded(
                child: Text(
                  "Support / உதவி மையம்",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.brandDark,
                  ),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.supportOrange.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuAFiUBW1mfI4hxdCPH9NdjmHwCCrw88nlZdZL54HCMOazc__gxSoDvgP22Ip6yV0aRnYvCraR0J-9jFgmFVb0a6LFO75tqpjwgjsvXLeM4Y4SSP_sILTLcHeSJlrmFmAbVK2J0reGum3uoY2Jk4DE3pIHxan3_QkuCjbYRh5LT8rWyGSGGgzCicvePlzMFyyQVrEhUKU6atxgLZOfbdhebtFKi2H20bzqtiQwm7L4uoCpOYQdh1WjDcKEth9vyXD-bofh0mgy8k9Lzt",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "We are here to help / உங்கள் உதவிக்காக நாங்கள் இருக்கிறோம்",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.supportOrange.withOpacity(0.1),
            AppTheme.supportOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Connect with our team",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.supportOrange,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Our local experts are ready to assist you anytime.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 4,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuD2sx65CIdsL1Hn2Lfs_Z6v-s9akgnfVlXJvSGXGxubbO6Naq-dWKybxvgHRnor5DyjlLvlSTW3Klg0OZc0SntLV8zzfAPUonQJ5Ma7-TOYioKowqLhLVyUNd6qmdbvMkmvFO5C6Yxe7UgZSeSNVnCnUh4G757qdIdqXnpY-6akxclbx5wl4q5Sujc5sCqMI_zikRbCXXWkUe10xt3hGaQv7t0rfpSYKaSOPxzqqMxCOAKD9-XkoXnb-0oeKyCG1g0aXKN95D4UUucQ",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildOptionCard(
            Icons.phone_in_talk,
            "Call Us",
            bgColor: AppTheme.supportOrange.withOpacity(0.1),
            iconColor: AppTheme.supportOrange,
          ),
          _buildOptionCard(
            Icons.chat,
            "WhatsApp",
            bgColor: Colors.green.shade50,
            iconColor: Colors.green.shade600,
          ),
          _buildOptionCard(
            Icons.help_outline,
            "FAQ",
            bgColor: AppTheme.supportOrange.withOpacity(0.1),
            iconColor: AppTheme.supportOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(
    IconData icon,
    String label, {
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      width: 110,
      height: 110,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: AppTheme.supportOrange.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.brandDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Email / மின்னஞ்சல்"),
        const SizedBox(height: 8),
        _buildTextField("Enter your email", maxLines: 1),
        const SizedBox(height: 24),
        _buildLabel("Message / செய்தி"),
        const SizedBox(height: 8),
        _buildTextField("Tell us how we can help...", maxLines: 5),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {required int maxLines}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withOpacity(0.8),
        borderRadius: BorderRadius.circular(maxLines == 1 ? 99 : 24),
      ),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildMapPreview() {
    return Column(
      children: [
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            image: const DecorationImage(
              image: NetworkImage(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuAhf7pURCx8IObtrFZr1Kd2QJSPYOc7tkh_Kp_PpUH2hO-l3zyRi7hG7W05qKF3MVk-JaJ38ANYKrBZNPMsHtU7Mz8Gl-NuJ8xcgqQv1E3Xz9ACC8hXUEPAcP5nc7p-7DlCQFslFtQY0DenydTI3GNk34YeE0DYFkop5HLH74f7hTKXaknJllpOHSuxCTiVwUN-23BKHjtlpOnYfliiNm6tDk72UOmBI-lnBVWDGPKsDRagDZkeLjPXB1LgET0rIOLp8zwtUZP9UbFg",
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppTheme.supportOrange,
                BlendMode.overlay,
              ),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Head Office: Madurai",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.supportOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Positioned(
      bottom: 110,
      left: 24,
      right: 24,
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.brandDark,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(32),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "Send Message / செய்தியை அனுப்பவும்",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.send, color: Colors.white, size: 18),
                SizedBox(width: 16), // Extra padding for the icon side
              ],
            ),
          ),
        ),
      ),
    );
  }
}
