import 'package:shared_preferences/shared_preferences.dart';

abstract class BreadService {
  const BreadService();

  Future<DateTime> setNextBread(DateTime next);
  Future<DateTime> getNextBread();
}

class SharedPreferencesBreadService extends BreadService {
  final prefs = SharedPreferences.getInstance();

  @override
  Future<DateTime> setNextBread(DateTime next) async {
    await (await prefs).setInt("bread:next", next.millisecondsSinceEpoch);

    return next;
  }

  @override
  Future<DateTime> getNextBread() async {
    return DateTime.fromMillisecondsSinceEpoch(
        (await prefs).getInt("bread:next") ?? 0);
  }
}
