function DiscoverScreen({ onMatch }) {
  const { SwipeCard, IconButton, BottomNav } = window.CrushapDesignSystem_d1bbc4;
  const profiles = [
    { name: 'Mia', age: 27, distance: '3 km away', verified: true, bio: 'Coffee snob, weekend hiker.', tags: ['Hiking','Coffee'], slot: 'p1' },
    { name: 'Noah', age: 31, distance: '6 km away', bio: 'Always down for tacos and live music.', tags: ['Foodie','Live music'], slot: 'p2' },
    { name: 'Ava', age: 25, distance: '1 km away', verified: true, bio: 'Dog mom. Yoga most mornings.', tags: ['Dogs','Yoga'], slot: 'p3' },
  ];
  const [idx, setIdx] = React.useState(0);
  const current = profiles[idx % profiles.length];
  const advance = (matched) => { if (matched) onMatch(current); else setIdx(i => i + 1); };
  return React.createElement('div', { style: { display: 'flex', flexDirection: 'column', height: '100%', background: 'var(--surface-app)' } },
    React.createElement('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '20px 0 8px', font: 'var(--text-title)', fontFamily: 'var(--font-display)', color: 'var(--text-primary)' } }, 'Discover'),
    React.createElement('div', { style: { flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' } },
      React.createElement(SwipeCard, {
        name: current.name, age: current.age, distance: current.distance, verified: current.verified, bio: current.bio, tags: current.tags,
        photo: React.createElement('image-slot', { id: 'discover-' + current.slot, placeholder: 'Drop a photo of ' + current.name, style: { width: '100%', height: '100%' } }),
        style: { width: 340, height: 440 },
      })
    ),
    React.createElement('div', { style: { display: 'flex', justifyContent: 'center', gap: 20, padding: '4px 0 20px' } },
      React.createElement(IconButton, { icon: 'x', variant: 'outline', size: 'lg', label: 'Pass', onClick: () => advance(false) }),
      React.createElement(IconButton, { icon: 'star', variant: 'surface', label: 'Superlike', onClick: () => advance(false) }),
      React.createElement(IconButton, { icon: 'heart', variant: 'filled', size: 'lg', label: 'Like', onClick: () => advance(true) })
    ),
    React.createElement(BottomNav, { active: 'discover' })
  );
}
window.DiscoverScreen = DiscoverScreen;
