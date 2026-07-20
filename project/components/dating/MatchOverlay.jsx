import React from 'react';
import { Avatar } from '../core/Avatar';
import { Button } from '../core/Button';
export function MatchOverlay({ youPhoto, matchPhoto, matchName, onMessage, onKeepSwiping, style }) {
  return React.createElement('div', {
    style: {
      position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      background: 'var(--overlay-scrim)', backdropFilter: 'var(--blur-glass)', WebkitBackdropFilter: 'var(--blur-glass)',
      textAlign: 'center', padding: 32, gap: 24, ...style,
    },
  },
    React.createElement('div', { style: { font: 'var(--text-display-xl)', fontFamily: 'var(--font-display)', background: 'var(--gradient-primary)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent', letterSpacing: 'var(--tracking-tight)' } }, "It's a match!"),
    React.createElement('p', { style: { margin: 0, font: 'var(--text-body)', color: 'var(--text-secondary)', maxWidth: 280 } }, `You and ${matchName} liked each other.`),
    React.createElement('div', { style: { display: 'flex', alignItems: 'center', gap: -16 } },
      React.createElement('div', { style: { marginRight: -20, boxShadow: 'var(--shadow-glow-primary)', borderRadius: '50%' } }, React.createElement(Avatar, { src: youPhoto, name: 'You', size: 'xl' })),
      React.createElement('div', { style: { boxShadow: 'var(--shadow-glow-primary)', borderRadius: '50%' } }, React.createElement(Avatar, { src: matchPhoto, name: matchName, size: 'xl' }))
    ),
    React.createElement('div', { style: { display: 'flex', flexDirection: 'column', gap: 12, width: '100%', maxWidth: 280, marginTop: 8 } },
      React.createElement(Button, { variant: 'primary', size: 'lg', onClick: onMessage, style: { width: '100%' } }, 'Send a Message'),
      React.createElement(Button, { variant: 'ghost', size: 'md', onClick: onKeepSwiping, style: { width: '100%' } }, 'Keep Swiping')
    )
  );
}
