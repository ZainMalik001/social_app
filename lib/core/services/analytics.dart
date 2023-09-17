import 'package:firebase_analytics/firebase_analytics.dart';

class Analytics {
  final _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer => FirebaseAnalyticsObserver(analytics: _analytics);
}
