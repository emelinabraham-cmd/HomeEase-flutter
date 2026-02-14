// =====================================================
// HomeEase Edge Function: cancel-booking
// Production-Ready Booking Cancellation
// =====================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.4'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface CancelBookingRequest {
  booking_id: string
  cancellation_reason?: string
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
    const body: CancelBookingRequest = await req.json()

    // Validate required fields
    if (!body.booking_id) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Missing required field: booking_id',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Get booking to verify ownership and status
    const { data: booking, error: fetchError } = await supabaseClient
      .from('bookings')
      .select('id, user_id, status, booking_date, booking_time')
      .eq('id', body.booking_id)
      .single()

    if (fetchError || !booking) {
      return new Response(
        JSON.stringify({
          error: 'Booking Not Found',
          message: 'The requested booking does not exist',
        }),
        {
          status: 404,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Verify booking belongs to the user
    if (booking.user_id !== user.id) {
      return new Response(
        JSON.stringify({
          error: 'Forbidden',
          message: 'You can only cancel your own bookings',
        }),
        {
          status: 403,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Check if booking is already cancelled or completed
    if (booking.status === 'cancelled') {
      return new Response(
        JSON.stringify({
          error: 'Already Cancelled',
          message: 'This booking has already been cancelled',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    if (booking.status === 'completed') {
      return new Response(
        JSON.stringify({
          error: 'Cannot Cancel',
          message: 'Completed bookings cannot be cancelled',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Update booking status to cancelled
    const updateData: any = {
      status: 'cancelled',
    }

    // Add cancellation reason to notes if provided
    if (body.cancellation_reason) {
      updateData.notes = `Cancellation reason: ${body.cancellation_reason}`
    }

    const { data: updatedBooking, error: updateError } = await supabaseClient
      .from('bookings')
      .update(updateData)
      .eq('id', body.booking_id)
      .select('*, services(name)')
      .single()

    if (updateError) {
      console.error('Booking cancellation error:', updateError)
      return new Response(
        JSON.stringify({
          error: 'Cancellation Failed',
          message: 'Failed to cancel booking. Please try again.',
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
        message: 'Booking cancelled successfully',
        booking: updatedBooking,
      }),
      {
        status: 200,
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
