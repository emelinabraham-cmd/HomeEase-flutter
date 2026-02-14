import 'package:flutter/material.dart';

class Service {
  final String id;
  final String name;
  final String tamilName;
  final int price;
  final IconData icon;
  final MaterialColor color;
  final String duration;

  const Service({
    required this.id,
    required this.name,
    required this.tamilName,
    required this.price,
    required this.icon,
    required this.color,
    this.duration = "1 hr",
  });

  static const List<Service> allServices = [
    Service(
      id: "handyman",
      name: "HANDYMAN",
      tamilName: "கைவினைஞர்",
      price: 199,
      icon: Icons.handyman_rounded,
      color: Colors.blue,
    ),
    Service(
      id: "moving",
      name: "MOVING",
      tamilName: "இடம் மாற்றம்",
      price: 499,
      icon: Icons.local_shipping_rounded,
      color: Colors.orange,
    ),
    Service(
      id: "light_fixtures",
      name: "LIGHT FIXTURES",
      tamilName: "மின் விளக்குகள்",
      price: 149,
      icon: Icons.lightbulb_outline_rounded,
      color: Colors.amber,
    ),
    Service(
      id: "hanging",
      name: "HANGING",
      tamilName: "மாட்டுதல்",
      price: 199,
      icon: Icons.grid_view_rounded,
      color: Colors.indigo,
    ),
    Service(
      id: "cleaning",
      name: "CLEANING",
      tamilName: "வடிகால் சுத்தம்",
      price: 249,
      icon: Icons.water_drop_rounded,
      color: Colors.cyan,
    ),
    Service(
      id: "assembly",
      name: "ASSEMBLY",
      tamilName: "தளவாடங்கள்",
      price: 399,
      icon: Icons.weekend_rounded,
      color: Colors.green,
    ),
    Service(
      id: "hauling",
      name: "HAULING",
      tamilName: "இழுத்துச் செல்லுதல்",
      price: 349,
      icon: Icons.local_shipping_rounded,
      color: Colors.deepOrange,
    ),
    Service(
      id: "tv_wall_mount",
      name: "TV WALL MOUNT",
      tamilName: "டிவி பொருத்துதல்",
      price: 299,
      icon: Icons.tv_rounded,
      color: Colors.purple,
    ),
    Service(
      id: "gutter_cleaning",
      name: "GUTTER CLEANING",
      tamilName: "வடிகால் சுத்தம்",
      price: 249,
      icon: Icons.water_drop_rounded,
      color: Colors.teal,
    ),
    Service(
      id: "detectors",
      name: "DETECTORS",
      tamilName: "அலாரங்கள்",
      price: 149,
      icon: Icons.sensors_rounded,
      color: Colors.pink,
    ),
  ];
}
