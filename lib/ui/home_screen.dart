import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_firebase_auth/controllers/auth_controller.dart';
import 'package:flutter_simple_firebase_auth/controllers/my_user_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Get.put(MyUserController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => Get.find<AuthController>().signOut(),
          )
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return _MyUserSection();
      }),
    );
  }
}

class _MyUserSection extends StatefulWidget {
  @override
  _MyUserSectionState createState() => _MyUserSectionState();
}

class _MyUserSectionState extends State<_MyUserSection> {
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<MyUserController>();

    Widget image = Image.asset(
      'assets/intro_3.png',
      fit: BoxFit.fill,
    );

    if (userController.pickedImage.value != null) {
      image = Image.file(
        userController.pickedImage.value!,
        fit: BoxFit.fill,
      );
    } else if (userController.user.value?.image?.isNotEmpty == true) {
      image = CachedNetworkImage(
        imageUrl: userController.user.value!.image!,
        progressIndicatorBuilder: (_, __, progress) =>
            CircularProgressIndicator(value: progress.progress),
        errorWidget: (_, __, ___) => Icon(Icons.error),
        fit: BoxFit.fill,
      );
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final pickedImage =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  Get.find<MyUserController>().setImage(File(pickedImage.path));
                }
              },
              child: Center(
                child: ClipOval(
                  child: Container(
                    width: 150,
                    height: 150,
                    child: image,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Obx(() {
              if (Get.find<AuthController>().authState.value == AuthState.signedIn) {
                return Center(
                  child:
                      Text('UID: ${Get.find<AuthController>().authUser.value!.uid}'),
                );
              }
              return SizedBox.shrink();
            }),
            TextField(
              controller: userController.nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: userController.lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: userController.ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            SizedBox(height: 8),
            Obx(() {
              final isSaving = userController.isSaving.value;
              return Stack(
                alignment: Alignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: isSaving ? null : () => userController.saveMyUser(),
                  ),
                  if (isSaving) CircularProgressIndicator(),
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
