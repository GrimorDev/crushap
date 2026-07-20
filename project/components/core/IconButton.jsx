import React from 'react';
import { Icon } from './Icon';
const sizeMap = { sm: 36, md: 44, lg: 56 };
const variants = {
  filled: { background: 'var(--gradient-primary)', color: '#fff', border: '1px solid transparent', boxShadow: 'var(--shadow-glow-primary)' },
  outline: { background: 'var(--surface-elevated)', color: 'var(--text-primary)', border: '1px solid var(--border-strong)' },
  ghost: { background: 'rgba(255,255,255,.06)', color: 'var(--text-primary)', border: '1px solid transparent' },
  surface: { background: 'var(--surface-card)', color: 'var(--text-primary)', border: '1px solid var(--border-subtle)' },
};
export function IconButton({ icon, size = 'md', variant = 'outline', label, style, ...rest }) {
  const px = sizeMap[size] || 44;
  const v = variants[variant] || variants.outline;
  const [hover, setHover] = React.useState(false);
  return React.createElement('button', {
    'aria-label': label,
    onMouseEnter: () => setHover(true), onMouseLeave: () => setHover(false),
    style: {
      width: px, height: px, borderRadius: 'var(--radius-pill)', display: 'inline-flex',
      alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
      transform: hover ? 'translateY(-2px) scale(1.04)' : 'none',
      transition: 'transform var(--dur-fast) var(--ease-spring), filter var(--dur-fast)',
      filter: hover ? 'brightness(1.1)' : 'none',
      ...v, ...style,
    },
    ...rest,
  }, React.createElement(Icon, { name: icon, size: Math.round(px * 0.45), color: 'currentColor' }));
}
