import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_application_1/core/errors/exceptions.dart';
import 'package:flutter_application_1/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> logout();
  Future<void> resetPassword(String email);
  Future<String?> getCurrentToken();
  Future<UserModel?> getCurrentUser();
}

class FirebaseAuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth _firebaseAuth;

  FirebaseAuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        final token = await user.getIdToken();
        return UserModel(
          id: user.uid,
          username: user.displayName ?? user.email!.split('@')[0],
          email: user.email!,
          fullName: user.displayName,
          phoneNumber: user.phoneNumber,
          photoUrl: user.photoURL,
          token: token ?? '',
        );
      } else {
        throw ServerException('User not found after login');
      }
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Authentication failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUp(String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        final token = await user.getIdToken();
        return UserModel(
          id: user.uid,
          username: user.email!.split('@')[0],
          email: user.email!,
          fullName: user.displayName,
          phoneNumber: user.phoneNumber,
          photoUrl: user.photoURL,
          token: token ?? '',
        );
      } else {
        throw ServerException('User not created');
      }
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Registration failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      throw ServerException(e.message ?? 'Password reset failed');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String?> getCurrentToken() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return await user.getIdToken();
    }
    return null;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      return UserModel(
        id: user.uid,
        username: user.displayName ?? user.email!.split('@')[0],
        email: user.email!,
        fullName: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL,
        token: token ?? '',
      );
    }
    return null;
  }
}
