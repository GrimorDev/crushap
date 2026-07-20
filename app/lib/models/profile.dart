/// Ported from the sample data in ui_kits/dating-app/DiscoverScreen.jsx,
/// expanded with a larger cast and a stable `id` for matching/chat keying.
class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.age,
    required this.distance,
    this.verified = false,
    required this.bio,
    required this.tags,
  });

  final String id;
  final String name;
  final int age;
  final String distance;
  final bool verified;
  final String bio;
  final List<String> tags;
}

const sampleProfiles = [
  Profile(
    id: 'mia',
    name: 'Mia',
    age: 27,
    distance: '3 km away',
    verified: true,
    bio: 'Coffee snob, weekend hiker.',
    tags: ['Hiking', 'Coffee'],
  ),
  Profile(
    id: 'noah',
    name: 'Noah',
    age: 31,
    distance: '6 km away',
    bio: 'Always down for tacos and live music.',
    tags: ['Foodie', 'Live music'],
  ),
  Profile(
    id: 'ava',
    name: 'Ava',
    age: 25,
    distance: '1 km away',
    verified: true,
    bio: 'Dog mom. Yoga most mornings.',
    tags: ['Dogs', 'Yoga'],
  ),
  Profile(
    id: 'leo',
    name: 'Leo',
    age: 29,
    distance: '4 km away',
    verified: true,
    bio: 'Board games, bad puns, worse dance moves.',
    tags: ['Gaming', 'Foodie'],
  ),
  Profile(
    id: 'zara',
    name: 'Zara',
    age: 26,
    distance: '2 km away',
    bio: 'Chasing sunsets and cheap flights.',
    tags: ['Travel', 'Coffee'],
  ),
  Profile(
    id: 'ethan',
    name: 'Ethan',
    age: 33,
    distance: '9 km away',
    verified: true,
    bio: 'Sunrise runs, then an entire pizza.',
    tags: ['Hiking', 'Foodie'],
  ),
  Profile(
    id: 'priya',
    name: 'Priya',
    age: 28,
    distance: '5 km away',
    verified: true,
    bio: 'Front row at every local show.',
    tags: ['Live music', 'Yoga'],
  ),
  Profile(
    id: 'kai',
    name: 'Kai',
    age: 30,
    distance: '7 km away',
    bio: 'Two dogs, zero chill, all good vibes.',
    tags: ['Dogs', 'Travel'],
  ),
  Profile(
    id: 'sofia',
    name: 'Sofia',
    age: 24,
    distance: '2 km away',
    verified: true,
    bio: 'Yoga in the morning, tacos at night.',
    tags: ['Yoga', 'Foodie'],
  ),
  Profile(
    id: 'marcus',
    name: 'Marcus',
    age: 32,
    distance: '8 km away',
    bio: 'Retired gamer, professional coffee snob.',
    tags: ['Gaming', 'Coffee'],
  ),
];
