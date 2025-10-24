import 'package:equatable/equatable.dart';

class Challenge extends Equatable {
  final String id;
  final String title;
  final String description;
  final String creatorId;
  final String creatorName;
  final ChallengeType type;
  final ChallengeCategory category;
  final DateTime startDate;
  final DateTime endDate;
  final Map<String, dynamic> target; // e.g., {"runs": 100, "matches": 5}
  final List<ChallengeParticipant> participants;
  final ChallengeStatus status;
  final String? reward;
  final bool isPublic; // true = anyone can join, false = invite only

  const Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorId,
    required this.creatorName,
    required this.type,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.target,
    this.participants = const [],
    this.status = ChallengeStatus.upcoming,
    this.reward,
    this.isPublic = true,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    creatorId,
    creatorName,
    type,
    category,
    startDate,
    endDate,
    target,
    participants,
    status,
    reward,
    isPublic,
  ];

  Challenge copyWith({
    String? id,
    String? title,
    String? description,
    String? creatorId,
    String? creatorName,
    ChallengeType? type,
    ChallengeCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? target,
    List<ChallengeParticipant>? participants,
    ChallengeStatus? status,
    String? reward,
    bool? isPublic,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      type: type ?? this.type,
      category: category ?? this.category,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      target: target ?? this.target,
      participants: participants ?? this.participants,
      status: status ?? this.status,
      reward: reward ?? this.reward,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}

class ChallengeParticipant extends Equatable {
  final String userId;
  final String userName;
  final String? userImage;
  final DateTime joinedAt;
  final Map<String, dynamic> progress; // Current progress
  final int rank;

  const ChallengeParticipant({
    required this.userId,
    required this.userName,
    this.userImage,
    required this.joinedAt,
    this.progress = const {},
    this.rank = 0,
  });

  @override
  List<Object?> get props => [
    userId,
    userName,
    userImage,
    joinedAt,
    progress,
    rank,
  ];
}

enum ChallengeType { batting, bowling, fielding, allRound }

enum ChallengeCategory { leatherBall, tennisBall, boxCricket }

enum ChallengeStatus { upcoming, ongoing, completed }
