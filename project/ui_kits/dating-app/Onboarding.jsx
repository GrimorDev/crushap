function Onboarding({ onDone }) {
  const { Button, Input, Chip, Icon } = window.CrushapDesignSystem_d1bbc4;
  const [step, setStep] = React.useState(0);
  const [name, setName] = React.useState('');
  const [interests, setInterests] = React.useState([]);
  const allInterests = ['Hiking','Coffee','Live music','Foodie','Dogs','Travel','Yoga','Gaming'];
  const toggle = (t) => setInterests(v => v.includes(t) ? v.filter(x=>x!==t) : [...v, t]);
  const steps = [
    React.createElement('div', { key: 0, style: sScreen },
      React.createElement('div', { style: { flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: 12 } },
        React.createElement('div', { style: { font: 'var(--text-display-xl)', fontFamily: 'var(--font-display)', color: 'var(--text-primary)' } }, 'crushap'),
        React.createElement('p', { style: { margin: 0, font: 'var(--text-body-lg)', color: 'var(--text-secondary)', maxWidth: 280 } }, 'Find your spark tonight. No games, just genuine matches.')
      ),
      React.createElement(Button, { variant: 'primary', size: 'lg', style: { width: '100%' }, onClick: () => setStep(1) }, 'Get Started'),
      React.createElement(Button, { variant: 'ghost', size: 'md', style: { width: '100%' } }, 'I already have an account')
    ),
    React.createElement('div', { key: 1, style: sScreen },
      React.createElement('div', { style: { flex: 1, display: 'flex', flexDirection: 'column', gap: 16, paddingTop: 24 } },
        React.createElement('div', { style: { font: 'var(--text-title)', fontFamily: 'var(--font-display)', color: 'var(--text-primary)' } }, "What's your name?"),
        React.createElement(Input, { placeholder: 'First name', value: name, onChange: e => setName(e.target.value) })
      ),
      React.createElement(Button, { variant: 'primary', size: 'lg', style: { width: '100%' }, disabled: !name, onClick: () => setStep(2) }, 'Continue')
    ),
    React.createElement('div', { key: 2, style: sScreen },
      React.createElement('div', { style: { flex: 1, display: 'flex', flexDirection: 'column', gap: 16, paddingTop: 24, overflow: 'auto' } },
        React.createElement('div', { style: { font: 'var(--text-title)', fontFamily: 'var(--font-display)', color: 'var(--text-primary)' } }, 'Pick a few interests'),
        React.createElement('div', { style: { display: 'flex', gap: 8, flexWrap: 'wrap' } },
          allInterests.map(t => React.createElement(Chip, { key: t, selected: interests.includes(t), onClick: () => toggle(t) }, t))
        )
      ),
      React.createElement(Button, { variant: 'primary', size: 'lg', style: { width: '100%' }, disabled: interests.length === 0, onClick: onDone }, 'Start swiping')
    ),
  ];
  return steps[step];
}
const sScreen = { display: 'flex', flexDirection: 'column', gap: 20, height: '100%', padding: '32px 24px', boxSizing: 'border-box', background: 'var(--surface-app)' };
window.Onboarding = Onboarding;
