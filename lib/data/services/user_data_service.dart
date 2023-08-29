import 'package:playmyhit/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataService {
  FirebaseFirestore firestore;
  UserDataService({required this.firestore});

  Future<bool> saveUserData(UserModel model) async {
    try {
      await firestore.runTransaction((transaction)async{
        CollectionReference usersCollectionReference = firestore.collection('users');

        usersCollectionReference.add(model);

        return true;
        
      });

      return true;
    }catch(e){
      return false;
    }
  }

  void dispose(){
    
  }
}