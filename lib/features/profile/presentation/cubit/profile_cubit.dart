import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_platform_example/features/profile/domain/usecases/get_profile_use_case.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit({
    required this.getProfileUseCase,
  }) : super(ProfileInitial());

  Future<void> getProfile() async{
    emit(ProfileLoading());
    try {
      final profileData = await getProfileUseCase();
      emit(ProfileLoaded(profileData: profileData));
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

}
