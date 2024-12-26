import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/features/auth/data/models/user_model.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<User> signIn(String email, String password);
  Future<User> signUp(String email, String password, String username);
  Future<void> signOut();
    Future<void> changePassword(String currentPassword, String newPassword);
  Future<UserModel> updateProfile(String username, String? profilePictureUrl);
  Future<User?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final _auth = firebase_auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  AuthRemoteDataSourceImpl._();
  static AuthRemoteDataSourceImpl get instance => AuthRemoteDataSourceImpl._();

  @override
  Future<User> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userData = await _getUserData(result.user!.uid);
    return UserModel.fromJson(userData);
  }

  @override
  Future<User> signUp(String email, String password, String username) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userData = {
      'id': result.user!.uid,
      'email': email,
      'username': username,
      'profilePictureUrl': null,
    };

    await _firestore.collection('users').doc(result.user!.uid).set(userData);
    return UserModel.fromJson(userData);
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<User?> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    final userData = await _getUserData(currentUser.uid);
    return UserModel.fromJson(userData);
  }
  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    // Reauthenticate user before changing password
    final credential = firebase_auth.EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);

    // Change password
    await user.updatePassword(newPassword);
  }

  @override
  Future<UserModel> updateProfile(
      String username, String? profilePictureUrl) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final updates = {
      'username': username,
      if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
    };

    await _firestore.collection('users').doc(user.uid).update(updates);

    final userData = await _getUserData(user.uid);
    return UserModel.fromJson(userData);
  }


  Future<Map<String, dynamic>> _getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    final data = doc.data()!;
    data['id'] = userId; // Ensure ID is included
    return data;
  }
}
