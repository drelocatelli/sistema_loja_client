import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/web.dart';
import 'package:provider/provider.dart';
import 'package:racoon_tech_panel/src/View/layout/functions/assign_colaborator.dart';
import 'package:racoon_tech_panel/src/View/layout/login_layout.dart';
import 'package:racoon_tech_panel/src/ViewModel/repository/LoginRepository.dart';
import 'package:racoon_tech_panel/src/ViewModel/shared/SharedTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ViewModel/providers/ColaboratorProvider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _storePassword = true;
  bool _isLoginLoading = false;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final width = MediaQuery.of(context).size.width;  

  
    return LoginLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final mediumConst = width * (SharedTheme.isLargeScreen(context) ? 0.2 : 0.8);
                
                return Container(
                  width:  mediumConst,
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
                        const Gap(18),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          autofocus: true,
                          controller: _userController,
                          decoration: InputDecoration(
                            labelText: 'Digite o usuário',
                            hintText: "Nome de usuário",
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
                        const Gap(12),
                        TextFormField(
                          autofocus: true,
                          obscureText: true,
                          controller: _passwordController,
                          onFieldSubmitted: (value) async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await _loginRequest(context, _userController.text, _passwordController.text);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Digite a senha',
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
                            onPressed: () async  {
                              _isLoginLoading = true;
                              setState(() {});
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState?.validate() ?? false) {
                                await _loginRequest(context, _userController.text, _passwordController.text);
                              }
                              _isLoginLoading = false;
                              setState(() {});
                
                            },
                            child: _isLoginLoading ? Text("Aguarde...") : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Continuar'),
                                Icon(Icons.arrow_right)
                              ],
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                );
              }
            )
          ),
        ],
      )
    );
  }
}

_loginRequest(BuildContext context, String user, String password) async {
  final colaboratorModel = Provider.of<ColaboratorProvider>(context, listen: false);
  final response = await LoginRepository.login(user, password);

  if(response.status != 200) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? 'Ocorreu um erro inesperado!'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('login', jsonEncode(response.data!.details));
  await prefs.setString('token', response.data!.token.toString());
  colaboratorModel.setCurrentLogin(response.data!);  
  await assignUserToColaboratorDialog(context);

  context.pushReplacement('/dashboard');
}
