import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/data/models/user_model.dart';

abstract class AuthDataSource {

  Future<UserModel?> login(AuthCredentials credentials);

  Future<UserModel?> getUserById(String id);


}