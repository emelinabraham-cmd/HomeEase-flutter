-- =====================================================
-- HomeEase Seed Data
-- Sample data for development and testing
-- =====================================================

-- =====================================================
-- SAMPLE SERVICES
-- =====================================================

INSERT INTO public.services (id, name, category, price, description, image_url, is_active) VALUES
(
    uuid_generate_v4(),
    'Handyman Services',
    'Home Repair',
    199.00,
    'Professional handyman services for various home repairs and maintenance tasks. Includes minor electrical, plumbing, and carpentry work.',
    'https://images.unsplash.com/photo-1581578731548-c64695cc6952',
    true
),
(
    uuid_generate_v4(),
    'Moving Services',
    'Transportation',
    499.00,
    'Complete moving and relocation services. Safe and reliable transportation of your belongings with trained professionals.',
    'https://images.unsplash.com/photo-1600518464441-9154a4dea21b',
    true
),
(
    uuid_generate_v4(),
    'Light Fixtures Installation',
    'Electrical',
    149.00,
    'Expert installation of light fixtures, ceiling fans, and other electrical fittings. Safety certified electricians.',
    'https://images.unsplash.com/photo-1513694203232-719a280e022f',
    true
),
(
    uuid_generate_v4(),
    'Picture Hanging',
    'Home Decor',
    199.00,
    'Professional picture and artwork hanging service. Perfect alignment and secure mounting guaranteed.',
    'https://images.unsplash.com/photo-1582037928769-181f2644ecb7',
    true
),
(
    uuid_generate_v4(),
    'Drain Cleaning',
    'Plumbing',
    249.00,
    'Professional drain cleaning and unclogging services. Fast and effective solutions for all drainage issues.',
    'https://images.unsplash.com/photo-1607472586893-edb57bdc0e39',
    true
),
(
    uuid_generate_v4(),
    'Furniture Assembly',
    'Assembly',
    399.00,
    'Expert furniture assembly service for all types of furniture. Save time and avoid the hassle.',
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
    true
),
(
    uuid_generate_v4(),
    'Hauling Service',
    'Transportation',
    349.00,
    'Efficient hauling service for junk removal, furniture disposal, and large item transportation.',
    'https://images.unsplash.com/photo-1527192491265-7e15c55b1ed2',
    true
),
(
    uuid_generate_v4(),
    'TV Wall Mount Installation',
    'Installation',
    299.00,
    'Professional TV wall mounting service. Includes cable management and setup assistance.',
    'https://images.unsplash.com/photo-1593784991095-a205069470b6',
    true
),
(
    uuid_generate_v4(),
    'Gutter Cleaning',
    'Maintenance',
    249.00,
    'Comprehensive gutter cleaning service to prevent water damage and maintain proper drainage.',
    'https://images.unsplash.com/photo-1585421514738-01798e348b17',
    true
),
(
    uuid_generate_v4(),
    'Smoke & CO Detector Installation',
    'Safety',
    149.00,
    'Installation and testing of smoke alarms and carbon monoxide detectors for home safety.',
    'https://images.unsplash.com/photo-1558618666-fcd25c85cd64',
    true
)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- SAMPLE ADMIN USER
-- Note: This requires manual creation via Supabase Auth
-- After creating auth user, run this to set admin role:
-- =====================================================

-- Example: Update existing user to admin (replace with actual UUID)
-- UPDATE public.profiles 
-- SET role = 'admin' 
-- WHERE phone = '+919876543210';

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON TABLE public.services IS 'Seeded with 10 sample home services for development';
