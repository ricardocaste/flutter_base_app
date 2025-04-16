import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String name;
  final String email;
  final String ranking;
  final int studyStreak;
  final int challengesInProgress;
  final List<Achievement> achievements;

  const Profile({
    required this.name,
    required this.email,
    required this.ranking,
    required this.studyStreak,
    required this.challengesInProgress,
    required this.achievements,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    ranking,
    studyStreak,
    challengesInProgress,
    achievements,
  ];
}

class Achievement extends Equatable {
  final String name;
  final int level;

  const Achievement({
    required this.name,
    required this.level,
  });

  @override
  List<Object?> get props => [name, level];
}