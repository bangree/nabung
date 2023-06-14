import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabung/model/userModel.dart';

class AuthenticationRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  Future<Either<UserModel?, String>> hasLoggedIn() async {
    try {
      if (auth.currentUser != null) {
        // get data user from firestore
        DocumentSnapshot userSnapshot =
            await userReference.doc(auth.currentUser!.uid).get();

        UserModel userModel = UserModel.fromDocumentSnapshot(userSnapshot);

        // return user model
        return Left(userModel);
      }
      return const Left(null);
    } on FirebaseException catch (e) {
      return Right(_getMessageFromErrorCode(errorCode: e.code));
    } catch (e) {
      return Right(e.toString());
    }
  }

  Future<Either<UserModel, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // get data user from firestore
        DocumentSnapshot userSnapshot =
            await userReference.doc(auth.currentUser!.uid).get();

        UserModel userModel = UserModel.fromDocumentSnapshot(userSnapshot);

        // return user model
        return Left(userModel);
      }

      return const Right('Login Gagal');
    } on FirebaseException catch (e) {
      return Right(_getMessageFromErrorCode(errorCode: e.code));
    } catch (e) {
      return Right(e.toString());
    }
  }

  Future<Either<String, String>> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        UserModel userModel = UserModel(
          id: user.uid,
          email: user.email,
          username: username,
        );

        // insert user to firestore
        await userReference.doc(user.uid).set(userModel.toMap());

        // return success
        return const Left('Register Sukses');
      }

      return const Right('Register Gagal');
    } on FirebaseException catch (e) {
      return Right(_getMessageFromErrorCode(errorCode: e.code));
    } catch (e) {
      return Right(e.toString());
    }
  }

  Future<Either<String, String>> logout() async {
    try {
      await auth.signOut();
      return const Left('Logout Sukses');
    } on FirebaseException catch (e) {
      return Right(_getMessageFromErrorCode(errorCode: e.code));
    } catch (e) {
      return Right(e.toString());
    }
  }

  Future<Either<String, String>> changePassword({
    required String email,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      if (auth.currentUser != null) {
        AuthCredential authCredential = EmailAuthProvider.credential(
          email: email,
          password: oldPassword,
        );
        UserCredential userCredential = await auth.currentUser!
            .reauthenticateWithCredential(authCredential);
        if (userCredential.user != null) {
          await userCredential.user!.updatePassword(newPassword);
          return const Left('Change Password Success');
        }
      }
      return const Right('Change Password Fail');
    } on FirebaseException catch (e) {
      return Right(_getMessageFromErrorCode(errorCode: e.code));
    } catch (e) {
      return Right(e.toString());
    }
  }

  Future<Either<String, String>> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final String id = userCredential.user!.uid;
        // remove auth
        await userCredential.user!.delete();

        // remove firestore
        await userReference.doc(id).delete();

        return const Left('Delete Account Success');
      }
      return const Right('Delete Account Fail');
    } on FirebaseException catch (e) {
      return Right(_getMessageFromErrorCode(errorCode: e.code));
    } catch (e) {
      return Right(e.toString());
    }
  }

  String _getMessageFromErrorCode({required String errorCode}) {
    switch (errorCode) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "Email already used. Go to login page.";
      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        return "Wrong email/password combination.";
      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        return "No user found with this email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "User disabled.";
      case "ERROR_TOO_MANY_REQUESTS":
      case "operation-not-allowed":
        return "Too many requests to log into this account.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Server error, please try again later.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "Email address is invalid.";
      default:
        return "Login failed. Please try again.";
    }
  }
}
