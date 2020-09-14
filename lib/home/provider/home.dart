import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pratilipi_assignment/story/model/story.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider() {
    loadData();
  }

  Map<String, Story> _stories = {};

  Map<String, Story> get stories => _stories;

  set stories(Map<String,Story> stories) {
    _stories = stories;
    notifyListeners();
  }

  Future<void> loadStories() async {
    Map<String, Story> __stories = {};
    final docs =
        (await FirebaseFirestore.instance.collection('Stories').get()).docs;
    for (final d in docs) {
      __stories[d.id] =Story.fromJson(d.data());
    }
    stories = __stories;
  }

  void loadData() async {
    await loadStories();
    notifyListeners();
  }
}
