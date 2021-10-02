import 'package:flutter/material.dart';
import 'package:flutter_simple_firebase_auth/controllers/email_signin_controller.dart';
import 'package:get/get.dart';

class EmailSignIn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final signInController = Get.put(EmailSignInController());

    return Scaffold(
      appBar: AppBar(title: Text('Login with Email')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Visibility(
                  visible: signInController.isLoading.value,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              Obx(
                () => Visibility(
                  visible: signInController.error.value?.isNotEmpty == true,
                  child: Text(
                    signInController.error.value ?? '',
                    style: TextStyle(color: Colors.red, fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: signInController.emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: signInController.emptyValidator,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: signInController.passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                validator: signInController.emptyValidator,
              ),
              SizedBox(height: 8),
              Center(
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      signInController.signInWithEmailAndPassword();
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
