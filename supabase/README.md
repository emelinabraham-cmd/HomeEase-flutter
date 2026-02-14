# Supabase Backend Configuration

This document provides a quick reference for the complete Supabase backend structure.

## 📁 File Structure

```
supabase/
├── migrations/                                    # Database migrations
│   ├── 20240101000000_initial_schema.sql         # Tables, indexes, triggers
│   ├── 20240101000001_rls_policies.sql           # Row Level Security
│   └── 20240101000002_storage_policies.sql       # Storage buckets & policies
├── functions/                                     # Edge Functions
│   ├── create-booking/index.ts                   # Create booking
│   ├── cancel-booking/index.ts                   # Cancel booking
│   ├── create-support-message/index.ts           # Support ticket
│   └── admin-create-service/index.ts             # Admin: Create service
└── seed.sql                                       # Sample data

lib/
├── services/
│   └── supabase_service.dart                     # Flutter integration
└── examples/
    └── flutter_supabase_examples.dart            # Usage examples
```

## 🗄️ Database Schema

### Tables

1. **profiles**
   - User profiles with role-based access (user, admin, provider)
   - Auto-created on signup via trigger

2. **services**
   - Home services catalog
   - Only admins can create/update

3. **bookings**
   - Service bookings
   - Users can only see their own bookings

4. **payments**
   - Payment tracking (Razorpay ready)
   - Linked to bookings

5. **support_messages**
   - Customer support tickets
   - Users create, admins reply

### Storage Buckets

1. **service-images** (Public)
   - Service images visible to all
   - Only admins can upload

2. **profile-images** (Private)
   - User profile images
   - Users can only access their own

## 🔐 Security (RLS)

All tables have Row Level Security enabled with these policies:

### Profiles
- ✅ Users: Read/write own profile
- ✅ Admins: Read/write all profiles

### Services
- ✅ Public: Read active services
- ✅ Admins: Full CRUD access

### Bookings
- ✅ Users: CRUD own bookings
- ✅ Admins: Read/update all bookings
- ✅ Providers: Read assigned bookings

### Payments
- ✅ Users: Read/create for own bookings
- ✅ Admins: Full access

### Support Messages
- ✅ Users: Create/read own messages
- ✅ Admins: Read/update all messages

## ⚡ Edge Functions

### 1. create-booking
**POST** `/functions/v1/create-booking`

Creates a new service booking.

**Request:**
```json
{
  "service_id": "uuid",
  "booking_date": "YYYY-MM-DD",
  "booking_time": "HH:MM",
  "address": "Full address",
  "notes": "Optional notes"
}
```

### 2. cancel-booking
**POST** `/functions/v1/cancel-booking`

Cancels an existing booking.

**Request:**
```json
{
  "booking_id": "uuid",
  "cancellation_reason": "Optional reason"
}
```

### 3. create-support-message
**POST** `/functions/v1/create-support-message`

Creates a support ticket.

**Request:**
```json
{
  "message": "Support message content",
  "subject": "Optional subject"
}
```

### 4. admin-create-service
**POST** `/functions/v1/admin-create-service`

Admin-only: Creates a new service.

**Request:**
```json
{
  "name": "Service name",
  "category": "Category",
  "price": 199.00,
  "description": "Optional description",
  "image_url": "Optional image URL",
  "is_active": true
}
```

## 🎯 User Roles

### user (default)
- Browse services
- Create bookings
- Manage own profile
- Contact support

### admin
- All user permissions
- Create/update services
- View all bookings
- Reply to support messages
- Access analytics

### provider (future)
- View assigned bookings
- Update booking status
- Communicate with customers

## 🚀 Quick Start

### 1. Set Up Supabase
```bash
supabase login
supabase link --project-ref your-project-ref
supabase db push
```

### 2. Deploy Edge Functions
```bash
supabase functions deploy create-booking
supabase functions deploy cancel-booking
supabase functions deploy create-support-message
supabase functions deploy admin-create-service
```

### 3. Configure Flutter
```dart
// In lib/services/supabase_service.dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### 4. Test
```dart
// Check examples in:
// lib/examples/flutter_supabase_examples.dart
```

## 📝 Environment Variables

For Edge Functions, set via Supabase CLI:
```bash
supabase secrets set TWILIO_API_KEY=your-key
supabase secrets set RAZORPAY_KEY=your-key
```

## 📚 Documentation

- Full setup guide: `SUPABASE_SETUP.md`
- Flutter examples: `lib/examples/flutter_supabase_examples.dart`
- Supabase Docs: https://supabase.com/docs

## 🔧 Troubleshooting

### RLS Blocking Queries?
Check if user is authenticated:
```dart
final user = supabase.auth.currentUser;
print('User ID: ${user?.id}');
```

### Edge Function Errors?
Check logs:
```bash
supabase functions logs create-booking
```

### Migration Issues?
Reset local DB:
```bash
supabase db reset
```

## 🎓 Next Steps

1. ✅ Configure phone auth provider (Twilio)
2. ✅ Create admin user
3. ✅ Seed production services
4. ✅ Deploy to production
5. ✅ Set up monitoring
6. ✅ Integrate Razorpay payments

---

**Backend Status:** ✅ Production Ready

For detailed deployment instructions, see `SUPABASE_SETUP.md`.
