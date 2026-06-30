00// ============================================================
// config.js — RMS Payroll App Configuration
// ============================================================
// Fill in your keys here after completing setup.
// This file is loaded by all pages in the app.
// IMPORTANT: Only put the ANON key here (not service role).
// The service role key is entered in the manager dashboard UI.
// ============================================================

const RMS_CONFIG = {
  // From your Supabase project → Settings → API
  supabase_url: 'https://tzkocvxojszkjjjphkrv.supabase.co',           // e.g. https://xxxx.supabase.co
  supabase_anon_key: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6a29jdnhvanN6a2pqanBoa3J2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI3NTgzMDYsImV4cCI6MjA5ODMzNDMwNn0.2Qjov5jweqzFMeH5E2CPR_LZV1adJ4-S7B7TPS9VSJE', // safe to expose in frontend

  // From Formspree.io → your form endpoint
  formspree_endpoint: 'https://formspree.io/f/xaqgbzgz', // e.g. https://formspree.io/f/xxxx

  // Company info
  company_name: 'Riverside Medical Supply',
  company_short: 'RMS',

  // Manager dashboard access (separate from employee PINs)
  // Change this to something only you know
  manager_password: '1234',

  // PTO policy
  vacation_notice_days: 14,    // days advance notice required for vacation
  work_hours_per_day: 8,       // standard hours per workday

  // Pay periods
  pay_frequency: 'biweekly',   // 'biweekly', 'semimonthly', 'weekly'
};
