import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreProvider with ChangeNotifier {
    Map<String, dynamic> formData = {};
  Map<String, dynamic> coachData = {};
  // Map<CoachNo, Map<Area, Score>>
  final Map<String, Map<String, int>> _scores = {};
  final Map<String, Map<String, String>> _remarks = {};
  void initializeCoach(String coach) {
    _scores[coach] = {
      for (var area in ['T1', 'T2', 'T3', 'T4', 'D1', 'D2', 'B1', 'B2'])
        area: 0,
    };
    _remarks[coach] = {
      for (var area in ['T1', 'T2', 'T3', 'T4', 'D1', 'D2', 'B1', 'B2'])
        area: '',
    };
  }
 void saveFormData(Map<String, dynamic> data) {
    formData = data;
    _saveToPrefs();
    notifyListeners();
  }

  void saveCoachData(Map<String, dynamic> data) {
    coachData = data;
    _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('formData', jsonEncode(formData));
    prefs.setString('coachData', jsonEncode(coachData));
  }

  Future<void> restoreFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final form = prefs.getString('formData');
    final coach = prefs.getString('coachData');
    if (form != null) formData = jsonDecode(form);
    if (coach != null) coachData = jsonDecode(coach);
    notifyListeners();
  }

  void clearSaved() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('formData');
    await prefs.remove('coachData');
    formData = {};
    coachData = {};
    notifyListeners();
  }
  void setScore(String coach, String area, int score) {
    _scores.putIfAbsent(coach, () => {})[area] = score;
    notifyListeners();
  }

  void setRemarks(String coach, String area, String remark) {
    _remarks.putIfAbsent(coach, () => {})[area] = remark;
    notifyListeners();
  }

  Map<String, dynamic> getCoachReview(String coach) {
    return {'scores': _scores[coach] ?? {}, 'remarks': _remarks[coach] ?? {}};
  }

  Map<String, dynamic> getAllReview() {
    return {'scores': _scores, 'remarks': _remarks};
  }
}
