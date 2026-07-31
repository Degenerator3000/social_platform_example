import 'package:equatable/equatable.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';

class ProfileData extends Equatable{
  final User user;
  final int likesCount;

  const ProfileData({
    required this.user,
    required this.likesCount,
  });

  @override
  List<Object?> get props => [user, likesCount];
}