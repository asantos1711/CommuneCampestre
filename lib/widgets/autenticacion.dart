
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices{
    late FirebaseAuth firebaseAuth;
    String? verificationId;
    bool? isLogedIn;

    static AuthenticationServices? _instance;

    AuthenticationServices(){
      firebaseAuth = FirebaseAuth.instance;
      isLogedIn = false;
    }

    static getInstance(){
      if(_instance == null){
        _instance = AuthenticationServices();
      }
      return _instance;
    }

    Future<void> sendCodeToPhoneNumber(String phone) async{
       final PhoneCodeSent codeSent =
           (String verificationId, [int? forceResendingToken]) async {
         this.verificationId = verificationId;
         print("code sent to " + phone);
       };
     }

     /*Future<AuthResult> loginWithEmail({required String em, required String pwd})async{
       try{
           AuthResult user = await firebaseAuth.signInWithEmailAndPassword(email: em, password: pwd);
           isLogedIn = true;
         return user;
       }catch(error){
         print('LoginWithEmail : -> ${error.toString()}');
         return null;
       }
     }*/

     /*Future singUpWithEmail({required String em,required String pwd}) async{
       try{
         AuthResult authResult = await firebaseAuth.createUserWithEmailAndPassword(email: em, password: pwd);
       }catch(error){
         return error.toString();
       }

    }     */

    Future signOut() async{
      firebaseAuth.signOut();
    }
}