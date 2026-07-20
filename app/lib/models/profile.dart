/// Ported from the sample data in ui_kits/dating-app/DiscoverScreen.jsx.
class Profile {
  const Profile({
    required this.name,
    required this.age,
    required this.distance,
    this.verified = false,
    required this.bio,
    required this.tags,
  });

  final String name;
  final int age;
  final String distance;
  final bool verified;
  final String bio;
  final List<String> tags;
}

const sampleProfiles = [
  Profile(
    name: 'Mia',
    age: 27,
    distance: '3 km away',
    verified: true,
    bio: 'Coffee snob, weekend hiker.',
    tags: ['Hiking', 'Coffee'],
  ),
  Profile(
    name: 'Noah',
    age: 31,
    distance: '6 km away',
    bio: 'Always down for tacos and live music.',
    tags: ['Foodie', 'Live music'],
  ),
  Profile(
    name: 'Ava',
    age: 25,
    distance: '1 km away',
    verified: true,
    bio: 'Dog mom. Yoga most mornings.',
    tags: ['Dogs', 'Yoga'],
  ),
];
