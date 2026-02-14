// =====================================================
// HomeEase Edge Function: admin-create-service
// Production-Ready Admin Service Creation
// =====================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.4'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface ServiceRequest {
  name: string
  category: string
  price: number
  description?: string
  image_url?: string
  is_active?: boolean
}

serve(async (req) => {
  // Handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Initialize Supabase client with service role for admin operations
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

    // Verify user is an admin
    const { data: profile, error: profileError } = await supabaseClient
      .from('profiles')
      .select('role')
      .eq('id', user.id)
      .single()

    if (profileError || !profile || profile.role !== 'admin') {
      return new Response(
        JSON.stringify({
          error: 'Forbidden',
          message: 'Only administrators can create services',
        }),
        {
          status: 403,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Parse request body
    const body: ServiceRequest = await req.json()

    // Validate required fields
    if (!body.name || body.name.trim().length === 0) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Service name is required',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    if (!body.category || body.category.trim().length === 0) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Service category is required',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    if (!body.price || body.price <= 0) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Valid price is required (must be greater than 0)',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Validate price is a number with at most 2 decimal places
    if (!Number.isFinite(body.price) || !/^\d+(\.\d{1,2})?$/.test(body.price.toString())) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Price must be a valid number with at most 2 decimal places',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Check for duplicate service name
    const { data: existingService } = await supabaseClient
      .from('services')
      .select('id')
      .eq('name', body.name.trim())
      .maybeSingle()

    if (existingService) {
      return new Response(
        JSON.stringify({
          error: 'Duplicate Service',
          message: 'A service with this name already exists',
        }),
        {
          status: 409,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Create service
    const { data: service, error: createError } = await supabaseClient
      .from('services')
      .insert({
        name: body.name.trim(),
        category: body.category.trim(),
        price: body.price,
        description: body.description?.trim() || null,
        image_url: body.image_url?.trim() || null,
        is_active: body.is_active !== undefined ? body.is_active : true,
      })
      .select()
      .single()

    if (createError) {
      console.error('Service creation error:', createError)
      return new Response(
        JSON.stringify({
          error: 'Creation Failed',
          message: 'Failed to create service. Please try again.',
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
        message: 'Service created successfully',
        service,
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
