library wChaser.src.services.local_storage;

import 'dart:convert';
import 'dart:html';

import 'package:crypto/crypto.dart';

import 'package:wChaser/src/constants.dart' as constants;

class LocationStorageService {
  Storage localStorage = window.localStorage;

  /**
   * Authorization
   */
  get githubUsername => localStorage['githubUsername'];

  set githubUsername(String username) {
    localStorage['githubUsername'] = username;
    localStorage['githubAuthorization'] = githubUserNameAccessToken;
    this.setGithubAuthorization();
  }

  get githubAccessToken => localStorage[constants.localStorageKey];

  set githubAccessToken(String accessToken) {
    localStorage['githubAccessToken'] = accessToken;
    this.setGithubAuthorization();
  }

  get githubUserNameAccessToken => githubUsername.toString() + ':' + githubAccessToken.toString();

  get githubAuthorization => localStorage['githubAuthorization'];

  setGithubAuthorization() {
    var bytes = UTF8.encode(githubUserNameAccessToken);
    var base64 = CryptoUtils.bytesToBase64(bytes);
    localStorage['githubAuthorization'] = base64;
  }
}
