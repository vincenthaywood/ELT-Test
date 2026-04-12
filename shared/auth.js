// Mock auth — use this for current user context
// In a real app this would come from Supabase Auth

export const currentUser = {
  id: 'a1000000-0000-0000-0000-000000000007',
  name: 'Léa Dupont',
  email: 'lea.dupont@spendesk.com',
  department: 'Engineering',
  role: 'manager',
  avatar_initials: 'LD'
};

export function isManager() {
  return currentUser.role === 'manager' || currentUser.role === 'admin';
}

export function isFinance() {
  return currentUser.role === 'finance' || currentUser.role === 'admin';
}
