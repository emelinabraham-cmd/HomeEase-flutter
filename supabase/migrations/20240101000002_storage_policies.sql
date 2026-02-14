-- =====================================================
-- HomeEase Storage Buckets and Policies
-- Production-Ready File Storage
-- =====================================================

-- =====================================================
-- CREATE STORAGE BUCKETS
-- =====================================================

-- Service images bucket (public read)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'service-images',
    'service-images',
    true,
    5242880, -- 5MB limit
    ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- Profile images bucket (private)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'profile-images',
    'profile-images',
    false,
    2097152, -- 2MB limit
    ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO NOTHING;

-- =====================================================
-- SERVICE IMAGES POLICIES (PUBLIC READ)
-- =====================================================

-- Anyone can view service images
CREATE POLICY "Public can view service images"
    ON storage.objects
    FOR SELECT
    USING (bucket_id = 'service-images');

-- Only admins can upload service images
CREATE POLICY "Admins can upload service images"
    ON storage.objects
    FOR INSERT
    WITH CHECK (
        bucket_id = 'service-images'
        AND EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Only admins can update service images
CREATE POLICY "Admins can update service images"
    ON storage.objects
    FOR UPDATE
    USING (
        bucket_id = 'service-images'
        AND EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Only admins can delete service images
CREATE POLICY "Admins can delete service images"
    ON storage.objects
    FOR DELETE
    USING (
        bucket_id = 'service-images'
        AND EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- PROFILE IMAGES POLICIES (PRIVATE)
-- =====================================================

-- Users can view their own profile images
CREATE POLICY "Users can view own profile images"
    ON storage.objects
    FOR SELECT
    USING (
        bucket_id = 'profile-images'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- Users can upload their own profile images
CREATE POLICY "Users can upload own profile images"
    ON storage.objects
    FOR INSERT
    WITH CHECK (
        bucket_id = 'profile-images'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- Users can update their own profile images
CREATE POLICY "Users can update own profile images"
    ON storage.objects
    FOR UPDATE
    USING (
        bucket_id = 'profile-images'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- Users can delete their own profile images
CREATE POLICY "Users can delete own profile images"
    ON storage.objects
    FOR DELETE
    USING (
        bucket_id = 'profile-images'
        AND (storage.foldername(name))[1] = auth.uid()::text
    );

-- Admins can view all profile images
CREATE POLICY "Admins can view all profile images"
    ON storage.objects
    FOR SELECT
    USING (
        bucket_id = 'profile-images'
        AND EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON POLICY "Public can view service images" ON storage.objects IS 'Allow public read access to service images';
COMMENT ON POLICY "Users can view own profile images" ON storage.objects IS 'Allow users to view only their profile images';
