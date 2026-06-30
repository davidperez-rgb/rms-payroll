// ============================================================
// config.js — RMS Payroll App Configuration
// ============================================================
// Fill in your keys here after completing setup.
// This file is loaded by all pages in the app.
// IMPORTANT: Keep your GitHub repo PRIVATE since this file
// contains your service role key and manager password.
// ============================================================

const RMS_CONFIG = {
  // From your Supabase project → Settings → API
  supabase_url: 'YOUR_SUPABASE_URL',           // e.g. https://xxxx.supabase.co
  supabase_anon_key: 'YOUR_SUPABASE_ANON_KEY', // safe to expose in frontend

  // Service role key — gives manager dashboard full database access.
  // Keep your GitHub repo PRIVATE. Never share this key.
  supabase_service_role_key: 'YOUR_SERVICE_ROLE_KEY', // From Supabase → Settings → API

  // From Formspree.io → your form endpoint
  formspree_endpoint: 'YOUR_FORMSPREE_ENDPOINT', // e.g. https://formspree.io/f/xxxx

  // Company info
  company_name: 'Riverside Medical Supply',
  company_short: 'RMS',

  // Manager dashboard access (separate from employee PINs)
  // Change this to something only you know
  manager_password: 'CHANGE_THIS_PASSWORD',

  // PTO policy
  vacation_notice_days: 14,    // days advance notice required for vacation
  work_hours_per_day: 8,       // standard hours per workday

  // Pay periods
  pay_frequency: 'semimonthly',   // 'biweekly', 'semimonthly', 'weekly'
};
