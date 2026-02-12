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
      id: "light_fixtures",
      name: "LIGHT FIXTURES",
      tamilName: "மின் விளக்குகள்",
      price: 199,
      icon: Icons.lightbulb,
      color: Colors.amber,
    ),
    Service(
      id: "handyman",
      name: "HANDYMAN",
      tamilName: "கைவினைஞர்",
      price: 249,
      icon: Icons.handyman,
      color: Colors.blue,
    ),
    Service(
      id: "moving",
      name: "MOVING",
      tamilName: "இடம் மாற்றம்",
      price: 499,
      icon: Icons.local_shipping,
      color: Colors.orange,
    ),
    Service(
      id: "holiday",
      name: "HOLIDAY",
      tamilName: "விளக்குகள்",
      price: 299,
      icon: Icons.celebration,
      color: Colors.teal,
    ),
    Service(
      id: "detectors",
      name: "DETECTORS",
      tamilName: "அலாரங்கள்",
      price: 149,
      icon: Icons.sensors,
      color: Colors.pink,
    ),
    Service(
      id: "hanging",
      name: "HANGING",
      tamilName: "மாட்டுதல்",
      price: 129,
      icon: Icons.wallpaper,
      color: Colors.indigo,
    ),
    Service(
      id: "hauling",
      name: "HAULING",
      tamilName: "இழுத்துச் செல்லுதல்",
      price: 399,
      icon: Icons.local_shipping,
      color: Colors.deepOrange,
    ),
    Service(
      id: "furniture_assembly",
      name: "FURNITURE ASSEMBLY",
      tamilName: "தளவாடங்கள் பொருத்துதல்",
      price: 299,
      icon: Icons.chair,
      color: Colors.brown,
    ),
    Service(
      id: "tv_wall_mount",
      name: "TV WALL MOUNT",
      tamilName: "டிவி பொருத்துதல்",
      price: 199,
      icon: Icons.tv,
      color: Colors.purple,
    ),
    Service(
      id: "gutter_cleaning",
      name: "GUTTER CLEANING",
      tamilName: "வடிகால் சுத்தம்",
      price: 249,
      icon: Icons.water_drop,
      color: Colors.cyan,
    ),
  ];
}
