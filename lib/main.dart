// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:wep/controller/authcontroller.dart';
// import 'package:wep/core/binding/inintboding.dart';
// import 'package:wep/core/services/Authservices.dart';
// import 'package:wep/view/screen/chatapp.dart';
// import 'package:wep/view/screen/auth/login.dart';
// import 'package:wep/view/screen/auth/register.dart'; // افترضنا وجودها

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const SignTalkApp());
// }

// class SignTalkApp extends StatelessWidget {
//   const SignTalkApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       initialBinding: AuthBinding(),
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(scaffoldBackgroundColor: Colors.white),
//       home: StreamBuilder(
//         stream: AuthServices.instance.authStateChanges,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }

//           if (snapshot.hasData) {
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               if (Get.isRegistered<AuthController>()) {
//                 Get.delete<
//                   AuthController
//                 >(); 
//               }
//             });
//             return HomePage();
//           }

//           return const AuthToggleView();
//         },
//       ),
//     );
//   }
// }

// class AuthToggleView extends StatelessWidget {
//   const AuthToggleView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(AuthController());
//     return Obx(() => controller.isLogin.value ? LoginPage() : RegisterPage());
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wep/view/screen/people_counter_screen.dart';


void main() {
  runApp(const PeopleCounterApp());
}

class PeopleCounterApp extends StatelessWidget {
  const PeopleCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vision AI',
      theme: ThemeData.dark(),
      home: PeopleCounterScreen(),
    );
  }
}
