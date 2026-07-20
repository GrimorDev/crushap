import React from 'react';
import { Badge } from '../core/Badge';
import { Icon } from '../core/Icon';
export function SwipeCard({ name, age, distance, verified = false, bio, photo, tags = [], style }) {
  return React.createElement('div', {
    style: {
      position: 'relative', width: 340, height: 460, borderRadius: 'var(--radius-xl)', overflow: 'hidden',
      background: photo ? 'var(--surface-card)' : 'linear-gradient(160deg,var(--black-4),var(--black-2))',
      boxShadow: 'var(--shadow-elevated)', border: '1px solid var(--border-subtle)', ...style,
    },
  },
    photo ? React.createElement('div', { style: { position: 'absolute', inset: 0 } }, photo) : null,
    React.createElement('div', { style: { position: 'absolute', inset: 0, background: 'var(--gradient-scrim-bottom)' } }),
    React.createElement('div', { style: { position: 'absolute', top: 16, right: 16 } },
      verified ? React.createElement(Badge, { variant: 'verified', icon: React.createElement(Icon, { name: 'shield-check', size: 12 }) }, 'Verified') : null
    ),
    React.createElement('div', { style: { position: 'absolute', left: 20, right: 20, bottom: 20, color: 'var(--text-primary)' } },
      React.createElement('div', { style: { display: 'flex', alignItems: 'baseline', gap: 8 } },
        React.createElement('span', { style: { font: 'var(--text-display-md)', fontFamily: 'var(--font-display)' } }, name),
        React.createElement('span', { style: { font: 'var(--text-title)', color: 'var(--text-secondary)', fontFamily: 'var(--font-display)' } }, age)
      ),
      distance ? React.createElement('div', { style: { display: 'flex', alignItems: 'center', gap: 6, marginTop: 4, color: 'var(--text-secondary)', font: 'var(--text-body-sm)' } },
        React.createElement(Icon, { name: 'map-pin', size: 14, color: 'var(--text-secondary)' }), distance
      ) : null,
      bio ? React.createElement('p', { style: { margin: '10px 0 0', font: 'var(--text-body-sm)', color: 'var(--text-secondary)', maxWidth: 280 } }, bio) : null,
      tags.length ? React.createElement('div', { style: { display: 'flex', gap: 6, marginTop: 10, flexWrap: 'wrap' } },
        tags.map((t, i) => React.createElement('span', {
          key: i, style: { padding: '4px 10px', borderRadius: 'var(--radius-pill)', background: 'rgba(255,255,255,.1)', backdropFilter: 'blur(6px)', font: 'var(--text-caption)', textTransform: 'none', letterSpacing: 0, color: 'var(--text-primary)' },
        }, t))
      ) : null
    )
  );
}
