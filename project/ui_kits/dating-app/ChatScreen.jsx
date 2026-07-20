function ChatScreen({ matchName }) {
  const { Avatar, IconButton, BottomNav } = window.CrushapDesignSystem_d1bbc4;
  const [messages, setMessages] = React.useState([
    { from: 'them', text: 'Hey! Your hiking photos are amazing 😄' },
    { from: 'me', text: "Ha thanks! That was Half Dome, brutal but worth it" },
    { from: 'them', text: 'Ok that\'s officially a date idea' },
  ]);
  const [draft, setDraft] = React.useState('');
  const send = () => { if (!draft.trim()) return; setMessages(m => [...m, { from: 'me', text: draft }]); setDraft(''); };
  return React.createElement('div', { style: { display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--surface-app)' } },
    React.createElement('div', { style: { display: 'flex', alignItems: 'center', gap: 12, padding: '16px 20px', borderBottom: '1px solid var(--border-subtle)' } },
      React.createElement(Avatar, { name: matchName, size: 'sm', online: true }),
      React.createElement('span', { style: { font: 'var(--text-title)', fontFamily: 'var(--font-display)', color: 'var(--text-primary)' } }, matchName)
    ),
    React.createElement('div', { style: { flex: 1, overflow: 'auto', padding: 20, display: 'flex', flexDirection: 'column', gap: 10 } },
      messages.map((m, i) => React.createElement('div', {
        key: i,
        style: {
          alignSelf: m.from === 'me' ? 'flex-end' : 'flex-start', maxWidth: '75%',
          padding: '10px 16px', borderRadius: 'var(--radius-lg)', font: 'var(--text-body)',
          background: m.from === 'me' ? 'var(--gradient-primary)' : 'var(--surface-card)',
          color: m.from === 'me' ? '#fff' : 'var(--text-primary)',
        },
      }, m.text))
    ),
    React.createElement('div', { style: { display: 'flex', gap: 10, alignItems: 'center', padding: '12px 16px', borderTop: '1px solid var(--border-subtle)' } },
      React.createElement('input', {
        value: draft, onChange: e => setDraft(e.target.value), placeholder: 'Send a message',
        onKeyDown: e => e.key === 'Enter' && send(),
        style: { flex: 1, background: 'var(--surface-elevated)', border: '1px solid var(--border-subtle)', borderRadius: 'var(--radius-pill)', padding: '12px 18px', color: 'var(--text-primary)', font: 'var(--text-body)', fontFamily: 'var(--font-body)', outline: 'none' },
      }),
      React.createElement(IconButton, { icon: 'send', variant: 'filled', label: 'Send', onClick: send })
    ),
    React.createElement(BottomNav, { active: 'chat' })
  );
}
window.ChatScreen = ChatScreen;
