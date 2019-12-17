

import 'package:firebase_auth/firebase_auth.dart';



class FireStoreFunction{
    Future<FirebaseUser> loginUser({String email, String password}) async {
    try {
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return result;
    }  catch (e) {
      throw new AuthException(e.code, e.message);
    }
  }


    Future logout() async {
   FirebaseAuth.instance.signOut().then((user){
     return user;

   });
  
  }

   


    
}