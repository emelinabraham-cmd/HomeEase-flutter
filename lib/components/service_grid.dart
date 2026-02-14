import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../theme.dart';
import '../models/service_model.dart';

class ServiceGrid extends StatefulWidget {
  final Function(Service) onServiceSelected;
  const ServiceGrid({super.key, required this.onServiceSelected});

  @override
  State<ServiceGrid> createState() => _ServiceGridState();
}

class _ServiceGridState extends State<ServiceGrid> {
  String? _selectedId;

  void _handleTap(Service service) {
    setState(() {
      _selectedId = service.id;
    });
    widget.onServiceSelected(service);
  }

  @override
  Widget build(BuildContext context) {
    final services = Service.allServices;

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
        const SizedBox(height: 16),

        StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            for (int i = 0; i < services.length; i++)
              StaggeredGridTile.count(
                crossAxisCellCount: 1,
                mainAxisCellCount: 1.15,
                child: _buildServiceCard(services[i], false),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildServiceCard(Service service, bool isTall) {
    final isSelected = _selectedId == service.id;

    return GestureDetector(
      onTap: () => _handleTap(service),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? service.color.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? service.color : Colors.grey.shade50,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.08 : 0.03),
              blurRadius: isSelected ? 15 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: service.color.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                service.icon,
                color: service.color.shade600,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  service.tamilName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.brandDark,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  service.name,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.brandSlate,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "Starting from ₹${service.price}",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.brandDark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
