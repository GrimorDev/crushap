import React from 'react';
const sizeMap = { sm: 32, md: 48, lg: 72, xl: 112 };
export function Avatar({ src, name = '', size = 'md', online = false, style }) {
  const px = sizeMap[size] || 48;
  const initial = name ? name.trim()[0].toUpperCase() : '?';
  return React.createElement('div', { style: { position: 'relative', width: px, height: px, flexShrink: 0, ...style } },
    src
      ? React.createElement('img', { src, alt: name, style: { width: px, height: px, borderRadius: '50%', objectFit: 'cover', border: '2px solid var(--border-subtle)' } })
      : React.createElement('div', {
          style: {
            width: px, height: px, borderRadius: '50%', display: 'flex', alignItems: 'center', justifyContent: 'center',
            background: 'var(--gradient-primary)', color: '#fff', fontFamily: 'var(--font-display)', fontWeight: 'var(--fw-bold)',
            fontSize: px * 0.4,
          },
        }, initial),
    online ? React.createElement('span', {
      style: {
        position: 'absolute', bottom: 0, right: 0, width: px * 0.26, height: px * 0.26, borderRadius: '50%',
        background: 'var(--action-like)', border: '2px solid var(--surface-app)',
      },
    }) : null
  );
}
