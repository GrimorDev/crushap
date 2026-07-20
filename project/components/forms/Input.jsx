import React from 'react';
export function Input({ placeholder, value, onChange, type = 'text', icon, style, ...rest }) {
  const [focused, setFocused] = React.useState(false);
  return React.createElement('div', {
    style: {
      display: 'flex', alignItems: 'center', gap: 10,
      background: 'var(--surface-elevated)', border: `1px solid ${focused ? 'var(--accent-primary)' : 'var(--border-subtle)'}`,
      borderRadius: 'var(--radius-md)', padding: '14px 18px',
      boxShadow: focused ? '0 0 0 4px var(--accent-glow)' : 'none',
      transition: 'box-shadow var(--dur-normal) var(--ease-standard), border-color var(--dur-normal)',
      ...style,
    },
  },
    icon ? React.createElement('span', { style: { color: 'var(--text-tertiary)', display: 'flex' } }, icon) : null,
    React.createElement('input', {
      type, placeholder, value, onChange,
      onFocus: () => setFocused(true), onBlur: () => setFocused(false),
      style: { flex: 1, background: 'transparent', border: 'none', outline: 'none', font: 'var(--text-body)', fontFamily: 'var(--font-body)', color: 'var(--text-primary)' },
      ...rest,
    })
  );
}
