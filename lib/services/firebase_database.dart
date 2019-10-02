import 'dart:convert';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:tracking06/utils/sharedUtils.dart';

class UserFirebase {
  final databaseReference = FirebaseDatabase.instance.reference();
  Future<bool> createUserInfo(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String dateOfBirth,
      String gender,
      String password,
      String uid) async {
    try {
      await databaseReference.child('users').child(uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'email': email,
        'password': password,
        'uid': uid
      });
      await SessionStorage.setCurrentUser('firstName', firstName);
      await SessionStorage.setCurrentUser('lastName', lastName);
      await SessionStorage.setCurrentUser('user_email', email);
      await SessionStorage.setCurrentUser('phoneNumber', phoneNumber);
      await SessionStorage.setCurrentUser('gender', gender);
      await SessionStorage.setCurrentUser('uid', uid);
      await SessionStorage.setCurrentUser('dateOfBirth', dateOfBirth);
      await SessionStorage.setCurrentUser('displayName', 'NotFound');
      await SessionStorage.setCurrentUser('photoUrl', 'NotFound');

      return true;
    } catch (e) {
      log('UserFirebase.createUserInfo' + e.toString());
      return false;
    }
  }

  Future<bool> createUserInfoGoogle(
      String email, String uid, String displayName, String photoUrl) async {
    try {
      String child = email.replaceAll('@', '').replaceAll('.', '');
      await databaseReference
          .child('users').child(child)
          .set({'email': email, 'displayName': displayName, 'uid': uid});

      await SessionStorage.setCurrentUser('user_email', email);
      await SessionStorage.setCurrentUser('displayName', displayName);
      await SessionStorage.setCurrentUser('uid', uid);
      await SessionStorage.setCurrentUser('photoUrl', photoUrl);
      await SessionStorage.setCurrentUser('firstName', 'NotFound');
      await SessionStorage.setCurrentUser('lastName', 'NotFound');
      await SessionStorage.setCurrentUser('phoneNumber', 'NotFound');
      await SessionStorage.setCurrentUser('gender', 'NotFound');
      await SessionStorage.setCurrentUser('dateOfBirth', 'NotFound');

      return true;
    } catch (e) {
      log('UserFirebase.createUserInfo' + e.toString());
      return false;
    }
  }

  Future<bool> updateUserInfo(
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String dateOfBirth,
      String gender,
      String password,
      String uid) async {
    try {
      String displayName =
           firstName + ' ' + lastName;
          String child = email.replaceAll('@', '').replaceAll('.', '');
          await databaseReference.child('users').child(child).set({
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'email': email,
        'password': password,
        'displayName': displayName,
        'uid': uid
      });
      await SessionStorage.setCurrentUser('firstName', firstName);
      await SessionStorage.setCurrentUser('lastName', lastName);
      await SessionStorage.setCurrentUser('user_email', email);
      await SessionStorage.setCurrentUser('displayName', displayName);
      await SessionStorage.setCurrentUser('phoneNumber', phoneNumber);
      await SessionStorage.setCurrentUser('gender', gender);
      await SessionStorage.setCurrentUser('uid', uid);
      await SessionStorage.setCurrentUser('dateOfBirth', dateOfBirth);
      await SessionStorage.setCurrentUser('photoUrl', 'NotFound');
      return true;
    } catch (e) {
      log('UserFirebase.createUserInfo' + e.toString());
      return false;
    }
  }
Future<String> getUsers(String email)async{
    try {
      var users = {};
      String child = email.replaceAll('@', '').replaceAll('.', '');
      await databaseReference
          .child("users")
          .child(child)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        users = values;      
      });
     return jsonEncode(users);
    } catch (e) {
      log('UserFirebase.isUserExists' + e.toString());
      return 'false';
    }
  }


  Future<bool> isUserExists(String email) async {
    try {
      String useremail = '';
      String child = email.replaceAll('@', '').replaceAll('.', '');
      await databaseReference
          .child("users")
          .child(child)
          .once()
          .then((DataSnapshot snapshot) {
        Map<dynamic, dynamic> values = snapshot.value;
        useremail = values['email'];       
      });
     if(useremail ==email){
       return true;
     }else{
      return false;
     }
    } catch (e) {
      log('UserFirebase.isUserExists' + e.toString());
      return false;
    }
  }
}
