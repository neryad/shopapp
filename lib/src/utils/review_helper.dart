import 'package:in_app_review/in_app_review.dart';
import 'package:pocketlist/src/Shared_Prefs/Preferencias_user.dart';

class ReviewHelper {
  static const int _minCompletedLists = 3;
  static const int _cooldownDays = 90;

  static Future<void> maybeRequestReview() async {
    final prefs = PreferenciasUsuario();

    if (prefs.completedListCount < _minCompletedLists) return;

    final lastTimestamp = prefs.lastReviewRequestTimestamp;
    if (lastTimestamp > 0) {
      final lastDate = DateTime.fromMillisecondsSinceEpoch(lastTimestamp);
      final daysSince = DateTime.now().difference(lastDate).inDays;
      if (daysSince < _cooldownDays) return;
    }

    final inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      await inAppReview.requestReview();
      prefs.lastReviewRequestTimestamp = DateTime.now().millisecondsSinceEpoch;
    }
  }
}