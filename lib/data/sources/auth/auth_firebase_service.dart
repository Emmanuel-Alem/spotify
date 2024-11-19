import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/auth/create_user_req.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signin(SigninUserReq signinUserReq);
  Future<Either> signup(CreateUserReq createUserReq);

}

class AuthFirebaseServiceImpl extends AuthFirebaseService{
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email, 
        password: signinUserReq.password
        );

      return const Right('Signin was successful');
    
    
    }on FirebaseAuthException catch(e) {
      String message = '';
      if(e.code == 'invalid-email'){
        message = 'User not found for that email.';
      }else if(e.code == 'invalid-credential'){
        message = 'wrong password provided.';
      }
      return Left(message);
    }
   
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: createUserReq.email, password: createUserReq.password);

      return const Right('Signup was successful');
    
    
    }on FirebaseAuthException catch(e) {
      String message = '';
      if(e.code == 'weak-password'){
        message = 'The password provided is too weak';
      }else if(e.code == 'email-already-in-use'){
        message = 'An account already exists with that email.';
      }
      return Left(message);
    }
   
  }
  
}