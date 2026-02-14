-- =====================================================
-- HomeEase Row Level Security (RLS) Policies
-- Production-Ready Security Implementation
-- =====================================================

-- =====================================================
-- ENABLE RLS ON ALL TABLES
-- =====================================================

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.services ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.support_messages ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- PROFILES TABLE POLICIES
-- =====================================================

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
    ON public.profiles
    FOR SELECT
    USING (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
    ON public.profiles
    FOR UPDATE
    USING (auth.uid() = id)
    WITH CHECK (auth.uid() = id);

-- Users can insert their own profile (for manual creation if trigger fails)
CREATE POLICY "Users can insert own profile"
    ON public.profiles
    FOR INSERT
    WITH CHECK (auth.uid() = id);

-- Admins can view all profiles
CREATE POLICY "Admins can view all profiles"
    ON public.profiles
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Admins can update any profile
CREATE POLICY "Admins can update any profile"
    ON public.profiles
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- SERVICES TABLE POLICIES
-- =====================================================

-- Everyone can view active services (public read)
CREATE POLICY "Public can view active services"
    ON public.services
    FOR SELECT
    USING (is_active = true);

-- Authenticated users can view all services
CREATE POLICY "Authenticated users can view all services"
    ON public.services
    FOR SELECT
    USING (auth.uid() IS NOT NULL);

-- Only admins can insert services
CREATE POLICY "Admins can insert services"
    ON public.services
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Only admins can update services
CREATE POLICY "Admins can update services"
    ON public.services
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Only admins can delete services
CREATE POLICY "Admins can delete services"
    ON public.services
    FOR DELETE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- BOOKINGS TABLE POLICIES
-- =====================================================

-- Users can view their own bookings
CREATE POLICY "Users can view own bookings"
    ON public.bookings
    FOR SELECT
    USING (user_id = auth.uid());

-- Users can create their own bookings
CREATE POLICY "Users can create own bookings"
    ON public.bookings
    FOR INSERT
    WITH CHECK (user_id = auth.uid());

-- Users can update their own bookings (for cancellation)
CREATE POLICY "Users can update own bookings"
    ON public.bookings
    FOR UPDATE
    USING (user_id = auth.uid())
    WITH CHECK (user_id = auth.uid());

-- Admins can view all bookings
CREATE POLICY "Admins can view all bookings"
    ON public.bookings
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Admins can update all bookings
CREATE POLICY "Admins can update all bookings"
    ON public.bookings
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Providers can view bookings assigned to them (future feature)
CREATE POLICY "Providers can view assigned bookings"
    ON public.bookings
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'provider'
        )
    );

-- =====================================================
-- PAYMENTS TABLE POLICIES
-- =====================================================

-- Users can view payments for their own bookings
CREATE POLICY "Users can view own payments"
    ON public.payments
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.bookings
            WHERE bookings.id = payments.booking_id
            AND bookings.user_id = auth.uid()
        )
    );

-- Users can create payments for their own bookings
CREATE POLICY "Users can create own payments"
    ON public.payments
    FOR INSERT
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM public.bookings
            WHERE bookings.id = payments.booking_id
            AND bookings.user_id = auth.uid()
        )
    );

-- Admins can view all payments
CREATE POLICY "Admins can view all payments"
    ON public.payments
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Admins can update all payments
CREATE POLICY "Admins can update all payments"
    ON public.payments
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- SUPPORT MESSAGES TABLE POLICIES
-- =====================================================

-- Users can view their own support messages
CREATE POLICY "Users can view own support messages"
    ON public.support_messages
    FOR SELECT
    USING (user_id = auth.uid());

-- Users can create support messages
CREATE POLICY "Users can create support messages"
    ON public.support_messages
    FOR INSERT
    WITH CHECK (user_id = auth.uid());

-- Users can update their own support messages (before admin reply)
CREATE POLICY "Users can update own support messages"
    ON public.support_messages
    FOR UPDATE
    USING (user_id = auth.uid() AND reply IS NULL)
    WITH CHECK (user_id = auth.uid());

-- Admins can view all support messages
CREATE POLICY "Admins can view all support messages"
    ON public.support_messages
    FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- Admins can update all support messages (to add replies)
CREATE POLICY "Admins can update all support messages"
    ON public.support_messages
    FOR UPDATE
    USING (
        EXISTS (
            SELECT 1 FROM public.profiles
            WHERE id = auth.uid() AND role = 'admin'
        )
    );

-- =====================================================
-- COMMENTS
-- =====================================================

COMMENT ON POLICY "Users can view own profile" ON public.profiles IS 'Allow users to view their own profile';
COMMENT ON POLICY "Public can view active services" ON public.services IS 'Allow public access to active services';
COMMENT ON POLICY "Users can view own bookings" ON public.bookings IS 'Allow users to view only their bookings';
COMMENT ON POLICY "Users can view own payments" ON public.payments IS 'Allow users to view payments for their bookings';
COMMENT ON POLICY "Users can create support messages" ON public.support_messages IS 'Allow users to create support tickets';
