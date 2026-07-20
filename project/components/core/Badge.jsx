import React from 'react';
const variants = {
  neutral: { background: 'var(--surface-card)', color: 'var(--text-secondary)', border: '1px solid var(--border-subtle)' },
  verified: { background: 'rgba(61,220,132,.14)', color: 'var(--green-1)', border: '1px solid rgba(61,220,132,.3)' },
  premium: { background: 'rgba(255,193,69,.14)', color: 'var(--gold-1)', border: '1px solid rgba(255,193,69,.3)' },
  accent: { background: 'var(--gradient-primary)', color: '#fff', border: '1px solid transparent' },
};
export function Badge({ children, variant = 'neutral', icon, style }) {
  const v = variants[variant] || variants.neutral;
  return React.createElement('span', {
    style: {
      display: 'inline-flex', alignItems: 'center', gap: 4, padding: '4px 10px', borderRadius: 'var(--radius-pill)',
      font: 'var(--text-caption)', fontFamily: 'var(--font-body)', letterSpacing: 'var(--tracking-wide)', textTransform: 'uppercase',
      ...v, ...style,
    },
  }, icon, children);
}
