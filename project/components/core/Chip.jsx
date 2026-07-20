import React from 'react';
export function Chip({ children, selected = false, onClick, style, ...rest }) {
  return React.createElement('button', {
    onClick,
    style: {
      display: 'inline-flex', alignItems: 'center', padding: '8px 16px',
      borderRadius: 'var(--radius-pill)', font: 'var(--text-body-sm)', fontFamily: 'var(--font-body)',
      cursor: 'pointer', transition: 'all var(--dur-fast) var(--ease-standard)',
      background: selected ? 'var(--gradient-primary)' : 'var(--surface-card)',
      color: selected ? 'var(--text-primary)' : 'var(--text-secondary)',
      border: `1px solid ${selected ? 'transparent' : 'var(--border-subtle)'}`,
      boxShadow: selected ? 'var(--shadow-glow-primary)' : 'none',
      ...style,
    },
    ...rest,
  }, children);
}
