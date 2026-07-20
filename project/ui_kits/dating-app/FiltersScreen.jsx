function FiltersScreen({ onClose }) {
  const { Button, Chip, IconButton, Icon } = window.CrushapDesignSystem_d1bbc4;
  const [range, setRange] = React.useState(35);
  const [dist, setDist] = React.useState(25);
  const [showVerifiedOnly, setShowVerifiedOnly] = React.useState(true);
  return React.createElement('div', { style: { display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--surface-app)' } },
    React.createElement('div', { style: { display: 'flex', alignItems: 'center', gap: 12, padding: '16px 20px', borderBottom: '1px solid var(--border-subtle)' } },
      React.createElement(IconButton, { icon: 'arrow-left', variant: 'ghost', label: 'Back', onClick: onClose }),
      React.createElement('span', { style: { font: 'var(--text-title)', fontFamily: 'var(--font-display)', color: 'var(--text-primary)' } }, 'Filters')
    ),
    React.createElement('div', { style: { flex: 1, overflow: 'auto', padding: 20, display: 'flex', flexDirection: 'column', gap: 28 } },
      React.createElement('div', null,
        React.createElement('div', { style: { display: 'flex', justifyContent: 'space-between', font: 'var(--text-body)', color: 'var(--text-primary)', marginBottom: 10 } },
          React.createElement('span', null, 'Maximum distance'), React.createElement('span', { style: { color: 'var(--accent-primary)' } }, dist + ' km')
        ),
        React.createElement('input', { type: 'range', min: 1, max: 100, value: dist, onChange: e => setDist(+e.target.value), style: { width: '100%', accentColor: 'var(--pink-1)' } })
      ),
      React.createElement('div', null,
        React.createElement('div', { style: { display: 'flex', justifyContent: 'space-between', font: 'var(--text-body)', color: 'var(--text-primary)', marginBottom: 10 } },
          React.createElement('span', null, 'Age range'), React.createElement('span', { style: { color: 'var(--accent-primary)' } }, '18 - ' + range)
        ),
        React.createElement('input', { type: 'range', min: 18, max: 60, value: range, onChange: e => setRange(+e.target.value), style: { width: '100%', accentColor: 'var(--pink-1)' } })
      ),
      React.createElement('div', null,
        React.createElement('div', { style: { font: 'var(--text-body)', color: 'var(--text-primary)', marginBottom: 10 } }, 'Show me'),
        React.createElement('div', { style: { display: 'flex', gap: 8 } }, ['Women','Men','Everyone'].map((g,i) => React.createElement(Chip, { key: g, selected: i === 2 }, g)))
      ),
      React.createElement('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between' } },
        React.createElement('div', { style: { display: 'flex', alignItems: 'center', gap: 8, color: 'var(--text-primary)', font: 'var(--text-body)' } },
          React.createElement(Icon, { name: 'shield-check', size: 18, color: 'var(--green-1)' }), 'Verified profiles only'
        ),
        React.createElement('div', {
          onClick: () => setShowVerifiedOnly(v => !v),
          style: { width: 46, height: 28, borderRadius: 'var(--radius-pill)', background: showVerifiedOnly ? 'var(--gradient-primary)' : 'var(--surface-card)', border: '1px solid var(--border-subtle)', position: 'relative', cursor: 'pointer', transition: 'background var(--dur-fast)' },
        }, React.createElement('div', { style: { position: 'absolute', top: 2, left: showVerifiedOnly ? 20 : 2, width: 22, height: 22, borderRadius: '50%', background: '#fff', transition: 'left var(--dur-fast) var(--ease-spring)' } }))
      )
    ),
    React.createElement('div', { style: { padding: 20 } }, React.createElement(Button, { variant: 'primary', size: 'lg', style: { width: '100%' }, onClick: onClose }, 'Apply filters'))
  );
}
window.FiltersScreen = FiltersScreen;
