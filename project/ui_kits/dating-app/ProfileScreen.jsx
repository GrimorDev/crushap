function ProfileScreen() {
  const { Avatar, Badge, Chip, Icon, IconButton, BottomNav } = window.CrushapDesignSystem_d1bbc4;
  return React.createElement('div', { style: { display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--surface-app)' } },
    React.createElement('div', { style: { flex: 1, overflow: 'auto', padding: '24px 20px' } },
      React.createElement('div', { style: { display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 12 } },
        React.createElement('image-slot', { id: 'profile-photo', shape: 'circle', placeholder: 'Drop your photo', style: { width: 112, height: 112 } }),
        React.createElement('div', { style: { display: 'flex', alignItems: 'center', gap: 8 } },
          React.createElement('span', { style: { font: 'var(--text-display-md)', fontFamily: 'var(--font-display)', color: 'var(--text-primary)' } }, 'You, 28'),
          React.createElement(Badge, { variant: 'verified', icon: React.createElement(Icon, { name: 'shield-check', size: 12 }) }, 'Verified')
        ),
        React.createElement(IconButton, { icon: 'camera', variant: 'surface', label: 'Edit photo' })
      ),
      React.createElement('div', { style: { marginTop: 28 } },
        React.createElement('div', { style: { font: 'var(--text-body-sm)', color: 'var(--text-tertiary)', textTransform: 'uppercase', letterSpacing: 'var(--tracking-wide)', marginBottom: 10 } }, 'About'),
        React.createElement('p', { style: { margin: 0, font: 'var(--text-body)', color: 'var(--text-secondary)' } }, 'Coffee snob, weekend hiker, professional dog-petter. Looking for someone to explore new trails with.')
      ),
      React.createElement('div', { style: { marginTop: 24 } },
        React.createElement('div', { style: { font: 'var(--text-body-sm)', color: 'var(--text-tertiary)', textTransform: 'uppercase', letterSpacing: 'var(--tracking-wide)', marginBottom: 10 } }, 'Interests'),
        React.createElement('div', { style: { display: 'flex', gap: 8, flexWrap: 'wrap' } },
          ['Hiking','Coffee','Dogs','Travel'].map(t => React.createElement(Chip, { key: t, selected: true }, t))
        )
      ),
      React.createElement('div', { style: { marginTop: 24, display: 'flex', flexDirection: 'column', gap: 2 } },
        ['Edit profile','Notifications','Privacy & safety','Subscription'].map(t => React.createElement('div', {
          key: t, style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '16px 4px', borderBottom: '1px solid var(--border-subtle)', color: 'var(--text-primary)', font: 'var(--text-body)' },
        }, t, React.createElement(Icon, { name: 'chevron-left', size: 16, color: 'var(--text-tertiary)', style: { transform: 'rotate(180deg)' } })))
      )
    ),
    React.createElement(BottomNav, { active: 'profile' })
  );
}
window.ProfileScreen = ProfileScreen;
