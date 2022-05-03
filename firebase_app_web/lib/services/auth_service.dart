import 'package:firebase_app_web/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = const FlutterSecureStorage();

  Future<void> googleSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        try {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          storeTokenAndData(userCredential);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (builder) => const HomePage()),
              (route) => false);
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      } else {
        final snackbar = SnackBar(content: Text("Not Able to sign In "));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> storeTokenAndData(UserCredential userCredential) async {
    await storage.write(
        key: "token", value: userCredential.credential.token.toString());
    await storage.write(
        key: "token", value: userCredential.credential.token.toString());
  }

  Future<String> getToken() async {
    return await storage.read(key: "token");
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber, BuildContext context, Function setData) async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };
    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException exception) {
      showSnackBar(context, exception.toString());
    };
    PhoneCodeSent codeSent =
        (String verificationID, [int forceResnedingtoken]) {
      showSnackBar(context, "Verification Code sent on the phone number");
      setData(verificationID);
    };
    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationID) {
      showSnackBar(context, "Time out");
    };
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      await storage.delete(key: "token");
    }
  }

  Future<void> signInwithPhoneNumber(
      String verificationId, smsCode, BuildContext context) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      storeTokenAndData(userCredential);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (builder) => const HomePage()),
          (route) => false);
      showSnackBar(context, "logged Ind");
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void showSnackBar(BuildContext context, String text) {
    final snackbar = SnackBar(content: Text(text.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
