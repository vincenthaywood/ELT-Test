import { createClient } from '@supabase/supabase-js';

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL  || 'https://beafagckgeidshnoikzg.supabase.co';
const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJlYWZhZ2NrZ2VpZHNobm9pa3pnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNTgxODMsImV4cCI6MjA4MjkzNDE4M30.cJW2Ar25jzcTzcVLBxLjdmrmWJx4mNgfspofaNMJIJs';

// All workshop tables live in the 'workshop' schema
export const supabase = createClient(supabaseUrl, supabaseKey, {
  db: { schema: 'workshop' }
});
