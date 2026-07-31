import 'package:equatable/equatable.dart';
import 'package:social_platform_example/features/profile/domain/entities/profile_data.dart';


abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState{
  const ProfileInitial();
  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
  @override
  List<Object> get props => [];
}

class ProfileLoaded extends ProfileState {
  final ProfileData profileData;
  const ProfileLoaded({required this.profileData});
  @override
  List<Object> get props => [profileData];
}

class ProfileError  extends ProfileState {
  final String message;
  const ProfileError ({required this.message});
  @override
  List<Object> get props => [message];
}