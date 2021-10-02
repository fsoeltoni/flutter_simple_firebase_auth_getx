import 'package:flutter/material.dart';
import 'package:flutter_simple_firebase_auth/controllers/auth_controller.dart';
import 'package:flutter_simple_firebase_auth/navigation/routes.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: authController,
      builder: (authController) {
        return GetMaterialApp(
          title: 'Authentication Flow',
          onGenerateRoute: Routes.routes,
        );
      },
    );
  }
}
