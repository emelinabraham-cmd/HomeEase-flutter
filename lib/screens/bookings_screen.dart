import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/service_model.dart';

class BookingsScreen extends StatefulWidget {
  final Service? service;
  final VoidCallback? onBack;
  const BookingsScreen({super.key, this.service, this.onBack});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 1;

  @override
  Widget build(BuildContext context) {
    // Fallback if no service is selected
    final displayService =
        widget.service ??
        Service.allServices.firstWhere((s) => s.id == "handyman");

    final serviceColor = _getServiceThemeColor(displayService.name);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
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
                      _buildServiceInfoCard(displayService),
                      const SizedBox(height: 32),
                      _buildDateSelection(serviceColor),
                      const SizedBox(height: 32),
                      _buildTimeSlots(serviceColor),
                      const SizedBox(height: 16),
                      _buildAddressCard(),
                      const SizedBox(height: 32),
                      _buildPriceSummary(displayService),
                      const SizedBox(height: 180), // Space for buttons
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildBottomAction(context, serviceColor),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: widget.onBack,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppTheme.brandSlate,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                "BOOKING DETAILS",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: Colors.grey.shade400,
                ),
              ),
              const Text(
                "Book Service",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.brandDark,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                "https://lh3.googleusercontent.com/aida-public/AB6AXuC7blLF1EL3phFT_3WTHMIPmCCWZ1Lg9jQsDa8_0tVesAIYAXeHMijUcEcOiNNJpNPbp5d9ufix5P1QC6hjrKtXycsK6dIPxX27P3O5zSW3QclhmpqwaAuOv_0ZTaiqMxxM4HU8U7Lr7oRtCmCluB9oWqmuZi0x7BL4UIytA6-VPhjtCB4UB46YfTAx-fokRTvYgpWdqrYlvlOyecciCDqx4w9Gz0rYtSRwK4bYr1xA1YN6E6y2V8CZH2YzU5TbQ1YFziVNHWWKeosp",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfoCard(Service service) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: service.color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: service.color.withOpacity(0.1)),
            ),
            child: Icon(service.icon, color: service.color, size: 36),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.brandDark,
                  ),
                ),
                Text(
                  service.tamilName,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade400,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "₹${service.price}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.forestGreen,
                      ),
                    ),
                    Text(
                      "/${service.duration == '1 hr' ? 'hr' : service.duration}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.scaffoldBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "Min ${service.duration}",
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.brandSlate,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection(Color serviceColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Date",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.brandDark,
                  ),
                ),
                Text(
                  "தேதியைத் தேர்வு செய்யவும்",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.brandSlate,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.forestGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "October 2024",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.forestGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildDateCard(0, "Today", "23", serviceColor),
              _buildDateCard(1, "Thu", "24", serviceColor),
              _buildDateCard(2, "Fri", "25", serviceColor),
              _buildDateCard(3, "Sat", "26", serviceColor),
              _buildDateCard(4, "Sun", "27", serviceColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateCard(
    int index,
    String day,
    String date,
    Color serviceColor,
  ) {
    final isSelected = _selectedDateIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedDateIndex = index),
      child: Container(
        width: 76,
        height: 96,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isSelected ? serviceColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: Colors.grey.shade100),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: serviceColor.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isSelected
                    ? Colors.white.withOpacity(0.7)
                    : Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: isSelected ? Colors.white : AppTheme.brandDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots(Color serviceColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Slots",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.brandDark,
          ),
        ),
        const Text(
          "நேரத்தைத் தேர்வு செய்யவும்",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppTheme.brandSlate,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final times = [
              "09:00 AM",
              "10:30 AM",
              "12:00 PM",
              "02:30 PM",
              "04:00 PM",
              "05:30 PM",
            ];
            return _buildSlotCard(index, times[index], serviceColor);
          },
        ),
      ],
    );
  }

  Widget _buildSlotCard(int index, String time, Color serviceColor) {
    final isSelected = _selectedTimeIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? serviceColor : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? serviceColor : Colors.grey.shade100,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: serviceColor.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Service Address",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.brandDark,
                  ),
                ),
                Text(
                  "சேவை முகவரி",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.brandSlate,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.forestGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Add New",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.forestGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuDKdXinWPcMB8Vb7ZlGjuyHZc1j6BQfWRnojJOd9SRaI0LFz4jMvajXMSjYymUO4ULA-oyfomWUetlM5V_YwGSOcSb1_E82SGKn_lM0JIaoQjl_dbsKXXhmbhS124cKxeaEi8dqviBlW0h2kXMGwpeFQu4lEVRKXcJLyuksRJSaCnudMmN4nxrMsQ-i10_U90PjZbBzflVs1pjNUbZnilSrLWxsgQar8R-O61PUHl0hhBKpEEsDBLi6IbXX0ERnX4MLQAlDsrLeRmsh",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Home (Primary)",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.brandDark,
                      ),
                    ),
                    Text(
                      "12/B, Anna Nagar, Salem, Tamil Nadu...",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.brandSlate,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummary(Service service) {
    const visitingCharge = 50.0;
    final discount = (service.price + visitingCharge) * 0.2;
    final total = (service.price + visitingCharge) - discount;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PRICE SUMMARY",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.0,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          _buildPriceRow("Service Fee", "₹${service.price}.00"),
          const SizedBox(height: 12),
          _buildPriceRow("Visiting Charge", "₹${visitingCharge.toInt()}.00"),
          const SizedBox(height: 12),
          _buildPriceRow(
            "Rural Discount (20%)",
            "-₹${discount.toInt()}.00",
            isDiscount: true,
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.black12),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.brandDark,
                    ),
                  ),
                  Text(
                    "மொத்த தொகை",
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Text(
                "₹${total.toInt()}.00",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.brandDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isDiscount ? FontWeight.w600 : FontWeight.w500,
            color: isDiscount ? AppTheme.forestGreen : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: isDiscount ? AppTheme.forestGreen : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context, Color serviceColor) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.8)),
              child: Container(
                width: double.infinity,
                height: 72,
                decoration: BoxDecoration(
                  color: serviceColor,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: serviceColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.1),
                    width: 4,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "CONFIRM BOOKING",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      "பதிவு உறுதி",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getServiceThemeColor(String serviceName) {
    final name = _normalizeServiceName(serviceName);

    if (name.contains("handyman")) return const Color(0xFF2F80ED);
    if (name.contains("moving")) return const Color(0xFFF2994A);
    if (name.contains("light")) return const Color(0xFFF2C94C);
    if (name.contains("hanging")) return const Color(0xFF5B6EE1);

    // Case-specific check for cleaning to distinguish from gutter cleaning if needed
    if (name == "cleaning") return const Color(0xFF2D9CDB);
    if (name.contains("gutter")) return const Color(0xFF2AA198);

    if (name.contains("assembly")) return const Color(0xFF5E8D6A);
    if (name.contains("tv")) return const Color(0xFF9B51E0);
    if (name.contains("hauling")) return const Color(0xFFEB5757);
    if (name.contains("detector")) return const Color(0xFFFF4D6D);

    return const Color(0xFF1F7A5A); // existing green
  }

  String _normalizeServiceName(String name) {
    return name.toLowerCase().trim();
  }
}
