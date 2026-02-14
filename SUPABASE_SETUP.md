# HomeEase Supabase Backend - Complete Setup Guide

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Project Structure](#project-structure)
3. [Initial Setup](#initial-setup)
4. [Database Migration](#database-migration)
5. [Edge Functions Deployment](#edge-functions-deployment)
6. [Flutter Integration](#flutter-integration)
7. [Admin Setup](#admin-setup)
8. [Testing](#testing)
9. [Production Deployment](#production-deployment)

---

## Prerequisites

Before you begin, ensure you have:

- ✅ Supabase account (https://supabase.com)
- ✅ Supabase CLI installed (`npm install -g supabase`)
- ✅ Flutter SDK installed (3.10.8 or higher)
- ✅ Deno installed (for Edge Functions local testing)

---

## Project Structure

```
supabase/
├── migrations/
│   ├── 20240101000000_initial_schema.sql     # Database schema
│   ├── 20240101000001_rls_policies.sql       # Row Level Security
│   └── 20240101000002_storage_policies.sql   # Storage buckets
├── functions/
│   ├── create-booking/
│   │   └── index.ts
│   ├── cancel-booking/
│   │   └── index.ts
│   ├── create-support-message/
│   │   └── index.ts
│   └── admin-create-service/
│       └── index.ts
└── seed.sql                                   # Sample data

lib/services/
└── supabase_service.dart                      # Flutter integration
```

---

## Initial Setup

### 1. Create Supabase Project

1. Go to https://supabase.com/dashboard
2. Click "New Project"
3. Fill in:
   - **Name**: HomeEase
   - **Database Password**: (save this securely)
   - **Region**: Choose closest to your users
4. Wait for project to be ready (2-3 minutes)

### 2. Get Project Credentials

From your Supabase Dashboard:

1. Go to **Settings** → **API**
2. Copy these values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **Anon/Public Key** (starts with `eyJ...`)

### 3. Link Local Project

```bash
# Login to Supabase CLI
supabase login

# Link to your project
supabase link --project-ref your-project-ref

# Project ref can be found in Project Settings → General
```

---

## Database Migration

### Apply Schema and Policies

```bash
# Navigate to your project root
cd /path/to/HomeEase-flutter

# Run all migrations in order
supabase db push

# OR apply migrations one by one:
supabase db execute < supabase/migrations/20240101000000_initial_schema.sql
supabase db execute < supabase/migrations/20240101000001_rls_policies.sql
supabase db execute < supabase/migrations/20240101000002_storage_policies.sql

# Seed sample data
supabase db execute < supabase/seed.sql
```

### Verify Database

1. Go to **Table Editor** in Supabase Dashboard
2. You should see:
   - profiles
   - services
   - bookings
   - payments
   - support_messages
3. Check **Storage** → You should see:
   - service-images (public)
   - profile-images (private)

---

## Edge Functions Deployment

### Deploy All Functions

```bash
# Deploy create-booking function
supabase functions deploy create-booking

# Deploy cancel-booking function
supabase functions deploy cancel-booking

# Deploy create-support-message function
supabase functions deploy create-support-message

# Deploy admin-create-service function
supabase functions deploy admin-create-service
```

### Set Environment Variables

If your functions need additional env variables:

```bash
# Set environment variables
supabase secrets set SOME_API_KEY=your-key
```

### Test Functions Locally

```bash
# Start local Supabase
supabase start

# Test a function locally
supabase functions serve create-booking --env-file .env.local

# Test with curl
curl -i --location --request POST 'http://localhost:54321/functions/v1/create-booking' \
  --header 'Authorization: Bearer YOUR_ANON_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"service_id":"xxx","booking_date":"2024-12-25","booking_time":"10:00","address":"123 Main St"}'
```

---

## Flutter Integration

### 1. Install Dependencies

```bash
cd /path/to/HomeEase-flutter
flutter pub get
```

### 2. Configure Supabase

Update `lib/services/supabase_service.dart`:

```dart
Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',          // From Step 2 above
    anonKey: 'YOUR_SUPABASE_ANON_KEY', // From Step 2 above
  );
}
```

### 3. Initialize in main.dart

```dart
import 'package:flutter/material.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await initializeSupabase();
  
  runApp(MyApp());
}
```

### 4. Usage Examples

#### Login with Phone OTP

```dart
// Send OTP
await AuthService.sendOTP('+919876543210');

// Verify OTP
await AuthService.verifyOTP('+919876543210', '123456');
```

#### Fetch Services

```dart
final services = await ServiceCatalog.getActiveServices();
```

#### Create Booking

```dart
final booking = await BookingService.createBooking(
  serviceId: 'service-uuid',
  bookingDate: '2024-12-25',
  bookingTime: '10:00',
  address: '123 Main St, City',
  notes: 'Please call before arriving',
);
```

#### Fetch User Bookings

```dart
final bookings = await BookingService.getUserBookings();
```

#### Update Profile

```dart
await ProfileService.updateProfile(
  name: 'John Doe',
  village: 'Village Name',
  city: 'City Name',
  address: 'Full Address',
);
```

---

## Admin Setup

### 1. Enable Phone Auth

1. Go to **Authentication** → **Providers**
2. Enable **Phone**
3. Configure Twilio or another SMS provider
   - For testing, you can use test phone numbers in Supabase

### 2. Create Admin User

#### Option A: Via Supabase Dashboard

1. Go to **Authentication** → **Users**
2. Click **Add user** → **Create new user**
3. Enter phone number: `+919876543210`
4. User will be created

#### Option B: Via SQL

```sql
-- After user signs up via app, promote to admin:
UPDATE public.profiles 
SET role = 'admin' 
WHERE phone = '+919876543210';
```

### 3. Create Provider Users

```sql
UPDATE public.profiles 
SET role = 'provider' 
WHERE phone = '+919123456789';
```

---

## Testing

### Test Authentication

```bash
# Use Supabase Test Helpers
curl -X POST 'https://your-project.supabase.co/auth/v1/otp' \
  -H "apikey: YOUR_ANON_KEY" \
  -H "Content-Type: application/json" \
  -d '{"phone": "+919876543210"}'
```

### Test Edge Functions

```bash
# Test create-booking (need auth token)
curl -X POST 'https://your-project.supabase.co/functions/v1/create-booking' \
  -H "Authorization: Bearer YOUR_USER_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "service_id": "uuid",
    "booking_date": "2024-12-25",
    "booking_time": "10:00",
    "address": "123 Main St"
  }'
```

### Test RLS Policies

```sql
-- Test as user
SET request.jwt.claims.sub = 'user-uuid';
SELECT * FROM bookings; -- Should only see own bookings
```

---

## Production Deployment

### 1. Security Checklist

- ✅ All RLS policies enabled
- ✅ Anon key is safe to expose in mobile apps
- ✅ Service role key kept secret (never in client)
- ✅ Edge Functions use proper auth validation
- ✅ Storage policies properly configured

### 2. Performance Optimization

```sql
-- Ensure all indexes are created (already in migration)
-- Monitor slow queries in Supabase Dashboard → Database → Query Performance
```

### 3. Backup Strategy

```bash
# Enable point-in-time recovery (PITR)
# Go to Settings → Database → Enable Point in Time Recovery
```

### 4. Monitoring

1. **Supabase Dashboard** → **Reports**
   - Monitor API usage
   - Track database performance
   - Check Edge Function logs

2. **Set up alerts** for:
   - High error rates
   - Slow queries
   - Database space

### 5. Environment Variables

For production Flutter app:

```dart
// Use environment-specific configuration
const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
```

Build with:

```bash
flutter build apk --dart-define=SUPABASE_URL=your-url --dart-define=SUPABASE_ANON_KEY=your-key
```

---

## Scaling Considerations

### Database

- **Current Plan**: Suitable for 0-10K users
- **Scale Up**: Upgrade to Pro plan for unlimited API requests
- **Connection Pooling**: Automatically handled by Supabase

### Edge Functions

- **Auto-scaling**: Functions scale automatically
- **Cold starts**: ~100-500ms for first request
- **Keep-alive**: Add health check endpoint if needed

### Storage

- **Image Optimization**: Use Supabase Image Transformations
  ```dart
  final url = supabase.storage
      .from('service-images')
      .getPublicUrl('image.jpg', transform: TransformOptions(
        width: 400,
        height: 300,
        resize: ResizeMode.cover,
      ));
  ```

---

## Troubleshooting

### Migration Errors

```bash
# Check migration status
supabase migration list

# Reset local database (destructive)
supabase db reset
```

### Edge Function Errors

```bash
# View function logs
supabase functions logs create-booking

# Check for CORS issues
# Ensure corsHeaders are properly set in functions
```

### RLS Policy Issues

```sql
-- Test policies as specific user
SELECT * FROM public.check_auth_policies('user-uuid');

-- Temporarily disable RLS for debugging (NOT IN PRODUCTION)
ALTER TABLE bookings DISABLE ROW LEVEL SECURITY;
```

---

## Support

- **Supabase Docs**: https://supabase.com/docs
- **Supabase Discord**: https://discord.supabase.com
- **Flutter Supabase**: https://supabase.com/docs/reference/dart

---

## Next Steps

1. ✅ Complete Razorpay payment integration
2. ✅ Add push notifications (Firebase Cloud Messaging)
3. ✅ Create admin dashboard (Flutter Web or React)
4. ✅ Add provider app functionality
5. ✅ Implement real-time chat support
6. ✅ Add service ratings and reviews

---

**Your production-ready Supabase backend is now complete! 🚀**
