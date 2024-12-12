import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:racoon_tech_panel/src/layout/login_layout.dart';
import 'package:racoon_tech_panel/src/shared/SharedTheme.dart';
import 'package:routefly/routefly.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;  
  
    return LoginLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: Container(
              width:  width * (SharedTheme.isLargeScreen(context) ? 0.2 : 0.8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Login", style: TextStyle(color: SharedTheme.secondaryColor, fontSize: 30, fontWeight: FontWeight.bold)),
                    Gap(18),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        hintText: "exemplo@raccoontech.com",
                        labelStyle: TextStyle(color: SharedTheme.secondaryColor),
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: SharedTheme.secondaryColor.withOpacity(0.3), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: SharedTheme.secondaryColor.withOpacity(0.3), width: 2.0),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent, width: 2.5),
                      ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha o campo';
                        }
                        return null;
                      },
                    ),
                    Gap(18),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        hintText: "******",
                        labelStyle: TextStyle(color: SharedTheme.secondaryColor),
                        enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: SharedTheme.secondaryColor.withOpacity(0.6), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: SharedTheme.secondaryColor.withOpacity(0.6), width: 2.0),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent, width: 2.5),
                      ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha o campo';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)
                        ),
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState!.validate()) {
                            Routefly.navigate('/dashboard');
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Continuar'),
                            Icon(Icons.arrow_right)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ),
        ],
      )
    );
  }
}