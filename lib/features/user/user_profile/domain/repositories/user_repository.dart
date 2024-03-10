import '../../../../../core/typedef/typedefs.dart';
import '../../data/models/user_model.dart';
import '../entities/user_entity.dart';

abstract interface class UserRepository {
  FutureEither<void> addUserProfile(UserEntity userEntity);

  Stream<UserEntity?> getUserData(String uid);

  FutureEither<void> updateUserProfile(UserEntity userEntity);

  FutureEither<bool> addAttendanceDate({
    required String uid,
    required List<DateTime> attendance,
  });

  FutureEither<List<UserEntity>> getListUsers({
    required FilterUserType type,
    required int limit,
  });

  FutureEither<List<String>> syncFavourites({
    required String uid,
    required List<String> favourites,
  });

  FutureEither<List<String>> syncKnowns({
    required String uid,
    required List<String> knowns,
  });

  FutureEither<void> removeAllFavourites({required String uid});

  FutureEither<void> removeAllKnowns({required String uid});
}