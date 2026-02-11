import 'package:flutter/material.dart';
import '../theme.dart';

class ServiceHeader extends StatelessWidget {
  const ServiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "வணக்கம், அருண்",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.brandDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "VANAKKAM, ARUN",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppTheme.brandSlateDark,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
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
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage("https://lh3.googleusercontent.com/aida-public/AB6AXuD09Mg3vepGG2fSdRJJLrnvXUEOzWulppEFjONMYqZANu0ki_knVa3SqpjJWsjaIzFKiaJ0DPDPsCJ5uNM3SouJqanOCNOE9a2gshg_Mxlvf-pxpBWR3Xt5LpeBa4sGqL6HWG27iYBRcD3ICREd698YA4Cnpg1N7rls54yKcQ-SO2rmCCzr0hbCuvzgiQYniycgf9sDxdbe9IN3XW8kKUeL6hac8cmmfnTmjF26CV7twg13T2uKEbzznU6fXA0-TK6XiIBwwRCv3wt4"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
