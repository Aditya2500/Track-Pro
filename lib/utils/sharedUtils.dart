import 'dart:developer';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
static  Future<void> setCurrentUser(String key,String setString) async{
  try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString(key, setString);
  }catch(e){
    log('SessionStorage.setCurrentUser'+e.toString());
  }
  }
  static Future<String> getCurrentUser(String getString) async{
    try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
   return  prefs.getString(getString);
    }catch(e){
    log('SessionStorage.getCurrentUser'+e.toString());
  }
  return null;
  }
 
static  Future<void> removeCurrentUser(String removeString) async{
  try{
    SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.remove(removeString);
  }
     catch(e){
    log('SessionStorage.removeCurrentUser'+e.toString());
  }
  }
}