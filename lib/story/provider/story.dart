import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pratilipi_assignment/common/model/user.dart';
import 'package:pratilipi_assignment/common/persistence/cookie_monster.dart';
import 'package:pratilipi_assignment/common/utils.dart';
import 'package:pratilipi_assignment/story/model/story.dart';

class StoryProvider extends ChangeNotifier {
  StoryProvider({@required this.storyId, this.user}) {
    loadData();
  }

  final String storyId;
  String anonUid;
  User user;
  Timer timer;
  DocumentReference docRef;

  String get userName => user?.username ?? anonUid;
  Story _story;

  Story get story => _story;

  set story(Story story) {
    _story = story;
    notifyListeners();
  }

  bool _hasFocus = false;

  bool get hasFocus => _hasFocus;

  set hasFocus(bool hasFocus) {
    _hasFocus = hasFocus;
    handleFocus();
    notifyListeners();
  }

  StreamSubscription sub;

  void registerStoryStream() {
    sub = docRef.snapshots().listen(
          (DocumentSnapshot event) => story = Story.fromJson(event.data()),
        );
  }

  Future<void> addViewer() async {
    _story.viewing.add(userName);
    _story.viewing = _story.viewing.toSet().toList();
    await docRef.update(_story.toJson());
  }

  Future<void> removeViewer() async {
    _story.viewing.remove(userName);
    _story.viewing = _story.viewing.toSet().toList();
    await docRef.update(_story.toJson());
  }

  void handleFocus() async {
    if (hasFocus) {
      await addViewer();
    } else {
      await removeViewer();
    }
    notifyListeners();
  }

  void loadData() async {
    String _anonUid = CookieMonster.getCookie('anon_uid');
    if (_anonUid.length == 0) {
      _anonUid = "ANON" + getRandomString(16);
      CookieMonster.addToCookie('anon_uid', _anonUid);
    }
    anonUid = _anonUid;
    docRef = FirebaseFirestore.instance.collection('Stories').doc(storyId);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      _story = Story.fromJson(docSnapshot.data());
      if (_story.viewing == null) _story.viewing = [];
      if (_story.allReads == null) _story.allReads = [];
      _story.allReads.add(userName);
      _story.allReads = _story.allReads.toSet().toList();
      docRef.update(_story.toJson());
      registerStoryStream();
      checkFocusTimerInit();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    timer?.cancel();
    sub?.cancel();
    removeViewer();
    super.dispose();
  }

  void checkFocusTimerInit() {
    html.window.onBeforeUnload.listen((event) async {
      _story.viewing.remove(userName);
      await docRef.update(_story.toJson());
    });
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      final focus = js.context.callMethod('checkFocus');
      if (hasFocus != focus) {
        hasFocus = focus ?? false;
      }
    });
  }
}
