import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep/core/services/Authservices.dart';
import 'package:wep/core/services/firestoreservices.dart';

class AuthController extends GetxController {
  final AuthServices _authService = AuthServices.instance;
  final firestore = FirestoreServices.instance;
  final regKey = GlobalKey<FormState>();
  final loginKey = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController username;

  RxBool isLogin = true.obs;
  RxString gender = "Male".obs;
  RxBool obscure = true.obs;
  bool isLoading = false;

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    username = TextEditingController();
    super.onInit();
  }

  Future<void> login() async {
    if (!loginKey.currentState!.validate()) return;
    try {
      isLoading = true;
      update();

      await _authService.signIn(
        email: email.text.trim(),
        password: password.text.trim(),
      );
    } catch (e) {
      Get.snackbar("Login Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> register() async {
    if (!regKey.currentState!.validate()) return;
    try {
      isLoading = true;
      update();

      await _authService.signUp(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      final uid = _authService.currentUser?.uid;

      if (uid != null) {
        await firestore.setdatabyid("users", uid, {
          "username": username.text.trim(),
          "email": email.text.trim(),
          "gender": gender.value,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      Get.snackbar("Register Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  void toggleAuthView() => isLogin.value = !isLogin.value;
  void changeGender(String val) => gender.value = val;
  void togglePassword() => obscure.value = !obscure.value;

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    username.dispose();
    super.onClose();
  }
}
