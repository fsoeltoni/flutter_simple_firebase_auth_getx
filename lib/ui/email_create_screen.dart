import 'package:flutter/material.dart';
import 'package:flutter_simple_firebase_auth/controllers/email_create_controller.dart';
import 'package:get/get.dart';

class EmailCreate extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = Get.put(EmailCreateController());

    return Scaffold(
      appBar: AppBar(title: Text('Create account')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Visibility(
                  visible: emailController.isLoading.value,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: emailController.error.value?.isNotEmpty == true,
                  child: Text(
                    emailController.error.value ?? '',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: emailController.emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: emailController.emailValidator,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: emailController.passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: emailController.passwordValidator,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: emailController.repeatPasswordController,
                decoration: InputDecoration(labelText: 'Repeat Password'),
                validator: emailController.passwordValidator,
              ),
              Center(
                child: ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      Get.find<EmailCreateController>()
                          .createUserWithEmailAndPassword();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
