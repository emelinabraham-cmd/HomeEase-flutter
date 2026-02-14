# 🏠 HomeEase - Complete Supabase Backend Documentation

> **Production-ready backend for a home services booking platform built with Flutter and Supabase**

---

## 📋 Quick Navigation

- [Overview](#overview)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [API Documentation](#api-documentation)
- [Security](#security)
- [Deployment](#deployment)
- [Additional Resources](#additional-resources)

---

## Overview

HomeEase is a complete home services booking platform with a production-ready Supabase backend. Users can browse services, book appointments, manage their profile, and contact support - all backed by a secure, scalable infrastructure.

### ✨ Features

**User Features:**
- 📱 Phone OTP Authentication
- 🔍 Browse home services
- 📅 Book services with date/time selection
- 📋 View booking history
- 👤 Manage profile
- 💬 Contact support

**Admin Features:**
- ➕ Create/manage services
- 📊 View all bookings
- 👥 User management
- 💬 Reply to support messages
- 📈 Access analytics

**Future Features:**
- 💳 Razorpay payment integration
- 🔔 Push notifications
- ⭐ Service ratings
- 💬 Real-time chat

---

## Architecture

### Tech Stack

**Backend:**
- 🗄️ **Supabase**: PostgreSQL database, Authentication, Storage, Edge Functions
- 🔐 **Row Level Security**: Policy-based access control
- ⚡ **Edge Functions**: Serverless TypeScript/Deno functions
- 📦 **Storage**: Public and private file storage

**Frontend:**
- 📱 **Flutter**: Cross-platform mobile app
- 🎨 **Material Design**: Modern UI components

### Database Schema

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  profiles   │────▶│  bookings   │────▶│  payments   │
└─────────────┘     └─────────────┘     └─────────────┘
      │                    │
      │                    ▼
      │             ┌─────────────┐
      └────────────▶│  services   │
                    └─────────────┘
      │
      ▼
┌──────────────────┐
│ support_messages │
└──────────────────┘
```

#### Tables

1. **profiles**
   - User information and role management
   - Roles: `user`, `admin`, `provider`
   - Auto-created on signup via trigger

2. **services**
   - Catalog of home services
   - Includes pricing, description, images
   - Admin-managed

3. **bookings**
   - Service booking records
   - Tracks status: `pending`, `confirmed`, `completed`, `cancelled`
   - Links users to services

4. **payments**
   - Payment transaction records
   - Razorpay integration ready
   - Status: `pending`, `success`, `failed`, `refunded`

5. **support_messages**
   - Customer support tickets
   - Admin replies tracked
   - Status: `open`, `in_progress`, `resolved`, `closed`

---

## Getting Started

### Prerequisites

- ✅ Supabase account
- ✅ Flutter SDK (3.10.8+)
- ✅ Supabase CLI
- ✅ Deno (for Edge Functions)

### Installation

#### 1. Clone Repository

```bash
git clone https://github.com/emelinabraham-cmd/HomeEase-flutter.git
cd HomeEase-flutter
```

#### 2. Set Up Supabase

```bash
# Login to Supabase
supabase login

# Link to your project
supabase link --project-ref YOUR_PROJECT_REF

# Apply migrations
supabase db push

# Seed sample data
supabase db execute < supabase/seed.sql
```

#### 3. Deploy Edge Functions

```bash
supabase functions deploy create-booking
supabase functions deploy cancel-booking
supabase functions deploy create-support-message
supabase functions deploy admin-create-service
```

#### 4. Configure Flutter

Update `lib/services/supabase_service.dart`:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

#### 5. Run Flutter App

```bash
flutter pub get
flutter run
```

---

## API Documentation

### Authentication

#### Send OTP

```dart
await AuthService.sendOTP('+919876543210');
```

#### Verify OTP

```dart
await AuthService.verifyOTP('+919876543210', '123456');
```

### Services

#### Get All Services

```dart
final services = await ServiceCatalog.getActiveServices();
```

#### Search Services

```dart
final results = await ServiceCatalog.searchServices('plumbing');
```

### Bookings

#### Create Booking

```dart
final booking = await BookingService.createBooking(
  serviceId: 'uuid',
  bookingDate: '2024-12-25',
  bookingTime: '10:00',
  address: '123 Main St',
  notes: 'Optional notes',
);
```

#### Get User Bookings

```dart
final bookings = await BookingService.getUserBookings();
```

#### Cancel Booking

```dart
await BookingService.cancelBooking('booking-id', reason: 'Changed plans');
```

### Profile

#### Get Profile

```dart
final profile = await ProfileService.getProfile();
```

#### Update Profile

```dart
await ProfileService.updateProfile(
  name: 'John Doe',
  village: 'Village Name',
  city: 'City',
  address: 'Full Address',
);
```

### Support

#### Create Support Message

```dart
final ticket = await SupportService.createSupportMessage(
  message: 'Need help with booking',
  subject: 'Booking Issue',
);
```

---

## Security

### Row Level Security (RLS)

All tables have RLS enabled. Policies ensure:

✅ Users can only access their own data  
✅ Admins have elevated privileges  
✅ Public read access to active services  
✅ Secure storage bucket policies  

### Edge Function Security

✅ JWT-based authentication  
✅ Input validation  
✅ Error handling  
✅ CORS headers configured  

### Best Practices

- 🔐 Never expose service role key in client apps
- 🔑 Anon key is safe to use in mobile apps
- 👤 RLS policies handle authorization
- 📝 All inputs validated before database operations
- 🚨 Error messages don't leak sensitive data

---

## Deployment

### Production Checklist

#### Database
- [x] All migrations applied
- [x] RLS enabled on all tables
- [x] Indexes created for performance
- [x] Sample data seeded
- [ ] Backup strategy configured

#### Edge Functions
- [x] All functions deployed
- [x] CORS configured
- [x] Error handling implemented
- [ ] Environment variables set

#### Authentication
- [ ] Phone auth provider configured (Twilio/MessageBird)
- [ ] Admin user created
- [ ] Test OTP flow

#### Storage
- [x] Buckets created
- [x] Policies configured
- [ ] Upload test files

#### Monitoring
- [ ] Enable point-in-time recovery
- [ ] Set up alerts
- [ ] Configure logging

### Scaling Considerations

**0-1K Users:** Free tier sufficient  
**1K-10K Users:** Pro plan recommended  
**10K+ Users:** Enterprise with dedicated resources  

**Edge Functions:** Auto-scale with demand  
**Storage:** Unlimited (pay per GB)  
**Database:** Connection pooling auto-enabled  

---

## Additional Resources

### Documentation Files

- 📘 **[SUPABASE_SETUP.md](./SUPABASE_SETUP.md)**: Complete setup and deployment guide
- 👨‍💼 **[ADMIN_GUIDE.md](./ADMIN_GUIDE.md)**: Admin operations and management
- 📂 **[supabase/README.md](./supabase/README.md)**: Backend structure reference
- 💻 **[lib/examples/flutter_supabase_examples.dart](./lib/examples/flutter_supabase_examples.dart)**: Flutter code examples

### External Links

- 🌐 [Supabase Documentation](https://supabase.com/docs)
- 📱 [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- 💬 [Supabase Discord](https://discord.supabase.com)

### File Structure

```
HomeEase-flutter/
├── lib/
│   ├── services/
│   │   └── supabase_service.dart        # Main integration
│   ├── examples/
│   │   └── flutter_supabase_examples.dart  # Usage examples
│   ├── models/
│   ├── screens/
│   └── components/
├── supabase/
│   ├── migrations/
│   │   ├── 20240101000000_initial_schema.sql
│   │   ├── 20240101000001_rls_policies.sql
│   │   └── 20240101000002_storage_policies.sql
│   ├── functions/
│   │   ├── create-booking/
│   │   ├── cancel-booking/
│   │   ├── create-support-message/
│   │   └── admin-create-service/
│   ├── seed.sql
│   └── README.md
├── SUPABASE_SETUP.md
├── ADMIN_GUIDE.md
└── BACKEND_README.md  # This file
```

---

## Troubleshooting

### Common Issues

**Issue:** RLS blocking queries  
**Solution:** Ensure user is authenticated and check policy rules

**Issue:** Edge Function timeout  
**Solution:** Optimize queries, add indexes

**Issue:** Storage upload fails  
**Solution:** Check file size limits and bucket policies

**Issue:** Migration conflicts  
**Solution:** Use `supabase db reset` (local only)

### Support

- 📧 Email: support@homeease.com
- 💬 Discord: Supabase Community
- 🐛 Issues: GitHub Issues

---

## Contributing

### Development Workflow

1. Create feature branch
2. Make changes
3. Test locally
4. Create pull request
5. Deploy to staging
6. Deploy to production

### Code Standards

- ✅ Use TypeScript for Edge Functions
- ✅ Follow Flutter/Dart style guide
- ✅ Add comments for complex logic
- ✅ Write tests for critical paths

---

## License

This project is proprietary software for HomeEase.

---

## Roadmap

### Phase 1 (Complete) ✅
- Database schema
- RLS policies
- Edge Functions
- Flutter integration
- Documentation

### Phase 2 (In Progress) 🚧
- [ ] Razorpay payment integration
- [ ] Push notifications
- [ ] Real-time features
- [ ] Service ratings

### Phase 3 (Planned) 📋
- [ ] Provider mobile app
- [ ] Admin web dashboard
- [ ] Advanced analytics
- [ ] AI-powered recommendations

---

## Credits

**Backend Architecture:** Supabase  
**Mobile Framework:** Flutter  
**Developer:** HomeEase Team  

---

**🚀 Your production-ready backend is complete and ready to scale!**

For questions or support, refer to the documentation links above.
