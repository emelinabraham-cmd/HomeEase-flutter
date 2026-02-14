// =====================================================
// HomeEase Flutter + Supabase Integration Examples
// Production-Ready Code Snippets
// =====================================================

// IMPORTANT: Add this to your pubspec.yaml dependencies:
// supabase_flutter: ^2.5.0

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

// =====================================================
// EXAMPLE 1: PHONE OTP LOGIN SCREEN
// =====================================================

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;

  Future<void> _sendOTP() async {
    setState(() => _loading = true);
    try {
      await AuthService.sendOTP(_phoneController.text);
      setState(() => _otpSent = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to ${_phoneController.text}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _verifyOTP() async {
    setState(() => _loading = true);
    try {
      await AuthService.verifyOTP(_phoneController.text, _otpController.text);
      // Navigate to home screen
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login with Phone')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_otpSent) ...[
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+919876543210',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _sendOTP,
                child: _loading
                    ? CircularProgressIndicator()
                    : Text('Send OTP'),
              ),
            ] else ...[
              Text('OTP sent to ${_phoneController.text}'),
              SizedBox(height: 20),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'Enter OTP',
                  prefixIcon: Icon(Icons.lock),
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _verifyOTP,
                child: _loading
                    ? CircularProgressIndicator()
                    : Text('Verify & Login'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// =====================================================
// EXAMPLE 2: FETCH AND DISPLAY SERVICES
// =====================================================

class ServicesListScreen extends StatefulWidget {
  @override
  _ServicesListScreenState createState() => _ServicesListScreenState();
}

class _ServicesListScreenState extends State<ServicesListScreen> {
  List<Map<String, dynamic>> _services = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final services = await ServiceCatalog.getActiveServices();
      setState(() {
        _services = services;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading services: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Home Services')),
      body: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return ListTile(
            leading: service['image_url'] != null
                ? Image.network(service['image_url'], width: 50, height: 50)
                : Icon(Icons.home_repair_service),
            title: Text(service['name']),
            subtitle: Text('${service['category']} - ₹${service['price']}'),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => _bookService(service),
          );
        },
      ),
    );
  }

  void _bookService(Map<String, dynamic> service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingScreen(service: service),
      ),
    );
  }
}

// =====================================================
// EXAMPLE 3: CREATE BOOKING
// =====================================================

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> service;

  BookingScreen({required this.service});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  bool _loading = false;

  Future<void> _createBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter address')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final booking = await BookingService.createBooking(
        serviceId: widget.service['id'],
        bookingDate:
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
        bookingTime:
            '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
        address: _addressController.text,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Booking created successfully!'),
            backgroundColor: Colors.green),
      );

      // Navigate to bookings screen
      Navigator.of(context).pushReplacementNamed('/bookings');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book ${widget.service['name']}')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(widget.service['name'],
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text('₹${widget.service['price']}',
                        style: Theme.of(context).textTheme.titleLarge),
                    if (widget.service['description'] != null)
                      Text(widget.service['description']),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text('Select Date'),
              subtitle: Text(_selectedDate != null
                  ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                  : 'Not selected'),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
            ListTile(
              title: Text('Select Time'),
              subtitle: Text(_selectedTime != null
                  ? '${_selectedTime!.format(context)}'
                  : 'Not selected'),
              trailing: Icon(Icons.access_time),
              onTap: _selectTime,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Service Address',
                hintText: 'Enter full address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Additional Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _loading ? null : _createBooking,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _loading
                  ? CircularProgressIndicator()
                  : Text('Confirm Booking', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================
// EXAMPLE 4: FETCH USER BOOKINGS
// =====================================================

class MyBookingsScreen extends StatefulWidget {
  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final bookings = await BookingService.getUserBookings();
      setState(() {
        _bookings = bookings;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading bookings: $e')),
      );
    }
  }

  Future<void> _cancelBooking(String bookingId) async {
    try {
      await BookingService.cancelBooking(bookingId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking cancelled'), backgroundColor: Colors.green),
      );
      _fetchBookings(); // Refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cancellation failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: Text('My Bookings')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_bookings.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('My Bookings')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_busy, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No bookings yet'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/services'),
                child: Text('Book a Service'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('My Bookings')),
      body: RefreshIndicator(
        onRefresh: _fetchBookings,
        child: ListView.builder(
          itemCount: _bookings.length,
          itemBuilder: (context, index) {
            final booking = _bookings[index];
            final service = booking['services'];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text(service['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${booking['booking_date']}'),
                    Text('Time: ${booking['booking_time']}'),
                    Text('Address: ${booking['address']}'),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(booking['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        booking['status'].toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (booking['status'] == 'pending') {
                    _showCancelDialog(booking['id']);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCancelDialog(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Booking'),
        content: Text('Are you sure you want to cancel this booking?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _cancelBooking(bookingId);
            },
            child: Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// EXAMPLE 5: UPDATE PROFILE
// =====================================================

class ProfileEditScreen extends StatefulWidget {
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameController = TextEditingController();
  final _villageController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await ProfileService.getProfile();
      if (profile != null) {
        _nameController.text = profile['name'] ?? '';
        _villageController.text = profile['village'] ?? '';
        _cityController.text = profile['city'] ?? '';
        _addressController.text = profile['address'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _loading = true);
    try {
      await ProfileService.updateProfile(
        name: _nameController.text,
        village: _villageController.text,
        city: _cityController.text,
        address: _addressController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated!'), backgroundColor: Colors.green),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _villageController,
              decoration: InputDecoration(
                labelText: 'Village',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Full Address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _loading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: _loading
                  ? CircularProgressIndicator()
                  : Text('Save Profile', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
