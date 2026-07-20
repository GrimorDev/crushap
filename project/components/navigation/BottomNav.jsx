import React from 'react';
import { Icon } from '../core/Icon';
const tabs = [
  { key: 'discover', icon: 'flame', label: 'Discover' },
  { key: 'search', icon: 'search', label: 'Search' },
  { key: 'matches', icon: 'heart', label: 'Matches' },
  { key: 'chat', icon: 'message-circle', label: 'Chat' },
  { key: 'profile', icon: 'user', label: 'Profile' },
];
export function BottomNav({ active = 'discover', onChange, style }) {
  return React.createElement('nav', {
    style: {
      display: 'flex', justifyContent: 'space-around', alignItems: 'center',
      padding: '14px 8px calc(14px + env(safe-area-inset-bottom, 0px))',
      background: 'rgba(19,13,23,.72)', backdropFilter: 'var(--blur-glass)', WebkitBackdropFilter: 'var(--blur-glass)',
      borderTop: '1px solid var(--border-subtle)', ...style,
    },
  }, tabs.map(t => {
    const isActive = t.key === active;
    return React.createElement('button', {
      key: t.key, onClick: () => onChange && onChange(t.key),
      style: {
        display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, background: 'transparent', border: 'none', cursor: 'pointer',
        color: isActive ? 'var(--accent-primary)' : 'var(--text-tertiary)', transition: 'color var(--dur-fast)', minWidth: 44,
      },
    },
      React.createElement(Icon, { name: t.icon, size: 22, color: isActive ? 'var(--accent-primary)' : 'var(--text-tertiary)' }),
      React.createElement('span', { style: { font: 'var(--text-caption)', fontFamily: 'var(--font-body)', textTransform: 'none', letterSpacing: 0 } }, t.label)
    );
  }));
}
