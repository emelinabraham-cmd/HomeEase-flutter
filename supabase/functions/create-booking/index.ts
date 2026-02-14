// =====================================================
// HomeEase Edge Function: create-booking
// Production-Ready Booking Creation
// =====================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.4'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface BookingRequest {
  service_id: string
  booking_date: string
  booking_time: string
  address: string
  notes?: string
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Initialize Supabase client
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    // Get authenticated user
    const {
      data: { user },
      error: userError,
    } = await supabaseClient.auth.getUser()

    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized', message: 'User not authenticated' }),
        {
          status: 401,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Parse request body
    const body: BookingRequest = await req.json()

    // Validate required fields
    if (!body.service_id || !body.booking_date || !body.booking_time || !body.address) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Missing required fields: service_id, booking_date, booking_time, address',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Validate date format (YYYY-MM-DD)
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/
    if (!dateRegex.test(body.booking_date)) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Invalid date format. Use YYYY-MM-DD',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Validate time format (HH:MM)
    const timeRegex = /^([01]\d|2[0-3]):([0-5]\d)$/
    if (!timeRegex.test(body.booking_time)) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Invalid time format. Use HH:MM (24-hour format)',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Check if booking date is in the future
    const bookingDate = new Date(body.booking_date)
    const today = new Date()
    today.setHours(0, 0, 0, 0)

    if (bookingDate < today) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Booking date must be today or in the future',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Verify service exists and is active
    const { data: service, error: serviceError } = await supabaseClient
      .from('services')
      .select('id, name, price, is_active')
      .eq('id', body.service_id)
      .single()

    if (serviceError || !service) {
      return new Response(
        JSON.stringify({
          error: 'Service Not Found',
          message: 'The requested service does not exist',
        }),
        {
          status: 404,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    if (!service.is_active) {
      return new Response(
        JSON.stringify({
          error: 'Service Unavailable',
          message: 'The requested service is currently not available',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Create booking
    const { data: booking, error: bookingError } = await supabaseClient
      .from('bookings')
      .insert({
        user_id: user.id,
        service_id: body.service_id,
        booking_date: body.booking_date,
        booking_time: body.booking_time,
        address: body.address,
        notes: body.notes || null,
        status: 'pending',
        payment_status: 'pending',
      })
      .select('*, services(name, price)')
      .single()

    if (bookingError) {
      console.error('Booking creation error:', bookingError)
      return new Response(
        JSON.stringify({
          error: 'Booking Failed',
          message: 'Failed to create booking. Please try again.',
        }),
        {
          status: 500,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Return success response
    return new Response(
      JSON.stringify({
        success: true,
        message: 'Booking created successfully',
        booking,
      }),
      {
        status: 201,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  } catch (error) {
    console.error('Unexpected error:', error)
    return new Response(
      JSON.stringify({
        error: 'Internal Server Error',
        message: 'An unexpected error occurred',
      }),
      {
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      }
    )
  }
})
