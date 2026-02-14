// =====================================================
// HomeEase Edge Function: create-support-message
// Production-Ready Support Ticket Creation
// =====================================================

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.4'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface SupportMessageRequest {
  message: string
  subject?: string
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
    const body: SupportMessageRequest = await req.json()

    // Validate required fields
    if (!body.message || body.message.trim().length === 0) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Message content is required',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Validate message length
    if (body.message.length > 2000) {
      return new Response(
        JSON.stringify({
          error: 'Validation Error',
          message: 'Message is too long. Maximum 2000 characters allowed.',
        }),
        {
          status: 400,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        }
      )
    }

    // Prepare message content (add subject if provided)
    let messageContent = body.message.trim()
    if (body.subject && body.subject.trim().length > 0) {
      messageContent = `Subject: ${body.subject}\n\n${messageContent}`
    }

    // Create support message
    const { data: supportMessage, error: createError } = await supabaseClient
      .from('support_messages')
      .insert({
        user_id: user.id,
        message: messageContent,
        status: 'open',
      })
      .select('*, profiles(name, phone)')
      .single()

    if (createError) {
      console.error('Support message creation error:', createError)
      return new Response(
        JSON.stringify({
          error: 'Creation Failed',
          message: 'Failed to create support message. Please try again.',
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
        message: 'Support ticket created successfully. We will respond shortly.',
        support_message: supportMessage,
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
