# Admin Management Guide - HomeEase

This guide covers admin-specific operations for managing the HomeEase platform.

## 🎯 Overview

Admins have full control over:
- Services catalog
- All bookings
- User profiles
- Support messages
- Platform analytics

## 🔐 Creating an Admin User

### Method 1: Via SQL (Recommended for First Admin)

After a user signs up through the app:

```sql
-- Connect to your Supabase SQL Editor
-- Update the user's role to admin
UPDATE public.profiles 
SET role = 'admin' 
WHERE phone = '+919876543210';  -- Replace with actual phone

-- Verify the change
SELECT id, name, phone, role 
FROM public.profiles 
WHERE role = 'admin';
```

### Method 2: Via Supabase Dashboard

1. Go to **Authentication** → **Users**
2. Click on the user you want to make admin
3. Go to **Database** → **Table Editor** → **profiles**
4. Find the user by their UUID (from auth.users)
5. Update `role` column to `'admin'`

### Method 3: Via Edge Function (Future)

Create an Edge Function for promoting users (requires existing admin):

```typescript
// admin-promote-user function
// Only callable by existing admins
```

## 📊 Admin Operations

### 1. Managing Services

#### Create a New Service

**Via Edge Function:**

```bash
curl -X POST 'https://your-project.supabase.co/functions/v1/admin-create-service' \
  -H "Authorization: Bearer ADMIN_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Plumbing Services",
    "category": "Home Repair",
    "price": 299.00,
    "description": "Professional plumbing services including leak repairs, pipe installation, and emergency fixes.",
    "image_url": "https://example.com/plumbing.jpg",
    "is_active": true
  }'
```

**Via SQL:**

```sql
INSERT INTO public.services (name, category, price, description, is_active)
VALUES (
  'Plumbing Services',
  'Home Repair',
  299.00,
  'Professional plumbing services',
  true
);
```

**Via Supabase Dashboard:**

1. Go to **Table Editor** → **services**
2. Click **Insert row**
3. Fill in the details
4. Click **Save**

#### Update Service

```sql
UPDATE public.services
SET 
  price = 349.00,
  description = 'Updated description',
  is_active = true
WHERE id = 'service-uuid';
```

#### Disable Service (Soft Delete)

```sql
UPDATE public.services
SET is_active = false
WHERE id = 'service-uuid';
```

### 2. Managing Bookings

#### View All Bookings

```sql
SELECT 
  b.id,
  b.booking_date,
  b.booking_time,
  b.status,
  p.name as customer_name,
  p.phone as customer_phone,
  s.name as service_name,
  b.address
FROM public.bookings b
JOIN public.profiles p ON b.user_id = p.id
JOIN public.services s ON b.service_id = s.id
ORDER BY b.created_at DESC;
```

#### Update Booking Status

```sql
-- Confirm a booking
UPDATE public.bookings
SET status = 'confirmed'
WHERE id = 'booking-uuid';

-- Mark as completed
UPDATE public.bookings
SET status = 'completed'
WHERE id = 'booking-uuid';
```

#### View Pending Bookings

```sql
SELECT 
  b.id,
  b.booking_date,
  b.booking_time,
  p.name as customer_name,
  s.name as service_name
FROM public.bookings b
JOIN public.profiles p ON b.user_id = p.id
JOIN public.services s ON b.service_id = s.id
WHERE b.status = 'pending'
ORDER BY b.booking_date, b.booking_time;
```

### 3. Managing Support Messages

#### View All Support Messages

```sql
SELECT 
  sm.id,
  sm.message,
  sm.reply,
  sm.status,
  sm.created_at,
  p.name as user_name,
  p.phone as user_phone
FROM public.support_messages sm
JOIN public.profiles p ON sm.user_id = p.id
WHERE sm.status = 'open'
ORDER BY sm.created_at DESC;
```

#### Reply to Support Message

```sql
UPDATE public.support_messages
SET 
  reply = 'Thank you for contacting us. We will resolve your issue shortly.',
  status = 'in_progress'
WHERE id = 'message-uuid';
```

#### Close Support Message

```sql
UPDATE public.support_messages
SET status = 'resolved'
WHERE id = 'message-uuid';
```

### 4. User Management

#### View All Users

```sql
SELECT 
  id,
  name,
  phone,
  village,
  city,
  role,
  created_at
FROM public.profiles
ORDER BY created_at DESC;
```

#### Promote User to Provider

```sql
UPDATE public.profiles
SET role = 'provider'
WHERE phone = '+919123456789';
```

#### View User Booking History

```sql
SELECT 
  b.id,
  b.booking_date,
  b.status,
  s.name as service_name,
  b.created_at
FROM public.bookings b
JOIN public.services s ON b.service_id = s.id
WHERE b.user_id = 'user-uuid'
ORDER BY b.created_at DESC;
```

## 📈 Analytics Queries

### Revenue by Service

```sql
SELECT 
  s.name,
  s.category,
  COUNT(b.id) as total_bookings,
  SUM(s.price) as total_revenue
FROM public.services s
JOIN public.bookings b ON s.id = b.service_id
WHERE b.status = 'completed'
GROUP BY s.id, s.name, s.category
ORDER BY total_revenue DESC;
```

### Daily Bookings

```sql
SELECT 
  booking_date,
  COUNT(*) as total_bookings,
  COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed,
  COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled
FROM public.bookings
WHERE booking_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY booking_date
ORDER BY booking_date DESC;
```

### Active Users

```sql
SELECT 
  COUNT(DISTINCT user_id) as active_users
FROM public.bookings
WHERE created_at >= CURRENT_DATE - INTERVAL '30 days';
```

### Popular Services

```sql
SELECT 
  s.name,
  s.category,
  COUNT(b.id) as booking_count
FROM public.services s
LEFT JOIN public.bookings b ON s.id = b.service_id
GROUP BY s.id, s.name, s.category
ORDER BY booking_count DESC
LIMIT 10;
```

## 🛡️ Security Best Practices

### 1. Admin Access Control

- ✅ Never share admin credentials
- ✅ Use strong, unique passwords
- ✅ Enable 2FA on Supabase account
- ✅ Regularly rotate admin JWT tokens
- ✅ Monitor admin activity logs

### 2. Database Security

```sql
-- Create read-only analyst role (for reports)
CREATE ROLE analyst;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO analyst;
```

### 3. Audit Trail

```sql
-- View recent admin actions (if audit logging enabled)
SELECT 
  created_at,
  table_name,
  operation,
  user_id
FROM audit.logs
WHERE user_id IN (
  SELECT id FROM public.profiles WHERE role = 'admin'
)
ORDER BY created_at DESC
LIMIT 50;
```

## 🚨 Emergency Procedures

### Disable All Bookings

```sql
-- In case of emergency (e.g., maintenance)
UPDATE public.services
SET is_active = false;
```

### Cancel All Pending Bookings

```sql
UPDATE public.bookings
SET 
  status = 'cancelled',
  notes = 'Cancelled due to system maintenance'
WHERE status = 'pending';
```

### Backup Database

```bash
# Using Supabase CLI
supabase db dump -f backup_$(date +%Y%m%d).sql

# Or via Supabase Dashboard
# Settings → Database → Download backup
```

## 📱 Admin Mobile App (Future)

Consider building a Flutter admin app with:

- 📊 Dashboard with analytics
- 📋 Booking management
- 💬 Support chat
- 👥 User management
- 📈 Revenue reports

**Quick Admin Panel in Flutter:**

```dart
// Admin dashboard showing key metrics
class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Dashboard')),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          DashboardCard(
            title: 'Total Bookings',
            value: '1,234',
            icon: Icons.calendar_today,
          ),
          DashboardCard(
            title: 'Active Users',
            value: '456',
            icon: Icons.people,
          ),
          DashboardCard(
            title: 'Revenue',
            value: '₹45,678',
            icon: Icons.attach_money,
          ),
          DashboardCard(
            title: 'Support Tickets',
            value: '23',
            icon: Icons.help,
          ),
        ],
      ),
    );
  }
}
```

## 🔧 Maintenance Tasks

### Weekly

- ✅ Review support messages
- ✅ Check for suspicious activity
- ✅ Monitor booking trends

### Monthly

- ✅ Generate revenue reports
- ✅ Review service performance
- ✅ Update service prices if needed
- ✅ Clean up cancelled bookings (archive)

### Quarterly

- ✅ Database performance optimization
- ✅ Review and update RLS policies
- ✅ Backup audit
- ✅ Security review

## 📞 Support Contacts

- **Technical Issues**: admin@homeease.com
- **Supabase Support**: https://supabase.com/support
- **Emergency Hotline**: +91-XXXX-XXXX

---

**Admin Guide Version:** 1.0.0  
**Last Updated:** 2024-01-01

For technical documentation, see `SUPABASE_SETUP.md`
