import 'package:flutter/material.dart';

class User {
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String village;
  final String billingAddress;
  final String billingCity;
  final String billingPin;
  final String billingState;

  User({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.village,
    this.billingAddress = "",
    this.billingCity = "",
    this.billingPin = "",
    this.billingState = "",
  });

  String get fullName => "$firstName $lastName";

  User copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? village,
    String? billingAddress,
    String? billingCity,
    String? billingPin,
    String? billingState,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      village: village ?? this.village,
      billingAddress: billingAddress ?? this.billingAddress,
      billingCity: billingCity ?? this.billingCity,
      billingPin: billingPin ?? this.billingPin,
      billingState: billingState ?? this.billingState,
    );
  }
}

class UserStore extends ChangeNotifier {
  static final UserStore _instance = UserStore._internal();
  factory UserStore() => _instance;
  UserStore._internal();

  User _user = User(
    firstName: "அருண்",
    lastName: "குமார்",
    phone: "+91 98765 43210",
    email: "arun.kumar@example.com",
    village: "பொள்ளாச்சி",
  );

  User get user => _user;

  void updateUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
