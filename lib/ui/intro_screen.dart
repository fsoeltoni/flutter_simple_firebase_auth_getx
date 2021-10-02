import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_simple_firebase_auth/controllers/home_signin_controller.dart';
import 'package:flutter_simple_firebase_auth/navigation/routes.dart';
import 'package:get/get.dart';
import 'package:page_indicator/page_indicator.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: _IntroPager(),
    );
  }
}

class _IntroPager extends HookWidget {
  final String exampleText =
      'Lorem ipsum dolor sit amet, consecrated advising elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.';

  @override
  Widget build(BuildContext context) {
    final homeSignInController = Get.put(HomeSignInController());

    return AbsorbPointer(
      absorbing: homeSignInController.isLoading.value,
      child: PageIndicatorContainer(
        child: PageView(
          children: <Widget>[
            _DescriptionPage(
              text: exampleText,
              imagePath: 'assets/intro_1.png',
            ),
            _DescriptionPage(
              text: exampleText,
              imagePath: 'assets/intro_2.png',
            ),
            _DescriptionPage(
              text: exampleText,
              imagePath: 'assets/intro_3.png',
            ),
            _LoginPage(),
          ],
          controller: usePageController(),
        ),
        align: IndicatorAlign.bottom,
        length: 4,
        indicatorSpace: 12,
        indicatorColor: Colors.grey,
        indicatorSelectorColor: Colors.black,
      ),
    );
  }
}

class _DescriptionPage extends StatelessWidget {
  final String text;
  final String imagePath;

  const _DescriptionPage({
    Key? key,
    required this.text,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeSignInController = Get.find<HomeSignInController>();

    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/intro_1.png',
            width: 200,
            height: 200,
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                'Sign in or create an account',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Obx(
            () => Visibility(
              visible: homeSignInController.isLoading.value,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          Obx(
            () => Visibility(
              visible: homeSignInController.error.value?.isNotEmpty == true,
              child: Text(
                homeSignInController.error.value ?? '',
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                SizedBox(height: 8),
                _LoginButton(
                  text: 'Sign in with Google',
                  imagePath: 'assets/icon_google.png',
                  color: Colors.white,
                  textColor: Colors.grey,
                  onTap: () => homeSignInController.signInWithGoogle(),
                ),
                SizedBox(height: 8),
                _LoginButton(
                  text: 'Sign in with Facebook',
                  imagePath: 'assets/icon_facebook.png',
                  color: Colors.blueAccent,
                  onTap: () => homeSignInController.signInWithFacebook(),
                ),
                SizedBox(height: 8),
                _LoginButton(
                  text: 'Sign in with Email',
                  imagePath: 'assets/icon_email.png',
                  color: Colors.red,
                  textColor: Colors.white,
                  onTap: () => Get.toNamed(Routes.signInEmail),
                ),
                SizedBox(height: 8),
                _LoginButton(
                  text: 'Sign in Anonymously',
                  imagePath: 'assets/icon_question.png',
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  onTap: () => homeSignInController.signInAnonymously(),
                ),
                SizedBox(height: 48),
                OutlinedButton(
                  child: Text('Create account'),
                  onPressed: () => Get.toNamed(Routes.createAccount),
                ),
                SizedBox(height: 48),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback? onTap;
  final Color color;
  final Color textColor;

  const _LoginButton({
    Key? key,
    required this.text,
    required this.imagePath,
    this.onTap,
    this.color = Colors.blue,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 3,
      borderRadius: BorderRadius.all(Radius.circular(5)),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 24,
                height: 24,
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
