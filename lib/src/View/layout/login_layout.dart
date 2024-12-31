import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo.png',
              height: 40,
            ),
            const Gap(18),
            SelectableText(dotenv.env['TITLE'] ?? 'Sistema da loja'),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: SharedTheme.thirdColor,
        child: child
      )
    );
  }
}