import React from 'react';
const sizes = {
  sm: { padding: '10px 20px', font: 'var(--text-body-sm)', gap: 6 },
  md: { padding: '14px 26px', font: 'var(--text-body)', gap: 8 },
  lg: { padding: '18px 32px', font: 'var(--text-body-lg)', gap: 10 },
};
const variants = {
  primary: { background: 'var(--gradient-primary)', color: 'var(--text-primary)', border: '1px solid transparent', boxShadow: 'var(--shadow-glow-primary)' },
  secondary: { background: 'var(--surface-elevated)', color: 'var(--text-primary)', border: '1px solid var(--border-strong)', boxShadow: 'none' },
  ghost: { background: 'transparent', color: 'var(--text-secondary)', border: '1px solid transparent', boxShadow: 'none' },
};
export function Button({ variant = 'primary', size = 'md', disabled = false, icon, children, style, onClick, ...rest }) {
  const s = sizes[size] || sizes.md;
  const v = variants[variant] || variants.primary;
  const [hover, setHover] = React.useState(false);
  const [active, setActive] = React.useState(false);
  return React.createElement('button', {
    onClick: disabled ? undefined : onClick,
    disabled,
    onMouseEnter: () => setHover(true),
    onMouseLeave: () => { setHover(false); setActive(false); },
    onMouseDown: () => setActive(true),
    onMouseUp: () => setActive(false),
    style: {
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: s.gap,
      padding: s.padding, font: s.font, fontFamily: 'var(--font-body)', fontWeight: 'var(--fw-semibold)',
      borderRadius: 'var(--radius-pill)', cursor: disabled ? 'not-allowed' : 'pointer',
      opacity: disabled ? 0.4 : 1, transition: 'transform var(--dur-fast) var(--ease-standard), filter var(--dur-fast) var(--ease-standard), box-shadow var(--dur-normal) var(--ease-standard)',
      transform: active ? 'scale(.96)' : hover ? 'translateY(-1px)' : 'none',
      filter: hover && !disabled ? 'brightness(1.08)' : 'none',
      whiteSpace: 'nowrap', ...v, ...style,
    },
    ...rest,
  }, children);
}
