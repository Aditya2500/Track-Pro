import 'dart:convert';
import 'dart:developer';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tracking06/models/users.dart';
import 'package:tracking06/services/firebase_database.dart';
import 'package:tracking06/utils/sharedUtils.dart';

class FirebaseAuthResult {
  final String idToken;
  final String uid;
  final String email;

  FirebaseAuthResult(this.idToken, this.uid, this.email);
}

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  //   scopes: [
  //     'email',
  //     'https://www.googleapis.com/auth/contacts.readonly',
  //   ],
  // );
  Users users = new Users();
  final UserFirebase userFirebase = new UserFirebase();
  Future<AuthCredential> getGoogleAuthCredential() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        return GoogleAuthProvider.getCredential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
      }
    } catch (exception) {
      log("FirebaseAuthService.getGoogleAuthCredential: " +
          exception.toString());
    }
    return null;
  }

  Future<GoogleSignInAccount> googleSignIn() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final FirebaseUser user =
          await _firebaseAuth.signInWithCredential(credential);

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      assert(user.uid == currentUser.uid);
      if (googleSignInAccount != null) {
        await SessionStorage.setCurrentUser('user_email', user.email);
        await SessionStorage.setCurrentUser('displayName', user.displayName);
        await SessionStorage.setCurrentUser('photoUrl', user.photoUrl);
        await SessionStorage.setCurrentUser('uid', user.uid);

        await SessionStorage.setCurrentUser('firstName', 'NotFound');
        await SessionStorage.setCurrentUser('lastName', 'NotFound');
        await SessionStorage.setCurrentUser('phoneNumber', 'NotFound');
        await SessionStorage.setCurrentUser('gender', 'NotFound');
        await SessionStorage.setCurrentUser('dateOfBirth', 'NotFound');

        await userFirebase.createUserInfoGoogle(
            googleSignInAccount.email,
            googleSignInAccount.id,
            googleSignInAccount.displayName,
            googleSignInAccount.photoUrl);
        return googleSignInAccount;
      }
    } catch (exception) {
      log("FirebaseAuthService.signinWithGoogle: " + exception.toString());
    }
    return null;
  }

  Future<FirebaseAuthResult> signInWithGoogle() async {
    try {
      AuthCredential credential = await this.getGoogleAuthCredential();
      if (credential != null) {
        FirebaseUser firebaseUser =
            await _firebaseAuth.signInWithCredential(credential);
        String idToken = await firebaseUser.getIdToken();
        return FirebaseAuthResult(
            idToken, firebaseUser.uid, firebaseUser.email);
      }
    } catch (exception) {
      log("FirebaseAuthService.signInWithGoogle: " + exception.toString());
    }
    return null;
  }

  Future<FirebaseAuthResult> createAccountFirebase(
      String email, String password) async {
    try {
      FirebaseUser firebaseUser = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String idToken = await firebaseUser.getIdToken();
      return FirebaseAuthResult(idToken, firebaseUser.uid, firebaseUser.email);
    } catch (exception) {
      log("FirebaseAuthService.signInWithGoogle: " + exception.toString());
    }
    return null;
  }

  Future<FirebaseAuthResult> signinFirebase(
      String email, String password) async {
    try {
      FirebaseUser firebaseUser = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      String idToken = await firebaseUser.getIdToken();


    String jsonUser = await  userFirebase.getUsers(email);
    var user = jsonDecode(jsonUser);    
        await SessionStorage.setCurrentUser('user_email', user['email']);
          await SessionStorage.setCurrentUser('displayName', 'NotFound');
        await SessionStorage.setCurrentUser('photoUrl', 'NotFound');
        await SessionStorage.setCurrentUser('uid', user['uid']);
        await SessionStorage.setCurrentUser('firstName', user['firstName']);
        await SessionStorage.setCurrentUser('lastName', user['lastName']);
        await SessionStorage.setCurrentUser('phoneNumber', user['phoneNumber']);
        await SessionStorage.setCurrentUser('gender', user['gender']);
        await SessionStorage.setCurrentUser('dateOfBirth', user['dateOfBirth']);

      return FirebaseAuthResult(idToken, firebaseUser.uid, firebaseUser.email);
    } catch (exception) {
      log("signinFirebase : " + exception.toString());
    }
    return null;
  }

  Future<bool> signoutFirebase() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (exception) {
      log("FirebaseAuthService.signInWithGoogle: " + exception.toString());
    }
    return false;
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (exception) {
      log("FirebaseAuthService.signInWithGoogle: " + exception.toString());
    }
    return false;
  }

  Future<FirebaseAuthResult> getCurrentUser() async {
    try {
      FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
      if (firebaseUser != null) {
        String idToken = await firebaseUser.getIdToken();

        return FirebaseAuthResult(
            idToken, firebaseUser.uid, firebaseUser.email);
      } else {
        return null;
      }
    } catch (exception) {
      log("FirebaseAuthService.getCurrentUser: " + exception.toString());
    }
    return null;
  }   
}
