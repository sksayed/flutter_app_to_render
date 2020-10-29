import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:async/async.dart';

class UserRepository {
  static const String username = "username";
  static const String password = "password";
  static const String token = "token";

  List<_SecItem> _database = [];
  final _storage = FlutterSecureStorage();

  //authenticate
  Future<String> authenticate(
      {@required String username, @required String password}) async {
    await Future.delayed(Duration(seconds: 1));
    if (username != "" && password != "") {
      await _storage.write(key: UserRepository.username, value: username);
      await _storage.write(key: UserRepository.password, value: password);
      return "done";
    } else {
      throw Exception(" validation failed");
    }
  }

  Future<Null> _readAll() async {
    final all = await _storage.readAll();
    _database =
        all.keys.map((key) => _SecItem(key, all[key])).toList(growable: false);
  }

  //delete token
  Future<void> deleteToken() async {
    await Future.delayed(Duration(seconds: 1));
    await _storage.deleteAll();

    return;
  }

//persist token
  Future<void> persistToken({@required String token}) async {
    await Future.delayed(Duration(seconds: 1));
    _storage.write(key: UserRepository.token, value: token);
    return;
  }

//has token
  Future<bool> hasToken() async {
    await Future.delayed(Duration(seconds: 1));
    var token = await _storage.read(key: UserRepository.token);
    return (token == null) ? false : true;
  }

  Future<String> getUserName() async {
    var uname = await _storage.read(key: UserRepository.username);
    return uname;
  }

  Future<String> getPassword() async {
    var pass = await _storage.read(key: UserRepository.password);
    return pass;
  }

  Future<Map<String, String>> getUsernameAndPassWord() async {
    var uname = await _storage.read(key: UserRepository.username);
    var pass = await _storage.read(key: UserRepository.password);
    return {UserRepository.username: uname, UserRepository.password: pass};
  }
}

class _SecItem {
  _SecItem(this.key, this.value);

  final String key;
  final String value;
}
