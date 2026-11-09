import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  AuthServices._();

  static final AuthServices instance = AuthServices._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  /// معرفة حالة تسجيل الدخول
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// إنشاء حساب جديد
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  /// تسجيل الدخول
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
