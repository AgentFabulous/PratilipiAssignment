import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:password_hash/password_hash.dart';
import 'package:pratilipi_assignment/common/model/user.dart';
import 'package:pratilipi_assignment/common/persistence/cookie_monster.dart';
import 'package:pratilipi_assignment/common/utils.dart';

enum SignInState {
  NO_USER,
  BAD_PASS,
  BAD_TOKEN,
  SUCCESS,
}

class AppInfoProvider extends ChangeNotifier {
  AppInfoProvider() {
    loadData();
  }

  User _user;

  User get user => _user;

  set user(User user) {
    _user = user;
    notifyListeners();
  }

  bool get isSignedIn => user != null;

  Future<SignInState> signIn(String username, String password) async {
    final userSnapshot = (await FirebaseFirestore.instance
        .collection('Users')
        .doc(username)
        .get());
    if (!userSnapshot.exists) {
      return SignInState.NO_USER;
    }
    final user = User.fromJson(userSnapshot.data());
    var generator = PBKDF2();
    var salt = user.salt;
    var hash = generator.generateBase64Key(password, salt, 1000, 32);
    if (user.hash != hash) return SignInState.BAD_PASS;
    user.token = genToken();
    await userSnapshot.reference.update(user.toJson());
    CookieMonster.addToCookie('login_token', user.token);
    CookieMonster.addToCookie('login_user', user.username);
    this.user = user;
    return SignInState.SUCCESS;
  }

  Future<SignInState> signInToken(String username, String token) async {
    if (token.length != 32) return SignInState.BAD_TOKEN;
    final userSnapshot = (await FirebaseFirestore.instance
        .collection('Users')
        .doc(username)
        .get());
    if (!userSnapshot.exists) {
      return SignInState.NO_USER;
    }
    final user = User.fromJson(userSnapshot.data());
    if (user.token != token)return SignInState.BAD_TOKEN;
    this.user = user;
    return SignInState.SUCCESS;
  }

  Future<bool> register(String username, String password) async {
    final exists = (await FirebaseFirestore.instance
            .collection('Users')
            .doc(username)
            .get())
        .exists;
    if (exists) return false;

    var salt = Salt.generateAsBase64String(10);
    var hash = PBKDF2().generateBase64Key(password, salt, 1000, 32);
    User dis = User(
      username: username,
      salt: salt,
      hash: hash,
      token: "",
    );
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(username)
        .set(dis.toJson());
    return true;
  }

  String genToken() => getRandomString(32);

  void signOut() {
    CookieMonster.deleteCookie("login_token");
    CookieMonster.deleteCookie("login_user");
    user = null;
  }

  void loadData() async {
    // assign an anon uid here too, just to be safe
    String _anonUid = CookieMonster.getCookie('anon_uid');
    if (_anonUid.length == 0) {
      _anonUid = "ANON" + getRandomString(16);
      CookieMonster.addToCookie('anon_uid', _anonUid);
    }
    final __loginToken = CookieMonster.getCookie("login_token");
    final __loginUser = CookieMonster.getCookie("login_user");
    if (__loginUser.length != 0 && __loginToken.length != 0) {
      print(await signInToken(__loginUser, __loginToken));
    }
    notifyListeners();
  }
}
