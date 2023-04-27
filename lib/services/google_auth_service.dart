


import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  // Sign in with google

  signInWithGoogle() async {

    // Begin signin process
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    // Obtain auth details from request
    if (gUser == null) return;
    
    final GoogleSignInAuthentication gAuth = await gUser!.authentication; 
    
    // Create new credential for user
    
    final credential = GoogleAuthProvider.credential(
      accessToken : gAuth.accessToken, 
      idToken : gAuth.idToken
      
    );
    // Then sign in
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


}