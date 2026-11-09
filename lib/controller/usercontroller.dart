import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:wep/core/models/usermodel.dart';
import 'package:wep/core/services/Authservices.dart';
import 'package:wep/core/services/firestoreservices.dart'; // مسار ملف السيرفس الخاص بك

class UserController extends GetxController {
  // 1. استدعاء السيرفس
  final AuthServices _authService = AuthServices.instance;

  Rxn<UserModel> currentUser = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();

    // 2. الاستماع للـ Stream المعرف داخل AuthServices
    _authService.authStateChanges.listen((User? firebaseUser) {
      if (firebaseUser != null) {
        fetchUserData(firebaseUser.uid);
      } else {
        currentUser.value = null;
      }
    });
  }

  Future<void> fetchUserData(String uid) async {
    try {
      // جلب مستند المستخدم من Firestore السيرفس
      final doc = await FirestoreServices.instance.getdatabyid("users", uid);

      if (doc.exists && doc.data() != null) {
        currentUser.value = UserModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
  }

  // 3. استدعاء دالة الخروج من السيرفس مباشرة
  Future<void> logout() async {
    await _authService.signOut();
  }
}
