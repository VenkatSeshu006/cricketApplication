class Organization {
  final String id;
  final String name;
  final String type; // Club, Association, Federation, League, etc.
  final String location;
  final String address;
  final String imageUrl;
  final String? logoUrl;
  final double rating;
  final int reviewCount;
  final String description;
  final String established;
  final int memberCount;
  final String? presidentName;
  final String? secretaryName;
  final String contactNumber;
  final String email;
  final String? website;

  // Organization specifics
  final List<String> achievements;
  final List<String> teams; // Teams under this organization
  final List<String> facilities;
  final List<String> events; // Regular events/tournaments
  final List<String>
  affiliations; // Other organizations they're affiliated with

  // Membership
  final bool acceptingMembers;
  final double? membershipFee; // Annual fee
  final List<String> membershipBenefits;
  final List<String> membershipRequirements;

  // Activities
  final List<String> activities; // Training, Tournaments, Social Events, etc.
  final String meetingSchedule; // When they meet

  // Social
  final String? facebookUrl;
  final String? instagramUrl;
  final String? twitterUrl;

  // Location
  final double? latitude;
  final double? longitude;

  // Status
  final bool isVerified;
  final bool isActive;
  final int foundingYear;

  Organization({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.address,
    required this.imageUrl,
    this.logoUrl,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.established,
    required this.memberCount,
    this.presidentName,
    this.secretaryName,
    required this.contactNumber,
    required this.email,
    this.website,
    required this.achievements,
    required this.teams,
    required this.facilities,
    required this.events,
    required this.affiliations,
    required this.acceptingMembers,
    this.membershipFee,
    required this.membershipBenefits,
    required this.membershipRequirements,
    required this.activities,
    required this.meetingSchedule,
    this.facebookUrl,
    this.instagramUrl,
    this.twitterUrl,
    this.latitude,
    this.longitude,
    required this.isVerified,
    required this.isActive,
    required this.foundingYear,
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      location: json['location'] as String,
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String,
      logoUrl: json['logoUrl'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      description: json['description'] as String,
      established: json['established'] as String,
      memberCount: json['memberCount'] as int,
      presidentName: json['presidentName'] as String?,
      secretaryName: json['secretaryName'] as String?,
      contactNumber: json['contactNumber'] as String,
      email: json['email'] as String,
      website: json['website'] as String?,
      achievements: List<String>.from(json['achievements'] as List),
      teams: List<String>.from(json['teams'] as List),
      facilities: List<String>.from(json['facilities'] as List),
      events: List<String>.from(json['events'] as List),
      affiliations: List<String>.from(json['affiliations'] as List),
      acceptingMembers: json['acceptingMembers'] as bool,
      membershipFee: json['membershipFee'] != null
          ? (json['membershipFee'] as num).toDouble()
          : null,
      membershipBenefits: List<String>.from(json['membershipBenefits'] as List),
      membershipRequirements: List<String>.from(
        json['membershipRequirements'] as List,
      ),
      activities: List<String>.from(json['activities'] as List),
      meetingSchedule: json['meetingSchedule'] as String,
      facebookUrl: json['facebookUrl'] as String?,
      instagramUrl: json['instagramUrl'] as String?,
      twitterUrl: json['twitterUrl'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      isVerified: json['isVerified'] as bool,
      isActive: json['isActive'] as bool,
      foundingYear: json['foundingYear'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'location': location,
      'address': address,
      'imageUrl': imageUrl,
      'logoUrl': logoUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'description': description,
      'established': established,
      'memberCount': memberCount,
      'presidentName': presidentName,
      'secretaryName': secretaryName,
      'contactNumber': contactNumber,
      'email': email,
      'website': website,
      'achievements': achievements,
      'teams': teams,
      'facilities': facilities,
      'events': events,
      'affiliations': affiliations,
      'acceptingMembers': acceptingMembers,
      'membershipFee': membershipFee,
      'membershipBenefits': membershipBenefits,
      'membershipRequirements': membershipRequirements,
      'activities': activities,
      'meetingSchedule': meetingSchedule,
      'facebookUrl': facebookUrl,
      'instagramUrl': instagramUrl,
      'twitterUrl': twitterUrl,
      'latitude': latitude,
      'longitude': longitude,
      'isVerified': isVerified,
      'isActive': isActive,
      'foundingYear': foundingYear,
    };
  }
}
