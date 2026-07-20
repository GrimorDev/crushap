/// A user's public profile, as returned by the server (see server/README.md).
/// `distanceKm` is only ever real (Redis GEO between two opted-in users) —
/// null means "unknown", never a fabricated placeholder.
class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.age,
    this.distanceKm,
    this.verified = false,
    required this.bio,
    required this.tags,
    this.photos = const [],
  });

  final String id;
  final String name;
  final int age;
  final double? distanceKm;
  final bool verified;
  final String bio;
  final List<String> tags;
  final List<String> photos;

  String? get distanceLabel => distanceKm == null ? null : '${distanceKm!.toStringAsFixed(distanceKm! < 10 ? 1 : 0)} km away';

  factory Profile.fromJson(Map<String, dynamic> j) {
    return Profile(
      id: j['id'] as String,
      name: j['name'] as String,
      age: j['age'] as int,
      distanceKm: (j['distanceKm'] as num?)?.toDouble(),
      verified: j['verified'] as bool? ?? false,
      bio: j['bio'] as String? ?? '',
      tags: (j['tags'] as List?)?.map((e) => e as String).toList() ?? const [],
      photos: (j['photos'] as List?)?.map((e) => e as String).toList() ?? const [],
    );
  }
}
