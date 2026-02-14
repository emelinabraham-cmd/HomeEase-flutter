// =====================================================
// HomeEase Supabase Service
// Production-Ready Flutter Integration
// =====================================================

import 'package:supabase_flutter/supabase_flutter.dart';

/// Initialize Supabase client
/// Call this in main() before runApp()
Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
}

/// Get Supabase client instance
final supabase = Supabase.instance.client;

// =====================================================
// AUTHENTICATION SERVICES
// =====================================================

/// Login with Phone OTP
/// Step 1: Send OTP to phone number
class AuthService {
  /// Send OTP to phone number
  static Future<void> sendOTP(String phoneNumber) async {
    try {
      await supabase.auth.signInWithOtp(
        phone: phoneNumber,
        shouldCreateUser: true,
      );
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  /// Verify OTP and login
  static Future<AuthResponse> verifyOTP(
      String phoneNumber, String otp) async {
    try {
      final response = await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: otp,
        type: OtpType.sms,
      );
      return response;
    } catch (e) {
      throw Exception('OTP verification failed: ${e.toString()}');
    }
  }

  /// Sign out current user
  static Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  /// Get current user
  static User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    return supabase.auth.currentUser != null;
  }

  /// Listen to auth state changes
  static Stream<AuthState> authStateChanges() {
    return supabase.auth.onAuthStateChange;
  }
}

// =====================================================
// PROFILE SERVICES
// =====================================================

class ProfileService {
  /// Get user profile
  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to fetch profile: ${e.toString()}');
    }
  }

  /// Update user profile
  static Future<void> updateProfile({
    String? name,
    String? village,
    String? city,
    String? address,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (village != null) updates['village'] = village;
      if (city != null) updates['city'] = city;
      if (address != null) updates['address'] = address;

      await supabase.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      throw Exception('Failed to update profile: ${e.toString()}');
    }
  }
}

// =====================================================
// SERVICES (HOME SERVICES)
// =====================================================

class ServiceCatalog {
  /// Fetch all active services
  static Future<List<Map<String, dynamic>>> getActiveServices() async {
    try {
      final response = await supabase
          .from('services')
          .select()
          .eq('is_active', true)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch services: ${e.toString()}');
    }
  }

  /// Fetch service by ID
  static Future<Map<String, dynamic>?> getServiceById(String serviceId) async {
    try {
      final response = await supabase
          .from('services')
          .select()
          .eq('id', serviceId)
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to fetch service: ${e.toString()}');
    }
  }

  /// Search services by name or category
  static Future<List<Map<String, dynamic>>> searchServices(
      String query) async {
    try {
      final response = await supabase
          .from('services')
          .select()
          .or('name.ilike.%$query%,category.ilike.%$query%')
          .eq('is_active', true)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to search services: ${e.toString()}');
    }
  }
}

// =====================================================
// BOOKING SERVICES
// =====================================================

class BookingService {
  /// Create a new booking
  static Future<Map<String, dynamic>> createBooking({
    required String serviceId,
    required String bookingDate, // Format: YYYY-MM-DD
    required String bookingTime, // Format: HH:MM
    required String address,
    String? notes,
  }) async {
    try {
      final response = await supabase.functions.invoke(
        'create-booking',
        body: {
          'service_id': serviceId,
          'booking_date': bookingDate,
          'booking_time': bookingTime,
          'address': address,
          if (notes != null) 'notes': notes,
        },
      );

      if (response.status != 201) {
        throw Exception(
            response.data['message'] ?? 'Failed to create booking');
      }

      return response.data['booking'];
    } catch (e) {
      throw Exception('Booking creation failed: ${e.toString()}');
    }
  }

  /// Get user's bookings
  static Future<List<Map<String, dynamic>>> getUserBookings() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final response = await supabase
          .from('bookings')
          .select('*, services(name, price, category)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch bookings: ${e.toString()}');
    }
  }

  /// Get booking by ID
  static Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    try {
      final response = await supabase
          .from('bookings')
          .select('*, services(name, price, category)')
          .eq('id', bookingId)
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to fetch booking: ${e.toString()}');
    }
  }

  /// Cancel a booking
  static Future<void> cancelBooking(String bookingId,
      {String? reason}) async {
    try {
      final response = await supabase.functions.invoke(
        'cancel-booking',
        body: {
          'booking_id': bookingId,
          if (reason != null) 'cancellation_reason': reason,
        },
      );

      if (response.status != 200) {
        throw Exception(
            response.data['message'] ?? 'Failed to cancel booking');
      }
    } catch (e) {
      throw Exception('Booking cancellation failed: ${e.toString()}');
    }
  }

  /// Get bookings by status
  static Future<List<Map<String, dynamic>>> getBookingsByStatus(
      String status) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final response = await supabase
          .from('bookings')
          .select('*, services(name, price, category)')
          .eq('user_id', userId)
          .eq('status', status)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch bookings: ${e.toString()}');
    }
  }
}

// =====================================================
// SUPPORT SERVICES
// =====================================================

class SupportService {
  /// Create a support message/ticket
  static Future<Map<String, dynamic>> createSupportMessage({
    required String message,
    String? subject,
  }) async {
    try {
      final response = await supabase.functions.invoke(
        'create-support-message',
        body: {
          'message': message,
          if (subject != null) 'subject': subject,
        },
      );

      if (response.status != 201) {
        throw Exception(
            response.data['message'] ?? 'Failed to create support message');
      }

      return response.data['support_message'];
    } catch (e) {
      throw Exception('Failed to create support message: ${e.toString()}');
    }
  }

  /// Get user's support messages
  static Future<List<Map<String, dynamic>>> getUserSupportMessages() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final response = await supabase
          .from('support_messages')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch support messages: ${e.toString()}');
    }
  }
}

// =====================================================
// STORAGE SERVICES
// =====================================================

class StorageService {
  /// Upload profile image
  static Future<String> uploadProfileImage(String filePath) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage
          .from('profile-images')
          .upload(fileName, filePath);

      final url = supabase.storage
          .from('profile-images')
          .getPublicUrl(fileName);

      return url;
    } catch (e) {
      throw Exception('Failed to upload profile image: ${e.toString()}');
    }
  }

  /// Get service image URL
  static String getServiceImageUrl(String imagePath) {
    return supabase.storage.from('service-images').getPublicUrl(imagePath);
  }
}

// =====================================================
// REALTIME SUBSCRIPTIONS
// =====================================================

class RealtimeService {
  /// Subscribe to booking updates
  static RealtimeChannel subscribeToBookings(
      Function(Map<String, dynamic>) onUpdate) {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    return supabase
        .channel('bookings:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'bookings',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onUpdate(payload.newRecord);
          },
        )
        .subscribe();
  }

  /// Subscribe to support message updates
  static RealtimeChannel subscribeToSupportMessages(
      Function(Map<String, dynamic>) onUpdate) {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    return supabase
        .channel('support:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'support_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onUpdate(payload.newRecord);
          },
        )
        .subscribe();
  }
}
